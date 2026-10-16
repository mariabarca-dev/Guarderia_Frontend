package com.GuarderiaCentral.Guarderia_Frontend.service;

import com.GuarderiaCentral.Guarderia_Frontend.exception.BackendException;
import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

/**
 * Servicio encargado de la comunicación HTTP hacia la API REST del Backend.
 * Adjunta automáticamente el token Bearer JWT en llamadas protegidas.
 */
@Slf4j
@Service
public class BackendClientService {

    private static final char COMILLA = '"';
    private static final char BARRA = (char) 92;

    private final RestTemplate restTemplate;
    private final String backendApiUrl;

    /**
     * Crea el servicio de comunicación con el backend.
     *
     * @param restTemplate  cliente HTTP compartido
     * @param backendApiUrl URL base de la API del backend (propiedad backend.api.url, termina en /api)
     */
    public BackendClientService(RestTemplate restTemplate, @Value("${backend.api.url}") String backendApiUrl) {
        this.restTemplate = restTemplate;
        this.backendApiUrl = backendApiUrl;
    }

    /**
     * Realiza el login hacia el Backend (petición pública no autenticada).
     *
     * @param username nombre de usuario
     * @param password contraseña
     * @return Map con la respuesta JSON del backend (accessToken, tokenType y rol según el contrato)
     * @throws BackendException si el backend responde con error o no se puede conectar
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> login(String username, String password) {
        String url = backendApiUrl + "/auth/login";
        Map<String, String> requestBody = Map.of("username", username, "password", password);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestBody, headers);

        try {
            log.info("Enviando solicitud de login para usuario: {}", username);
            ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            log.error("Error HTTP al autenticar usuario {}: {}", username, e.getStatusCode());
            throw new BackendException(e.getStatusCode().value(),
                    extraerMensaje(e, "Credenciales inválidas o error de autenticación"));
        } catch (Exception e) {
            log.error("Error de conexión con el backend durante login: {}", e.getMessage());
            throw new BackendException(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "No se pudo conectar con el servidor backend");
        }
    }

    /**
     * Realiza una petición GET al Backend.
     *
     * @param path ruta relativa del endpoint (ej: "/socios/me")
     * @return objeto (Map o List&lt;Map&gt;) según la respuesta JSON
     * @throws BackendException si el backend responde con error
     */
    public Object get(String path) {
        return execute(path, HttpMethod.GET, null);
    }

    /**
     * Realiza una petición POST al Backend.
     *
     * @param path ruta relativa del endpoint
     * @param body cuerpo JSON del request
     * @return objeto respuesta del backend
     * @throws BackendException si el backend responde con error
     */
    public Object post(String path, Object body) {
        return execute(path, HttpMethod.POST, body);
    }

    /**
     * Realiza una petición PUT al Backend.
     *
     * @param path ruta relativa del endpoint
     * @param body cuerpo JSON del request
     * @return objeto respuesta del backend
     * @throws BackendException si el backend responde con error
     */
    public Object put(String path, Object body) {
        return execute(path, HttpMethod.PUT, body);
    }

    /**
     * Realiza una petición DELETE al Backend.
     *
     * @param path ruta relativa del endpoint
     * @return objeto respuesta del backend (puede ser null)
     * @throws BackendException si el backend responde con error
     */
    public Object delete(String path) {
        return execute(path, HttpMethod.DELETE, null);
    }

    /**
     * Método genérico para ejecutar llamadas protegidas al Backend.
     *
     * @param path   ruta relativa del endpoint
     * @param method método HTTP
     * @param body   cuerpo del request (puede ser null)
     * @return cuerpo de la respuesta
     * @throws BackendException si el backend responde con error
     */
    private Object execute(String path, HttpMethod method, Object body) {
        String url = backendApiUrl + path;
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String token = obtenerTokenSesion();
        if (token != null) {
            headers.setBearerAuth(token);
        }

        HttpEntity<Object> entity = new HttpEntity<>(body, headers);

        try {
            log.debug("Ejecutando HTTP {} hacia {}", method, url);
            ResponseEntity<Object> response = restTemplate.exchange(url, method, entity, Object.class);
            return response.getBody();
        } catch (HttpStatusCodeException e) {
            log.error("Error HTTP {} al llamar a {}: {}", e.getStatusCode(), url, e.getResponseBodyAsString());
            throw new BackendException(e.getStatusCode().value(),
                    extraerMensaje(e, "Error en el servicio backend"));
        } catch (Exception e) {
            log.error("Error inesperado en llamada HTTP a {}: {}", url, e.getMessage());
            throw new BackendException(HttpStatus.INTERNAL_SERVER_ERROR.value(),
                    "Error de comunicación con el servicio backend");
        }
    }

    /**
     * Extrae el campo "message" del JSON de error del backend
     * ({ timestamp, status, error, message, path }).
     *
     * @param e          excepción HTTP devuelta por el backend
     * @param porDefecto mensaje a usar si el cuerpo no trae el campo message
     * @return mensaje del backend o el mensaje por defecto
     */
    private String extraerMensaje(HttpStatusCodeException e, String porDefecto) {
        String cuerpo = e.getResponseBodyAsString();
        if (cuerpo == null || cuerpo.isBlank()) {
            return porDefecto;
        }
        String clave = COMILLA + "message" + COMILLA;
        int posClave = cuerpo.indexOf(clave);
        if (posClave < 0) {
            return porDefecto;
        }
        int dosPuntos = cuerpo.indexOf(':', posClave + clave.length());
        if (dosPuntos < 0) {
            return porDefecto;
        }
        int abre = cuerpo.indexOf(COMILLA, dosPuntos + 1);
        if (abre < 0 || !cuerpo.substring(dosPuntos + 1, abre).isBlank()) {
            return porDefecto;
        }
        StringBuilder mensaje = new StringBuilder();
        for (int k = abre + 1; k < cuerpo.length(); k++) {
            char c = cuerpo.charAt(k);
            if (c == BARRA && k + 1 < cuerpo.length()) {
                k++;
                mensaje.append(cuerpo.charAt(k));
            } else if (c == COMILLA) {
                return mensaje.toString();
            } else {
                mensaje.append(c);
            }
        }
        return porDefecto;
    }

    /**
     * Obtiene el token JWT del usuario autenticado desde el contexto de seguridad.
     *
     * @return token Bearer o null si no hay usuario autenticado
     */
    private String obtenerTokenSesion() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UsuarioAutenticado user) {
            return user.getAccessToken();
        }
        return null;
    }
}
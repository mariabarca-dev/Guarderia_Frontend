package com.GuarderiaCentral.Guarderia_Frontend.client;

import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriUtils;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Único punto de comunicación HTTP del front con la API REST del back.
 * <p>
 * El back usa SESIÓN HTTP con la cookie {@code GUARDERIA_BACK} (no JWT). Este servicio:
 * </p>
 * <ul>
 *   <li>en el login lee el valor de esa cookie del header {@code Set-Cookie};</li>
 *   <li>en cada llamada protegida la reenvía en el header {@code Cookie}, tomándola del
 *       {@link UsuarioAutenticado} guardado en la sesión del front;</li>
 *   <li>ante un error del back lanza {@link BackendException} con el código y el campo "message".</li>
 * </ul>
 * <p>
 * Los datos viajan como JSON y se devuelven como {@code Map} (objeto) o {@code List<Map>} (arreglo):
 * el front no tiene DTOs. Las rutas se escriben relativas a {@code backend.api.url}, que ya termina en /api.
 * La cookie del back nunca se registra en el log.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Slf4j
@Service
public class BackendClientService {

    /** Clave del mapa de login con el nombre de usuario devuelto por el back. */
    public static final String LOGIN_NOMBRE_USUARIO = "nombreUsuario";
    /** Clave del mapa de login con el rol devuelto por el back. */
    public static final String LOGIN_ROL = "rol";
    /** Clave del mapa de login con el valor de la cookie de sesión del back. */
    public static final String LOGIN_COOKIE = "cookieBack";

    private static final String MENSAJE_SIN_CONEXION = "No se pudo conectar con el servidor. Intentá de nuevo en unos minutos.";
    private static final String MENSAJE_GENERICO = "Ocurrió un error al procesar la solicitud.";

    private final RestTemplate restTemplate;
    private final String backendApiUrl;
    private final String nombreCookie;

    /**
     * Crea el cliente.
     *
     * @param restTemplate  cliente HTTP configurado en {@code RestTemplateConfig}
     * @param backendApiUrl URL base del back (por ejemplo http://localhost:8080/api)
     * @param nombreCookie  nombre de la cookie de sesión del back (GUARDERIA_BACK)
     */
    public BackendClientService(RestTemplate restTemplate,
                                @Value("${backend.api.url}") String backendApiUrl,
                                @Value("${backend.cookie.nombre:GUARDERIA_BACK}") String nombreCookie) {
        this.restTemplate = restTemplate;
        this.backendApiUrl = backendApiUrl;
        this.nombreCookie = nombreCookie;
    }

    // ------------------------------------------------------------------ login / logout

    /**
     * Inicia sesión en el back ({@code POST /auth/login}).
     *
     * @param username nombre de usuario (ya validado por el provider)
     * @param password clave (no se guarda ni se registra)
     * @return mapa con {@link #LOGIN_NOMBRE_USUARIO}, {@link #LOGIN_ROL} y {@link #LOGIN_COOKIE}
     * @throws BackendException con 400/401 si el back rechaza las credenciales,
     *                          o {@link BackendException#SIN_CONEXION} si no responde
     */
    @SuppressWarnings("unchecked")
    public Map<String, String> login(String username, String password) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        Map<String, String> cuerpo = Map.of("username", username, "password", password);

        try {
            ResponseEntity<Map> respuesta = restTemplate.exchange(
                    backendApiUrl + "/auth/login", HttpMethod.POST, new HttpEntity<>(cuerpo, headers), Map.class);

            Map<String, Object> datos = respuesta.getBody();
            String cookie = extraerCookie(respuesta.getHeaders());
            if (datos == null || datos.get(LOGIN_ROL) == null || cookie == null) {
                throw new BackendException(BackendException.SIN_CONEXION,
                        "El servidor no devolvió el rol o la cookie de sesión.");
            }

            Map<String, String> resultado = new LinkedHashMap<>();
            resultado.put(LOGIN_NOMBRE_USUARIO, String.valueOf(datos.get(LOGIN_NOMBRE_USUARIO)));
            resultado.put(LOGIN_ROL, String.valueOf(datos.get(LOGIN_ROL)));
            resultado.put(LOGIN_COOKIE, cookie);
            return resultado;
        } catch (RestClientException e) {
            throw traducir(e, "/auth/login", HttpMethod.POST);
        }
    }

    /**
     * Cierra la sesión del back ({@code POST /auth/logout}) enviando la cookie indicada.
     *
     * @param cookieBack valor de la cookie GUARDERIA_BACK del usuario que cierra sesión
     * @throws BackendException si el back responde con error o no responde
     */
    public void logout(String cookieBack) {
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.COOKIE, nombreCookie + "=" + cookieBack);
        HttpEntity<Void> pedido = new HttpEntity<>(headers);
        try {
            restTemplate.exchange(backendApiUrl + "/auth/logout", HttpMethod.POST, pedido, String.class);
        } catch (RestClientException e) {
            throw traducir(e, "/auth/logout", HttpMethod.POST);
        }
    }

    // ------------------------------------------------------------------ llamadas protegidas

    /**
     * GET al back.
     *
     * @param path ruta relativa a backend.api.url (por ejemplo "/usuarios/me")
     * @return {@code Map} o {@code List<Map>} según el JSON de respuesta
     * @throws BackendException si el back responde con error o no responde
     */
    public Object get(String path) {
        return ejecutar(path, HttpMethod.GET, null);
    }

    /**
     * POST al back.
     *
     * @param path ruta relativa a backend.api.url
     * @param body cuerpo que se envía como JSON (normalmente un Map armado con {@link #armarCuerpo})
     * @return {@code Map} o {@code List<Map>} según el JSON de respuesta
     * @throws BackendException si el back responde con error o no responde
     */
    public Object post(String path, Object body) {
        return ejecutar(path, HttpMethod.POST, body);
    }

    /**
     * PUT al back.
     *
     * @param path ruta relativa a backend.api.url
     * @param body cuerpo que se envía como JSON (puede ser null)
     * @return {@code Map} o {@code List<Map>} según el JSON de respuesta
     * @throws BackendException si el back responde con error o no responde
     */
    public Object put(String path, Object body) {
        return ejecutar(path, HttpMethod.PUT, body);
    }

    /**
     * DELETE al back (en el back es una baja lógica).
     *
     * @param path ruta relativa a backend.api.url
     * @return cuerpo de la respuesta, o null si el back no devuelve cuerpo
     * @throws BackendException si el back responde con error o no responde
     */
    public Object delete(String path) {
        return ejecutar(path, HttpMethod.DELETE, null);
    }

    /**
     * GET al back cuando la respuesta es un arreglo JSON.
     *
     * @param path ruta relativa a backend.api.url
     * @return lista de registros (cada uno es un Map con los campos del JSON)
     * @throws BackendException si el back responde con error o no responde
     */
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getLista(String path) {
        return (List<Map<String, Object>>) get(path);
    }

    /**
     * GET al back cuando la respuesta es un objeto JSON.
     *
     * @param path ruta relativa a backend.api.url
     * @return el registro como Map con los campos del JSON
     * @throws BackendException si el back responde con error o no responde
     */
    @SuppressWarnings("unchecked")
    public Map<String, Object> getMapa(String path) {
        return (Map<String, Object>) get(path);
    }

    /**
     * Codifica un valor escrito por el usuario para usarlo como tramo de una ruta
     * (por ejemplo una matrícula o un DNI). Los IDs numéricos no necesitan codificarse.
     *
     * @param valor texto a codificar
     * @return el valor codificado para URL
     */
    public static String segmento(String valor) {
        return UriUtils.encodePathSegment(valor, StandardCharsets.UTF_8);
    }

    /**
     * Arma el cuerpo JSON de un crear/editar tomando del formulario SOLO los campos indicados
     * (los nombres exactos de la clase Request/Update del back). Descarta el resto
     * (por ejemplo {@code _csrf} o {@code id}) y convierte los campos vacíos en null,
     * para que los opcionales (como el DNI del empleado) no viajen como texto vacío.
     *
     * @param formulario parámetros recibidos del formulario HTML
     * @param campos     nombres de los campos que espera el back
     * @return mapa listo para enviar con {@link #post} o {@link #put}
     */
    public static Map<String, Object> armarCuerpo(Map<String, String> formulario, String... campos) {
        Map<String, Object> cuerpo = new LinkedHashMap<>();
        for (String campo : campos) {
            String valor = formulario.get(campo);
            cuerpo.put(campo, valor == null || valor.isBlank() ? null : valor.trim());
        }
        return cuerpo;
    }

    // ------------------------------------------------------------------ internos

    /**
     * Ejecuta una llamada protegida reenviando la cookie de sesión del back.
     */
    private Object ejecutar(String path, HttpMethod method, Object body) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(List.of(MediaType.APPLICATION_JSON));
        String cookie = cookieDeLaSesion();
        if (cookie != null) {
            headers.add(HttpHeaders.COOKIE, nombreCookie + "=" + cookie);
        }

        try {
            log.debug("HTTP {} {}", method, path);
            // URI ya armada: los valores del usuario se codifican antes con segmento(), así no se codifican dos veces
            ResponseEntity<Object> respuesta = restTemplate.exchange(
                    URI.create(backendApiUrl + path), method, new HttpEntity<>(body, headers), Object.class);
            return respuesta.getBody();
        } catch (RestClientException e) {
            throw traducir(e, path, method);
        }
    }

    /**
     * Convierte un error de RestTemplate en {@link BackendException} con el campo "message" del back.
     */
    @SuppressWarnings("unchecked")
    private BackendException traducir(RestClientException e, String path, HttpMethod method) {
        if (e instanceof HttpStatusCodeException http) {
            int status = http.getStatusCode().value();
            String mensaje = MENSAJE_GENERICO;
            try {
                Map<String, Object> error = http.getResponseBodyAs(Map.class);
                if (error != null && error.get("message") != null) {
                    mensaje = String.valueOf(error.get("message"));
                }
            } catch (RuntimeException ignorada) {
                // el cuerpo no era JSON: queda el mensaje genérico
            }
            if (status >= 500) {
                mensaje = MENSAJE_GENERICO;
            }
            log.warn("El back respondió {} a {} {}: {}", status, method, path, mensaje);
            return new BackendException(status, mensaje);
        }
        if (e instanceof ResourceAccessException) {
            log.error("Sin conexión con el back en {} {}: {}", method, path, e.getMessage());
        } else {
            log.error("Error inesperado llamando a {} {}: {}", method, path, e.getMessage());
        }
        return new BackendException(BackendException.SIN_CONEXION, MENSAJE_SIN_CONEXION);
    }

    /**
     * Toma del header Set-Cookie solo el valor de la cookie del back (hasta el primer punto y coma).
     */
    private String extraerCookie(HttpHeaders headers) {
        List<String> setCookies = headers.get(HttpHeaders.SET_COOKIE);
        if (setCookies == null) {
            return null;
        }
        String prefijo = nombreCookie + "=";
        for (String setCookie : setCookies) {
            if (setCookie.startsWith(prefijo)) {
                int fin = setCookie.indexOf(';');
                return setCookie.substring(prefijo.length(), fin < 0 ? setCookie.length() : fin);
            }
        }
        return null;
    }

    /**
     * Lee la cookie del back guardada en el {@link UsuarioAutenticado} de la sesión del front.
     */
    private String cookieDeLaSesion() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UsuarioAutenticado usuario) {
            return usuario.getCookieBack();
        }
        return null;
    }
}

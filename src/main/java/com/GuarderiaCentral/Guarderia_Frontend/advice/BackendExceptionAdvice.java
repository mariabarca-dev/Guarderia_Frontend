package com.GuarderiaCentral.Guarderia_Frontend.advice;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import java.net.URI;
import java.util.Set;

/**
 * Traduce los errores del back ({@link BackendException}) a lo que ve el usuario:
 * <ul>
 *   <li>401 (sesión del back vencida o back reiniciado): invalida la sesión del front y vuelve al login.</li>
 *   <li>403: redirige a /acceso-denegado.</li>
 *   <li>Cualquier otro (400, 404, 405, 409, 500, sin conexión): vuelve a la pantalla anterior con
 *       el atributo flash {@code mensajeError}. Si no hay una pantalla anterior segura a la que volver,
 *       muestra error.jsp con el mensaje (nunca un stacktrace).</li>
 * </ul>
 * Los controllers no capturan BackendException: la dejan subir hasta acá.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Slf4j
@ControllerAdvice
public class BackendExceptionAdvice {

    /** Pantallas a las que nunca se vuelve con un error (evita redirecciones en bucle). */
    private static final Set<String> RUTAS_SIN_VUELTA = Set.of("", "/", "/login", "/logout");

    /**
     * Maneja un error del back.
     *
     * @param ex      error lanzado por {@code BackendClientService}
     * @param request petición actual
     * @return redirección (login, acceso denegado o pantalla anterior) o la vista error.jsp
     */
    @ExceptionHandler(BackendException.class)
    public ModelAndView manejarBackendException(BackendException ex, HttpServletRequest request) {
        if (ex.getStatus() == 401) {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.invalidate();
            }
            SecurityContextHolder.clearContext();
            return new ModelAndView("redirect:/login?expired");
        }
        if (ex.getStatus() == 403) {
            return new ModelAndView("redirect:/acceso-denegado");
        }

        String volver = rutaDeVuelta(request);
        if (volver != null) {
            RequestContextUtils.getOutputFlashMap(request).put("mensajeError", ex.getMessage());
            return new ModelAndView("redirect:" + volver);
        }
        ModelAndView error = new ModelAndView("error");
        error.addObject("mensajeError", ex.getMessage());
        return error;
    }

    /**
     * Calcula a qué pantalla volver: la del header Referer (solo su ruta, sin host, para no
     * redirigir fuera del sitio). En un GET no se vuelve a la misma ruta que falló.
     *
     * @param request petición actual
     * @return ruta relativa al contexto, o null si no hay a dónde volver
     */
    private String rutaDeVuelta(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer == null) {
            return null;
        }
        URI uri;
        try {
            uri = URI.create(referer);
        } catch (IllegalArgumentException e) {
            return null;
        }
        String contexto = request.getContextPath();
        String ruta = uri.getRawPath();
        if (ruta == null || !ruta.startsWith(contexto)) {
            return null;
        }
        ruta = ruta.substring(contexto.length());
        if (RUTAS_SIN_VUELTA.contains(ruta)) {
            return null;
        }
        String destino = uri.getRawQuery() == null ? ruta : ruta + "?" + uri.getRawQuery();

        String actual = request.getRequestURI().substring(contexto.length())
                + (request.getQueryString() == null ? "" : "?" + request.getQueryString());
        if ("GET".equals(request.getMethod()) && destino.equals(actual)) {
            return null;
        }
        return destino;
    }
}

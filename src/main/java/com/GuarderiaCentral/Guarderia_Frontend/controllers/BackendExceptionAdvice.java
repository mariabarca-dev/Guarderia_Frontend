package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.exception.BackendException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.support.RequestContextUtils;

import java.net.URI;

/**
 * Captura las excepciones provenientes del Backend REST y las traduce a una vista o redirección.
 */
@Slf4j
@ControllerAdvice
public class BackendExceptionAdvice {

    /**
     * Maneja un {@link BackendException}: 401 cierra la sesión y va a /login, 403 va a
     * acceso denegado. Cualquier otro código vuelve a la vista anterior con el atributo
     * {@code mensajeError} (en un POST) o muestra la página de error con ese atributo (en un GET).
     *
     * @param ex      excepción lanzada por {@code BackendClientService}
     * @param request petición actual
     * @param model   modelo de la vista de error
     * @return vista o redirección a mostrar
     */
    @ExceptionHandler(BackendException.class)
    public String handleBackendException(BackendException ex, HttpServletRequest request, Model model) {
        log.error("Excepción del backend capturada: status={}, msg={}", ex.getStatus(), ex.getMessage());

        if (ex.getStatus() == 401) {
            SecurityContextHolder.clearContext();
            request.getSession().invalidate();
            return "redirect:/login?expired";
        }
        if (ex.getStatus() == 403) {
            return "redirect:/acceso-denegado";
        }

        String retorno = "POST".equalsIgnoreCase(request.getMethod()) ? rutaDeRetorno(request) : null;
        if (retorno != null) {
            FlashMap flashMap = RequestContextUtils.getOutputFlashMap(request);
            flashMap.put("mensajeError", ex.getMessage());
            return "redirect:" + retorno;
        }

        model.addAttribute("mensajeError", ex.getMessage());
        return "error";
    }

    /**
     * Calcula la ruta (relativa al contexto) de la página desde la que se hizo el pedido,
     * usando el encabezado Referer. Solo acepta páginas del mismo servidor.
     *
     * @param request petición actual
     * @return ruta a la que volver, o null si no hay una válida
     */
    private String rutaDeRetorno(HttpServletRequest request) {
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isBlank()) {
            return null;
        }
        try {
            URI uri = URI.create(referer);
            if (uri.getHost() == null || !uri.getHost().equalsIgnoreCase(request.getServerName())) {
                return null;
            }
            String contexto = request.getContextPath();
            String path = uri.getRawPath();
            if (path == null || !path.startsWith(contexto + "/")) {
                return null;
            }
            String relativa = path.substring(contexto.length());
            if (relativa.startsWith("/error") || relativa.startsWith("/login")) {
                return null;
            }
            return relativa;
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
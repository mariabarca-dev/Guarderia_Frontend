package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.exception.BackendException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

/**
 * Captura las excepciones provenientes del Backend REST y las traduce a una vista o redirección.
 */
@Slf4j
@ControllerAdvice
public class BackendExceptionAdvice {

    /**
     * Maneja un {@link BackendException}: 401 cierra la sesión, 403 va a acceso denegado
     * y cualquier otro código muestra la página de error con el mensaje.
     *
     * @param ex      excepción lanzada por {@code BackendClientService}
     * @param request petición actual (para invalidar la sesión en un 401)
     * @param model   modelo de la vista de error
     * @return vista o redirección a mostrar
     */
    @ExceptionHandler(BackendException.class)
    public String handleBackendException(BackendException ex, HttpServletRequest request, Model model) {
        log.error("Excepción del backend capturada: status={}, msg={}", ex.getStatus(), ex.getMessage());

        if (ex.getStatus() == 401) {
            request.getSession().invalidate();
            return "redirect:/login?expired";
        }
        if (ex.getStatus() == 403) {
            return "redirect:/acceso-denegado";
        }

        model.addAttribute("mensajeError", "Error en el servicio: " + ex.getMessage());
        return "error";
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.controllers;
import org.springframework.boot.webmvc.error.ErrorController;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
 //import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controlador de errores HTTP del contenedor (404, 500, etc.). Muestra error.jsp.
 */
@Controller
public class MvcErrorController implements ErrorController {

    /**
     * Prepara el código y el mensaje del error para la vista error.jsp.
     *
     * @param request petición con el código de estado del error
     * @param model   modelo donde se cargan {@code errorCode} y {@code errorMessage}
     * @return nombre de la vista error.jsp
     */
    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());
            model.addAttribute("errorCode", statusCode);

            if (statusCode == 404) {
                model.addAttribute("errorMessage", "La página o recurso solicitado no fue encontrado.");
            } else if (statusCode == 500) {
                model.addAttribute("errorMessage", "Ocurrió un error interno en el servidor.");
            } else {
                model.addAttribute("errorMessage", "Ha ocurrido un error inesperado.");
            }
        }

        return "error";
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.controllers;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MvcErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        // Obtener el código de estado HTTP si está disponible
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);

        if (status != null) {
            int statusCode = Integer.parseInt(status.toString());
            model.addAttribute("errorCode", statusCode);

            if (statusCode == 404) {
                model.addAttribute("errorMessage", "La página o recurso solicitada no fue encontrada.");
            } else if (statusCode == 500) {
                model.addAttribute("errorMessage", "Ocurrió un error interno en el servidor.");
            } else {
                model.addAttribute("errorMessage", "Ha ocurrido un error inesperado.");
            }
        }

        // Retorna el nombre del archivo JSP (error.jsp ubicado en tu directorio de vistas)
        return "error";
    }
}

package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controlador encargado de servir la pantalla de login.
 */
@Controller
public class LoginController {

    /**
     * Muestra la pantalla de login.
     *
     * @return nombre de la vista login.jsp
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }
}
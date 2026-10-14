package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controlador encargado de servir la pantalla de login, la de acceso denegado
 * y de redirigir la raíz del sitio.
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

    /**
     * Muestra la pantalla de acceso denegado (403).
     *
     * @return nombre de la vista accesoDenegado.jsp
     */
    @GetMapping("/acceso-denegado")
    public String accesoDenegado() {
        return "accesoDenegado";
    }

    /**
     * Redirige la raíz del sitio al login; si ya hay sesión, Spring Security lo manda al panel.
     *
     * @return redirección a /login
     */
    @GetMapping("/")
    public String raiz() {
        return "redirect:/login";
    }
}
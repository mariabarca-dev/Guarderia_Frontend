package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controlador de las rutas generales de acceso: la raíz del sitio y la pantalla de acceso denegado.
 */
@Controller
public class AccesoController {

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
     * Redirige la raíz del sitio a la pantalla de login.
     *
     * @return redirección a /login
     */
    @GetMapping("/")
    public String raiz() {
        return "redirect:/login";
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Inyecta en el Model de todas las vistas el rol y el nombre del usuario autenticado.
 */
@ControllerAdvice
public class GlobalControllerAdvice {

    /**
     * Agrega los atributos {@code rol} (en minúsculas) y {@code nombreUsuario} al Model.
     *
     * @param model modelo de la vista actual
     */
    @ModelAttribute
    public void addGlobalAttributes(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UsuarioAutenticado user) {
            model.addAttribute("rol", user.getRol().toLowerCase());
            model.addAttribute("nombreUsuario", user.getNombreUsuario());
        }
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.security.RedireccionPorRolHandler;
import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Espejo de AuthController del back. Sirve la pantalla de login (el POST /login lo procesa
 * Spring Security), la raíz del sitio y la pantalla de acceso denegado.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class LoginController {

    /**
     * Muestra el login. Si ya hay sesión iniciada, redirige al panel del rol (no se puede
     * volver al login con la sesión abierta, ni con "atrás" ni escribiendo /login).
     *
     * @param authentication autenticación actual (null si es anónimo)
     * @return vista login.jsp o redirección a /&lt;rol&gt;/dash
     */
    @GetMapping("/login")
    public String login(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UsuarioAutenticado) {
            return "redirect:" + RedireccionPorRolHandler.rutaPanel(authentication);
        }
        return "login";
    }

    /**
     * La raíz del sitio lleva al login (que a su vez redirige al panel si hay sesión).
     *
     * @return redirección a /login
     */
    @GetMapping("/")
    public String raiz() {
        return "redirect:/login";
    }

    /**
     * Pantalla de acceso denegado (403 de Spring Security o del back).
     *
     * @return vista acceso-denegado.jsp
     */
    @GetMapping("/acceso-denegado")
    public String accesoDenegado() {
        return "acceso-denegado";
    }
}

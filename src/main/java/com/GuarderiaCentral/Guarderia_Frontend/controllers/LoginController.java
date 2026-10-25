package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.security.BackendLogoutHandler;
import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
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

    private final BackendLogoutHandler backendLogoutHandler;

    /**
     * Crea el controller.
     *
     * @param backendLogoutHandler cierra también la sesión del back al llegar al login con sesión abierta
     */
    public LoginController(BackendLogoutHandler backendLogoutHandler) {
        this.backendLogoutHandler = backendLogoutHandler;
    }

    /**
     * Muestra el login. Si se llega con la sesión abierta (por ejemplo con la flecha "atrás" del
     * navegador o escribiendo /login), las credenciales se descartan: se cierra la sesión del back
     * y la del front, y se vuelve a mostrar el login. Así la flecha "adelante" ya no permite entrar.
     *
     * @param authentication autenticación actual (null si es anónimo)
     * @param request        petición actual
     * @param response       respuesta actual
     * @return vista login.jsp, o redirección a /login?logout luego de cerrar la sesión
     */
    @GetMapping("/login")
    public String login(Authentication authentication, HttpServletRequest request, HttpServletResponse response) {
        if (authentication != null && authentication.getPrincipal() instanceof UsuarioAutenticado) {
            backendLogoutHandler.logout(request, response, authentication);
            new SecurityContextLogoutHandler().logout(request, response, authentication);
            return "redirect:/login?logout";
        }
        return "login";
    }

    /**
     * La raíz del sitio lleva al login (que cierra la sesión si hubiera una abierta).
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
package com.GuarderiaCentral.Guarderia_Frontend.security;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import com.GuarderiaCentral.Guarderia_Frontend.client.BackendException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Component;

/**
 * Al cerrar sesión en el front, cierra también la sesión del back ({@code POST /auth/logout}).
 * Si esa llamada falla (back caído o sesión ya vencida) se ignora y el logout del front sigue igual.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Slf4j
@Component
public class BackendLogoutHandler implements LogoutHandler {

    private final BackendClientService backendClientService;

    /**
     * Crea el handler.
     *
     * @param backendClientService cliente HTTP hacia el back
     */
    public BackendLogoutHandler(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    /**
     * Llama al logout del back con la cookie guardada en el {@link UsuarioAutenticado}.
     *
     * @param request        petición de logout
     * @param response       respuesta de logout
     * @param authentication autenticación que se está cerrando (puede ser null si la sesión ya venció)
     */
    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UsuarioAutenticado usuario) {
            try {
                backendClientService.logout(usuario.getCookieBack());
            } catch (BackendException e) {
                log.warn("No se pudo cerrar la sesión del back (se continúa con el logout del front): {}", e.getStatus());
            }
        }
    }
}

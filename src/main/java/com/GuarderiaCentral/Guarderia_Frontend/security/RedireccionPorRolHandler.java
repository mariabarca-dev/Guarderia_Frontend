package com.GuarderiaCentral.Guarderia_Frontend.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Manejador de éxito en el Login. Redirige automáticamente al panel (/dash)
 * correspondiente según el ROL del usuario autenticado.
 */
@Component
public class RedireccionPorRolHandler implements AuthenticationSuccessHandler {

    /**
     * Redirige a {@code /<rol>/dash} una vez autenticado el usuario.
     *
     * @param request        petición del login
     * @param response       respuesta donde se envía la redirección
     * @param authentication autenticación exitosa con el rol del usuario
     * @throws IOException si falla el envío de la redirección
     */
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        GrantedAuthority authority = authentication.getAuthorities().iterator().next();
        String rol = authority.getAuthority().replace("ROLE_", "").toLowerCase();

        response.sendRedirect(request.getContextPath() + "/" + rol + "/dash");
    }
}
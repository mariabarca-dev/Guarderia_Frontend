package com.GuarderiaCentral.Guarderia_Frontend.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * Después de un login correcto redirige al panel del rol, SIN if ni switch por rol:
 * toma la autoridad, le quita "ROLE_", la pasa a minúsculas y arma "/" + rol + "/dash".
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Component
public class RedireccionPorRolHandler implements AuthenticationSuccessHandler {

    private static final String PREFIJO_ROL = "ROLE_";

    /**
     * Arma la ruta del panel a partir de la autoridad del usuario. La usan este handler
     * y {@code LoginController} (para no volver al login con la sesión iniciada).
     *
     * @param authentication autenticación con una única autoridad ROLE_&lt;ROL&gt;
     * @return ruta del panel, por ejemplo "/socio/dash"
     */
    public static String rutaPanel(Authentication authentication) {
        // Se busca la autoridad ROLE_* (Spring Security 7 puede agregar otras, como FACTOR_PASSWORD)
        String autoridad = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .filter(a -> a.startsWith(PREFIJO_ROL))
                .findFirst()
                .orElseThrow();
        return "/" + autoridad.substring(PREFIJO_ROL.length()).toLowerCase() + "/dash";
    }

    /**
     * Redirige a {@code /<rol>/dash}.
     *
     * @param request        petición del login
     * @param response       respuesta donde se envía la redirección
     * @param authentication autenticación exitosa
     * @throws IOException si falla el envío de la redirección
     */
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        response.sendRedirect(request.getContextPath() + rutaPanel(authentication));
    }
}

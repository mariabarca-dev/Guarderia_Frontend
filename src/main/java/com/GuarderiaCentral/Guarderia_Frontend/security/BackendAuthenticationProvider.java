package com.GuarderiaCentral.Guarderia_Frontend.security;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import com.GuarderiaCentral.Guarderia_Frontend.client.BackendException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Proveedor de autenticación del front: el front no tiene usuarios propios, delega en el back.
 * <p>
 * Antes de llamar al back valida el formato del usuario y de la clave (barrera contra scripts
 * o marcado en el login). Si el back acepta, arma un {@link UsuarioAutenticado} con el rol que
 * informa el back y la cookie de sesión del back. La clave nunca se guarda ni se registra.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Slf4j
@Component
public class BackendAuthenticationProvider implements AuthenticationProvider {

    private static final Pattern PATRON_USUARIO = Pattern.compile("^[a-zA-Z0-9_.-]{1,50}$");
    private static final int LARGO_MAXIMO_CLAVE = 100;
    private static final String MENSAJE_CREDENCIALES = "Usuario o clave incorrectos";

    private final BackendClientService backendClientService;

    /**
     * Crea el proveedor.
     *
     * @param backendClientService cliente HTTP hacia el back
     */
    public BackendAuthenticationProvider(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    /**
     * Valida el formato de las credenciales y las verifica contra {@code POST /auth/login} del back.
     *
     * @param authentication token con el usuario y la clave del formulario de login
     * @return autenticación con {@link UsuarioAutenticado} como principal y la autoridad ROLE_&lt;rol&gt;
     * @throws BadCredentialsException         si el formato es inválido o el back responde 400/401
     * @throws AuthenticationServiceException si el back no responde o falla
     */
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials() == null ? null : authentication.getCredentials().toString();

        if (!usuarioValido(username) || !claveValida(password)) {
            log.warn("Login rechazado por formato inválido (no se consultó al back)");
            throw new BadCredentialsException(MENSAJE_CREDENCIALES);
        }

        try {
            Map<String, String> login = backendClientService.login(username, password);
            String rol = login.get(BackendClientService.LOGIN_ROL);
            UsuarioAutenticado principal = new UsuarioAutenticado(
                    login.get(BackendClientService.LOGIN_NOMBRE_USUARIO), rol, login.get(BackendClientService.LOGIN_COOKIE));

            log.info("Login correcto de {} con rol {}", principal.getNombreUsuario(), rol);
            return new UsernamePasswordAuthenticationToken(principal, null, List.of(new SimpleGrantedAuthority("ROLE_" + rol)));
        } catch (BackendException e) {
            if (e.getStatus() == 400 || e.getStatus() == 401) {
                throw new BadCredentialsException(MENSAJE_CREDENCIALES);
            }
            throw new AuthenticationServiceException("No se pudo conectar con el servidor");
        }
    }

    /**
     * Indica que este proveedor procesa autenticaciones por usuario y clave.
     *
     * @param authentication clase del token a evaluar
     * @return true si es un {@link UsernamePasswordAuthenticationToken}
     */
    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }

    /**
     * Usuario: solo letras, números, guion bajo, punto y guion, de 1 a 50 caracteres.
     */
    private boolean usuarioValido(String username) {
        return username != null && PATRON_USUARIO.matcher(username).matches();
    }

    /**
     * Clave: de 1 a 100 caracteres y sin los caracteres de marcado &lt; ni &gt;.
     */
    private boolean claveValida(String password) {
        return password != null && !password.isEmpty() && password.length() <= LARGO_MAXIMO_CLAVE
                && password.indexOf('<') < 0 && password.indexOf('>') < 0;
    }
}

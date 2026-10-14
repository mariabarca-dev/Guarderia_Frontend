package com.GuarderiaCentral.Guarderia_Frontend.security;

import com.GuarderiaCentral.Guarderia_Frontend.exception.BackendException;
import com.GuarderiaCentral.Guarderia_Frontend.service.BackendClientService;
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

/**
 * Proveedor de Autenticación personalizado que delega la validación de credenciales
 * al backend vía API REST.
 */
@Slf4j
@Component
public class BackendAuthenticationProvider implements AuthenticationProvider {

    private final BackendClientService backendClientService;

    /**
     * Crea el proveedor de autenticación.
     *
     * @param backendClientService cliente HTTP que se comunica con el backend
     */
    public BackendAuthenticationProvider(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    /**
     * Autentica al usuario contra el backend y construye el Authentication con su rol y token JWT.
     *
     * @param authentication token con el usuario y la contraseña ingresados en el formulario
     * @return autenticación completa con {@link UsuarioAutenticado} como principal
     * @throws AuthenticationException si las credenciales son inválidas o el backend no responde bien
     */
    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        try {
            Map<String, Object> response = backendClientService.login(username, password);

            if (response == null || response.get("accessToken") == null || response.get("rol") == null) {
                throw new AuthenticationServiceException("El back no devolvió accessToken o rol");
            }

            String accessToken = (String) response.get("accessToken");
            String rol = (String) response.get("rol");

            UsuarioAutenticado principal = new UsuarioAutenticado(username, rol, accessToken);
            SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + rol);

            log.info("Autenticación exitosa en Backend para el usuario: {} con ROL: {}", username, rol);

            return new UsernamePasswordAuthenticationToken(principal, null, List.of(authority));

        } catch (BackendException e) {
            log.warn("Fallo de autenticación en backend para usuario: {} (status {})", username, e.getStatus());
            if (e.getStatus() >= 500) {
                throw new AuthenticationServiceException("Backend no disponible: " + e.getMessage());
            }
            throw new BadCredentialsException("Credenciales inválidas: " + e.getMessage());
        }
    }

    /**
     * Indica que este proveedor solo procesa autenticaciones por usuario y contraseña.
     *
     * @param authentication clase del token de autenticación a evaluar
     * @return true si es un {@link UsernamePasswordAuthenticationToken}
     */
    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}
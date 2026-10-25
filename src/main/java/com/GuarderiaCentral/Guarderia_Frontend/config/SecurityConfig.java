package com.GuarderiaCentral.Guarderia_Frontend.config;

import com.GuarderiaCentral.Guarderia_Frontend.security.BackendAuthenticationProvider;
import com.GuarderiaCentral.Guarderia_Frontend.security.BackendLogoutHandler;
import com.GuarderiaCentral.Guarderia_Frontend.security.RedireccionPorRolHandler;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.ExceptionMappingAuthenticationFailureHandler;

import java.util.Map;

/**
 * Configuración de Spring Security del front: TODAS las reglas de rutas en un solo {@code @Bean}.
 * <ul>
 *   <li>Cada rol accede solo a su prefijo (/socio/**, /empleado/**, /administrador/**, /sysadmin/**).
 *       Los controllers no revisan roles. Agregar un rol = agregar una línea requestMatchers.</li>
 *   <li>Login por formulario contra el back ({@link BackendAuthenticationProvider}) y redirección
 *       al panel del rol ({@link RedireccionPorRolHandler}).</li>
 *   <li>Logout por POST que invalida la sesión del front y cierra la del back ({@link BackendLogoutHandler}).</li>
 *   <li>CSRF activado (por defecto) y cabeceras no-cache (Cache-Control: no-cache, no-store, max-age=0,
 *       must-revalidate; Pragma: no-cache; Expires: 0), para que "atrás" siempre vuelva a pedir la página.</li>
 * </ul>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final BackendAuthenticationProvider authenticationProvider;
    private final RedireccionPorRolHandler redireccionPorRolHandler;
    private final BackendLogoutHandler backendLogoutHandler;

    /**
     * Crea la configuración.
     *
     * @param authenticationProvider   valida las credenciales contra el back
     * @param redireccionPorRolHandler redirige al panel del rol después del login
     * @param backendLogoutHandler     cierra la sesión del back en el logout
     */
    public SecurityConfig(BackendAuthenticationProvider authenticationProvider,
                          RedireccionPorRolHandler redireccionPorRolHandler,
                          BackendLogoutHandler backendLogoutHandler) {
        this.authenticationProvider = authenticationProvider;
        this.redireccionPorRolHandler = redireccionPorRolHandler;
        this.backendLogoutHandler = backendLogoutHandler;
    }

    /**
     * Cadena de filtros de seguridad del front.
     *
     * @param http configurador de seguridad HTTP
     * @return la cadena de filtros
     * @throws Exception si falla la construcción de la configuración
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        // Login fallido: credenciales -> /login?error ; back sin respuesta -> /login?error=servidor
        ExceptionMappingAuthenticationFailureHandler falloLogin = new ExceptionMappingAuthenticationFailureHandler();
        falloLogin.setDefaultFailureUrl("/login?error");
        falloLogin.setExceptionMappings(Map.of(AuthenticationServiceException.class.getName(), "/login?error=servidor"));

        http
                .authenticationProvider(authenticationProvider)
                .authorizeHttpRequests(auth -> auth
                        // Los forward/include internos hacia las JSP y el despacho de errores no son rutas del usuario
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.INCLUDE, DispatcherType.ERROR).permitAll()
                        .requestMatchers("/", "/login", "/acceso-denegado", "/error",
                                "/images/**", "/css/**", "/caravana.ico").permitAll()
                        .requestMatchers("/socio/**").hasRole("SOCIO")
                        .requestMatchers("/empleado/**").hasRole("EMPLEADO")
                        .requestMatchers("/administrador/**").hasRole("ADMINISTRADOR")
                        .requestMatchers("/sysadmin/**").hasRole("SYSADMIN")
                        .anyRequest().authenticated()
                )
                .headers(headers -> headers.cacheControl(Customizer.withDefaults()))
                .formLogin(form -> form
                        .loginPage("/login")
                        .successHandler(redireccionPorRolHandler)
                        .failureHandler(falloLogin)
                        .permitAll()
                )
                .exceptionHandling(ex -> ex.accessDeniedPage("/acceso-denegado"))
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .addLogoutHandler(backendLogoutHandler)
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll()
                );

        return http.build();
    }
}

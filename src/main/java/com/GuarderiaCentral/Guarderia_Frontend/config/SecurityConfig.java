package com.GuarderiaCentral.Guarderia_Frontend.config;

import com.GuarderiaCentral.Guarderia_Frontend.security.BackendAuthenticationProvider;
import com.GuarderiaCentral.Guarderia_Frontend.security.RedireccionPorRolHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuración central de Spring Security del Frontend.
 * La autorización de rutas se hace únicamente aquí; no hay interceptores propios.
 * Las cabeceras anti-caché (Cache-Control, Pragma, Expires) son las que Spring Security
 * envía por defecto, para que tras cerrar sesión el botón "atrás" del navegador
 * no muestre páginas protegidas.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final BackendAuthenticationProvider authenticationProvider;
    private final RedireccionPorRolHandler successHandler;

    /**
     * Crea la configuración de seguridad.
     *
     * @param authenticationProvider proveedor que valida credenciales contra el back
     * @param successHandler         handler que redirige al panel según el rol
     */
    public SecurityConfig(BackendAuthenticationProvider authenticationProvider,
                          RedireccionPorRolHandler successHandler) {
        this.authenticationProvider = authenticationProvider;
        this.successHandler = successHandler;
    }

    /**
     * Define la cadena de filtros de seguridad del front.
     *
     * @param http configurador de seguridad HTTP
     * @return la cadena de filtros construida
     * @throws Exception si falla la construcción de la configuración
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authenticationProvider(authenticationProvider)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/login", "/acceso-denegado", "/error",
                                "/images/**", "/caravana.ico", "/css/**").permitAll()
                        .requestMatchers("/socio/**").hasRole("SOCIO")
                        .requestMatchers("/empleado/**").hasRole("EMPLEADO")
                        .requestMatchers("/administrador/**").hasRole("ADMINISTRADOR")
                        .requestMatchers("/sysadmin/**").hasRole("SYSADMIN")
                        .anyRequest().authenticated()
                )
                .headers(headers -> headers
                        .cacheControl(Customizer.withDefaults())
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .successHandler(successHandler)
                        .failureUrl("/login?error")
                        .permitAll()
                )
                .exceptionHandling(ex -> ex
                        .accessDeniedPage("/acceso-denegado")
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .logoutSuccessUrl("/login?logout")
                        .permitAll()
                );

        return http.build();
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuración Web MVC limpia (sin interceptores manuales).
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {
    // Interceptores eliminados: La seguridad es manejada exclusivamente por Spring Security.
}
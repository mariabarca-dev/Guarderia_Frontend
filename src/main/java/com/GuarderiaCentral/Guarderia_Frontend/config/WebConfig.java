package com.GuarderiaCentral.Guarderia_Frontend.config;

import com.GuarderiaCentral.Guarderia_Frontend.interceptors.AuthInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Registramos el interceptor para proteger las rutas del sistema
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/dashboard/**", "/admin/**", "/empleado/**", "/socio/**") // Rutas que exigen estar logueado
                .excludePathPatterns("/login", "/do-login", "/error"); // Rutas libres donde no se exige sesión previa
    }
}
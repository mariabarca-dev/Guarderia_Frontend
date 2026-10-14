package com.GuarderiaCentral.Guarderia_Frontend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Configuración del cliente HTTP usado para consumir la API REST del Backend.
 */
@Configuration
public class RestTemplateConfig {

    /**
     * Crea el {@link RestTemplate} compartido por {@code BackendClientService}.
     *
     * @return instancia de RestTemplate
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
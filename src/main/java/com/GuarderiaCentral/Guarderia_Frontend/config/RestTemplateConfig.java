package com.GuarderiaCentral.Guarderia_Frontend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

/**
 * Configuración única del cliente HTTP que usa {@code BackendClientService} para consumir la API REST del back.
 * <p>
 * Se usa {@link SimpleClientHttpRequestFactory} (HttpURLConnection del JDK), que NO administra cookies
 * por su cuenta: la cookie de sesión del back la envía siempre {@code BackendClientService} de forma explícita.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Configuration
public class RestTemplateConfig {

    /**
     * Crea el {@link RestTemplate} compartido, con timeout de conexión y de lectura.
     *
     * @param timeoutConexion milisegundos máximos para establecer la conexión con el back
     * @param timeoutLectura  milisegundos máximos para esperar la respuesta del back
     * @return instancia de RestTemplate configurada
     */
    @Bean
    public RestTemplate restTemplate(@Value("${backend.timeout.conexion:5000}") long timeoutConexion,
                                     @Value("${backend.timeout.lectura:10000}") long timeoutLectura) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(Duration.ofMillis(timeoutConexion));
        factory.setReadTimeout(Duration.ofMillis(timeoutLectura));
        return new RestTemplate(factory);
    }
}

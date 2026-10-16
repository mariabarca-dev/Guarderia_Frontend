package com.GuarderiaCentral.Guarderia_Frontend;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Inicializador para desplegar el frontend como WAR en un contenedor de servlets externo.
 */
public class ServletInitializer extends SpringBootServletInitializer {

	/**
	 * Indica la clase principal que arranca la aplicación al desplegar el WAR.
	 *
	 * @param application constructor de la aplicación
	 * @return constructor configurado con {@link GuarderiaFrontendApplication}
	 */
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(GuarderiaFrontendApplication.class);
	}
}
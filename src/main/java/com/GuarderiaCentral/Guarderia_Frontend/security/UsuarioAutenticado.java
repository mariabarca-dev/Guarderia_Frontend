package com.GuarderiaCentral.Guarderia_Frontend.security;

import org.springframework.security.core.AuthenticatedPrincipal;

import java.io.Serializable;

/**
 * Objeto Principal almacenado en la autenticación de Spring Security.
 * Almacena los datos del usuario logueado y su token JWT.
 */
public class UsuarioAutenticado implements AuthenticatedPrincipal, Serializable {

    private static final long serialVersionUID = 1L;

    private final String nombreUsuario;
    private final String rol;
    private final String accessToken;

    /**
     * Constructor con los datos necesarios del usuario autenticado.
     *
     * @param nombreUsuario Nombre de usuario.
     * @param rol           Rol asignado (ej: SOCIO, EMPLEADO, ADMINISTRADOR, SYSADMIN).
     * @param accessToken   Token JWT recibido del Backend.
     */
    public UsuarioAutenticado(String nombreUsuario, String rol, String accessToken) {
        this.nombreUsuario = nombreUsuario;
        this.rol = rol;
        this.accessToken = accessToken;
    }

    /**
     * Devuelve el nombre de usuario (lo usa Spring Security en {@code getName()}).
     *
     * @return nombre de usuario
     */
    @Override
    public String getName() {
        return nombreUsuario;
    }

    /**
     * Devuelve el nombre de usuario.
     *
     * @return nombre de usuario
     */
    public String getNombreUsuario() {
        return nombreUsuario;
    }

    /**
     * Devuelve el rol del usuario.
     *
     * @return rol (SOCIO, EMPLEADO, ADMINISTRADOR o SYSADMIN)
     */
    public String getRol() {
        return rol;
    }

    /**
     * Devuelve el token JWT emitido por el Backend.
     *
     * @return token de acceso
     */
    public String getAccessToken() {
        return accessToken;
    }
}
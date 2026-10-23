package com.GuarderiaCentral.Guarderia_Frontend.security;

import org.springframework.security.core.AuthenticatedPrincipal;

import java.io.Serial;
import java.io.Serializable;

/**
 * Principal que Spring Security guarda en la sesión del front después del login.
 * <p>
 * Contiene el nombre de usuario, el rol (leído del back en cada login) y el valor de la cookie
 * {@code GUARDERIA_BACK}, que el front reenvía al back en cada llamada. La cookie nunca se expone
 * al navegador ni se muestra en ninguna JSP. No guarda la clave.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
public class UsuarioAutenticado implements AuthenticatedPrincipal, Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private final String nombreUsuario;
    private final String rol;
    private final String cookieBack;

    /**
     * Crea el usuario autenticado.
     *
     * @param nombreUsuario nombre de usuario devuelto por el back
     * @param rol           rol devuelto por el back (SOCIO, EMPLEADO, ADMINISTRADOR o SYSADMIN)
     * @param cookieBack    valor de la cookie de sesión del back
     */
    public UsuarioAutenticado(String nombreUsuario, String rol, String cookieBack) {
        this.nombreUsuario = nombreUsuario;
        this.rol = rol;
        this.cookieBack = cookieBack;
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
     * @return rol en mayúsculas (SOCIO, EMPLEADO, ADMINISTRADOR o SYSADMIN)
     */
    public String getRol() {
        return rol;
    }

    /**
     * Devuelve el valor de la cookie de sesión del back.
     *
     * @return valor de GUARDERIA_BACK
     */
    public String getCookieBack() {
        return cookieBack;
    }

    /**
     * Representación sin datos sensibles (no incluye la cookie del back).
     *
     * @return texto con el nombre de usuario y el rol
     */
    @Override
    public String toString() {
        return "UsuarioAutenticado[" + nombreUsuario + ", " + rol + "]";
    }
}

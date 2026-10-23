package com.GuarderiaCentral.Guarderia_Frontend.client;

/**
 * Error devuelto por el back (o falta de conexión con él).
 * <p>
 * Guarda el código HTTP y el campo {@code message} del JSON de error del back.
 * Si el back no responde, el código es {@link #SIN_CONEXION}.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
public class BackendException extends RuntimeException {

    /** Código usado cuando el back no responde (no hay respuesta HTTP real). */
    public static final int SIN_CONEXION = 503;

    private final int status;

    /**
     * Crea la excepción.
     *
     * @param status  código HTTP devuelto por el back ({@link #SIN_CONEXION} si no respondió)
     * @param message mensaje del campo "message" del JSON de error del back
     */
    public BackendException(int status, String message) {
        super(message);
        this.status = status;
    }

    /**
     * Devuelve el código HTTP del error.
     *
     * @return código HTTP (400, 401, 403, 404, 405, 409, 500, 503...)
     */
    public int getStatus() {
        return status;
    }
}

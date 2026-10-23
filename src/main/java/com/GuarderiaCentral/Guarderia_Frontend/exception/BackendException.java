package com.GuarderiaCentral.Guarderia_Frontend.exception;

/**
 * Excepción personalizada para capturar errores HTTP retornados por el Backend REST.
 */
public class BackendException extends RuntimeException {

    /** Código usado cuando el back no responde (no hay respuesta HTTP real). */
    public static final int SIN_CONEXION = 503;

    private final int status;

    /**
     * Constructor de la excepción.
     *
     * @param status  Código de estado HTTP devuelto por el backend.
     * @param message Mensaje explicativo del error.
     */
    public BackendException(int status, String message) {
        super(message);
        this.status = status;
    }

    /**
     * Devuelve el código de estado HTTP del error.
     *
     * @return código HTTP devuelto por el backend
     */
    public int getStatus() {
        return status;
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

/**
 * Servicio transversal para la gestión general de cuentas de usuario y los datos del usuario logueado.
 */
@Service
public class UsuarioService {

    private final BackendClientService backendClientService;

    public UsuarioService(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    /**
     * Obtiene la cuenta del usuario autenticado (GET /usuarios/me).
     */
    public Object obtenerUsuarioActual() {
        return backendClientService.get("/usuarios/me");
    }

    /**
     * Obtiene el listado general de cuentas (solo SYSADMIN) (GET /usuarios).
     */
    public Object listarTodasLasCuentas() {
        return backendClientService.get("/usuarios");
    }

    /**
     * Obtiene las cuentas dadas de baja (solo SYSADMIN) (GET /usuarios/inactivos).
     */
    public Object listarCuentasInactivas() {
        return backendClientService.get("/usuarios/inactivos");
    }

    /**
     * Obtiene el detalle de una cuenta por ID (GET /usuarios/{id}).
     */
    public Object obtenerCuentaPorId(Integer id) {
        return backendClientService.get("/usuarios/" + id);
    }
}
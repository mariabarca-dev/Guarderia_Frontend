package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;
import java.util.Map;

/**
 * Servicio que atiende las operaciones de la entidad Administrador y cuentas de administración.
 */
@Service
public class AdministradorService {

    private final BackendClientService backendClientService;

    public AdministradorService(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    // --- CRUD DE CUENTAS DE ADMINISTRADORES (SYSADMIN: /usuarios/administradores) ---

    public Object listarAdministradores() {
        return backendClientService.get("/usuarios/administradores");
    }

    public Object listarAdministradoresInactivos() {
        return backendClientService.get("/usuarios/administradores/inactivos");
    }

    public Object obtenerAdministradorPorId(Integer id) {
        return backendClientService.get("/usuarios/administradores/" + id);
    }

    public Object crearAdministrador(Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "nombre", "apellido", "direccion", "telefono", "nombreUsuario", "clave");
        return backendClientService.post("/usuarios/administradores", body);
    }

    /**
     * Edita un administrador. La clave es opcional: si el formulario la trae vacía se envía
     * como nula y el back conserva la clave actual; si trae un valor, el back la reemplaza (cifrada).
     *
     * @param id         id del administrador a editar
     * @param formulario campos del formulario de edición
     * @return respuesta del back con el administrador actualizado
     */
    public Object editarAdministrador(Integer id, Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "nombre", "apellido", "direccion", "telefono", "nombreUsuario", "clave");
        return backendClientService.put("/usuarios/administradores/" + id, body);
    }

    public Object eliminarAdministrador(Integer id) {
        return backendClientService.delete("/usuarios/administradores/" + id);
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Servicio que atiende las operaciones de la entidad Socio y lo propio del usuario con rol SOCIO.
 */
@Service
public class SocioService {

    private final BackendClientService backendClientService;

    public SocioService(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    // --- MÉTODOS DEL SOCIO LOGUEADO (/usuarios/me/socio) ---

    public Object obtenerMiPerfil() {
        return backendClientService.get("/usuarios/me/socio");
    }

    public Object obtenerMisVehiculos() {
        return backendClientService.get("/usuarios/me/socio/vehiculos");
    }

    public Object obtenerMiVehiculoDetalle(Integer vehiculoId) {
        return backendClientService.get("/usuarios/me/socio/vehiculos/" + vehiculoId);
    }

    public Object obtenerMisCocherasOcupadas() {
        return backendClientService.get("/usuarios/me/socio/garages-ocupados");
    }

    public Object obtenerMisComprasProperties() {
        return backendClientService.get("/usuarios/me/socio/propiedades");
    }

    // --- CRUD DE CUENTAS DE SOCIOS (ADMINISTRADOR y SYSADMIN: /usuarios/socios) ---

    public Object listarSocios() {
        return backendClientService.get("/usuarios/socios");
    }

    public Object listarSociosInactivos() {
        return backendClientService.get("/usuarios/socios/inactivos");
    }

    public Object obtenerSocioPorId(Integer id) {
        return backendClientService.get("/usuarios/socios/" + id);
    }

    public Object buscarSocioPorDni(String dni) {
        return backendClientService.get("/usuarios/socios/dni/" + dni);
    }

    public Object crearSocio(Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "dni", "nombre", "apellido", "direccion", "telefono", "fechaIngreso", "nombreUsuario", "clave");
        return backendClientService.post("/usuarios/socios", body);
    }

    /**
     * Edita un socio. La clave es opcional: si el formulario la trae vacía se envía
     * como nula y el back conserva la clave actual; si trae un valor, el back la reemplaza (cifrada).
     *
     * @param id         id del socio a editar
     * @param formulario campos del formulario de edición
     * @return respuesta del back con el socio actualizado
     */
    public Object editarSocio(Integer id, Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "dni", "nombre", "apellido", "direccion", "telefono", "fechaIngreso", "nombreUsuario", "clave");
        return backendClientService.put("/usuarios/socios/" + id, body);
    }

    public Object eliminarSocio(Integer id) {
        return backendClientService.delete("/usuarios/socios/" + id);
    }

    // --- CONSULTAS EXTRA (SOLO ADMINISTRADOR) ---

    public Object obtenerVehiculosDeSocio(Integer id) {
        return backendClientService.get("/usuarios/socios/" + id + "/vehiculos");
    }

    public Object obtenerGaragesDeSocio(Integer id) {
        return backendClientService.get("/usuarios/socios/" + id + "/garages");
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Servicio que atiende las operaciones de la entidad Empleado y lo propio del usuario con rol EMPLEADO.
 */
@Service
public class EmpleadoService {

    private final BackendClientService backendClientService;

    public EmpleadoService(BackendClientService backendClientService) {
        this.backendClientService = backendClientService;
    }

    // --- MÉTODOS DEL EMPLEADO LOGUEADO (/usuarios/me/empleado) ---

    public Object obtenerMiLegajo() {
        return backendClientService.get("/usuarios/me/empleado");
    }

    public Object obtenerMisSectores() {
        return backendClientService.get("/usuarios/me/empleado/zonas");
    }

    public Object obtenerMisEncargos() {
        return backendClientService.get("/usuarios/me/empleado/vehiculos");
    }

    // --- CRUD DE CUENTAS DE EMPLEADOS (ADMINISTRADOR y SYSADMIN: /usuarios/empleados) ---

    public Object listarEmpleados() {
        return backendClientService.get("/usuarios/empleados");
    }

    public Object listarEmpleadosInactivos() {
        return backendClientService.get("/usuarios/empleados/inactivos");
    }

    public Object obtenerEmpleadoPorId(Integer id) {
        return backendClientService.get("/usuarios/empleados/" + id);
    }

    public Object crearEmpleado(Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "codigoEmpleado", "nombre", "apellido", "especialidad", "direccion", "telefono", "dni", "nombreUsuario", "clave");
        return backendClientService.post("/usuarios/empleados", body);
    }

    public Object editarEmpleado(Integer id, Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "codigoEmpleado", "nombre", "apellido", "especialidad", "direccion", "telefono", "dni", "nombreUsuario");
        return backendClientService.put("/usuarios/empleados/" + id, body);
    }

    public Object eliminarEmpleado(Integer id) {
        return backendClientService.delete("/usuarios/empleados/" + id);
    }

    // --- CONSULTAS Y ACCIONES EXTRA (SOLO ADMINISTRADOR) ---

    public Object obtenerSectoresDeEmpleado(Integer id) {
        return backendClientService.get("/usuarios/empleados/" + id + "/zonas");
    }

    public Object obtenerEncargosDeEmpleado(Integer id) {
        return backendClientService.get("/usuarios/empleados/" + id + "/vehiculos-a-cargo");
    }

    public Object encargarVehiculo(Integer empleadoId, Integer vehiculoId) {
        return backendClientService.put("/usuarios/empleados/" + empleadoId + "/vehiculos/" + vehiculoId, null);
    }

    public Object desencargarVehiculo(Integer empleadoId, Integer vehiculoId) {
        return backendClientService.delete("/usuarios/empleados/" + empleadoId + "/vehiculos/" + vehiculoId);
    }
}
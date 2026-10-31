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

    /**
     * Obtiene un empleado por su id.
     *
     * @param id id interno del empleado
     * @return datos del empleado (el controller los usa, por ejemplo, para armar títulos con código y nombre)
     */
    public Map<String, Object> obtenerEmpleadoPorId(Integer id) {
        return backendClientService.getMapa("/usuarios/empleados/" + id);
    }

    public Object crearEmpleado(Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "codigo", "nombre", "apellido", "especialidad", "direccion", "telefono", "dni", "nombreUsuario", "clave");
        return backendClientService.post("/usuarios/empleados", body);
    }

    /**
     * Edita un empleado. La clave es opcional: si el formulario la trae vacía se envía
     * como nula y el back conserva la clave actual; si trae un valor, el back la reemplaza (cifrada).
     *
     * @param id         id del empleado a editar
     * @param formulario campos del formulario de edición
     * @return respuesta del back con el empleado actualizado
     */
    public Object editarEmpleado(Integer id, Map<String, String> formulario) {
        Map<String, Object> body = BackendClientService.armarCuerpo(formulario,
                "codigo", "nombre", "apellido", "especialidad", "direccion", "telefono", "dni", "nombreUsuario", "clave");
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

    /**
     * Encarga un vehículo a un empleado a partir de la matrícula que escribió el administrador.
     * Primero consulta al back el vehículo por matrícula (GET /vehiculos/matricula/{matricula}) para
     * obtener su id interno y luego lo encarga con {@link #encargarVehiculo(Integer, Integer)}.
     *
     * @param empleadoId id del empleado
     * @param matricula  matrícula del vehículo a encargar
     * @return respuesta del back al encargar
     */
    public Object encargarVehiculoPorMatricula(Integer empleadoId, String matricula) {
        Map<String, Object> vehiculo = backendClientService.getMapa("/vehiculos/matricula/" + BackendClientService.segmento(matricula.trim()));
        Integer vehiculoId = ((Number) vehiculo.get("id")).intValue();
        return encargarVehiculo(empleadoId, vehiculoId);
    }

    public Object desencargarVehiculo(Integer empleadoId, Integer vehiculoId) {
        return backendClientService.delete("/usuarios/empleados/" + empleadoId + "/vehiculos/" + vehiculoId);
    }
}
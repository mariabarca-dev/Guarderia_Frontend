package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de AsignacionEmpleadoZonaService del back (solo ADMINISTRADOR): qué empleado atiende qué zona
 * y cuántos vehículos tiene a cargo. Endpoint base: /asignaciones-empleado-zona.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class AsignacionEmpleadoZonaService {

    private static final String BASE = "/asignaciones-empleado-zona";
    /** Campos de AsignacionEmpleadoZonaRequest / AsignacionEmpleadoZonaUpdate del back que se copian tal cual del formulario (empleado y zona se resuelven aparte). */
    private static final String[] CAMPOS = {"cantVehiculosACargo"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public AsignacionEmpleadoZonaService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Asignaciones activas ({@code GET /asignaciones-empleado-zona}).
     *
     * @return lista de AsignacionEmpleadoZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Historial: todas las asignaciones, activas y dadas de baja ({@code GET /asignaciones-empleado-zona/admin/todas}).
     *
     * @return lista de AsignacionEmpleadoZonaResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> historial() {
        return backend.getLista(BASE + "/admin/todas");
    }

    /**
     * Busca una asignación por ID ({@code GET /asignaciones-empleado-zona/{id}}).
     *
     * @param id ID de la asignación
     * @return AsignacionEmpleadoZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscar(Integer id) {
        return backend.getMapa(BASE + "/" + id);
    }

    /**
     * Busca un empleado por su código ({@code GET /usuarios/empleados/codigo/{codigo}}): consulta puntual al back
     * que devuelve el empleado completo, con su ID interno.
     *
     * @param codigo código de empleado escrito por el usuario
     * @return datos del empleado (id, codigo, nombre, apellido...)
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscarEmpleadoPorCodigo(String codigo) {
        return backend.getMapa("/usuarios/empleados/codigo/" + BackendClientService.segmento(codigo.trim()));
    }

    /**
     * Sectores (asignaciones de zona activas) de un empleado ({@code GET /usuarios/empleados/{id}/zonas}).
     *
     * @param empleadoId ID interno del empleado
     * @return lista de AsignacionEmpleadoZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si el empleado no existe
     */
    public List<Map<String, Object>> listarDeEmpleado(Integer empleadoId) {
        return backend.getLista("/usuarios/empleados/" + empleadoId + "/zonas");
    }

    /**
     * Crea una asignación ({@code POST /asignaciones-empleado-zona}).
     *
     * @param formulario parámetros del formulario (el empleado llega como código en {@code empleadoCodigo} y la zona como letra en {@code zonaLetra})
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 (por ejemplo asignación duplicada)
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, armarCuerpo(formulario));
    }

    /**
     * Edita una asignación ({@code PUT /asignaciones-empleado-zona/{id}}).
     *
     * @param id         ID de la asignación
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back la rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, armarCuerpo(formulario));
    }

    /**
     * Da de baja (baja lógica) una asignación ({@code DELETE /asignaciones-empleado-zona/{id}}).
     *
     * @param id ID de la asignación
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back la rechaza
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }

    /**
     * Arma el cuerpo del Request/Update: copia los campos del formulario y reemplaza el código de empleado
     * y la letra de zona que escribió el usuario por los IDs internos, que es lo que espera el back.
     *
     * @param formulario parámetros del formulario
     * @return cuerpo listo para enviar al back
     */
    private Map<String, Object> armarCuerpo(Map<String, String> formulario) {
        Map<String, Object> cuerpo = BackendClientService.armarCuerpo(formulario, CAMPOS);
        String codigo = formulario.get("empleadoCodigo");
        cuerpo.put("empleadoId", codigo == null || codigo.isBlank() ? null : ((Number) buscarEmpleadoPorCodigo(codigo).get("id")).intValue());
        String letra = formulario.get("zonaLetra");
        cuerpo.put("zonaId", letra == null || letra.isBlank() ? null : idDeZonaPorLetra(letra));
        return cuerpo;
    }

    /**
     * Consulta puntual al back de una zona por su letra ({@code GET /zonas/{letra}}) para obtener su ID.
     *
     * @param letra letra de la zona escrita por el usuario
     * @return ID de la zona
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    private Integer idDeZonaPorLetra(String letra) {
        Map<String, Object> zona = backend.getMapa("/zonas/" + BackendClientService.segmento(letra.trim()));
        return ((Number) zona.get("id")).intValue();
    }
}
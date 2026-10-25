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
    /** Campos de AsignacionEmpleadoZonaRequest / AsignacionEmpleadoZonaUpdate del back. */
    private static final String[] CAMPOS = {"empleadoId", "zonaId", "cantVehiculosACargo"};

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
     * Crea una asignación ({@code POST /asignaciones-empleado-zona}).
     *
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 (por ejemplo asignación duplicada)
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Edita una asignación ({@code PUT /asignaciones-empleado-zona/{id}}).
     *
     * @param id         ID de la asignación
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back la rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, BackendClientService.armarCuerpo(formulario, CAMPOS));
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
}


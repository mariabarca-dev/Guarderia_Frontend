package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de GarageService del back (solo ADMINISTRADOR). Endpoint base: /garages.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class GarageService {

    private static final String BASE = "/garages";
    /** Campos de GarageRequest / GarageUpdate del back. */
    private static final String[] CAMPOS = {"numeroGarage", "lecturaLuz", "servicioMantenimiento", "zonaId"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public GarageService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Garages activos ({@code GET /garages}).
     *
     * @return lista de GarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Todos los garages, activos y dados de baja ({@code GET /garages/inactivos}).
     *
     * @return lista de GarageResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listarConBajas() {
        return backend.getLista(BASE + "/inactivos");
    }

    /**
     * Ocupación por zona ({@code GET /garages/disponibilidad}). El back devuelve ZonaResponse
     * (con espaciosDisponibles y espaciosOcupados), no garages.
     *
     * @return lista de ZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> disponibilidad() {
        return backend.getLista(BASE + "/disponibilidad");
    }

    /**
     * Busca un garage por ID ({@code GET /garages/{id}}).
     *
     * @param id ID del garage
     * @return GarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscar(Integer id) {
        return backend.getMapa(BASE + "/" + id);
    }

    /**
     * Crea un garage ({@code POST /garages}).
     *
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 si el back lo rechaza
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Edita un garage ({@code PUT /garages/{id}}).
     *
     * @param id         ID del garage
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back lo rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Da de baja (baja lógica) un garage ({@code DELETE /garages/{id}}).
     *
     * @param id ID del garage
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 409 si tiene dependencias activas
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }
}

package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de AsignacionVehiculoGarageService del back (solo ADMINISTRADOR): qué vehículo ocupa qué garage
 * y desde qué fecha. Endpoint base: /asignaciones-vehiculo-garage.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class AsignacionVehiculoGarageService {

    private static final String BASE = "/asignaciones-vehiculo-garage";
    /** Campos de AsignacionVehiculoGarageRequest / AsignacionVehiculoGarageUpdate del back. */
    private static final String[] CAMPOS = {"vehiculoId", "garageId", "fechaAsignacionGarage"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public AsignacionVehiculoGarageService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Ocupaciones activas ({@code GET /asignaciones-vehiculo-garage}).
     *
     * @return lista de AsignacionVehiculoGarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Historial: todas las ocupaciones, activas y dadas de baja ({@code GET /asignaciones-vehiculo-garage/admin/todas}).
     *
     * @return lista de AsignacionVehiculoGarageResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> historial() {
        return backend.getLista(BASE + "/admin/todas");
    }

    /**
     * Busca una ocupación por ID ({@code GET /asignaciones-vehiculo-garage/{id}}).
     *
     * @param id ID de la ocupación
     * @return AsignacionVehiculoGarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscar(Integer id) {
        return backend.getMapa(BASE + "/" + id);
    }

    /**
     * Ocupación actual de un vehículo ({@code GET /asignaciones-vehiculo-garage/vehiculo/{vehiculoId}}).
     * El back devuelve un único registro.
     *
     * @param vehiculoId ID del vehículo
     * @return AsignacionVehiculoGarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si el vehículo no ocupa ningún garage
     */
    public Map<String, Object> buscarDeVehiculo(Integer vehiculoId) {
        return backend.getMapa(BASE + "/vehiculo/" + vehiculoId);
    }

    /**
     * Asigna un vehículo a un garage ({@code POST /asignaciones-vehiculo-garage}).
     *
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 (por ejemplo garage ocupado)
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Edita una ocupación ({@code PUT /asignaciones-vehiculo-garage/{id}}).
     *
     * @param id         ID de la ocupación
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back la rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Da de baja (baja lógica) una ocupación: libera el garage ({@code DELETE /asignaciones-vehiculo-garage/{id}}).
     *
     * @param id ID de la ocupación
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back la rechaza
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }
}

package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de ZonaService del back (solo ADMINISTRADOR). Endpoint base: /zonas.
 * <p>
 * El back consulta una zona puntual por su LETRA ({@code GET /zonas/{letra}}), pero edita y da de baja
 * por ID ({@code PUT/DELETE /zonas/{id}}).
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class ZonaService {

    private static final String BASE = "/zonas";
    /** Campos de ZonaRequest / ZonaUpdate del back. */
    private static final String[] CAMPOS = {"letra", "tipoVehiculo", "capacidadVehiculos", "anchoGarage", "largoGarage"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public ZonaService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Zonas activas, con espacios disponibles y ocupados ({@code GET /zonas}).
     *
     * @return lista de ZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Todas las zonas, activas y dadas de baja ({@code GET /zonas/inactivos}).
     *
     * @return lista de ZonaResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listarConBajas() {
        return backend.getLista(BASE + "/inactivos");
    }

    /**
     * Busca una zona por su letra ({@code GET /zonas/{letra}}).
     *
     * @param letra letra de la zona
     * @return ZonaResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscarPorLetra(String letra) {
        return backend.getMapa(BASE + "/" + BackendClientService.segmento(letra));
    }

    /**
     * Crea una zona ({@code POST /zonas}).
     *
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 si el back la rechaza
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Edita una zona por ID ({@code PUT /zonas/{id}}).
     *
     * @param id         ID de la zona
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back la rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Da de baja (baja lógica) una zona por ID ({@code DELETE /zonas/{id}}).
     *
     * @param id ID de la zona
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 409 si tiene dependencias activas
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }
}

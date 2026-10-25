package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de PropiedadGarageService del back (solo ADMINISTRADOR): compras de garages por parte de socios.
 * Endpoint base: /propiedades-garage.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class PropiedadGarageService {

    private static final String BASE = "/propiedades-garage";
    /** Campos de PropiedadGarageRequest / PropiedadGarageUpdate del back. */
    private static final String[] CAMPOS = {"socioId", "garageId", "fechaCompraGarage"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public PropiedadGarageService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Propiedades activas ({@code GET /propiedades-garage}).
     *
     * @return lista de PropiedadGarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Todas las propiedades, activas y dadas de baja ({@code GET /propiedades-garage/inactivas}).
     *
     * @return lista de PropiedadGarageResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listarConBajas() {
        return backend.getLista(BASE + "/inactivas");
    }

    /**
     * Busca una propiedad por ID ({@code GET /propiedades-garage/{id}}).
     *
     * @param id ID de la propiedad
     * @return PropiedadGarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscar(Integer id) {
        return backend.getMapa(BASE + "/" + id);
    }

    /**
     * Garages comprados por un socio ({@code GET /propiedades-garage/socio/{socioId}}).
     * El back devuelve GarageResponse (los garages), no las propiedades.
     *
     * @param socioId ID del socio
     * @return lista de GarageResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si el socio no existe
     */
    public List<Map<String, Object>> garagesDeSocio(Integer socioId) {
        return backend.getLista(BASE + "/socio/" + socioId);
    }

    /**
     * Registra una compra ({@code POST /propiedades-garage}).
     *
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 (por ejemplo garage ya vendido)
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Edita una compra ({@code PUT /propiedades-garage/{id}}).
     *
     * @param id         ID de la propiedad
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back la rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, BackendClientService.armarCuerpo(formulario, CAMPOS));
    }

    /**
     * Da de baja (baja lógica) una compra ({@code DELETE /propiedades-garage/{id}}).
     *
     * @param id ID de la propiedad
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 409 si tiene dependencias activas
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }
}

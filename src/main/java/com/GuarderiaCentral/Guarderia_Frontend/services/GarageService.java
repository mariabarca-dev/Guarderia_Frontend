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
    /** Campos de GarageRequest / GarageUpdate del back que se copian tal cual del formulario (la zona se resuelve aparte). */
    private static final String[] CAMPOS = {"numeroGarage", "lecturaLuz", "servicioMantenimiento"};

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
     * @param formulario parámetros del formulario (la zona llega como letra en {@code zonaLetra})
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 si el back lo rechaza
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, armarCuerpo(formulario));
    }

    /**
     * Edita un garage ({@code PUT /garages/{id}}).
     *
     * @param id         ID del garage
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back lo rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, armarCuerpo(formulario));
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

    /**
     * Arma el cuerpo del Request/Update: copia los campos del formulario y reemplaza la letra de zona
     * que escribió el usuario por el ID interno de esa zona, que es lo que espera el back.
     *
     * @param formulario parámetros del formulario
     * @return cuerpo listo para enviar al back
     */
    private Map<String, Object> armarCuerpo(Map<String, String> formulario) {
        Map<String, Object> cuerpo = BackendClientService.armarCuerpo(formulario, CAMPOS);
        cuerpo.put("zonaId", idDeZonaPorLetra(formulario.get("zonaLetra")));
        return cuerpo;
    }

    /**
     * Consulta puntual al back de una zona por su letra ({@code GET /zonas/{letra}}) para obtener su ID.
     *
     * @param letra letra de la zona escrita por el usuario
     * @return ID de la zona, o null si no se escribió ninguna letra
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si la zona no existe
     */
    private Integer idDeZonaPorLetra(String letra) {
        if (letra == null || letra.isBlank()) {
            return null;
        }
        Map<String, Object> zona = backend.getMapa("/zonas/" + BackendClientService.segmento(letra.trim()));
        return ((Number) zona.get("id")).intValue();
    }
}
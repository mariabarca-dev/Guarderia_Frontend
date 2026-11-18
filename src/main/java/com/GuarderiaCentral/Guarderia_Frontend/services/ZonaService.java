package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    /** Zonas activas con la ocupación calculada (la expone el back en el controller de garages). */
    private static final String DISPONIBILIDAD = "/garages/disponibilidad";
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
     * Zonas activas con sus espacios ocupados y disponibles REALES. {@code GET /zonas} no calcula la ocupación
     * (devuelve 0), por eso se usa {@code GET /garages/disponibilidad}, que devuelve las mismas zonas
     * (ZonaResponse) con los espacios calculados desde las ocupaciones activas.
     *
     * @return lista de ZonaResponse con espaciosOcupados y espaciosDisponibles
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(DISPONIBILIDAD);
    }

    /**
     * Todas las zonas, activas y dadas de baja ({@code GET /zonas/inactivos}). A las zonas activas se les
     * completan los espacios ocupados y disponibles reales (ver {@link #listar()}); las dadas de baja no
     * tienen ocupación y conservan lo que informa el back.
     *
     * @return lista de ZonaResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listarConBajas() {
        Map<Object, Map<String, Object>> disponibilidadPorId = backend.getLista(DISPONIBILIDAD).stream()
                .collect(Collectors.toMap(zona -> zona.get("id"), zona -> zona));
        return backend.getLista(BASE + "/inactivos").stream()
                .map(zona -> completarEspacios(zona, disponibilidadPorId.get(zona.get("id"))))
                .toList();
    }

    /**
     * Devuelve una COPIA de la zona con los espacios ocupados y disponibles reales. No modifica la zona
     * original; si la zona no tiene ocupación calculada ({@code real} es null), conserva lo que informa el back.
     *
     * @param zona ZonaResponse tal como la devolvió el back
     * @param real la misma zona con la ocupación calculada (puede ser null)
     * @return copia de la zona con espaciosOcupados y espaciosDisponibles actualizados
     */
    private Map<String, Object> completarEspacios(Map<String, Object> zona, Map<String, Object> real) {
        Map<String, Object> resultado = new HashMap<>(zona);
        if (real != null) {
            resultado.put("espaciosOcupados", real.get("espaciosOcupados"));
            resultado.put("espaciosDisponibles", real.get("espaciosDisponibles"));
        }
        return resultado;
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
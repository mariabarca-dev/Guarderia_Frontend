package com.GuarderiaCentral.Guarderia_Frontend.services;

import com.GuarderiaCentral.Guarderia_Frontend.client.BackendClientService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Espejo de VehiculoService del back (solo ADMINISTRADOR). Endpoint base: /vehiculos.
 * <p>
 * Crear un vehículo con la matrícula de uno dado de baja lo reactiva: eso lo resuelve el back.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Service
public class VehiculoService {

    private static final String BASE = "/vehiculos";
    /** Campos de VehiculoRequest / VehiculoUpdate del back que se copian tal cual del formulario (el socio se resuelve aparte). */
    private static final String[] CAMPOS = {"nombre", "matricula", "tipo", "profundidad", "ancho"};

    private final BackendClientService backend;

    /**
     * Crea el service.
     *
     * @param backend cliente HTTP hacia el back
     */
    public VehiculoService(BackendClientService backend) {
        this.backend = backend;
    }

    /**
     * Vehículos activos ({@code GET /vehiculos}).
     *
     * @return lista de VehiculoResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listar() {
        return backend.getLista(BASE);
    }

    /**
     * Todos los vehículos, activos y dados de baja ({@code GET /vehiculos/inactivos}).
     *
     * @return lista de VehiculoResponse con su campo activo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException si el back responde con error
     */
    public List<Map<String, Object>> listarConBajas() {
        return backend.getLista(BASE + "/inactivos");
    }

    /**
     * Busca un vehículo por ID ({@code GET /vehiculos/{id}}).
     *
     * @param id ID del vehículo
     * @return VehiculoResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscar(Integer id) {
        return backend.getMapa(BASE + "/" + id);
    }

    /**
     * Busca un vehículo por matrícula ({@code GET /vehiculos/matricula/{matricula}}).
     *
     * @param matricula matrícula (patente) escrita por el usuario
     * @return VehiculoResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscarPorMatricula(String matricula) {
        return backend.getMapa(BASE + "/matricula/" + BackendClientService.segmento(matricula));
    }

    /**
     * Vehículos de un tipo ({@code GET /vehiculos/tipo/{tipo}}).
     *
     * @param tipo valor de TipoVehiculo (MOTORHOME, CASA_RODANTE_DE_ARRASTRE, CARAVANA o TRAILER)
     * @return lista de VehiculoResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400 si el tipo no existe
     */
    public List<Map<String, Object>> listarPorTipo(String tipo) {
        return backend.getLista(BASE + "/tipo/" + BackendClientService.segmento(tipo));
    }

    /**
     * Busca un socio por su DNI ({@code GET /usuarios/socios/dni/{dni}}): consulta puntual al back que
     * devuelve el socio completo, con su ID interno.
     *
     * @param dni DNI escrito por el usuario
     * @return datos del socio (id, nombre, apellido, dni...)
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si no existe
     */
    public Map<String, Object> buscarSocioPorDni(String dni) {
        return backend.getMapa("/usuarios/socios/dni/" + BackendClientService.segmento(dni.trim()));
    }

    /**
     * Vehículos de un socio ({@code GET /vehiculos/socio/{socioId}}).
     *
     * @param socioId ID del socio
     * @return lista de VehiculoResponse
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 404 si el socio no existe
     */
    public List<Map<String, Object>> listarDeSocio(Integer socioId) {
        return backend.getLista(BASE + "/socio/" + socioId);
    }

    /**
     * Crea un vehículo ({@code POST /vehiculos}).
     *
     * @param formulario parámetros del formulario (el socio llega como DNI en {@code socioDni})
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/409 si el back lo rechaza
     */
    public void crear(Map<String, String> formulario) {
        backend.post(BASE, armarCuerpo(formulario));
    }

    /**
     * Edita un vehículo ({@code PUT /vehiculos/{id}}).
     *
     * @param id         ID del vehículo
     * @param formulario parámetros del formulario
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 400/404/409 si el back lo rechaza
     */
    public void editar(Integer id, Map<String, String> formulario) {
        backend.put(BASE + "/" + id, armarCuerpo(formulario));
    }

    /**
     * Da de baja (baja lógica) un vehículo ({@code DELETE /vehiculos/{id}}).
     *
     * @param id ID del vehículo
     * @throws com.GuarderiaCentral.Guarderia_Frontend.client.BackendException 409 si tiene dependencias activas
     */
    public void darDeBaja(Integer id) {
        backend.delete(BASE + "/" + id);
    }

    /**
     * Arma el cuerpo del Request/Update: copia los campos del formulario y reemplaza el DNI del socio
     * que escribió el usuario por el ID interno del socio, que es lo que espera el back.
     *
     * @param formulario parámetros del formulario
     * @return cuerpo listo para enviar al back
     */
    private Map<String, Object> armarCuerpo(Map<String, String> formulario) {
        Map<String, Object> cuerpo = BackendClientService.armarCuerpo(formulario, CAMPOS);
        String dni = formulario.get("socioDni");
        cuerpo.put("socioId", dni == null || dni.isBlank() ? null : ((Number) buscarSocioPorDni(dni).get("id")).intValue());
        return cuerpo;
    }
}
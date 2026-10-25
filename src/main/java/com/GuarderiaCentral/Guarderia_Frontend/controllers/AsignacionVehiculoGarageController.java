package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.AsignacionVehiculoGarageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

/**
 * Pantalla de ocupaciones (asignaciones vehículo-garage) del ADMINISTRADOR
 * (ruta base /administrador/gestion-ocupaciones, vista asignacion-vehiculo-garage.jsp).
 * El back no expone "inactivas" para esta entidad: los registros dados de baja se ven en el historial.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class AsignacionVehiculoGarageController {

    private static final String BASE = "/administrador/gestion-ocupaciones";

    private final AsignacionVehiculoGarageService asignacionVehiculoGarageService;

    /**
     * Crea el controller.
     *
     * @param asignacionVehiculoGarageService service de asignaciones vehículo-garage
     */
    public AsignacionVehiculoGarageController(AsignacionVehiculoGarageService asignacionVehiculoGarageService) {
        this.asignacionVehiculoGarageService = asignacionVehiculoGarageService;
    }

    /**
     * Lista de ocupaciones activas y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Ocupaciones (rodados en cocheras)", asignacionVehiculoGarageService.listar(), null, false);
    }

    /**
     * Detalle de una ocupación y precarga del formulario de edición.
     *
     * @param id    ID de la ocupación
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        return mostrar(model, "Editar ocupación", asignacionVehiculoGarageService.listar(),
                asignacionVehiculoGarageService.buscar(id), false);
    }

    /**
     * Historial: todas las ocupaciones, activas y dadas de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/historial")
    public String historial(Model model) {
        return mostrar(model, "Historial de ocupaciones", asignacionVehiculoGarageService.historial(), null, true);
    }

    /**
     * Ocupación actual de un vehículo.
     *
     * @param vehiculoId ID del vehículo
     * @param model      modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/de-rodado/{vehiculoId}")
    public String deRodado(@PathVariable Integer vehiculoId, Model model) {
        return mostrar(model, "Ocupación del rodado " + vehiculoId,
                List.of(asignacionVehiculoGarageService.buscarDeVehiculo(vehiculoId)), null, false);
    }

    /**
     * Entrada del formulario de búsqueda por rodado.
     *
     * @param nroRodado ID del vehículo escrito por el usuario
     * @return redirección a {@code /de-rodado/{vehiculoId}}
     */
    @GetMapping(path = BASE + "/de-rodado", params = "nroRodado")
    public String formularioRodado(@RequestParam Integer nroRodado) {
        return "redirect:" + BASE + "/de-rodado/" + nroRodado;
    }

    /**
     * Asigna un vehículo a un garage.
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        asignacionVehiculoGarageService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Rodado asignado a la cochera.");
        return "redirect:" + BASE;
    }

    /**
     * Edita una ocupación.
     *
     * @param id         ID de la ocupación (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        asignacionVehiculoGarageService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Ocupación actualizada.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja una ocupación (baja lógica: libera la cochera).
     *
     * @param id       ID de la ocupación (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        asignacionVehiculoGarageService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Ocupación dada de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en el historial no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "asignacion-vehiculo-garage");
        model.addAttribute("titulo", titulo);
        model.addAttribute("base", BASE);
        model.addAttribute("lista", lista);
        model.addAttribute("registro", registro);
        model.addAttribute("esBajas", esBajas);
        model.addAttribute("puedeVer", !esBajas);
        model.addAttribute("puedeCrear", !esBajas);
        model.addAttribute("puedeEditar", !esBajas);
        model.addAttribute("puedeEliminar", !esBajas);
        model.addAttribute("puedeConsultar", true);
        return "layout";
    }
}

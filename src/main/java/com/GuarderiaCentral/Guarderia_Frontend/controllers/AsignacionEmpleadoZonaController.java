package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.AsignacionEmpleadoZonaService;
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
 * Pantalla de sectores (asignaciones empleado-zona) del ADMINISTRADOR
 * (ruta base /administrador/gestion-sectores, vista asignacion-empleado-zona.jsp).
 * El back no expone "inactivas" para esta entidad: los registros dados de baja se ven en el historial.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class AsignacionEmpleadoZonaController {

    private static final String BASE = "/administrador/gestion-sectores";

    private final AsignacionEmpleadoZonaService asignacionEmpleadoZonaService;

    /**
     * Crea el controller.
     *
     * @param asignacionEmpleadoZonaService service de asignaciones empleado-zona
     */
    public AsignacionEmpleadoZonaController(AsignacionEmpleadoZonaService asignacionEmpleadoZonaService) {
        this.asignacionEmpleadoZonaService = asignacionEmpleadoZonaService;
    }

    /**
     * Lista de asignaciones activas y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Sectores (empleados por zona)", asignacionEmpleadoZonaService.listar(), null, false);
    }

    /**
     * Detalle de una asignación y precarga del formulario de edición.
     *
     * @param id    ID de la asignación
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        return mostrar(model, "Editar sector", asignacionEmpleadoZonaService.listar(),
                asignacionEmpleadoZonaService.buscar(id), false);
    }

    /**
     * Historial: todas las asignaciones, activas y dadas de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/historial")
    public String historial(Model model) {
        return mostrar(model, "Historial de sectores", asignacionEmpleadoZonaService.historial(), null, true);
    }

    /**
     * Crea una asignación.
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        asignacionEmpleadoZonaService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Empleado asignado a la zona.");
        return "redirect:" + BASE;
    }

    /**
     * Edita una asignación.
     *
     * @param id         ID de la asignación (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        asignacionEmpleadoZonaService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Asignación actualizada.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja una asignación (baja lógica).
     *
     * @param id       ID de la asignación (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        asignacionEmpleadoZonaService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Asignación dada de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en el historial no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "asignacion-empleado-zona");
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

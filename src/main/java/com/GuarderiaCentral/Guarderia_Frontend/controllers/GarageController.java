package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.GarageService;
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
 * Pantalla de cocheras (garages) del ADMINISTRADOR (ruta base /administrador/gestion-cocheras, vista garage.jsp).
 * Los errores del back los maneja BackendExceptionAdvice.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class GarageController {

    private static final String BASE = "/administrador/gestion-cocheras";

    private final GarageService garageService;

    /**
     * Crea el controller.
     *
     * @param garageService service de garages
     */
    public GarageController(GarageService garageService) {
        this.garageService = garageService;
    }

    /**
     * Lista de garages activos y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Cocheras", garageService.listar(), null, false);
    }

    /**
     * Detalle de un garage y precarga del formulario de edición.
     *
     * @param id    ID del garage
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        return mostrar(model, "Editar cochera", garageService.listar(), garageService.buscar(id), false);
    }

    /**
     * Todos los garages, activos y dados de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/bajas")
    public String bajas(Model model) {
        return mostrar(model, "Cocheras activas y dadas de baja", garageService.listarConBajas(), null, true);
    }

    /**
     * Ocupación por zona (espacios ocupados y disponibles), junto con la lista de garages.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ocupacion")
    public String ocupacion(Model model) {
        model.addAttribute("ocupacion", garageService.disponibilidad());
        return mostrar(model, "Cocheras", garageService.listar(), null, false);
    }

    /**
     * Crea un garage.
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        garageService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Cochera creada.");
        return "redirect:" + BASE;
    }

    /**
     * Edita un garage.
     *
     * @param id         ID del garage (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        garageService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Cochera actualizada.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja un garage (baja lógica).
     *
     * @param id       ID del garage (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        garageService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Cochera dada de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en bajas no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "garage");
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

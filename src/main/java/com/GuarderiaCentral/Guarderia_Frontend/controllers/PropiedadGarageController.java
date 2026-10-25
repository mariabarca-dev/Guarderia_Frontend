package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.PropiedadGarageService;
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
 * Pantalla de compras de garages (propiedades) del ADMINISTRADOR
 * (ruta base /administrador/gestion-compras, vista propiedad-garage.jsp).
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class PropiedadGarageController {

    private static final String BASE = "/administrador/gestion-compras";

    private final PropiedadGarageService propiedadGarageService;

    /**
     * Crea el controller.
     *
     * @param propiedadGarageService service de propiedades de garage
     */
    public PropiedadGarageController(PropiedadGarageService propiedadGarageService) {
        this.propiedadGarageService = propiedadGarageService;
    }

    /**
     * Lista de compras activas y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Compras de cocheras", propiedadGarageService.listar(), null, false);
    }

    /**
     * Detalle de una compra y precarga del formulario de edición.
     *
     * @param id    ID de la propiedad
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        return mostrar(model, "Editar compra", propiedadGarageService.listar(), propiedadGarageService.buscar(id), false);
    }

    /**
     * Todas las compras, activas y dadas de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/bajas")
    public String bajas(Model model) {
        return mostrar(model, "Compras activas y dadas de baja", propiedadGarageService.listarConBajas(), null, true);
    }

    /**
     * Garages comprados por un socio (bloque aparte, junto con la lista de compras).
     *
     * @param socioId ID del socio
     * @param model   modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/de-socio/{socioId}")
    public String deSocio(@PathVariable Integer socioId, Model model) {
        model.addAttribute("garagesDelSocio", propiedadGarageService.garagesDeSocio(socioId));
        model.addAttribute("socioConsultado", socioId);
        return mostrar(model, "Compras de cocheras", propiedadGarageService.listar(), null, false);
    }

    /**
     * Entrada del formulario de búsqueda por socio.
     *
     * @param nroSocio ID del socio escrito por el usuario
     * @return redirección a {@code /de-socio/{socioId}}
     */
    @GetMapping(path = BASE + "/de-socio", params = "nroSocio")
    public String formularioSocio(@RequestParam Integer nroSocio) {
        return "redirect:" + BASE + "/de-socio/" + nroSocio;
    }

    /**
     * Registra una compra.
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        propiedadGarageService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Compra registrada.");
        return "redirect:" + BASE;
    }

    /**
     * Edita una compra.
     *
     * @param id         ID de la propiedad (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        propiedadGarageService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Compra actualizada.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja una compra (baja lógica).
     *
     * @param id       ID de la propiedad (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        propiedadGarageService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Compra dada de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en bajas no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "propiedad-garage");
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

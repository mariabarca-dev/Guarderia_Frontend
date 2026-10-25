package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.ZonaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * Pantalla de zonas del ADMINISTRADOR (ruta base /administrador/gestion-zonas, vista zona.jsp).
 * <p>
 * Excepción de zonas: se consultan por LETRA ({@code /ver/{letra}}) y se editan y dan de baja por ID
 * (campo oculto {@code id} del formulario). Los errores del back los maneja BackendExceptionAdvice.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class ZonaController {

    private static final String BASE = "/administrador/gestion-zonas";

    private final ZonaService zonaService;

    /**
     * Crea el controller.
     *
     * @param zonaService service de zonas
     */
    public ZonaController(ZonaService zonaService) {
        this.zonaService = zonaService;
    }

    /**
     * Lista de zonas activas y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Zonas", zonaService.listar(), null, false);
    }

    /**
     * Detalle de una zona (buscada por letra) y precarga del formulario de edición.
     *
     * @param letra letra de la zona
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{letra}")
    public String ver(@PathVariable String letra, Model model) {
        return mostrar(model, "Editar zona", zonaService.listar(), zonaService.buscarPorLetra(letra), false);
    }

    /**
     * Entrada del formulario "buscar por letra": redirige a {@code /ver/{letra}}.
     *
     * @param letra letra escrita por el usuario
     * @return redirección a la ficha de la zona
     */
    @GetMapping(path = BASE + "/ver", params = "letra")
    public String buscarPorLetra(@RequestParam String letra) {
        return "redirect:" + BASE + "/ver/" + UriUtils.encodePathSegment(letra.trim(), StandardCharsets.UTF_8);
    }

    /**
     * Todas las zonas, activas y dadas de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/bajas")
    public String bajas(Model model) {
        return mostrar(model, "Zonas activas y dadas de baja", zonaService.listarConBajas(), null, true);
    }

    /**
     * Crea una zona.
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        zonaService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Zona creada.");
        return "redirect:" + BASE;
    }

    /**
     * Edita una zona (por ID).
     *
     * @param id         ID de la zona (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        zonaService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Zona actualizada.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja una zona (baja lógica, por ID).
     *
     * @param id       ID de la zona (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        zonaService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Zona dada de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en bajas no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "zona");
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

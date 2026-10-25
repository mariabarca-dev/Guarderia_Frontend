package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.VehiculoService;
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
 * Pantalla de rodados (vehículos) del ADMINISTRADOR (ruta base /administrador/gestion-rodados, vista vehiculo.jsp).
 * <p>
 * Las búsquedas reciben el valor en la ruta ({@code /buscar-patente/{matricula}}, etc.). Como un formulario
 * HTML sin JavaScript solo puede mandar el valor como parámetro, cada búsqueda tiene además una entrada
 * ({@code /buscar-patente?patente=...}) que redirige a la ruta con el valor.
 * </p>
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@Controller
public class VehiculoController {

    private static final String BASE = "/administrador/gestion-rodados";

    private final VehiculoService vehiculoService;

    /**
     * Crea el controller.
     *
     * @param vehiculoService service de vehículos
     */
    public VehiculoController(VehiculoService vehiculoService) {
        this.vehiculoService = vehiculoService;
    }

    /**
     * Lista de vehículos activos y formulario de alta.
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE)
    public String listar(Model model) {
        return mostrar(model, "Rodados", vehiculoService.listar(), null, false);
    }

    /**
     * Detalle de un vehículo y precarga del formulario de edición.
     *
     * @param id    ID del vehículo
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/ver/{id}")
    public String ver(@PathVariable Integer id, Model model) {
        return mostrar(model, "Editar rodado", vehiculoService.listar(), vehiculoService.buscar(id), false);
    }

    /**
     * Todos los vehículos, activos y dados de baja (columna Estado, sin acciones).
     *
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/bajas")
    public String bajas(Model model) {
        return mostrar(model, "Rodados activos y dados de baja", vehiculoService.listarConBajas(), null, true);
    }

    /**
     * Resultado de buscar un vehículo por patente (matrícula).
     *
     * @param matricula matrícula buscada
     * @param model     modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/buscar-patente/{matricula}")
    public String buscarPatente(@PathVariable String matricula, Model model) {
        return mostrar(model, "Rodado con patente " + matricula,
                List.of(vehiculoService.buscarPorMatricula(matricula)), null, false);
    }

    /**
     * Entrada del formulario de búsqueda por patente.
     *
     * @param patente patente escrita por el usuario
     * @return redirección a {@code /buscar-patente/{matricula}}
     */
    @GetMapping(path = BASE + "/buscar-patente", params = "patente")
    public String formularioPatente(@RequestParam String patente) {
        return "redirect:" + BASE + "/buscar-patente/" + UriUtils.encodePathSegment(patente.trim(), StandardCharsets.UTF_8);
    }

    /**
     * Vehículos de una categoría (tipo de vehículo).
     *
     * @param tipo valor de TipoVehiculo
     * @param model modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/buscar-categoria/{tipo}")
    public String buscarCategoria(@PathVariable String tipo, Model model) {
        return mostrar(model, "Rodados de la categoría " + tipo.replace('_', ' '),
                vehiculoService.listarPorTipo(tipo), null, false);
    }

    /**
     * Entrada del formulario de búsqueda por categoría.
     *
     * @param categoria tipo elegido en el formulario
     * @return redirección a {@code /buscar-categoria/{tipo}}
     */
    @GetMapping(path = BASE + "/buscar-categoria", params = "categoria")
    public String formularioCategoria(@RequestParam String categoria) {
        return "redirect:" + BASE + "/buscar-categoria/" + UriUtils.encodePathSegment(categoria, StandardCharsets.UTF_8);
    }

    /**
     * Vehículos de un socio.
     *
     * @param socioId ID del socio
     * @param model   modelo de la vista
     * @return vista base "layout"
     */
    @GetMapping(BASE + "/de-socio/{socioId}")
    public String deSocio(@PathVariable Integer socioId, Model model) {
        return mostrar(model, "Rodados del socio " + socioId, vehiculoService.listarDeSocio(socioId), null, false);
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
     * Crea un vehículo (si la matrícula era de uno dado de baja, el back lo reactiva).
     *
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/crear")
    public String crear(@RequestParam Map<String, String> formulario, RedirectAttributes redirect) {
        vehiculoService.crear(formulario);
        redirect.addFlashAttribute("mensajeExito", "Rodado registrado.");
        return "redirect:" + BASE;
    }

    /**
     * Edita un vehículo.
     *
     * @param id         ID del vehículo (campo oculto)
     * @param formulario parámetros del formulario
     * @param redirect   atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/editar")
    public String editar(@RequestParam Integer id, @RequestParam Map<String, String> formulario,
                         RedirectAttributes redirect) {
        vehiculoService.editar(id, formulario);
        redirect.addFlashAttribute("mensajeExito", "Rodado actualizado.");
        return "redirect:" + BASE;
    }

    /**
     * Da de baja un vehículo (baja lógica).
     *
     * @param id       ID del vehículo (campo oculto)
     * @param redirect atributos flash para el mensaje de éxito
     * @return redirección a la lista
     */
    @PostMapping(BASE + "/eliminar")
    public String eliminar(@RequestParam Integer id, RedirectAttributes redirect) {
        vehiculoService.darDeBaja(id);
        redirect.addFlashAttribute("mensajeExito", "Rodado dado de baja.");
        return "redirect:" + BASE;
    }

    /**
     * Carga el Model común de la pantalla. Las banderas dependen de la ruta: en bajas no hay acciones.
     */
    private String mostrar(Model model, String titulo, List<Map<String, Object>> lista,
                           Map<String, Object> registro, boolean esBajas) {
        model.addAttribute("vista", "vehiculo");
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

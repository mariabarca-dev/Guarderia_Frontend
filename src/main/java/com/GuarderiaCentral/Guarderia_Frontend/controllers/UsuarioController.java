package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import com.GuarderiaCentral.Guarderia_Frontend.services.AdministradorService;
import com.GuarderiaCentral.Guarderia_Frontend.services.EmpleadoService;
import com.GuarderiaCentral.Guarderia_Frontend.services.SocioService;
import com.GuarderiaCentral.Guarderia_Frontend.services.UsuarioService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriUtils;
import java.nio.charset.StandardCharsets;
import java.util.Map;

/**
 * Controller espejo de UsuarioRestController. Atiende a todos los roles para dashboards,
 * perfil propio y gestión de cuentas de usuarios.
 */
@Controller
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final SocioService socioService;
    private final EmpleadoService empleadoService;
    private final AdministradorService administradorService;

    public UsuarioController(UsuarioService usuarioService, SocioService socioService,
                             EmpleadoService empleadoService, AdministradorService administradorService) {
        this.usuarioService = usuarioService;
        this.socioService = socioService;
        this.empleadoService = empleadoService;
        this.administradorService = administradorService;
    }

    // ------------------------------------------------------------------ CONSULTAS EXTRA DE SOCIOS (ADMINISTRADOR)

    /** Carga socio.jsp con la lista de socios y, opcionalmente, un registro o el resultado de una consulta. */
    private String vistaCuentasSocios(Model model, Object registro, Object resultado, String tituloResultado) {
        model.addAttribute("registros", socioService.listarSocios());
        if (registro != null) {
            model.addAttribute("registro", registro);
        }
        if (resultado != null) {
            model.addAttribute("resultado", resultado);
            model.addAttribute("tituloResultado", tituloResultado);
        }
        model.addAttribute("rutaBase", "/administrador/cuentas-socios");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @GetMapping("/administrador/cuentas-socios/{id}/sus-rodados")
    public String susRodados(@PathVariable Integer id, Model model) {
        return vistaCuentasSocios(model, null, socioService.obtenerVehiculosDeSocio(id), "Rodados del socio " + id);
    }

    @GetMapping("/administrador/cuentas-socios/{id}/sus-cocheras")
    public String susCocheras(@PathVariable Integer id, Model model) {
        return vistaCuentasSocios(model, null, socioService.obtenerGaragesDeSocio(id), "Cocheras del socio " + id);
    }

    @GetMapping("/administrador/cuentas-socios/buscar-documento/{dni}")
    public String buscarDocumento(@PathVariable String dni, Model model) {
        return vistaCuentasSocios(model, socioService.buscarSocioPorDni(dni), null, null);
    }

    /** RUTA EXTRA: un formulario GET no puede armar "/buscar-documento/{dni}", así que recibe ?dni= y redirige a la ruta del prompt. */
    @GetMapping("/administrador/cuentas-socios/buscar-documento")
    public String buscarDocumentoDesdeFormulario(@RequestParam String dni) {
        return "redirect:/administrador/cuentas-socios/buscar-documento/" + UriUtils.encodePathSegment(dni, StandardCharsets.UTF_8);
    }

    // ------------------------------------------------------------------ CONSULTAS EXTRA DE EMPLEADOS (ADMINISTRADOR)

    /** Carga empleado.jsp con la lista de empleados y el resultado de una consulta. */
    private String vistaCuentasEmpleados(Model model, Object resultado, String tituloResultado, Integer encargosDe) {
        model.addAttribute("registros", empleadoService.listarEmpleados());
        model.addAttribute("resultado", resultado);
        model.addAttribute("tituloResultado", tituloResultado);
        if (encargosDe != null) {
            model.addAttribute("resultadoEncargosDe", encargosDe);
        }
        model.addAttribute("rutaBase", "/administrador/cuentas-empleados");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "empleado");
        return "layout";
    }

    @GetMapping("/administrador/cuentas-empleados/{id}/sus-sectores")
    public String susSectores(@PathVariable Integer id, Model model) {
        return vistaCuentasEmpleados(model, empleadoService.obtenerSectoresDeEmpleado(id), "Sectores del empleado " + id, null);
    }

    @GetMapping("/administrador/cuentas-empleados/{id}/sus-encargos")
    public String susEncargos(@PathVariable Integer id, Model model) {
        return vistaCuentasEmpleados(model, empleadoService.obtenerEncargosDeEmpleado(id), "Vehículos a cargo del empleado " + id, id);
    }

    @PostMapping("/administrador/cuentas-empleados/{id}/encargar/{vehiculoId}")
    public String encargar(@PathVariable Integer id, @PathVariable Integer vehiculoId, RedirectAttributes redirect) {
        empleadoService.encargarVehiculo(id, vehiculoId);
        redirect.addFlashAttribute("mensajeExito", "Vehículo encargado exitosamente.");
        return "redirect:/administrador/cuentas-empleados/" + id + "/sus-encargos";
    }

    /** RUTA EXTRA: el formulario envía vehiculoId como campo (no puede armar la ruta con {vehiculoId}); hace lo mismo que la anterior. */
    @PostMapping("/administrador/cuentas-empleados/{id}/encargar")
    public String encargarDesdeFormulario(@PathVariable Integer id, @RequestParam Integer vehiculoId, RedirectAttributes redirect) {
        return encargar(id, vehiculoId, redirect);
    }

    @PostMapping("/administrador/cuentas-empleados/{id}/desencargar/{vehiculoId}")
    public String desencargar(@PathVariable Integer id, @PathVariable Integer vehiculoId, RedirectAttributes redirect) {
        empleadoService.desencargarVehiculo(id, vehiculoId);
        redirect.addFlashAttribute("mensajeExito", "Vehículo desencargado exitosamente.");
        return "redirect:/administrador/cuentas-empleados/" + id + "/sus-encargos";
    }

    // ------------------------------------------------------------------ DASHBOARDS (TODOS LOS ROLES)

    @GetMapping({"/{rol:socio|empleado|administrador|sysadmin}/dash"})
    public String dashboard(Model model) {
        model.addAttribute("registro", usuarioService.obtenerUsuarioActual());
        model.addAttribute("vista", "dashboard");
        return "layout";
    }

    // ------------------------------------------------------------------ ROL SOCIO (LO PROPIO / SOLO LECTURA)

    @GetMapping("/socio/mi-perfil")
    public String miPerfilSocio(Model model) {
        model.addAttribute("datosSocio", socioService.obtenerMiPerfil());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @GetMapping("/socio/mis-vehiculos")
    public String misVehiculosSocio(Model model) {
        model.addAttribute("titulo", "Mis Vehículos Registrados");
        model.addAttribute("registros", socioService.obtenerMisVehiculos());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "vehiculo");
        return "layout";
    }

    @GetMapping("/socio/mis-vehiculos/ver/{id}")
    public String miVehiculoDetalleSocio(@PathVariable Integer id, Model model) {
        model.addAttribute("titulo", "Detalle de Vehículo");
        model.addAttribute("registro", socioService.obtenerMiVehiculoDetalle(id));
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("vista", "vehiculo");
        return "layout";
    }

    @GetMapping("/socio/mis-cocheras")
    public String misCocherasSocio(Model model) {
        model.addAttribute("datosSocio", socioService.obtenerMiPerfil());
        model.addAttribute("listaCocherasOcupadas", socioService.obtenerMisCocherasOcupadas());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @GetMapping("/socio/mis-compras")
    public String misComprasSocio(Model model) {
        model.addAttribute("titulo", "Mis Compras de Garages");
        model.addAttribute("registros", socioService.obtenerMisComprasProperties());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "propiedad-garage");
        return "layout";
    }

    // ------------------------------------------------------------------ ROL EMPLEADO (LO PROPIO / SOLO LECTURA)

    @GetMapping("/empleado/mi-legajo")
    public String miLegajoEmpleado(Model model) {
        model.addAttribute("datosEmpleado", empleadoService.obtenerMiLegajo());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("vista", "empleado");
        return "layout";
    }

    @GetMapping("/empleado/mis-sectores")
    public String misSectoresEmpleado(Model model) {
        model.addAttribute("titulo", "Mis Sectores y Vehículos a Cargo");
        model.addAttribute("registros", empleadoService.obtenerMisSectores());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "asignacion-empleado-zona");
        return "layout";
    }

    @GetMapping("/empleado/mis-encargos")
    public String misEncargosEmpleado(Model model) {
        model.addAttribute("titulo", "Vehículos a Mi Cargo");
        model.addAttribute("registros", empleadoService.obtenerMisEncargos());
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "vehiculo");
        return "layout";
    }

    // ------------------------------------------------------------------ GESTIÓN CUENTAS SOCIOS (ADMIN / SYSADMIN)

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-socios"})
    public String listarCuentasSocios(@PathVariable String rol, Model model) {
        model.addAttribute("registros", socioService.listarSocios());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-socios");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-socios/bajas"})
    public String listarCuentasSociosBajas(@PathVariable String rol, Model model) {
        model.addAttribute("registros", socioService.listarSociosInactivos());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-socios");
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", true);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-socios/ver/{id}"})
    public String verCuentaSocio(@PathVariable String rol, @PathVariable Integer id, Model model) {
        model.addAttribute("registro", socioService.obtenerSocioPorId(id));
        model.addAttribute("registros", socioService.listarSocios());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-socios");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "socio");
        return "layout";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-socios/crear"})
    public String crearCuentaSocio(@PathVariable String rol, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        socioService.crearSocio(params);
        redirect.addFlashAttribute("mensajeExito", "Socio registrado correctamente.");
        return "redirect:/" + rol + "/cuentas-socios";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-socios/editar"})
    public String editarCuentaSocio(@PathVariable String rol, @RequestParam Integer id, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        socioService.editarSocio(id, params);
        redirect.addFlashAttribute("mensajeExito", "Datos del socio actualizados.");
        return "redirect:/" + rol + "/cuentas-socios";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-socios/eliminar"})
    public String eliminarCuentaSocio(@PathVariable String rol, @RequestParam Integer id, RedirectAttributes redirect) {
        socioService.eliminarSocio(id);
        redirect.addFlashAttribute("mensajeExito", "Socio dado de baja.");
        return "redirect:/" + rol + "/cuentas-socios";
    }

    // ------------------------------------------------------------------ GESTIÓN CUENTAS EMPLEADOS (ADMIN / SYSADMIN)

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-empleados"})
    public String listarCuentasEmpleados(@PathVariable String rol, Model model) {
        model.addAttribute("registros", empleadoService.listarEmpleados());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-empleados");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "empleado");
        return "layout";
    }

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-empleados/bajas"})
    public String listarCuentasEmpleadosBajas(@PathVariable String rol, Model model) {
        model.addAttribute("registros", empleadoService.listarEmpleadosInactivos());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-empleados");
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", true);
        model.addAttribute("vista", "empleado");
        return "layout";
    }

    @GetMapping({"/{rol:administrador|sysadmin}/cuentas-empleados/ver/{id}"})
    public String verCuentaEmpleado(@PathVariable String rol, @PathVariable Integer id, Model model) {
        model.addAttribute("registro", empleadoService.obtenerEmpleadoPorId(id));
        model.addAttribute("registros", empleadoService.listarEmpleados());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-empleados");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "empleado");
        return "layout";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-empleados/crear"})
    public String crearCuentaEmpleado(@PathVariable String rol, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        empleadoService.crearEmpleado(params);
        redirect.addFlashAttribute("mensajeExito", "Empleado registrado correctamente.");
        return "redirect:/" + rol + "/cuentas-empleados";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-empleados/editar"})
    public String editarCuentaEmpleado(@PathVariable String rol, @RequestParam Integer id, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        empleadoService.editarEmpleado(id, params);
        redirect.addFlashAttribute("mensajeExito", "Datos del empleado actualizados.");
        return "redirect:/" + rol + "/cuentas-empleados";
    }

    @PostMapping({"/{rol:administrador|sysadmin}/cuentas-empleados/eliminar"})
    public String eliminarCuentaEmpleado(@PathVariable String rol, @RequestParam Integer id, RedirectAttributes redirect) {
        empleadoService.eliminarEmpleado(id);
        redirect.addFlashAttribute("mensajeExito", "Empleado dado de baja.");
        return "redirect:/" + rol + "/cuentas-empleados";
    }

    // ------------------------------------------------------------------ VISTA SYSADMIN (TODAS LAS CUENTAS)

    @GetMapping("/sysadmin/todas-las-cuentas")
    public String todasLasCuentas(Model model) {
        model.addAttribute("registros", usuarioService.listarTodasLasCuentas());
        model.addAttribute("rutaBase", "/sysadmin/todas-las-cuentas");
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "usuario");
        return "layout";
    }

    @GetMapping("/sysadmin/todas-las-cuentas/bajas")
    public String todasLasCuentasBajas(Model model) {
        model.addAttribute("registros", usuarioService.listarCuentasInactivas());
        model.addAttribute("rutaBase", "/sysadmin/todas-las-cuentas");
        model.addAttribute("modoBajas", true);
        model.addAttribute("vista", "usuario");
        return "layout";
    }

    @GetMapping("/sysadmin/todas-las-cuentas/ver/{id}")
    public String verCuentaDetalleSysadmin(@PathVariable Integer id, Model model) {
        model.addAttribute("registro", usuarioService.obtenerCuentaPorId(id));
        model.addAttribute("vista", "usuario");
        return "layout";
    }


    // ------------------------------------------------------------------ GESTIÓN CUENTAS ADMINISTRADORES (ADMINISTRADOR / SYSADMIN)

    @GetMapping("/{rol:administrador|sysadmin}/cuentas-administradores")
    public String listarCuentasAdministradores(@PathVariable String rol, Model model) {
        model.addAttribute("registros", administradorService.listarAdministradores());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-administradores");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "administrador");
        return "layout";
    }

    @GetMapping("/{rol:administrador|sysadmin}/cuentas-administradores/bajas")
    public String listarCuentasAdministradoresBajas(@PathVariable String rol, Model model) {
        model.addAttribute("registros", administradorService.listarAdministradoresInactivos());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-administradores");
        model.addAttribute("puedeCrear", false);
        model.addAttribute("puedeEditar", false);
        model.addAttribute("puedeEliminar", false);
        model.addAttribute("modoBajas", true);
        model.addAttribute("vista", "administrador");
        return "layout";
    }

    @GetMapping("/{rol:administrador|sysadmin}/cuentas-administradores/ver/{id}")
    public String verCuentaAdministrador(@PathVariable String rol, @PathVariable Integer id, Model model) {
        model.addAttribute("registro", administradorService.obtenerAdministradorPorId(id));
        model.addAttribute("registros", administradorService.listarAdministradores());
        model.addAttribute("rutaBase", "/" + rol + "/cuentas-administradores");
        model.addAttribute("puedeCrear", true);
        model.addAttribute("puedeEditar", true);
        model.addAttribute("puedeEliminar", true);
        model.addAttribute("modoBajas", false);
        model.addAttribute("vista", "administrador");
        return "layout";
    }

    @PostMapping("/{rol:administrador|sysadmin}/cuentas-administradores/crear")
    public String crearCuentaAdministrador(@PathVariable String rol, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        administradorService.crearAdministrador(params);
        redirect.addFlashAttribute("mensajeExito", "Administrador registrado correctamente.");
        return "redirect:/" + rol + "/cuentas-administradores";
    }

    @PostMapping("/{rol:administrador|sysadmin}/cuentas-administradores/editar")
    public String editarCuentaAdministrador(@PathVariable String rol, @RequestParam Integer id, @RequestParam Map<String, String> params, RedirectAttributes redirect) {
        administradorService.editarAdministrador(id, params);
        redirect.addFlashAttribute("mensajeExito", "Datos del administrador actualizados.");
        return "redirect:/" + rol + "/cuentas-administradores";
    }

    @PostMapping("/{rol:administrador|sysadmin}/cuentas-administradores/eliminar")
    public String eliminarCuentaAdministrador(@PathVariable String rol, @RequestParam Integer id, RedirectAttributes redirect) {
        administradorService.eliminarAdministrador(id);
        redirect.addFlashAttribute("mensajeExito", "Administrador dado de baja.");
        return "redirect:/" + rol + "/cuentas-administradores";
    }

}
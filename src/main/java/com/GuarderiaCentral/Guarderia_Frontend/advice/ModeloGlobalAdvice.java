package com.GuarderiaCentral.Guarderia_Frontend.advice;

import com.GuarderiaCentral.Guarderia_Frontend.security.UsuarioAutenticado;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Agrega al Model de todas las vistas los datos que usa layout.jsp: {@code rol} (en minúscula,
 * para incluir menu/&lt;rol&gt;.jsp) y {@code nombreUsuario}. Se toman del {@link UsuarioAutenticado}
 * de Spring Security; no se arma a mano ningún atributo de sesión con el rol.
 *
 * @author Franco Buyatti, Daniela Forclaz, Héctor Machaca, María Eugenia Barca
 */
@ControllerAdvice
public class ModeloGlobalAdvice {

    /**
     * Carga {@code rol} y {@code nombreUsuario} si hay un usuario autenticado.
     * Spring entrega el usuario ya tipado con {@link AuthenticationPrincipal}; si el visitante
     * es anónimo llega {@code null} y el modelo queda sin esos datos.
     *
     * @param usuario usuario autenticado (null si es anónimo)
     * @param model   modelo de la vista actual
     */
    @ModelAttribute
    public void agregarDatosDelUsuario(@AuthenticationPrincipal UsuarioAutenticado usuario, Model model) {
        if (usuario != null) {
            model.addAttribute("rol", usuario.getRol().toLowerCase());
            model.addAttribute("nombreUsuario", usuario.getNombreUsuario());
        }
    }
}
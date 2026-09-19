package com.GuarderiaCentral.Guarderia_Frontend.controllers;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    // Muestra la vista login.jsp cuando entran a /login o a la raíz
    @GetMapping("/login")
    public String mostrarLogin() {
        return "login"; // Busca login.jsp en WEB-INF/jsp/
    }

    // Recibe los datos del formulario HTML por POST
    @PostMapping("/do-login")
    public String procesarLogin(@RequestParam("username") String username,
                                @RequestParam("password") String password,
                                HttpSession session) {

        // Aquí después llamarás al BackendClientService para autenticarte
        // Si es correcto, guardas el rol en la sesión: session.setAttribute("userRole", "ADMIN");

        return "redirect:/dashboard"; // Redirige al panel principal
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.interceptors;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // Verificamos si existe el token o el usuario en la sesión
        Object token = session.getAttribute("jwtToken");

        if (token == null) {
            // Si no está logueado, lo redirigimos al login
            response.sendRedirect("/login");
            return false; // Detiene la ejecución de la ruta protegida
        }

        return true; // Permite continuar si todo está OK
    }
}
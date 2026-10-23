package com.GuarderiaCentral.Guarderia_Frontend.controllers;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/sysadmin")
public class SysadminController {

    @GetMapping("/dash")
    public String dash(Authentication auth, Model model) {
        String rol = auth.getAuthorities().iterator().next()
                .getAuthority().replace("ROLE_", "");

        model.addAttribute("userName", auth.getName());
        model.addAttribute("userRole", rol);

        // TODO: cargar desde el backend con el client:
        // totalAdmins, totalEmpleados, totalSocios, alertasOcupacion, administradores

        return "dash/sysadmin-panel";
    }
}
package com.GuarderiaCentral.Guarderia_Frontend.service;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import java.util.Map;
import java.util.HashMap;
//prueba comit franco

@Service
public class BackendClientService {
    private final RestTemplate restTemplate;

    @Value("${backend.api.url}")
    private String backendUrl; // http://localhost:8080/api

    public BackendClientService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String login(String username, String password) {
        String url = backendUrl + "/auth/login";

        Map<String, String> request = new HashMap<>();
        request.put("username", username);
        request.put("password", password);

        // Envía los datos al Backend y espera recibir un JSON con el token
        ResponseEntity<Map> response = restTemplate.postForEntity(url, request, Map.class);

        if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
            return (String) response.getBody().get("token"); // Retorna el JWT
        }
        return null;
    }
}
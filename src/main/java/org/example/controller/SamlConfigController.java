package org.example.controller;

import org.example.service.saml.SamlSignAndVerifyCoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class SamlConfigController {

    @Autowired
    private SamlSignAndVerifyCoreService samlSignAndVerifyCoreService;

    @PostMapping("/api/generate-saml-request")
    public Map<String, String> handleSamlRequest(@RequestBody Map<String, String> request) {
        String tenantId = request.get("tenantId");
        String entityId = request.get("entityId");
        String acsUrl = request.get("acsUrl");
        return samlSignAndVerifyCoreService.generateSignSamlRequest(tenantId, entityId, acsUrl);
    }
}

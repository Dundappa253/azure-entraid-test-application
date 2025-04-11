package org.example.controller;

import org.example.model.SamlMetadataModel;
import org.example.service.saml.SamlSignAndVerifyCoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.util.Map;

@RestController
public class SamlConfigController {

    @Autowired
    private SamlSignAndVerifyCoreService samlSignAndVerifyCoreService;

    @PostMapping(value = "/api/generate-saml-request")
    public Map<String, String> handleSamlRequest(
            @RequestParam String tenantId,
            @RequestParam String entityId,
            @RequestParam String acsUrl,
            @RequestParam String verifyCertificateRequired)  {
        SamlMetadataModel samlMetadataModel = SamlMetadataModel.builder()
                .tenantId(tenantId)
                .entityId(entityId)
                .acsUrl(acsUrl)
                .verifyCertificateRequired(Boolean.valueOf(verifyCertificateRequired));


        return samlSignAndVerifyCoreService.generateSignSamlRequest(samlMetadataModel);
    }
}

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

    @PostMapping(value = "/api/generate-saml-request",consumes = "multipart/form-data")
    public Map<String, String> handleSamlRequest( @RequestParam String tenantId,
                                                  @RequestParam String entityId,
                                                  @RequestParam String acsUrl,
                                                  @RequestParam boolean isVerifyCertificateRequired,
                                                  @RequestParam(required = false) MultipartFile jksFile,
                                                  @RequestParam(required = false) String jksPassword,
                                                  @RequestParam(required = false) String jksAlias) throws KeyStoreException, IOException, CertificateException, NoSuchAlgorithmException {

        SamlMetadataModel samlMetadataModel = SamlMetadataModel.builder()
                 .tenantId(tenantId)
                .entityId(entityId)
                .acsUrl(acsUrl)
                .verifyCertificateRequired(isVerifyCertificateRequired);

        KeyStore keyStore = null;
        if (isVerifyCertificateRequired && jksFile != null && !jksFile.isEmpty()) {
            keyStore = KeyStore.getInstance("JKS");
            keyStore.load(jksFile.getInputStream(), jksPassword.toCharArray());
        }

        return samlSignAndVerifyCoreService.generateSignSamlRequest(samlMetadataModel,keyStore);
    }
}

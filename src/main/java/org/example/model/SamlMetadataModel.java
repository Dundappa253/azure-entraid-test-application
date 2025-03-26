package org.example.model;

import org.springframework.core.io.InputStreamSource;

public class SamlMetadataModel {
    private String tenantId;
    private String entityId;
    private String acsUrl;
    private boolean verifyCertificateRequired;
    private SigningCertificate signingCertificate;

    public SamlMetadataModel() {
    }

    public SamlMetadataModel(String tenantId, String entityId, String acsUrl, boolean verifyCertificateRequired) {
        this.tenantId = tenantId;
        this.entityId = entityId;
        this.acsUrl = acsUrl;
        this.verifyCertificateRequired = verifyCertificateRequired;
    }


    public SamlMetadataModel tenantId(String tenantId) {
        this.tenantId = tenantId;
        return this;
    }

    public SamlMetadataModel entityId(String entityId) {
        this.entityId = entityId;
        return this;
    }

    public SamlMetadataModel acsUrl(String acsUrl) {
        this.acsUrl = acsUrl;
        return this;
    }

    public SamlMetadataModel verifyCertificateRequired(boolean verifyCertificateRequired) {
        this.verifyCertificateRequired = verifyCertificateRequired;
        return this;
    }

    public SamlMetadataModel signingCertificate(SigningCertificate signingCertificate) {
        this.signingCertificate = signingCertificate;
        return this;
    }
    public SamlMetadataModel build() {
        return new SamlMetadataModel(tenantId, entityId, acsUrl, verifyCertificateRequired);
    }

    // Optional: Add a static method to create a builder
    public static SamlMetadataModel builder() {
        return new SamlMetadataModel();
    }


    public String getTenantId() {
        return tenantId;
    }

    public String getEntityId() {
        return entityId;
    }

    public String getAcsUrl() {
        return acsUrl;
    }

    public boolean isVerifyCertificateRequired() {
        return verifyCertificateRequired;
    }

    public SigningCertificate getSigningCertificate() {
        return signingCertificate;
    }

    public static class SigningCertificate{
        private InputStreamSource certificateData;
        private String keyStorePassword;
        private String keyPassword;
        private String alias;

        public InputStreamSource getCertificateData() {
            return certificateData;
        }

        public void setCertificateData(InputStreamSource certificateData) {
            this.certificateData = certificateData;
        }

        public String getKeyStorePassword() {
            return keyStorePassword;
        }

        public void setKeyStorePassword(String keyStorePassword) {
            this.keyStorePassword = keyStorePassword;
        }

        public String getKeyPassword() {
            return keyPassword;
        }

        public void setKeyPassword(String keyPassword) {
            this.keyPassword = keyPassword;
        }

        public String getAlias() {
            return alias;
        }

        public void setAlias(String alias) {
            this.alias = alias;
        }
    }
}

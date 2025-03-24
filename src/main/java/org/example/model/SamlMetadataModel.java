package org.example.model;

public class SamlMetadataModel {
    private String tenantId;
    private String entityId;
    private String acsUrl;
    private boolean verifyCertificateRequired;

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
}

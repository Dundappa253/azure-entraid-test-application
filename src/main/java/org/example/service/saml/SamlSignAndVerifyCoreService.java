package org.example.service.saml;


import org.example.model.SamlMetadataModel;
import org.opensaml.core.config.InitializationService;
import org.opensaml.core.xml.io.Marshaller;
import org.opensaml.core.xml.io.MarshallerFactory;
import org.opensaml.core.xml.io.MarshallingException;
import org.opensaml.core.xml.util.XMLObjectSupport;
import org.opensaml.saml.saml2.core.AuthnRequest;
import org.opensaml.saml.saml2.core.Issuer;
import org.opensaml.saml.saml2.core.NameIDPolicy;
import org.opensaml.saml.saml2.core.impl.AuthnRequestBuilder;
import org.opensaml.saml.saml2.core.impl.IssuerBuilder;
import org.opensaml.saml.saml2.core.impl.NameIDPolicyBuilder;
import org.opensaml.security.credential.Credential;
import org.opensaml.security.x509.BasicX509Credential;
import org.opensaml.xmlsec.signature.KeyInfo;
import org.opensaml.xmlsec.signature.Signature;
import org.opensaml.xmlsec.signature.X509Data;
import org.opensaml.xmlsec.signature.impl.KeyInfoBuilder;
import org.opensaml.xmlsec.signature.impl.SignatureBuilder;
import org.opensaml.xmlsec.signature.impl.X509CertificateBuilder;
import org.opensaml.xmlsec.signature.impl.X509DataBuilder;
import org.opensaml.xmlsec.signature.support.SignatureConstants;
import org.opensaml.xmlsec.signature.support.SignatureException;
import org.opensaml.xmlsec.signature.support.SignatureValidator;
import org.opensaml.xmlsec.signature.support.Signer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;
import org.w3c.dom.Element;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.*;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.time.Instant;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.Deflater;
import java.util.zip.DeflaterOutputStream;

@Service
public class SamlSignAndVerifyCoreService {

    public  Map<String,String> generateSignSamlRequest(SamlMetadataModel samlMetadataModel) {
        Map<String,String> samlRequestMap = new HashMap<>();
        try {
            InitializationService.initialize();
            // Create the SAML request
            AuthnRequest authnRequest = createAuthnRequest(samlMetadataModel);
            // Load the private key and certificate
            Signature signature = null;
            if (samlMetadataModel.isVerifyCertificateRequired()
                    && samlMetadataModel.getSigningCertificate().getCertificateData() != null) {
                signature = getSignature(samlMetadataModel, authnRequest);
            }
            XMLObjectSupport.marshall(authnRequest);

            if(samlMetadataModel.isVerifyCertificateRequired()){
                Signer.signObject(signature);
            }
            String encodedRequest = encodeSAMLRequest(authnRequest);
            Element element = XMLObjectSupport.marshall(authnRequest);
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            TransformerFactory.newInstance().newTransformer()
                    .transform(new DOMSource(element),
                            new StreamResult(outputStream));
            byte[] xmlBytes = outputStream.toByteArray();

            String plainSamlRequest = Base64.getEncoder().encodeToString(xmlBytes);
            samlRequestMap.put("encodedSamlRequest",plainSamlRequest);
            System.out.println("SAML Request: " + encodedRequest);
          //  verify(authnRequest,certificate);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return samlRequestMap;
    }

    private static AuthnRequest createAuthnRequest(SamlMetadataModel samlMetadataModel) {
        AuthnRequest authnRequest = new AuthnRequestBuilder().buildObject();
        authnRequest.setID("_" + java.util.UUID.randomUUID().toString());
        authnRequest.setIssueInstant(Instant.now());
        authnRequest.setProtocolBinding("urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST");
        authnRequest.setAssertionConsumerServiceURL(samlMetadataModel.getAcsUrl());

        Issuer issuer = new IssuerBuilder().buildObject();
        issuer.setValue(samlMetadataModel.getEntityId());
        authnRequest.setIssuer(issuer);

        NameIDPolicy nameIDPolicy = new NameIDPolicyBuilder().buildObject();
        nameIDPolicy.setAllowCreate(true);
        nameIDPolicy.setFormat("urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified");
        authnRequest.setNameIDPolicy(nameIDPolicy);
        authnRequest.setDestination(String.format("https://login.microsoftonline.com/%s/saml2",samlMetadataModel.getTenantId()));
        return authnRequest;
    }

    private static Signature getSignature(SamlMetadataModel samlMetadataModel, AuthnRequest authnRequest) throws KeyStoreException, IOException, NoSuchAlgorithmException, CertificateException, UnrecoverableKeyException {
        Signature signature;
        KeyInfo keyInfo = new KeyInfoBuilder().buildObject();
        X509Data x509Data = new X509DataBuilder().buildObject();
        org.opensaml.xmlsec.signature.X509Certificate x509Certificate = new X509CertificateBuilder().buildObject();

        KeyStore keyStore = KeyStore.getInstance("JKS");
        keyStore.load(
                samlMetadataModel.getSigningCertificate().getCertificateData().getInputStream(),
                samlMetadataModel.getSigningCertificate().getKeyStorePassword().toCharArray()
        );
        PrivateKey privateKey = (PrivateKey) keyStore.getKey(samlMetadataModel.getSigningCertificate().getAlias(),
                samlMetadataModel.getSigningCertificate().getKeyPassword().toCharArray());
        X509Certificate certificate = (X509Certificate)keyStore.getCertificate(samlMetadataModel.getSigningCertificate().getAlias());
        Credential credential = new BasicX509Credential(certificate, privateKey);
        signature = new SignatureBuilder().buildObject();
        signature.setSigningCredential(credential);
        signature.setSignatureAlgorithm(SignatureConstants.ALGO_ID_SIGNATURE_RSA_SHA256);
        signature.setCanonicalizationAlgorithm(SignatureConstants.ALGO_ID_C14N_EXCL_OMIT_COMMENTS);

        x509Certificate.setValue(Base64.getEncoder().encodeToString(certificate.getEncoded()));
        x509Data.getX509Certificates().add(x509Certificate);
        keyInfo.getX509Datas().add(x509Data);
        signature.setKeyInfo(keyInfo);
        authnRequest.setSignature(signature);
        return signature;
    }


    public static void verify(AuthnRequest authnRequest,X509Certificate certificate) {
        try {
            SignatureValidator.validate(authnRequest.getSignature(), new BasicX509Credential(certificate));
            System.out.println("Signature is valid!");
        } catch (SignatureException e) {
            System.out.println("Signature is invalid: " + e.getMessage());
        }
    }

    private static String serializeSAMLObject(AuthnRequest authnRequest) throws MarshallingException, TransformerException {
        MarshallerFactory marshallerFactory = org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport.getMarshallerFactory();
        Marshaller marshaller = marshallerFactory.getMarshaller(authnRequest);
        Element domElement = marshaller.marshall(authnRequest);
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        DOMSource source = new DOMSource(domElement);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        transformer.transform(source, result);
        return writer.toString();
    }

    public static String encodeSAMLRequest(AuthnRequest authnRequest) throws Exception {
        Element element = XMLObjectSupport.marshall(authnRequest);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        TransformerFactory.newInstance().newTransformer()
                .transform(new DOMSource(element),
                        new StreamResult(outputStream));
        byte[] xmlBytes = outputStream.toByteArray();
        return Base64.getEncoder().encodeToString(xmlBytes);
    }

    public static byte[] deflate(byte[] input) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        DeflaterOutputStream deflaterOutputStream = new DeflaterOutputStream(byteArrayOutputStream, new Deflater(Deflater.DEFLATED, true));
        deflaterOutputStream.write(input);
        deflaterOutputStream.close();
        return byteArrayOutputStream.toByteArray();
    }
}

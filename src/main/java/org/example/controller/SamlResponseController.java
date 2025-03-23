package org.example.controller;

import org.opensaml.core.xml.XMLObject;
import org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport;
import org.opensaml.core.xml.io.UnmarshallerFactory;
import org.opensaml.core.xml.io.UnmarshallingException;
import org.opensaml.saml.saml2.core.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.w3c.dom.Element;
import org.opensaml.saml.saml2.core.Response;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import org.example.model.Attribute;
import org.xml.sax.SAXException;

@Controller
public class SamlResponseController {
    @PostMapping("/saml/SSO")
    public String handleSamlResponse(@RequestParam("SAMLResponse") String samlResponse, Model model) {
        System.out.println("Received Response from Saml" + samlResponse);
        byte[] decodedBytes = Base64.getDecoder().decode(samlResponse);
        String decodedSamlResponse = new String(decodedBytes, StandardCharsets.UTF_8);
        model.addAttribute("samlResponse",decodedSamlResponse);
        model.addAttribute("samlClaims",getSamlClaims(decodedSamlResponse));
        return "saml-response";
    }

    private List<Attribute> getSamlClaims(String samlXmlResponse) {
        Response response = parseSamlResponse(samlXmlResponse);
        List<Attribute> samlClaimList = new ArrayList<>();
        // Extract details from the SAML response
        samlClaimList.add(new Attribute("Response ID", response.getID()));
        samlClaimList.add(new Attribute("Version",response.getVersion().toString()));
        samlClaimList.add(new Attribute("Issue Instant", response.getIssueInstant().toString()));
        samlClaimList.add(new Attribute("Destination", response.getDestination()));
        samlClaimList.add(new Attribute("InResponseTo",response.getInResponseTo()));

        // Extract details from the Assertion
        Assertion assertion = response.getAssertions().get(0); // Assuming single assertion
        samlClaimList.add(new Attribute("Assertion ID", assertion.getID()));
        samlClaimList.add(new Attribute("Assertion Issue Instant", assertion.getIssueInstant().toString()));
        samlClaimList.add(new Attribute("NameID", assertion.getSubject().getNameID().getValue()));
        samlClaimList.add(new Attribute("Subject Confirmation Method", assertion.getSubject().getSubjectConfirmations().get(0).getMethod()));
        // Extract Conditions
        samlClaimList.add(new Attribute("Not Before", assertion.getConditions().getNotBefore().toString()));
        samlClaimList.add(new Attribute("Not On Or After",assertion.getConditions().getNotOnOrAfter().toString()));
        samlClaimList.add(new Attribute("Audience",assertion.getConditions().getAudienceRestrictions().get(0).getAudiences().get(0).getAudienceURI().toString()));

        // Extract Attributes
        for (AttributeStatement statement : assertion.getAttributeStatements()) {
            for (org.opensaml.saml.saml2.core.Attribute attribute : statement.getAttributes()) {
                Attribute attribute1 = new Attribute();
                attribute1.setName(attribute.getName());
                for (XMLObject value : attribute.getAttributeValues()) {
                    attribute1.setValue(value.getDOM().getTextContent());
                }
                samlClaimList.add(attribute1);
            }
        }
        System.out.println("samlClaimList" + samlClaimList);
        return samlClaimList;
    }

    private static Response parseSamlResponse(String samlResponse)  {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        Element element = null;
        try {
            element = factory.newDocumentBuilder()
                    .parse(new ByteArrayInputStream(samlResponse.getBytes()))
                    .getDocumentElement();
        } catch (SAXException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (ParserConfigurationException e) {
            throw new RuntimeException(e);
        }
        // Unmarshal the XML into a Response object
        UnmarshallerFactory unmarshallerFactory = XMLObjectProviderRegistrySupport.getUnmarshallerFactory();
        try {
            return (Response) unmarshallerFactory.getUnmarshaller(element).unmarshall(element);
        } catch (UnmarshallingException e) {
            throw new RuntimeException(e);
        }
    }
}

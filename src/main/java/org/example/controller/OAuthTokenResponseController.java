package org.example.controller;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.model.Attribute;
import org.example.model.OAuthTokenRequest;
import org.example.model.OAuthTokenResponse;
import org.example.util.JsonUtil;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@RestController
public class OAuthTokenResponseController {

    @PostMapping(path = "/api/decode-oauth-token")
    public Map<String,Object> getDecodedTokenResponse(@RequestBody OAuthTokenResponse tokenResponse) throws JsonProcessingException {
        Map<String,Object> decodedTokenResponse = new HashMap<>();

        DecodedJWT idTokendecodedJWT = JWT.decode(tokenResponse.getId_token());
        String idTokenHeaderJson = decodeBase64(idTokendecodedJWT.getHeader());
        String idTokenPayloadJson = decodeBase64(idTokendecodedJWT.getPayload());
        String idTokenDecodedToken =  String.format(idTokenHeaderJson+".\n"+idTokenPayloadJson
                +".\n"+idTokendecodedJWT.getSignature());

        decodedTokenResponse.put("idTokenClaimList",extractToken(idTokendecodedJWT));
        decodedTokenResponse.put("decodedIdToken",idTokenDecodedToken);


        DecodedJWT accessTokendecodedJWT = JWT.decode(tokenResponse.getAccess_token());
        String accessTokenHeaderJson = decodeBase64(accessTokendecodedJWT.getHeader());
        String accessTokenPayloadJson = decodeBase64(accessTokendecodedJWT.getPayload());
        String accessTokenDecodedToken =  String.format(accessTokenHeaderJson+".\n"+
                accessTokenPayloadJson+".\n"+accessTokendecodedJWT.getSignature());

        decodedTokenResponse.put("accessTokenClaimList",extractToken(accessTokendecodedJWT));
        decodedTokenResponse.put("decodedAccessToken",accessTokenDecodedToken);
        decodedTokenResponse.put("rawTokenOAuthResponse",JsonUtil.toJson(tokenResponse));

        return decodedTokenResponse;
    }

    @PostMapping(path= "/api/clientCredential-token")
    public Map<String,Object> getToken(@RequestBody OAuthTokenRequest request) {
        // Build the token request to Microsoft
        Map<String,Object> decodedTokenResponse = new HashMap<>();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("client_id", request.getClientId());
        map.add("scope", request.getScope());
        map.add("grant_type", request.getGrantType());
        map.add("client_secret", request.getClientSecret());
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);
        // Make the request to Microsoft
        RestTemplate restTemplate = new RestTemplate();
        String tokenUrl = "https://login.microsoftonline.com/" + request.getTenantId() + "/oauth2/v2.0/token";
        String response = restTemplate.postForObject(tokenUrl, entity, String.class);
        OAuthTokenResponse tokenResponse = (OAuthTokenResponse)JsonUtil.toObject(response,OAuthTokenResponse.class);
        decodedTokenResponse.put("rawTokenOAuthResponse",JsonUtil.formatJson(response));

        DecodedJWT accessTokendecodedJWT = JWT.decode(tokenResponse.getAccess_token());
        String accessTokenHeaderJson = decodeBase64(accessTokendecodedJWT.getHeader());
        String accessTokenPayloadJson = decodeBase64(accessTokendecodedJWT.getPayload());
        String accessTokenDecodedToken =  String.format(accessTokenHeaderJson+".\n"+
                accessTokenPayloadJson+".\n"+accessTokendecodedJWT.getSignature());

        decodedTokenResponse.put("decodedAccessToken",accessTokenDecodedToken);
        decodedTokenResponse.put("accessTokenClaimList",extractToken(accessTokendecodedJWT));

        return decodedTokenResponse;
    }

    private List<Attribute> extractToken(DecodedJWT decodedJWT) {
        return decodedJWT.getClaims().entrySet().stream()
                .map(entry -> new Attribute(
                        entry.getKey(),
                        Optional.ofNullable(entry.getValue().asString())
                                .orElseGet(() -> entry.getValue().toString())
                ))
                .collect(Collectors.toList());
    }

    private static String decodeBase64(String encoded) {
        String jsonPayload = new String(Base64.getDecoder().decode(encoded));
        return JsonUtil.formatJson(jsonPayload);
    }

}

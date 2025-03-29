package org.example.controller;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.example.model.Attribute;
import org.example.model.OAuthTokenResponse;
import org.example.util.JsonUtil;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

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

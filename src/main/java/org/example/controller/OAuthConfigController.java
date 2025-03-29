package org.example.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.*;

@Controller
public class OAuthConfigController {
    @GetMapping("/oauth/callback")
    public String getOAuthConfiguration(@RequestParam(name = "code") String authCode,
                                        @RequestParam(name = "state") String state, Model model) {
        model.addAttribute("authCode",authCode);
        model.addAttribute("state",state);
       return "oauth-response";
    }

}

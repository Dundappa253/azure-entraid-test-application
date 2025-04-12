<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application 2</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <link href="${pageContext.request.contextPath}/static/css/common.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>
<br>
<div class="container mt-5">

    <!-- OAuth Test Content -->
    <div id="oauthTest" class="tab-content">
        <h2 class="mb-4 text-center">Azure EntraID OAuth Test Application</h2>

        <!-- OAuth Stepper -->
        <div class="stepper">
            <div class="step active" id="oauthStep1-tab">Step 1: Configuration</div>
            <div class="step" id="oauthStep2-tab">Step 2: Authorization</div>
            <div class="step" id="oauthStep3-tab">Step 3: Tokens</div>
            <div class="step" id="oauthStep4-tab">Step 4: API Test</div>
        </div>

        <!-- Step 1: Configuration -->
        <div id="oauthStep1-content" class="step-content active">
            <h5>Step 1: Configure OAuth Settings</h5>
            <br>
            <div class="mb-3">
                <label for="oauthTenantId" class="form-label">Tenant ID:</label>
                <select id="oauthTenantId" class="form-select">
                    <option value="-1">Select Azure Tenant</option>
                    <option value="dba21c9c-dbbc-4b6a-9473-8e886854204f">My Tenant -
                        dba21c9c-dbbc-4b6a-9473-8e886854204f
                    </option>
                </select>
                <div id="oauthTenantIdError" class="alert alert-danger custom-alert mt-1" style="display: none;"></div>
            </div>

            <!-- Rest of the configuration form remains the same -->
            <div class="mb-3">
                <label for="clientId" class="form-label">Client ID:</label>
                <input type="text" id="clientId" value="06b27541-b252-47cd-9898-6227cf5b1c77" class="form-control"
                       placeholder="Enter Application (Client) ID">
                <div id="clientIdError" class="alert alert-danger custom-alert mt-1" style="display: none;"></div>
            </div>

            <div class="mb-3">
                <label for="clientSecret" class="form-label">Client Secret:</label>
                <input type="password" id="clientSecret" class="form-control" placeholder="Enter Client Secret">
                <div id="clientSecretError" class="alert alert-danger custom-alert mt-1" style="display: none;"></div>
            </div>

            <div class="mb-3">
                <label for="redirectUri" class="form-label">Redirect URI:</label>
                <input type="text" id="redirectUri" class="form-control" value="http://localhost:8080/oauth/callback">
                <div id="redirectUriError" class="alert alert-danger custom-alert mt-1" style="display: none;"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Grant Type:</label>
                <select id="grantType" class="form-select">
                    <option value="authorization_code">Authorization Code</option>
                    <option value="client_credentials">Client Credentials</option>
                    <option value="password">Password (ROPC)</option>
                    <option value="implicit">Implicit (legacy)</option>
                </select>
            </div>

            <div class="mb-3" id="scopesContainer">
                <label class="form-label">Scopes:</label>
                <div class="scope-item">
                    <input type="checkbox" id="scope_openid" checked>
                    <label for="scope_openid">openid</label>
                </div>
                <div class="scope-item">
                    <input type="checkbox" id="scope_profile" checked>
                    <label for="scope_profile">profile</label>
                </div>
                <div class="scope-item">
                    <input type="checkbox" id="scope_email" checked>
                    <label for="scope_email">email</label>
                </div>
                <div class="scope-item">
                    <input type="checkbox" id="scope_offline_access">
                    <label for="scope_offline_access">offline_access</label>
                </div>
                <div class="scope-item">
                    <input type="checkbox" id="scope_user_read">
                    <label for="scope_user_read">User.Read</label>
                </div>
                <div class="scope-item">
                    <input type="text" id="customScope" class="form-control mt-2" placeholder="Or enter custom scope">
                </div>
            </div>

            <div class="d-flex gap-3">
                <button class="btn btn-secondary flex-grow-1" onclick="resetOAuthForm()">Reset</button>
                <button class="btn btn-primary flex-grow-1" onclick="validateOAuthStep1()">Next</button>
            </div>
        </div>

        <!-- Step 2: Authorization -->
        <div id="oauthStep2-content" class="step-content">
            <h5>Step 2: Get Authorization</h5>
            <br>
            <div class="mb-3">
                <label class="form-label">Authorization URL:</label>
                <div class="input-group">
                    <input type="text" id="authUrl" class="form-control" readonly>
                    <button class="btn btn-outline-secondary" onclick="copyToClipboard('authUrl')">Copy</button>
                </div>
            </div>

            <div class="mb-3">
                <button class="btn btn-primary" onclick="startAuthFlow()">Launch Authorization</button>
            </div>

            <div class="mb-3">
                <label for="authCode" class="form-label">Authorization Code:</label>
                <textarea id="authCode" class="form-control" rows="2"
                          placeholder="Paste the authorization code"></textarea>
                <div id="authCodeError" class="alert alert-danger custom-alert mt-1" style="display: none;"></div>
            </div>

            <div id="authFlowContainer" style="display: none;">
                <div class="alert alert-info">
                    <p>You are being redirected to Microsoft for authentication...</p>
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Step 3: Tokens -->
        <div id="oauthStep3-content" class="step-content">
            <h5>Step 3: View OAuth Response</h5>
            <div class="tab">
                <button class="tablinks" onclick="openTab(event, 'idTokenResponse')">ID Token Claims</button>
                <button class="tablinks" onclick="openTab(event, 'accessTokenResponse')">Access Token Claims</button>
                <button class="tablinks" onclick="openTab(event, 'rawOAuthResponse')">Decoded ID Token</button>
                <button class="tablinks" onclick="openTab(event, 'accessTokenOAuthResponse')">Decoded Access Token</button>
                <button class="tablinks" onclick="openTab(event, 'rawTokenOAuthResponse')">Raw OAuth Response</button>
            </div>

            <!-- Tab Content -->
            <div id="oauthContentId" style="display:none">
                <div id="idTokenResponse" class="tabcontent">
                   <table id="idTokenTable" class="table table-striped">
                       <thead>
                           <tr>
                               <th>Claim Name</th>
                               <th>Claim Value</th>
                           </tr>
                       </thead>
                       <tbody>
                       </tbody>
                   </table>
                </div>
                <div id="accessTokenResponse" class="tabcontent">
                   <table id="accessTokenTable" class="table table-striped">
                       <thead>
                           <tr>
                               <th>Claim Name</th>
                               <th>Claim Value</th>
                           </tr>
                       </thead>
                       <tbody>
                       </tbody>
                   </table>
                </div>
                <div id="rawOAuthResponse" class="tabcontent">
                    <pre id="rawIdTokenResponseId" class="token-value"></pre>
                </div>
                <div id="accessTokenOAuthResponse" class="tabcontent">
                    <pre id="rawAccessTokenResponseId" class="token-value"></pre>
                </div>
                <div id="rawTokenOAuthResponse" class="tabcontent">
                    <pre id="rawTokenOAuthResponseId" class="token-value"></pre>
                </div>
            </div>
            <jsp:include page="page-loader.jsp">
                <jsp:param name="loader-id" value="oauth-2" />
                <jsp:param name="loader-message" value="OAuth Response Detail is being loading" />
            </jsp:include>
        </div>
        <div class="d-flex gap-3">
            <button class="btn btn-secondary flex-grow-1" onclick="showOAuthStep(2)">Previous</button>
            <button class="btn btn-primary flex-grow-1" onclick="showOAuthStep(4)">Test API</button>
            <button class="btn btn-info flex-grow-1" id="refreshTokenBtn" onclick="refreshTokens()"
                    style="display: none;">Refresh Token
            </button>
        </div>
    </div>


    <!-- Step 4: API Test -->
    <div id="oauthStep4-content" class="step-content">
        <h5>Step 4: API Test</h5>
        <br>
        <div class="mb-3">
            <label for="apiEndpoint" class="form-label">API Endpoint:</label>
            <input type="text" id="apiEndpoint" class="form-control" value="https://graph.microsoft.com/v1.0/me">
        </div>

        <div class="mb-3">
            <label class="form-label">API Response:</label>
            <pre id="apiResponse" class="oauth-token-container"></pre>
        </div>

        <div class="d-flex gap-3">
            <button class="btn btn-secondary flex-grow-1" onclick="showOAuthStep(3)">Previous</button>
            <button class="btn btn-primary flex-grow-1" onclick="callApi()">Call API</button>
        </div>
    </div>
</div>


<!-- Documentation Content -->
<div id="documentation" class="tab-content" style="display: none;">
    <h2 class="mb-4 text-center">Azure EntraID Test - Documentation</h2>
    <p>Welcome to the documentation section.</p>
    <p>Here you can provide detailed information about SAML and OAuth integration.</p>
    <ul>
        <li><a href="#">SAML Documentation</a></li>
        <li><a href="#">OAuth Documentation</a></li>
        <li><a href="#">API Reference</a></li>
    </ul>
</div>
</div>
<%@ include file="footer.jsp" %>
<script>

    $(document).ready(function() {
         $("#redirectUri").val(window.location.origin + window.location.pathname);
           // Check for authorization code in URL (OAuth callback)
           const urlParams = new URLSearchParams(window.location.search);
           const authCode = urlParams.get('code');
           const state = urlParams.get('state');
           const error = urlParams.get('error');

           // Restore form state if we're returning from auth flow
           const savedState = sessionStorage.getItem('oauthFormState');
         if (savedState) {
               const formState = JSON.parse(savedState);
               $("#oauthTenantId").val(formState.tenantId);
               $("#clientId").val(formState.clientId);
               $("#redirectUri").val(formState.redirectUri);
               setSelectedScopes(formState.scopes);
               sessionStorage.removeItem('oauthFormState');

             //  $("#oauthTestTab").click();
               showOAuthStep(3);
               $("#loader-content-oauth-2").show();
         }

         if (error) {
               // Handle OAuth error
               console.error("OAuth Error:", error, urlParams.get('error_description'));
               $("#oauthTestTab").click();
               $("#authCodeError").text(`${error}: ${urlParams.get('error_description')}`).show();
          }
          else if (authCode && state === '12345') {
               // Switch to OAuth tab and populate the auth code
          //     $("#oauthTestTab").click();
               $("#authCode").val(authCode);

               // Automatically proceed to get tokens
               setTimeout(() => {
                   validateOAuthStep2();
                   // Clean the URL
                   if (window.history.replaceState) {
                       window.history.replaceState({}, document.title, window.location.pathname);
                   }
               }, 500);
         }
    });


     function openTab(evt, tabName) {
               const tabcontent = document.getElementsByClassName("tabcontent");
               for (let i = 0; i < tabcontent.length; i++) {
                   tabcontent[i].style.display = "none";
               }
               const tablinks = document.getElementsByClassName("tablinks");
               for (let i = 0; i < tablinks.length; i++) {
                   tablinks[i].className = tablinks[i].className.replace(" active", "");
               }
               document.getElementById(tabName).style.display = "block";
               evt.currentTarget.className += " active";
           }
           // Open the default tab
      document.getElementsByClassName("tablinks")[0].click();


     async function generateAuthUrl() {
         // Clear previous errors
         $(".alert-danger.custom-alert").hide().text("");

         // Generate PKCE code verifier and challenge
         const codeVerifier = generateRandomString(64);
         sessionStorage.setItem('code_verifier', codeVerifier);

         let codeChallenge;
         try {
             codeChallenge = await generateCodeChallenge(codeVerifier);
         } catch (error) {
             console.error("Failed to generate code challenge:", error);
             alert("Failed to generate security code. Please try again.");
             return;
         }

         // Validate inputs
         let isValid = true;
         const tenantId = $("#oauthTenantId").val();
         const clientId = $("#clientId").val();
         const grantType = $("#grantType").val();

         if (!tenantId || tenantId === "-1") {
             $("#oauthTenantIdError").text("Tenant ID is required").show();
             isValid = false;
         }

         if (!clientId) {
             $("#clientIdError").text("Client ID is required").show();
             isValid = false;
         }

         if (grantType !== 'client_credentials' && grantType !== 'password' && !$("#redirectUri").val()) {
             $("#redirectUriError").text("Redirect URI is required for this flow").show();
             isValid = false;
         }

         if (!isValid) return;

         // Build scopes
         let scopes = [];
         $("input[type='checkbox']:checked").each(function() {
             if (this.id.startsWith("scope_")) {
                 scopes.push(this.id.replace("scope_", ""));
             }
         });

         const customScope = $("#customScope").val().trim();
         if (customScope) {
             scopes.push(customScope);
         }

         if (scopes.length === 0 && grantType !== 'client_credentials') {
             scopes = ["openid"]; // Default scope
         }

         const scopeString = scopes.join(" ");

         // Build authorization URL
         let authUrl = "https://login.microsoftonline.com/"+$("#oauthTenantId").val()+"/oauth2/v2.0/authorize?";
         const params = new URLSearchParams();

         params.append("client_id", clientId);
         params.append("response_type", "code");
         params.append("redirect_uri", $("#redirectUri").val());
         params.append("response_mode", "query");
         params.append("scope", scopeString);
         params.append("state", "12345");
         params.append("code_challenge", codeChallenge);
         params.append("code_challenge_method", "S256");

         authUrl += params.toString();

         // Show authorization URL
         $("#authUrl").val(authUrl);
         return authUrl;
     }

    function startAuthFlow() {
        // Validate inputs first
      //  if (!validateOAuthStep1()) {
      //      return;
      //  }

        // Show loading state
        $("#authFlowContainer").show();
        $("#authUrl").closest('.mb-3').hide();
        // Store current form state in sessionStorage
        const formState = {
            tenantId: $("#oauthTenantId").val(),
            clientId: $("#clientId").val(),
            redirectUri: $("#redirectUri").val(),
            scopes: getSelectedScopes()
        };
        sessionStorage.setItem('oauthFormState', JSON.stringify(formState));

        // Redirect to Microsoft login
        window.location.href = $("#authUrl").val();
    }

    function getSelectedScopes() {
        let scopes = [];
        $("input[type='checkbox']:checked").each(function() {
            if (this.id.startsWith("scope_")) {
                scopes.push(this.id.replace("scope_", ""));
            }
        });
        const customScope = $("#customScope").val().trim();
        if (customScope) scopes.push(customScope);
        return scopes;
    }

    // Helper function to set selected scopes
    function setSelectedScopes(scopes) {
        // Reset all checkboxes
        $("input[type='checkbox'][id^='scope_']").prop("checked", false);

        // Set the checked ones
        scopes.forEach(scope => {
            const checkbox = $(`#scope_${scope}`);
            if (checkbox.length) {
                checkbox.prop("checked", true);
            }
        });

        // Handle custom scope
        const customScopes = scopes.filter(s => !$(`#scope_${s}`).length);
        if (customScopes.length) {
            $("#customScope").val(customScopes.join(" "));
        }
    }

    function getTokens() {
        const authCode = $("#authCode").val().trim();
        if (!authCode) {
            $("#authCodeError").text("Authorization code is required").show();
            return;
        }

        const tenantId = $("#oauthTenantId").val();
        const clientId = $("#clientId").val();
        const redirectUri = $("#redirectUri").val();
        const codeVerifier = sessionStorage.getItem('code_verifier');

        // Clear previous errors
        $("#authCodeError").hide().text("");

        // Build token request
        const tokenUrl =  "https://login.microsoftonline.com/"+$("#oauthTenantId").val()+"/oauth2/v2.0/token";

        const formData = new URLSearchParams();
        formData.append("client_id", clientId);
        formData.append("scope", "openid profile email offline_access");
        formData.append("code", authCode);
        formData.append("redirect_uri", redirectUri);
        formData.append("grant_type", "authorization_code");
        formData.append("code_verifier", codeVerifier);

        // Show loading state
        $("#accessToken").text("Requesting tokens...");
        $("#refreshToken").text("");
        $("#idToken").text("");
        $("#tokenDetails").text("");
        // Make AJAX call to token endpoint
        $.ajax({
            type: "POST",
            url: tokenUrl,
            data: formData.toString(),
            contentType: "application/x-www-form-urlencoded",
            success: function(tokenResponse) {
                // Send the entire token response to the backend
                callBackendAPI(tokenResponse);
            },
            error: function(xhr) {
                let errorMessage = "Error getting tokens";
                try {
                    const errorResponse = JSON.parse(xhr.responseText);
                    errorMessage += `: ${errorResponse.error} - ${errorResponse.error_description}`;
                } catch (e) {
                    errorMessage += `: ${xhr.statusText}`;
                }
                $("#accessToken").text(errorMessage);
                console.error("Token request failed:", xhr);
            }
        });
    }

    function refreshTokens() {
        const tenantId = $("#oauthTenantId").val();
        const clientId = $("#clientId").val();
        const clientSecret = $("#clientSecret").val();
        const refreshToken = $("#refreshToken").text();

        if (!refreshToken) {
            alert("No refresh token available");
            return;
        }

        // Build refresh request
        const tokenUrl = `https://login.microsoftonline.com/${tenantId}/oauth2/v2.0/token`;

        const formData = new URLSearchParams();
        formData.append("client_id", clientId);
        formData.append("scope", "openid profile email offline_access");
        formData.append("refresh_token", refreshToken);
        formData.append("grant_type", "refresh_token");

        if (clientSecret) {
            formData.append("client_secret", clientSecret);
        }

        // Simulated refresh response
        const simulatedResponse = {
            access_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1uQ19WWmNBVGZNNXBP...NEW",
            refresh_token: "OAQABAAAAAABHh4kmS_aKT5Ksj3R4...NEW",
            id_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ik1uQ19WWmNBVGZNNXBP...NEW",
            expires_in: 3599,
            token_type: "Bearer"
        };

        // Update displayed tokens
        $("#accessToken").text(simulatedResponse.access_token);
        $("#refreshToken").text(simulatedResponse.refresh_token);
        $("#idToken").text(simulatedResponse.id_token);
        $("#tokenDetails").text(JSON.stringify(simulatedResponse, null, 2));

        alert("Tokens refreshed successfully");
    }

    function renderTable(attributes,tokeTable) {
        let rows = "";
        attributes.forEach(item => {
             rows += "<tr><td>"+item.name+"</td><td style='white-space'>"+item.value+"</td></tr>";
        });
        $(tokeTable).html(rows || '<tr><td colspan="2">No data</td></tr>');
    }

    function generateRandomString(length) {
        const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
        let text = '';
        for (let i = 0; i < length; i++) {
            text += possible.charAt(Math.floor(Math.random() * possible.length));
        }
        return text;
    }

    async function generateCodeChallenge(codeVerifier) {
        // Convert the code verifier to an ArrayBuffer
        const encoder = new TextEncoder();
        const data = encoder.encode(codeVerifier);

        // Generate the SHA-256 hash
        const hashBuffer = await window.crypto.subtle.digest('SHA-256', data);

        // Convert the hash ArrayBuffer to a Base64 URL-safe string
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const base64String = btoa(String.fromCharCode.apply(null, hashArray));
        return base64String
            .replace(/=/g, '')
            .replace(/\+/g, '-')
            .replace(/\//g, '_');
    }

    function showOAuthStep(step) {
        // Hide all step contents
        $(".step-content").removeClass("active");

        // Show the selected step content
        $("#oauthStep" + step + "-content").addClass("active");

        // Update stepper tabs
        $(".step").removeClass("active");
        $("#oauthStep" + step + "-tab").addClass("active");
    }

    // OAuth Step 1 Validation
    function validateOAuthStep1() {
        // Clear previous errors
        $(".alert-danger.custom-alert").hide().text("");

        let isValid = true;

        // Validate required fields
        if (!$("#oauthTenantId").val() || $("#oauthTenantId").val() === '-1') {
            $("#oauthTenantIdError").text("Tenant ID is required").show();
            isValid = false;
        }

        if (!$("#clientId").val()) {
            $("#clientIdError").text("Client ID is required").show();
            isValid = false;
        }

        const grantType = $("#grantType").val();
        if (grantType !== 'client_credentials' && grantType !== 'password' && !$("#redirectUri").val()) {
            $("#redirectUriError").text("Redirect URI is required").show();
            isValid = false;
        }

        if (isValid) {
            generateAuthUrl().then(() => {
                showOAuthStep(2);
            });
        }
    }

    // OAuth Step 2 Validation
    function validateOAuthStep2() {
        const authCode = $("#authCode").val().trim();
        if (!authCode) {
            $("#authCodeError").text("Authorization code is required").show();
            return;
        }
        // Clear any previous error
        $("#authCodeError").hide().text("");

        // Show loading state
        $("#accessToken").text("Requesting tokens...");
        $("#refreshToken").text("");
        $("#idToken").text("");
        $("#tokenDetails").text("");

        // Proceed to get tokens
        getTokens();

        // Show token step (will be shown again after tokens are received)
        showOAuthStep(3);
    }

 // NEW: Function to send tokens to backend and handle response
    function callBackendAPI(tokenResponse) {
        // Show loading state
        $("#apiResponse").text("Sending tokens to backend...");
        $("#apiResponseContainer").show();

        // Replace with your actual backend endpoint
        const backendApiUrl = "http://localhost:8080/api/decode-oauth-token";
        $.ajax({
            type: "POST",  // Typically POST for token submission
            url: backendApiUrl,
            contentType: "application/json",
            data: JSON.stringify(tokenResponse),
            success: function(backendResponse) {
                 // Display tokens only after backend confirms
                 console.log('backendResponse'+JSON.stringify(backendResponse));
                 $("#rawIdTokenResponseId").text(backendResponse.decodedIdToken)
                 $("#rawAccessTokenResponseId").text(backendResponse.decodedAccessToken)
                 $("#rawTokenOAuthResponseId").text(JSON.stringify(tokenResponse))

                renderTable(backendResponse.idTokenClaimList,'#idTokenTable tbody')
                renderTable(backendResponse.accessTokenClaimList,'#accessTokenTable tbody')
                // Only now show Step 3 (after backend success)
                 showOAuthStep(3);
                 $("#oauthContentId").show();
                 $("#loader-content-oauth-2").hide();
                // Clear URL parameters
                if (window.history.replaceState) {
                    const cleanUrl = window.location.origin + window.location.pathname;
                    window.history.replaceState({}, document.title, cleanUrl);
                }
            },
            error: function(xhr) {
                $("#accessToken").text("Backend validation failed");
                let errorMessage = "Backend Error";
                try {
                    errorMessage += `: ${JSON.parse(xhr.responseText).error || xhr.statusText}`;
                } catch (e) {
                    errorMessage += `: ${xhr.statusText}`;
                }
                $("#apiResponse").text(errorMessage);
                console.error("Backend API call failed:", xhr);
            }
        });
    }

    // Reset OAuth Form
    function resetOAuthForm() {
        // Reset form fields
        $("#oauthTenantId").val("-1");
        $("#clientId").val("");
        $("#clientSecret").val("");
        $("#redirectUri").val("http://localhost:4200/");
        $("#grantType").val("authorization_code");
        $("input[type='checkbox']").prop("checked", false);
        $("#scope_openid, #scope_profile, #scope_email").prop("checked", true);
        $("#customScope").val("");
        $("#authUrl").val("");
        $("#authCode").val("");
        $("#redirectUri").val(window.location.origin + window.location.pathname);
        // Clear tokens
        $("#accessToken, #refreshToken, #idToken").text("");
        $("#tokenDetails, #apiResponse").text("");

        // Hide token refresh button
        $("#refreshTokenBtn").hide();

        // Reset to step 1
        showOAuthStep(1);

        // Clear errors
        $(".alert-danger.custom-alert").hide().text("");
        if (window.history.replaceState) {
                const cleanUrl = window.location.origin + window.location.pathname;
                window.history.replaceState({}, document.title, cleanUrl);
        }
    }

    function copyToClipboard(elementId) {
        const element = document.getElementById(elementId);
        const text = element.tagName === 'INPUT' || element.tagName === 'TEXTAREA'
            ? element.value
            : element.innerText;

        navigator.clipboard.writeText(text).then(function() {
            alert("Copied to clipboard!");
        }, function() {
            alert("Failed to copy text");
        });
    }

    function testApiWithToken() {
            const accessToken = $("#accessToken").text();
            if (!accessToken) {
                alert("No access token available");
                return;
            }

            // For demo, we'll simulate an API call to Microsoft Graph
            // In a real app, you would make an AJAX call to your backend
            // which would then call the API with the token

            // Simulated API response
            const simulatedResponse = {
                "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
                "businessPhones": [],
                "displayName": "Adele Vance",
                "givenName": "Adele",
                "jobTitle": "Retail Manager",
                "mail": "AdeleV@contoso.com",
                "mobilePhone": null,
                "officeLocation": "18/2111",
                "preferredLanguage": "en-US",
                "surname": "Vance",
                "userPrincipalName": "AdeleV@contoso.com",
                "id": "87d349ed-44d7-43e1-9a83-5f2406dee5bd"
            };

            // Display API response
            $("#apiEndpoint").val("https://graph.microsoft.com/v1.0/me");
            $("#apiResponse").text(JSON.stringify(simulatedResponse, null, 2));

            // Show API test step
            $("#oauthStep4").show();
        }

        function callApi() {
            const apiEndpoint = $("#apiEndpoint").val();
            if (!apiEndpoint) {
                alert("Please enter an API endpoint");
                return;
            }

            // In a real app, you would make the API call here
            // For demo, we'll just show the same simulated response
            testApiWithToken();
        }

</script>

</body>
</html>

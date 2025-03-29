<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application 2</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* New Theme */
        body {
            background: linear-gradient(white, #e3f2fd, white);
            font-family: 'Poppins', sans-serif;
            padding-bottom: 60px;
        }
        .container {
            max-width: 1200px !important;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
        }
        h2 {
            font-weight: bold;
            color: black;
            font-size: 22px;
        }

        /* Wider Rectangular Stepper */
        .stepper {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        .step {
            flex: 1;
            padding: 12px;
            text-align: center;
            font-weight: bold;
            background: #d6d6d6;
            color: black;
            transition: all 0.3s ease-in-out;
            border-radius: 5px;
            margin-right: 8px;
            font-size: 14px;
        }
        .step.active {
            background: black;
            color: white;
        }
        .step:last-child {
            margin-right: 0;
        }

        /* Step Content */
        .step-content {
            display: none;
            opacity: 0;
            transition: opacity 0.4s ease-in-out;
        }
        .step-content.active {
            display: block;
            opacity: 1;
        }

        /* Inputs & Buttons */
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #ced4da;
            font-size: 15px;
        }
        .btn-primary {
            background: black;
            border: none;
            font-weight: bold;
            padding: 12px;
            border-radius: 6px;
            width: 100%;
            font-size: 15px;
        }
        .btn-primary:hover {
            background: black;
        }
        .btn-secondary {
            background: #d6d6d6;
            border: none;
            font-weight: bold;
            padding: 12px;
            border-radius: 6px;
            width: 100%;
            font-size: 15px;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }

       .pretty-xml {
           background: #f4f4f4;
           padding: 10px;
           border-radius: 5px;
           white-space: pre-wrap; /* Ensures correct wrapping */
           font-family: "Courier New", monospace;
           font-size: 14px;
           color: #333;
           border: 2px solid grey;
           line-height: 1.5;
       }.

       .footer-container {
                   max-width: 850px;
                   background: white;
                   padding: 40px;
                   border-radius: 10px;
                   box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
        }

        .alert-danger.custom-alert {
            padding: 8px 8px; /* Reduce padding to minimize height */
            font-size: 12px; /* Reduce font size */
            margin-bottom: 0; /* Remove default margin-bottom */
            line-height: 1.5; /* Adjust line height for better readability */
            border-radius: 4px; /* Optional: Adjust border radius */
        }

        .tab-container {
             display: flex;
             flex-direction: column;
             gap: 20px;
             padding: 20px;
         }
         .tab {
             overflow: hidden;
             border: 1px solid #ccc;
             background-color: #f1f1f1;
         }
         .tab button {
             background-color: inherit;
             float: left;
             border: none;
             outline: none;
             cursor: pointer;
             padding: 10px 20px;
             transition: 0.3s;
             background-color: #D3D3D3;
         }
         .tab button:hover {
             background-color: #ddd;
         }
         .tab button.active {
             background-color: black;
             color:white;
         }
         .tabcontent {
             display: none;
             padding: 10px;
             border: 1px solid #ccc;
             border-top: none;
         }

         #tokenDisplay {
             margin-top: 20px;
             width: 100%;
         }

         .token-container {
             margin-bottom: 20px;
             background: #f8f9fa;
             padding: 15px;
             border-radius: 5px;
             border: 1px solid #dee2e6;
         }

         .token-value {
             word-wrap: break-word;
             white-space: pre-wrap;
             font-family: monospace;
             background: white;
             padding: 10px;
             border-radius: 3px;
             border: 1px solid #ced4da;
             overflow-y: auto;
         }

         .token-container h4 {
             margin-top: 0;
             color: #495057;
             font-size: 1.1rem;
         }

         .wrapText {
             white-space: pre-wrap;
             color: inherit !important;
         }

         th, td {
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 300px; /* Adjust as needed */
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">SAML and OAuth Testing</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" id="samlTestTab" href="#samlTest">Test SAML</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="oauthTestTab" href="#oauthTest">Test OAuth</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="documentationTab" href="#documentation">Documentation</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<br>
<div class="container mt-5">
    <div id="samlTest" class="tab-content">
    </div>

    <!-- OAuth Test Content -->
    <div id="oauthTest" class="tab-content" style="display: none;">
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
            <!--    <h5>Step 3: Tokens</h5>
             <div class="mb-3">
                  <label class="form-label">Token Details:</label>
                  <pre id="tokenDetails" class="token-value"></pre>
              </div> -->

            <h5>Step 3: View OAuth Response</h5>
            <div class="tab">
                <button class="tablinks" onclick="openTab(event, 'idTokenResponse')">ID Token Claims</button>
                <button class="tablinks" onclick="openTab(event, 'accessTokenResponse')">Access Token Claims</button>
                <button class="tablinks" onclick="openTab(event, 'rawOAuthResponse')">Decoded ID Token</button>
                <button class="tablinks" onclick="openTab(event, 'accessTokenOAuthResponse')">Decoded Access Token</button>
                <button class="tablinks" onclick="openTab(event, 'rawTokenOAuthResponse')">Raw OAuth Response</button>
            </div>

            <!-- Tab Content -->
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
<footer class="bg-dark text-white text-center py-1 fixed-bottom" style="font-size:12px">
    <div class="sb-0">&copy; 2025 SAML and OAuth Testing. All rights reserved.</div>
    <div class="mb-0">Contact: <a href="mailto:aacm-support@ubs.com" class="text-white">aacm-support@ubs.com</a></div>
</footer>
<script>

    $(document).ready(function() {
        // Clear validation messages when user interacts with the fields
        $("#tenantId").on("input change", function() {
            $("#tenantIdError").hide().text("");
        });

        $("#entityId").on("input", function() {
            $("#entityIdError").hide().text("");
        });

        $("#acsUrl").on("input", function() {
            $("#acsUrlError").hide().text("");
        });

        $(".nav-link").on("click", function(e) {
            e.preventDefault(); // Prevent default anchor behavior
            $(".nav-link").removeClass("active");
            $(this).addClass("active");
            $(".tab-content").hide();
            const target = $(this).attr("href");
            $(target).show();
        });
        $("#oauthTestTab").click();


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

               // Switch to OAuth tab
               $("#oauthTestTab").click();
               showOAuthStep(2);
         }

         if (error) {
               // Handle OAuth error
               console.error("OAuth Error:", error, urlParams.get('error_description'));
               $("#oauthTestTab").click();
               $("#authCodeError").text(`${error}: ${urlParams.get('error_description')}`).show();
          }
          else if (authCode && state === '12345') {
               // Switch to OAuth tab and populate the auth code
               $("#oauthTestTab").click();
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

    $("#isVerifyCertificateRequired").change(function() {
        if ($(this).val() === "true") {
            $("#certificateUploadSection").show();
        } else {
            $("#certificateUploadSection").hide();
        }
    }).trigger("change");

    function validateStep1() {
        // Clear previous error messages
        $("#tenantIdError").hide().text("");
        $("#entityIdError").hide().text("");
        $("#acsUrlError").hide().text("");

        let isValid = true;

        // Validate Tenant ID
        const tenantId = $("#tenantId").val();
        if (!tenantId || tenantId==='-1') {
            $("#tenantIdError").text("Tenant ID is required.").show();
            isValid = false;
        }

        // Validate Entity ID
        const entityId = $("#entityId").val();
        if (!entityId) {
            $("#entityIdError").text("Entity ID is required.").show();
            isValid = false;
        }

        // Validate ACS URL
        const acsUrl = $("#acsUrl").val();
        if (!acsUrl) {
            $("#acsUrlError").text("ACS URL is required.").show();
            isValid = false;
        }

        if ($("#isVerifyCertificateRequired").val() === "true") {
                const jksFile = $("#jksFile").val();
                if (!jksFile) {
                    $("#jksFileError").text("JKS file is required when certificate verification is enabled.").show();
                    isValid = false;
                }

                const jksPassword = $("#jksPassword").val();
                if (!jksPassword) {
                    $("#jksPasswordError").text("Keystore password is required.").show();
                    isValid = false;
                }
         }

        // If all inputs are valid, proceed to Step 2
        if (isValid) {
            submitStep1();
        }
    }

    function submitStep1() {
        let formData = new FormData();
        formData.append("tenantId", $("#tenantId").val());
        formData.append("entityId", $("#entityId").val());
        formData.append("acsUrl", $("#acsUrl").val());
        formData.append("isVerifyCertificateRequired", $("#isVerifyCertificateRequired").val());

        if ($("#isVerifyCertificateRequired").val() === "true") {
            formData.append("jksFile", $("#jksFile")[0].files[0]);
            formData.append("jksPassword", $("#jksPassword").val());
            formData.append("jksAlias", $("#jksAlias").val());
        }

        // Simulated API response (Replace with actual API call)
        $.ajax({
            type: "POST",
            url: "/api/generate-saml-request",
            data: formData,
            contentType: false,
            processData: false,
            success: function(response) {
                $("#encodedSamlRequest").html('<pre class="pretty-xml"><code class="language-xml">' + response.encodedSamlRequest + '</code></pre>');
                var decodedString = atob(response.encodedSamlRequest);
                $("#plainSamlRequest").html('<pre class="pretty-xml"><code class="language-xml">' + prettyPrintXml(decodedString) + '</code></pre>');
                $("#SAMLRequest1").val(response.encodedSamlRequest);
                showStep(2);
            },
            error: function(xhr) {
                alert("Error: " + xhr.responseText);
            }
        });
     }

     function submitStep2() {
           let azureSamlUrl = "https://login.microsoftonline.com/"+$("#tenantId").val()+"/saml2"; // Update with correct tenant ID
               // Create a hidden form dynamically
               let form = $('<form>', {
                   action: azureSamlUrl,
                   method: 'POST'
               }).append($('<input>', {
                   type: 'hidden',
                   name: 'SAMLRequest',
                   value: $("#SAMLRequest1").val()
               }));
               // Append form to body and submit
               $('body').append(form);
               form.submit();
     }

    function escapeHtml(unsafe) {
        return unsafe.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

      function prettyPrintXml(xml) {
          let formatted = "";
          let reg = /(>)(<)(\/*)/g;
          xml = xml.replace(reg, "$1\r\n$2$3"); // Add line breaks
          let pad = 0;
          xml.split("\r\n").forEach(function(node) {
              let indent = 0;
              if (node.match(/.+<\/\w[^>]*>$/)) {
                  indent = 0; // No change in indent
              } else if (node.match(/^<\/\w/)) {
                  pad -= 1; // Decrease indent
              } else if (node.match(/^<\w[^>]*[^/]>.*$/)) {
                  indent = 1; // Increase indent
              } else {
                  indent = 0;
              }

              let padding = new Array(pad + 1).join("  ");
              formatted += padding + node + "\r\n";
              pad += indent;
          });

          return formatted.replace(/</g, "&lt;").replace(/>/g, "&gt;"); // Escape HTML
     }

    function prevStep() {
        showStep(1);
    }

    function showStep(step) {
        $(".step-content").removeClass("active");
        $("#step" + step + "-content").addClass("active");

        $(".step").removeClass("active");
        $("#step" + step + "-tab").addClass("active");
    }

    function resetForm() {
        // Reset input fields
        $("#tenantId").val("-1"); // Reset to default option
        $("#entityId").val(""); // Clear Entity ID
        $("#acsUrl").val(""); // Clear ACS URL

        // Reset Step 2 and Step 3 content (if needed)
        $("#plainSamlRequest").html(""); // Clear plain SAML request
        $("#encodedSamlRequest").html(""); // Clear encoded SAML request
        $("#SAMLRequest1").val(""); // Clear hidden SAML request input
        $("#RelayState").val("https://sp.example.com/acs"); // Reset RelayState (if needed)

        $("#jksFile").val("");
        $("#jksPassword").val("");
        $("#jksAlias").val("");
        $("#jksFileError").hide().text("");
        $("#jksPasswordError").hide().text("");

        // Reset stepper to Step 1
        showStep(1);
    }

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
                 $("#rawIdTokenResponseId").text(formatJsonWithColors(backendResponse.decodedIdToken))
                 $("#rawAccessTokenResponseId").text(backendResponse.decodedAccessToken)
                 $("#rawTokenOAuthResponseId").text(JSON.stringify(tokenResponse))

                renderTable(backendResponse.idTokenClaimList,'#idTokenTable tbody')
                renderTable(backendResponse.accessTokenClaimList,'#accessTokenTable tbody')
                // Only now show Step 3 (after backend success)
                showOAuthStep(3);

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

    function renderTable(attributes,tokeTable) {
        let rows = "";
        attributes.forEach(item => {
             rows += "<tr><td>"+item.name+"</td><td style='white-space'>"+item.value+"</td></tr>";
        });
        $(tokeTable).html(rows || '<tr><td colspan="2">No data</td></tr>');
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

    function formatJsonWithColors(jsonData) {
        if (typeof jsonData === 'string') {
            try {
                jsonData = JSON.parse(jsonData);
            } catch (e) {
                return `<span style="color: red">Invalid JSON: ${e.message}</span>`;
            }
        }

        const jsonString = JSON.stringify(jsonData, null, 2)
            .replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g,
            function(match) {
                let style = 'color: ';
                if (/^"/.test(match)) {
                    if (/:$/.test(match)) {
                        style += '#FF79C6'; // Key color (pink)
                    } else {
                        style += '#F1FA8C'; // String value color (yellow)
                    }
                } else if (/true|false/.test(match)) {
                    style += '#BD93F9'; // Boolean color (purple)
                } else if (/null/.test(match)) {
                    style += '#FF5555'; // Null color (red)
                } else {
                    style += '#8BE9FD'; // Number color (blue)
                }
                return `<span style="${style}">${match}</span>`;
            });

        return `<pre style="
            background: #282A36;
            color: #F8F8F2;
            padding: 15px;
            border-radius: 5px;
            overflow: auto;
            font-family: 'Courier New', monospace;
            tab-size: 2;
        ">${jsonString}</pre>`;
    }
</script>

</body>
</html>

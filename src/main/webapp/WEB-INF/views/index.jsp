<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application</title>
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
            background: #0056b3;
        }
        .btn-secondary {
            background: #6c757d;
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
    <h2 class="mb-4 text-center">Azure EntraID SAML Test Application</h2>
    <!-- Wider Stepper -->
    <div class="stepper">
        <div class="step active" id="step1-tab">Step 1: Saml Metadata</div>
        <div class="step" id="step2-tab">Step 2: Saml Request</div>
        <div class="step" id="step3-tab">Step 3: Saml Response</div>
    </div>
    <!-- Step 1: Collect Inputs -->
    <div id="step1-content" class="step-content active">
        <h5>Step 1: Enter saml metadata</h5>
        <br>
        <label for="tenantId">Tenant ID:</label>
        <select id="tenantId" class="form-select">
            <option value="-1">Select Azure Tenant</option>
            <option value="dba21c9c-dbbc-4b6a-9473-8e886854204f">My Tenant - dba21c9c-dbbc-4b6a-9473-8e886854204f
            </option>
        </select>
        <div id="tenantIdError" class="alert alert-danger custom-alert mt-1"
             style="display: none; font:size= 12px"></div>
        <label for="entityId" class="mt-3">Entity ID:</label>
        <input type="text" id="entityId" class="form-control" placeholder="Enter Entity ID">
        <div id="entityIdError" class="alert alert-danger custom-alert mt-1"
             style="display: none; font:size= 12px"></div>
        <label for="acsUrl" class="mt-3">ACS URL:</label>
        <input type="text" id="acsUrl" class="form-control" placeholder="Enter ACS URL">
        <div id="acsUrlError" class="alert alert-danger custom-alert mt-1" style="display: none; font:size= 12px"></div>
        <br><br>
        <div class="d-flex gap-3 mt-3">
            <button class="btn btn-secondary flex-grow-1" onclick="resetForm()">Reset</button>
            <button class="btn btn-primary flex-grow-1" onclick="validateStep1()">Next</button>
        </div>
    </div>


    <div id="step2-content" class="step-content">
        <h5>Step 2: View and Send Saml Request</h5>
        <br>
        <div>Saml Request ( Plain ) :</div>
        <div id="plainSamlRequest" class="alert"></div>
        <div>Saml Request ( Encoded )</div>
        <div id="encodedSamlRequest" class="alert"></div>
        <input type="hidden" id="SAMLRequest1" name="SAMLRequest" value="test"/>
        <input type="hidden" id="RelayState" name="RelayState" value="https://sp.example.com/acs"/>
        <div class="d-flex gap-3 mt-3">
            <button class="btn btn-secondary flex-grow-1" onclick="prevStep()">Previous</button>
            <button class="btn btn-primary flex-grow-1" onclick="submitStep2()">Send Saml Request</button>
        </div>
    </div>
    <div id="step3-content" class="step-content">
        <h4 class="text-primary">Step 3: Saml Respone</h4>
        <button class="btn btn-secondary mt-3" onclick="prevStep()">Previous</button>
    </div>
 </div>

    <!-- OAuth Test Content -->
    <div id="oauthTest" class="tab-content" style="display: none;">
        <h2 class="mb-4 text-center">Azure EntraID OAuth Test Application</h2>
        <p>This section is for testing OAuth functionality.</p>
        <p>You can add forms, buttons, and other elements here to test OAuth flows.</p>
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
        $("#samlTestTab").click();
    });

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

        // If all inputs are valid, proceed to Step 2
        if (isValid) {
            submitStep1();
        }
    }

    function submitStep1() {
        let data = {
            tenantId: $("#tenantId").val(),
            entityId: $("#entityId").val(),
            acsUrl: $("#acsUrl").val()
        };

        // Simulated API response (Replace with actual API call)
        $.ajax({
            type: "POST",
            url: "/api/generate-saml-request",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function(response) {
                $("#encodedSamlRequest").html('<pre class="pretty-xml"><code class="language-xml">' + response.encodedSamlRequest+ '</code></pre>');
                var decodedString = atob(response.encodedSamlRequest);
                $("#plainSamlRequest").html('<pre class="pretty-xml"><code class="language-xml">' + prettyPrintXml(decodedString)+ '</code></pre>');
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

        // Reset stepper to Step 1
        showStep(1);
    }
</script>

</body>
</html>

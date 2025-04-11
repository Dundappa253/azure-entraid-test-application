<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application 2</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      <link href="${pageContext.request.contextPath}/static/css/common.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<br><br><br>
<%@ include file="header.jsp" %>
<div class="container">
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
        <div id="saml-request-form">
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
            <label for="isVerifyCertificateRequired" class="mt-3">Is verify Certificate Enabled:</label>
            <select id="isVerifyCertificateRequired" class="form-select">
                <option value="true">Yes</option>
                <option value="false">No</option>
            </select>
        </div>
        <jsp:include page="page-loader.jsp">
            <jsp:param name="loader-id" value="saml-1" />
            <jsp:param name="loader-message" value="SAML Request is being generating" />
        </jsp:include>
        <div class="d-flex gap-3 mt-3">
            <button class="btn btn-secondary flex-grow-1" onclick="resetForm()">Reset</button>
            <button class="btn btn-primary flex-grow-1" onclick="validateStep1()">Next</button>
        </div>
    </div>

    <div id="step2-content" class="step-content">
        <h5>Step 2: View and Send Saml Request</h5>
        <br>
        <div id="view-saml-request-content">
            <div class="tab">
                <button class="tablinks" onclick="openTab(event, 'viewPlainRequest')">Plain SAML Request</button>
                <button class="tablinks" onclick="openTab(event, 'viewEncodedRequest')">Encoded SAML Request</button>
            </div>

            <div id="viewPlainRequest" class="tabcontent">
                <div id="plainSamlRequest" class="alert"></div>
            </div>
             <div id="viewEncodedRequest" class="tabcontent">
                <div id="encodedSamlRequest" class="alert"></div>
             </div>
            <input type="hidden" id="SAMLRequest1" name="SAMLRequest" value="test"/>
            <input type="hidden" id="RelayState" name="RelayState" value="https://sp.example.com/acs"/>
        </div>
       <jsp:include page="page-loader.jsp">
            <jsp:param name="loader-id" value="saml-2" />
            <jsp:param name="loader-message" value="Your saml request being sending to idp server for authentication" />
        </jsp:include>
        <div class="d-flex gap-3 mt-3">
            <button class="btn btn-secondary flex-grow-1" onclick="prevStep()">Previous</button>
            <button class="btn btn-primary flex-grow-1" onclick="submitStep2()">Send Saml Request</button>
        </div>
    </div>
    <div id="step3-content" class="step-content">
        <h4 class="text-primary">Step 3: Saml Respone</h4>
        <button class="btn btn-secondary mt-3" onclick="prevStep()">Previous</button>
    </div>

 <body>
 <script>

     $(document).ready(function() {
         // Clear validation messages when user interacts with the fieldssss
         $("#tenantId").on("input change", function() {
             $("#tenantIdError").hide().text("");
         });
         $("#entityId").on("input", function() {
             $("#entityIdError").hide().text("");
         });
         $("#acsUrl").on("input", function() {
             $("#acsUrlError").hide().text("");
         });
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
         let formData = new FormData();
         formData.append("tenantId", $("#tenantId").val());
         formData.append("entityId", $("#entityId").val());
         formData.append("acsUrl", $("#acsUrl").val());
         formData.append("verifyCertificateRequired", $("#isVerifyCertificateRequired").val());
         // Simulated API response (Replace with actual API call)
         $("#saml-request-form").hide();
         $("#loader-content-saml-1").show();
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
                $("#view-saml-request-content").hide();
                $("#loader-content-saml-2").show();
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

     document.getElementsByClassName("tablinks")[0].click();

 </script>
</html>
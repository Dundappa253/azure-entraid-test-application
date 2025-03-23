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
       }

        .content-div {
                  background: #f4f4f4;
                  padding: 10px;
                  border-radius: 5px;
                  font-family: "Courier New", monospace;
                  font-size: 14px;
                  color: #333;
                  border: 2px solid grey;
        }


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
    .xml-display {
        background-color: #f4f4f4;
        padding: 10px;
        white-space: pre-wrap;
        font-family: monospace;
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
    </div>
</nav>
<br>


<div class="container mt-5">
    <div id="samlTestTab" class="tab-content">
    <h2 class="mb-4 text-center">Azure EntraID SAML Test Application</h2>

    <!-- Wider Stepper -->
    <div class="stepper">
        <div class="step" id="step1-tab">Step 1: Saml Metadata</div>
        <div class="step" id="step2-tab">Step 2: Saml Request</div>
        <div class="step active" id="step3-tab">Step 3: Saml Response</div>
    </div>

    <!-- Step 1: Collect Inputs -->
    <div id="step1-content" class="step-content">
        <h4 class="text-primary">Step 1: Enter Details</h4>
        <label for="tenantId">Tenant ID:</label>
        <select id="tenantId" class="form-select">
            <option value="dba21c9c-dbbc-4b6a-9473-8e886854204f">My Tenant - dba21c9c-dbbc-4b6a-9473-8e886854204f
            </option>
        </select>
        <label for="entityId" class="mt-3">Entity ID:</label>
        <input type="text" id="entityId" class="form-control" placeholder="Enter Entity ID">
        <label for="acsUrl" class="mt-3">ACS URL:</label>
        <input type="text" id="acsUrl" class="form-control" placeholder="Enter ACS URL">
        <button class="btn btn-primary mt-4">Next</button>
    </div>

    <!-- Step 2: Show API Response -->
    <div id="step2-content" class="step-content">
        <h5>Step 1: View Saml Response</h5>
        <div>Saml Request ( Plain ) :</div>
        <div id="plainSamlRequest" class="alert alert-info"></div>
        <div>Saml Request ( Encoded )</div>
        <div id="encodedSamlRequest" class="alert alert-info"></div>
        <input type="hidden" id="SAMLRequest1" name="SAMLRequest" value="test"/>
        <input type="hidden" id="RelayState" name="RelayState" value="https://sp.example.com/acs"/>
        <button class="btn btn-secondary mt-3" onclick="prevStep()">Previous</button>
        <button class="btn btn-primary mt-3">Send Saml Request</button>
    </div>
    <div id="step3-content" class="step-content active">
        <h5>Step 3: View Saml Response</h5>
        <div class="tab">
            <button class="tablinks" onclick="openTab(event, 'samlClaims')">Saml Claims</button>
            <button class="tablinks" onclick="openTab(event, 'rawXml')">Raw Saml Response</button>
        </div>

        <!-- Tab Content -->
        <div id="samlClaims" class="tabcontent">
            <table id="dataTable" class="table table-striped">
                <thead>
                <tr>
                    <th>Attribute Name</th>
                    <th>Attribute Value</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${samlClaims}">
                    <!-- Skip rows with null or empty values -->
                    <c:if test="${not empty item.name and not empty item.value}">
                        <tr>
                            <td>
                                <c:out value="${item.name}"/>
                            </td>
                            <td>
                                <c:out value="${item.value}"/>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <div id="rawXml" class="tabcontent">
            <div id="xmlDisplay" class="xml-display"></div>
        </div>
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

<script>
 $(document).ready(function() {
           $(".nav-link").on("click", function(e) {
             e.preventDefault(); // Prevent default anchor behavior
             $(".nav-link").removeClass("active");
             $(this).addClass("active");
             $(".tab-content").hide();
             const target = $(this).attr("href");
             $(target).show();
         });
         $("#samlTest").click();
     });


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
   function escapeHtml(unsafe) {
      return unsafe.replace(/</g, "&lt;").replace(/>/g, "&gt;");
   }

   $("#xmlDisplay").html('<pre class="pretty-xml"><code class="language-xml">' + prettyPrintXml('${samlResponse}')+ '</code></pre>');

   // Tab Functionality
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
</script>

</body>
</html>

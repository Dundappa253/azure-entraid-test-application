<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      <link href="${pageContext.request.contextPath}/static/css/common.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<%@ include file="header.jsp" %>
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
        <button class="btn btn-primary mt-3">Send Saml Request1</button>
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
                            <td style="white-space">
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
    <!-- Documentation Content -->
    <div id="documentation" class="tab-content" style="display: none;">
       <%@ include file="documentation.jsp" %>
    </div>
</div>
<%@ include file="footer.jsp" %>
<script>
 $(document).ready(function() {
     /*      $(".nav-link").on("click", function(e) {
             e.preventDefault(); // Prevent default anchor behavior
             $(".nav-link").removeClass("active");
             $(this).addClass("active");
             $(".tab-content").hide();
             const target = $(this).attr("href");
             $(target).show();
         });  */
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

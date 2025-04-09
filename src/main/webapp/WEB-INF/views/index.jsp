<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>AuthFlow | Enterprise Authentication Testing</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Original Header/Footer Styles */
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

        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 20px;
            color: white !important;
        }


        /* New Landing Page Styles */
        .hero {
            background: linear-gradient(135deg, #f5f7fa 0%, #e3f2fd 100%);
            padding: 100px 0;
            text-align: center;
        }
        .value-prop {
            padding: 80px 0;
        }

    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <br>

    <!-- New Landing Content -->
    <section class="hero">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">Enterprise Authentication Testing</h1>
            <p class="lead mb-5">Validate SAML, OAuth2, and OpenID Connect integrations with Microsoft EntraID</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="/saml-test" class="btn btn-outline-dark">Test SAML SSO Flow</a>
                <a href="/oauth-test" class="btn btn-outline-dark">Test OAuth SSO Flow</a>
            </div>
        </div>
    </section>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
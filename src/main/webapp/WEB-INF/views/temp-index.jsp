<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Azure EntraID SAML Test Application</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Enhanced Landing Page Theme */
        body {
            background: linear-gradient(white, #e3f2fd, white);
            font-family: 'Poppins', sans-serif;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 24px;
            color: black !important;
        }

        .nav-link {
            font-weight: 500;
            color: #333 !important;
            margin: 0 10px;
        }

        .nav-link:hover {
            color: #007bff !important;
        }

        .btn-primary {
            background: black;
            border: none;
            font-weight: 600;
            padding: 10px 25px;
            border-radius: 6px;
        }

        .btn-primary:hover {
            background: #333;
        }

        .btn-outline-primary {
            border-color: black;
            color: black;
            font-weight: 600;
            padding: 10px 25px;
            border-radius: 6px;
        }

        .btn-outline-primary:hover {
            background: black;
            color: white;
        }

        /* Hero Section */
        .hero {
            padding: 100px 0;
            text-align: center;
        }

        .hero h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            color: black;
        }

        .hero p {
            font-size: 20px;
            color: #666;
            max-width: 700px;
            margin: 0 auto 40px;
        }

        /* How It Works */
        .how-it-works {
            padding: 80px 0;
            background: #f8f9fa;
        }

        .step {
            display: flex;
            margin-bottom: 30px;
            align-items: flex-start;
        }

        .step-number {
            background: black;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            margin-right: 20px;
            flex-shrink: 0;
        }

        .step-content h3 {
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        /* Footer */
        footer {
            background: #343a40;
            color: white;
            padding: 30px 0;
            text-align: center;
        }

        .copyright {
            color: #adb5bd;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 36px;
            }

            .hero p {
                font-size: 18px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#">EntraTester</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">How It Works</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/saml-test">SAML Test</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/oauth-test">OAuth Test</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Test EntraID SSO with SAML & OAuth2</h1>
            <p>Validate your Microsoft EntraID integration with our specialized testing tools for SAML and OAuth2 protocols.</p>
            <div class="d-flex justify-content-center gap-3">
                <a href="/saml-test" class="btn btn-primary">Test SAML Now</a>
                <a href="/oauth-test" class="btn btn-outline-primary">Test OAuth2</a>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <div class="section-title">
                <h2>How It Works</h2>
                <p>Validate your EntraID integration in 4 simple steps</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="step">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <h3>Configure Your Settings</h3>
                            <p>Enter your EntraID Tenant ID, application details, and endpoint URLs.</p>
                        </div>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <h3>Generate Test Requests</h3>
                            <p>Our tool creates valid SAML AuthnRequests or OAuth2 authorization flows.</p>
                        </div>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <h3>Execute Tests</h3>
                            <p>Send requests to EntraID and capture the responses.</p>
                        </div>
                    </div>
                    <div class="step">
                        <div class="step-number">4</div>
                        <div class="step-content">
                            <h3>Analyze Results</h3>
                            <p>Inspect tokens, assertions, and debug issues with our visualization tools.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <p class="copyright">&copy; 2024 EntraTester. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
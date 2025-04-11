<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>AuthFlow | Enterprise Authentication Testing</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <link href="${pageContext.request.contextPath}/static/css/common.css" rel="stylesheet">
 <style>
    /* Card Styles for Landing */
  /* Auth Testing Cards */
  .auth-testing {
      background: linear-gradient(white, #f8f9fa, white);
  }

  .hover-lift {
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      border-radius: 12px;
  }

  .hover-lift:hover {
      transform: translateY(-5px);
      box-shadow: 0 2rem 3.5rem rgba(0, 0, 0, 0.1) !important;
  }

  .icon-xl {
      width: 64px;
      height: 64px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
  }

  .stretched-link::after {
      position: absolute;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
      z-index: 1;
      content: "";
  }

  .card-body {
      position: relative;
  }

  @media (max-width: 767.98px) {
      .auth-testing .display-4 {
          font-size: 2.5rem;
      }
  }
</style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <br>
  <!-- Card-based Authentication Testing Section -->
  <section class="auth-testing py-5">
      <div class="container">
          <div class="text-center mb-5">
              <h2 class="display-4 fw-bold">Enterprise Authentication Testing</h2>
              <p class="lead">Validate SAML, OAuth2, and OpenID Connect integrations with Microsoft EntraID</p>
          </div>

          <div class="row g-4 justify-content-center">
              <!-- SAML Test Card -->
              <div class="col-md-6 col-lg-5">
                  <div class="card h-100 border-0 shadow-sm hover-lift">
                      <div class="card-body p-4 text-center">
                          <div class="icon-xl bg-light rounded-circle mb-3">
                              <i class="bi bi-shield-lock fs-2 text-primary"></i>
                          </div>
                          <h3 class="h4 mb-3">SAML SSO Testing</h3>
                          <p class="mb-4">Validate your SAML 2.0 authentication flows and troubleshoot integration issues</p>
                          <a href="/saml-test" class="btn btn-dark stretched-link">Test SAML SSO</a>
                      </div>
                  </div>
              </div>

              <!-- OAuth Test Card -->
              <div class="col-md-6 col-lg-5">
                  <div class="card h-100 border-0 shadow-sm hover-lift">
                      <div class="card-body p-4 text-center">
                          <div class="icon-xl bg-light rounded-circle mb-3">
                              <i class="bi bi-key fs-2 text-primary"></i>
                          </div>
                          <h3 class="h4 mb-3">OAuth SSO Testing</h3>
                          <p class="mb-4">Verify OAuth2 and OpenID Connect implementations with Microsoft EntraID</p>
                          <a href="/oauth-test" class="btn btn-dark stretched-link">Test OAuth SSO</a>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </section>
    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Security Test Portal</title>
    <style>
        .menu-container {
            display: flex;
            flex-direction: column;
            width: 1500px;
            margin: 50px auto;
            font-family: Arial, sans-serif;
        }
        .menu-option {
            padding: 15px;
            margin: 5px 0;
            background: #4285f4;
            color: white;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .menu-option:hover {
            background: #3367d6;
        }
        .hidden {
            display: none;
        }
        iframe {
            width: 100%;
            height: 500px;
            border: 1px solid #ddd;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="menu-container">
        <h2>Select Test Type</h2>

        <div class="menu-option" onclick="loadTestPage('saml')">
            Test SAML Configuration
        </div>

        <div class="menu-option" onclick="loadTestPage('oauth')">
            Test OAuth Flow
        </div>

        <div class="menu-option" onclick="loadTestPage('openid')">
            Test OpenID Connect
        </div>

        <iframe id="testFrame" class="hidden"></iframe>
    </div>

    <script>
        function loadTestPage(testType) {
            const frame = document.getElementById('testFrame');
            frame.classList.remove('hidden');

            // Call ViewController with the selected test type
            frame.src = 'ViewController?testType=' + testType;
        }
    </script>
</body>
</html>
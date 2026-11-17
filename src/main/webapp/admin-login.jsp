<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petora | Admin Login</title>

    <link rel="stylesheet" href="CSS/auth.css">

    <style>
        .admin-badge {
            width: 66px;
            height: 66px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 22px;
            background: #e7f4e9;
            font-size: 30px;
        }

        .admin-note {
            margin: 20px 0;
            padding: 14px 16px;
            background: #f0f7f1;
            border: 1px solid #dcebdd;
            border-radius: 12px;
            color: #286443;
            font-size: 13px;
            line-height: 1.6;
        }

        .back-login {
            display: block;
            margin-top: 24px;
            text-align: center;
            color: #286443;
            text-decoration: none;
            font-weight: 600;
        }

        .back-login:hover {
            text-decoration: underline;
        }

        .admin-error {
            margin: 12px 0;
            padding: 12px;
            border-radius: 10px;
            color: #a52222;
            background: #fff0f0;
            font-size: 14px;
        }
    </style>
</head>

<body>
<div class="auth-page">

    <section class="auth-visual">
        <div class="brand">
            <div class="brand-icon">🐾</div>
            <div>
                <h2>Petora</h2>
                <p>Pet Management System</p>
            </div>
        </div>

        <div class="visual-content">
            <span class="small-heading">SECURE ADMINISTRATION</span>
            <h1>Care for Pets.<br><span>Manage with Trust.</span></h1>
            <p>
                Welcome to the Petora administration portal.
                Sign in securely to manage and oversee the platform.
            </p>
        </div>

        <div class="pet-image">
            <img src="images/auth-pets.jpg" alt="Pets">
        </div>

        <div class="visual-features">
            <div class="feature">
                <span class="feature-icon">✓</span>
                <span>Secure Access</span>
            </div>
            <div class="feature">
                <span class="feature-icon">🛡</span>
                <span>Admin Control</span>
            </div>
            <div class="feature">
                <span class="feature-icon">♥</span>
                <span>Better Pet Care</span>
            </div>
        </div>
    </section>

    <section class="auth-form-section">
        <div class="auth-card">

            <div class="admin-badge">🛡️</div>

            <div class="auth-heading">
                <h1>Admin <span>Login</span></h1>
                <p>Sign in to your administration account</p>
            </div>

            <div class="admin-note">
                <strong>Authorized administrators only.</strong><br>
                Use your assigned administrator credentials to continue.
            </div>

            <% if ("1".equals(request.getParameter("error"))) { %>
                <div class="admin-error">
                    Invalid administrator email or password.
                </div>
            <% } %>

            <form action="AdminLoginServlet" method="post">

                <div class="input-group">
                    <label for="email">Admin Email Address</label>
                    <div class="input-wrapper">
                        <span class="input-icon">✉</span>
                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="Enter admin email"
                               autocomplete="username"
                               required>
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter admin password"
                               autocomplete="current-password"
                               required>

                        <button type="button"
                                class="password-toggle"
                                onclick="togglePassword('password', this)">
                            👁
                        </button>
                    </div>
                </div>

                <button type="submit" class="auth-btn">
                    Login as Admin <span>→</span>
                </button>

            </form>

            <a href="login.jsp" class="back-login">
                ← Back to User Login
            </a>

        </div>
    </section>

</div>

<script src="js/auth.js"></script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Petora | Veterinarian Login</title>

    <!-- Existing CSS -->
    <link rel="stylesheet" href="CSS/auth.css">
</head>

<body>

<div class="auth-page doctor-auth-page">

    <!-- LEFT SIDE -->
    <section class="auth-visual doctor-visual">

        <div class="brand">
            <div class="brand-icon">🐾</div>
            <div>
                <h2>Petora</h2>
                <p>Pet Management System</p>
            </div>
        </div>

        <div class="visual-content">
            <span class="small-heading">
                CARE • TREAT • HEAL • TOGETHER
            </span>

            <h1>
                Make a<br>
                Healthier Tomorrow<br>
                for <span>Every Pet</span>
            </h1>

            <p>
                Join our veterinary network and be a part
                of a caring community dedicated to animal
                health and well-being.
            </p>
        </div>

        <div class="pet-image">
            <img src="images/auth-pets.jpg"
                 alt="Pets receiving loving care">
        </div>

        <div class="doctor-visual-footer">
            <span>🐾</span>
            <span>Compassionate Care. Healthier Pets.</span>
        </div>

    </section>


    <!-- RIGHT SIDE -->
    <section class="auth-form-section doctor-form-section">

        <div class="auth-card doctor-auth-card">

            <div class="auth-icon">🐾</div>

            <div class="auth-heading">
                <h1>
                    Veterinarian <span>Login</span>
                </h1>

                <p>Access your Petora doctor panel</p>
            </div>


            <!-- DOCTOR LOGIN FORM -->
            
<%
    String loginError = request.getParameter("error");
    String loginMessage = null;

    if ("empty".equals(loginError)) {
        loginMessage = "Please enter your email and password.";
    } else if ("invalid".equals(loginError)) {
        loginMessage = "Invalid email or password. Please try again.";
    } else if ("pending".equals(loginError)) {
        loginMessage = "Your application is still pending admin approval.";
    } else if ("rejected".equals(loginError)) {
        loginMessage = "Your application was not approved. Please contact the administrator.";
    }
%>

<% if (loginMessage != null) { %>
    <div class="login-error-message" role="alert">
        <%= loginMessage %>
    </div>
<% } %>
            
            <form id="doctorLoginForm"
                  action="${pageContext.request.contextPath}/DoctorLoginServlet"
                  method="post">

                <div class="input-group">
                    <label for="email">Email Address</label>

                    <div class="input-wrapper">
                        <span class="input-icon">✉</span>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="username"
                            required>
                    </div>
                </div>


                <div class="input-group">
                    <label for="password">Password</label>

                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            onclick="togglePassword('password', this)"
                            aria-label="Show or hide password">
                            👁
                        </button>
                    </div>
                </div>


                <div class="form-options">

                    <label class="remember">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>

                    <a href="doctor-forgot-password.jsp">
                        Forgot Password?
                    </a>

                </div>


                <button type="submit" class="auth-btn">
                    Login as Doctor
                    <span>→</span>
                </button>

            </form>


            <div class="divider">
                <span></span>
                <p>OR</p>
                <span></span>
            </div>


            <!-- DOCTOR REGISTRATION -->
            <div class="doctor-register-box">

                <div class="doctor-register-icon">🩺</div>

                <div class="doctor-register-text">
                    <h3>New in Petora?</h3>
                    <p>
                        Register now as a veterinarian
                        and start your journey with us.
                    </p>
                </div>

                <a href="doctor-register.jsp"
                   class="doctor-register-btn">
                    Register Now <span>→</span>
                </a>

            </div>

        </div>

    </section>

</div>

<!-- Existing JavaScript -->
<script src="js/auth.js"></script>

</body>
</html>

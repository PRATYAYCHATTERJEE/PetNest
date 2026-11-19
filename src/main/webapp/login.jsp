
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petora | Login</title>
    <link rel="stylesheet" href="CSS/auth.css">
</head>

<body>

<div class="auth-page">

    <!-- LEFT SIDE -->
    <section class="auth-visual">

        <!-- BRAND -->
        <div class="brand">
            <div class="brand-icon">🐾</div>
            <div class="brand-text">
                <h2>Petora</h2>
                <p>Pet Management System</p>
            </div>
        </div>

        <!-- PET ILLUSTRATION -->
        <div class="pet-image">
            <img src="images/auth-pets.jpg" alt="Petora pet care illustration">
        </div>

    </section>


    <!-- RIGHT SIDE -->
    <section class="auth-form-section">

        <div class="auth-card">

            <!-- FLOATING PAW ICON -->
            <div class="auth-icon">
                🐾
            </div>

            <!-- HEADING -->
            <div class="auth-heading">
                <h1>Welcome <span>Back</span></h1>
                <p>Login to continue your journey with Petora</p>
            </div>


            <!-- LOGIN FORM -->
            <form id="loginForm"
                  action="LoginServlet"
                  method="post">

                <!-- EMAIL -->
                <div class="input-group">
                    <label for="email">
                        <span class="field-icon">✉</span>
                        Email Address
                    </label>

                    <div class="input-wrapper">
                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>
                    </div>
                </div>


                <!-- PASSWORD -->
                <div class="input-group">
                    <label for="password">
                        <span class="field-icon">🔒</span>
                        Password
                    </label>

                    <div class="input-wrapper">
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
                            onclick="togglePassword('password', this)">
                            👁
                        </button>
                    </div>
                </div>


                <!-- REMEMBER AND FORGOT -->
                <div class="form-options">

                    <label class="remember">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>

                    <a href="forgot-password.jsp">
                        Forgot Password?
                    </a>

                </div>


                <!-- LOGIN BUTTON -->
                <button type="submit" class="auth-btn">
                    Login
                    <span>→</span>
                </button>

            </form>


            <!-- DIVIDER -->
            <div class="divider">
                <span></span>
                <p>🐾 Other Login Options 🐾</p>
                <span></span>
            </div>


            <!-- DOCTOR AND SELLER -->
            <div class="social-login">

                <a href="Doclogin.jsp"
                   class="social-btn">

                    <span class="role-icon">🩺</span>
                    <span>Login as Doctor</span>

                </a>

                <a href="seller-login.jsp"
                   class="social-btn">

                    <span class="role-icon">🤝</span>
                    <span>Login as Seller</span>

                </a>

            </div>


            <!-- REGISTER -->
            <div class="switch-auth">
                <p>
                    Don't have an account?
                    <a href="register.jsp">Register Now</a>
                </p>
            </div>

        </div>

    </section>

</div>

<script src="js/auth.js"></script>

</body>
</html>

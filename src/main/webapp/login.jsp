<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Petora | Login</title>

    <link rel="stylesheet" href="CSS/auth.css">

</head>


<body>

<div class="auth-page">


    <!-- ================= LEFT SIDE ================= -->

    <section class="auth-visual">

        <div class="brand">

            <div class="brand-icon">
                🐾
            </div>

            <div>
                <h2>Petora</h2>
                <p>Pet Management System</p>
            </div>

        </div>


        <div class="visual-content">

            <span class="small-heading">
                ADOPT • CARE • LOVE
            </span>

            <h1>
                A Better World
                <br>
                for <span>Every Pet</span>
            </h1>

            <p>
                Adopt, care, and give a second chance.
                Because every pet deserves a loving home.
            </p>

        </div>


        <div class="pet-image">

            <img src="images/auth-pets.jpg"
                 alt="Happy pets">

        </div>


        <div class="visual-features">

            <div class="feature">

                <span class="feature-icon">♥</span>

                <span>Adoption</span>

            </div>


            <div class="feature">

                <span class="feature-icon">🛡</span>

                <span>Care</span>

            </div>


            <div class="feature">

                <span class="feature-icon">👥</span>

                <span>Community</span>

            </div>

        </div>

    </section>



    <!-- ================= RIGHT SIDE ================= -->

    <section class="auth-form-section">


        <div class="auth-card">


            <!-- Small illustration -->

            <div class="auth-icon">

                🐶 🐱

            </div>


            <div class="auth-heading">

                <h1>
                    Welcome <span>Back</span>
                </h1>

                <p>
                    Login to continue your journey with Petora
                </p>

            </div>



            <!-- LOGIN FORM -->

            <form id="loginForm"
                  action="LoginServlet"
                  method="post">


                <!-- Email -->

                <div class="input-group">

                    <label for="email">
                        Email Address
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            ✉
                        </span>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>

                    </div>

                </div>



                <!-- Password -->

                <div class="input-group">

                    <label for="password">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            🔒
                        </span>

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



                <!-- Remember / Forgot -->

                <div class="form-options">

                    <label class="remember">

                        <input
                            type="checkbox"
                            name="remember">

                        <span>
                            Remember me
                        </span>

                    </label>


                    <a href="forgot-password.jsp">
                        Forgot Password?
                    </a>

                </div>



                <!-- Login button -->

                <button
                    type="submit"
                    class="auth-btn">

                    Login
                    <span>→</span>

                </button>


            </form>



            <!-- Divider -->

           
<!-- Divider -->
<div class="divider">
    <span></span>
    <p>Other Login Options</p>
    <span></span>
</div>

<!-- Doctor and Admin Login -->
<div class="social-login">

    <a href="Doclogin.jsp" class="social-btn role-login-btn">
        <span class="role-icon">🩺</span>
        Login as Doctor
        <span class="role-arrow">→</span>
    </a>

    <a href="admin-login.jsp" class="social-btn role-login-btn">
        <span class="role-icon">🛡️</span>
        Login as Admin
        <span class="role-arrow">→</span>
    </a>
    
    <a href="seller-login.jsp" class="social-btn role-login-btn">
        <span class="role-icon">🤝</span>
        Login as Seller
        <span class="role-arrow">→</span>
    </a>

</div>




            <!-- Register -->

            <div class="switch-auth">

                <p>
                    Don't have an account?

                    <a href="register.jsp">
                        Register Now
                    </a>
                </p>

            </div>


        </div>

    </section>

</div>


<script src="js/auth.js"></script>

</body>

</html>
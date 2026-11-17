<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Petora | Register</title>

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

                <p>
                    Pet Management System
                </p>

            </div>

        </div>


        <div class="visual-content">

            <span class="small-heading">
                JOIN OUR COMMUNITY
            </span>

            <h1>

                Give Them
                <br>

                a <span>Better Tomorrow</span>

            </h1>


            <p>

                Join Petora and become part of a
                community that believes every pet
                deserves love, care, and a happy home.

            </p>

        </div>


        <div class="pet-image">

            <img src="images/auth-pets.jpg"
                 alt="Happy pets">

        </div>


        <div class="visual-features">

            <div class="feature">

                <span class="feature-icon">
                    ♥
                </span>

                <span>
                    Adopt
                </span>

            </div>


            <div class="feature">

                <span class="feature-icon">
                    🐾
                </span>

                <span>
                    Care
                </span>

            </div>


            <div class="feature">

                <span class="feature-icon">
                    🤝
                </span>

                <span>
                    Connect
                </span>

            </div>

        </div>

    </section>



    <!-- ================= RIGHT SIDE ================= -->

    <section class="auth-form-section">


        <div class="auth-card register-card">


            <div class="auth-icon">
                🐶 🐱
            </div>


            <div class="auth-heading">

                <h1>
                    Create <span>Account</span>
                </h1>

                <p>
                    Start your journey with Petora
                </p>

            </div>



            <!-- REGISTER FORM -->

            <form id="registerForm" action="RegisterServlet" method="post">


                <!-- Full Name -->

                <div class="input-group">

                    <label for="name">
                        Full Name
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            👤
                        </span>

                        <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Enter your full name"
                            autocomplete="name"
                            required>

                    </div>

                </div>



                <!-- Email -->

                <div class="input-group">

                    <label for="registerEmail">
                        Email Address
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            ✉
                        </span>

                        <input
                            type="email"
                            id="registerEmail"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>

                    </div>

                </div>



                <!-- Phone -->

                <div class="input-group">

                    <label for="phone">
                        Phone Number
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            ☎
                        </span>

                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            placeholder="Enter your phone number"
                            autocomplete="tel"
                            required>

                    </div>

                </div>



                <!-- Password -->

                <div class="input-group">

                    <label for="registerPassword">
                        Password
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            🔒
                        </span>

                        <input
                            type="password"
                            id="registerPassword"
                            name="password"
                            placeholder="Create a password"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            onclick="togglePassword('registerPassword', this)">

                            👁

                        </button>

                    </div>

                </div>



                <!-- Confirm Password -->

                <div class="input-group">

                    <label for="confirmPassword">
                        Confirm Password
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            🔒
                        </span>

                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Confirm your password"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="password-toggle"
                            onclick="togglePassword('confirmPassword', this)">

                            👁

                        </button>

                    </div>

                </div>



                <!-- Terms -->

                <label class="terms">

                    <input
                        type="checkbox"
                        id="terms"
                        required>

                    <span>

                        I agree to the
                        <a href="#">
                            Terms & Conditions
                        </a>

                    </span>

                </label>



                <!-- Register -->

                <button
                    type="submit"
                    class="auth-btn">

                    Create Account
                    <span>→</span>

                </button>


            </form>



            <!-- Login -->

            <div class="switch-auth">

                <p>

                    Already have an account?

                    <a href="login.jsp">
                        Login Now
                    </a>

                </p>

            </div>


        </div>

    </section>

</div>


<script src="js/auth.js"></script>

</body>

</html>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petora | Admin Login</title>

    <link rel="stylesheet" href="CSS/admin-login.css">
</head>

<body class="admin-login-page">

    <main class="admin-login-layout">

        <!-- LEFT IMAGE SECTION -->
        <section class="admin-image-section">

            <!-- Petora Brand -->
            <div class="admin-brand">
                <div class="admin-brand-icon">
    <img src="images/PetNest_Logo.png" alt="Petora Logo">
</div>
                <div class="admin-brand-text">
                    <h2>PetNest</h2>
                    <p>Pet Management System</p>
                </div>
            </div>

            <img src="images/admin_login.png"
                 alt="Puppy and kitten"
                 class="admin-pet-image">

        </section>


        <!-- RIGHT LOGIN SECTION -->
        <section class="admin-form-section">

            <div class="admin-login-card">

                <div class="admin-icon">🛡️</div>

                <div class="admin-heading">
                    <h1>Admin <span>Login</span></h1>
                    <p>Sign in to your administration account</p>
                </div>

                <% if ("1".equals(request.getParameter("error"))) { %>
                    <div class="admin-error">
                        Invalid administrator email or password.
                    </div>
                <% } %>

                <form action="AdminLoginServlet" method="post">

                    <!-- EMAIL -->
                    <div class="admin-input-group">
                        <label for="email">Admin Email Address</label>

                        <div class="admin-input-wrapper">
                            <span class="admin-input-icon">✉</span>

                            <input type="email"
                                   id="email"
                                   name="email"
                                   placeholder="Enter admin email"
                                   autocomplete="username"
                                   required>
                        </div>
                    </div>


                    <!-- PASSWORD -->
                    <div class="admin-input-group">
                        <label for="password">Password</label>

                        <div class="admin-input-wrapper">
                            <span class="admin-input-icon">🔒</span>

                            <input type="password"
                                   id="password"
                                   name="password"
                                   placeholder="Enter password"
                                   autocomplete="current-password"
                                   required>

                            <button type="button"
                                    class="admin-password-toggle"
                                    onclick="togglePassword('password', this)"
                                    aria-label="Toggle password visibility">
                                👁
                            </button>
                        </div>
                    </div>


                    <!-- LOGIN BUTTON -->
                    <button type="submit" class="admin-login-button">
                        Login as Admin <span>→</span>
                    </button>

                </form>


                <!-- BACK TO USER LOGIN -->
                <a href="login.jsp" class="admin-back-link">
                    ← Back to User Login
                </a>

            </div>

        </section>

    </main>

    <!-- KEEPING YOUR EXISTING JAVASCRIPT -->
    <script src="js/auth.js"></script>

</body>
</html>

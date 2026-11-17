
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Login | PawCare</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/CSS/seller-login.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">

        <a class="brand" href="${pageContext.request.contextPath}/home.jsp">
            <span class="brand-icon">🐾</span>
            <span>PawCare</span>
        </a>

        <div class="login-heading">
            <span class="eyebrow">SELLER PORTAL</span>
            <h1>Welcome back!</h1>
            <p>Sign in to manage your PawCare seller account.</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error-message" role="alert">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/SellerLoginServlet"
              method="post">

          
<div class="form-group">
    <label for="email">Email address</label>
    <input type="email"
           id="email"
           name="email"
           placeholder="Enter your registered email"
           value="<%= request.getAttribute("email") == null ? "" :
               String.valueOf(request.getAttribute("email"))
                   .replace("&", "&amp;")
                   .replace("\"", "&quot;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;") %>"
           autocomplete="username"
           required>
</div>


            <div class="form-group">
                <label for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="Enter your password"
                       autocomplete="current-password"
                       required>
            </div>

            <button type="submit" class="login-button">
                Sign In
            </button>
        </form>

        <p class="register-link">
            Don't have a seller account?
            <a href="${pageContext.request.contextPath}/seller-register.jsp">
                Apply to become a seller
            </a>
        </p>

        <a class="back-link"
           href="${pageContext.request.contextPath}/home.jsp">
            ← Back to PawCare
        </a>

    </div>
</div>

</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Registration | Pet Nest</title>
    <link rel="stylesheet" href="CSS/seller.css">
</head>
<body>

<div class="seller-container">
    <div class="seller-card">
        <a href="index.jsp" class="back-link">← Back to Pet Nest</a>

        <div class="brand">🐾 Pet Nest</div>
        <h1>Become a Partner</h1>
        <p class="subtitle">Join our trusted pet-loving community.</p>

      
<form action="${pageContext.request.contextPath}/SellerRegisterServlet"
      method="post"
      enctype="multipart/form-data"
      id="sellerForm">

    <label for="fullName">Full Name</label>
    <input type="text" id="fullName" name="full_name"
           maxlength="100" required>

    <label for="email">Email Address</label>
    <input type="email" id="email" name="email"
           maxlength="150" required>

    <label for="phone">Phone Number</label>
    <input type="tel" id="phone" name="phone"
           maxlength="20" required>

    <!-- IMPORTANT: Seller Type Selection -->
    <label for="sellerType">What do you want to sell?</label>
    <select id="sellerType" name="seller_type" required>
        <option value="">-- Select Seller Type --</option>
        <option value="PET_SELLER">🐾 Pet Seller</option>
        <option value="PRODUCT_SELLER">🛍️ Pet Products Seller</option>
    </select>

    <label for="businessName">Business Name (Optional)</label>
    <input type="text" id="businessName" name="business_name"
           maxlength="150">

    <label for="address">Full Address</label>
    <textarea id="address" name="address"
              rows="3" required></textarea>

    <label for="password">Create Password</label>
    <input type="password" id="password" name="password"
           minlength="8" required>

    <!-- IMPORTANT: Confirm Password -->
    <label for="confirmPassword">Confirm Password</label>
    <input type="password" id="confirmPassword"
           name="confirm_password" minlength="8" required>

    <label for="document">Identity Document (Optional)</label>
    <input type="file" id="document" name="identity_document"
           accept=".jpg,.jpeg,.png,.pdf">

    <button type="submit">Submit Registration</button>
</form>

<script>
document.getElementById("sellerForm").addEventListener("submit",
    function(event) {
        const password = document.getElementById("password").value;
        const confirmPassword =
            document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            event.preventDefault();
            alert("Passwords do not match!");
            document.getElementById("confirmPassword").focus();
        }
    }
);
</script>
```

        <p class="login-link">
            Already registered?
            <a href="seller-login.jsp">Seller Login</a>
        </p>
    </div>
</div>

</body>
</html>

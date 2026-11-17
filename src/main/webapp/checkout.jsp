
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*, java.math.BigDecimal, java.text.NumberFormat, com.petcare.dao.CartDao, com.petcare.model.Cart"
%>

<%
Integer userId = (Integer) session.getAttribute("userId");

if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

CartDao cartDao = new CartDao();

List<Cart> items = new ArrayList<>();
BigDecimal total = BigDecimal.ZERO;

NumberFormat money =
    NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

String errorMessage = null;

try {
    items = cartDao.getCartItems(userId);
    total = cartDao.getCartTotal(userId);

    if (items.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

} catch (Exception e) {
    application.log("Checkout loading error", e);
    errorMessage = "Unable to load checkout details.";
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Checkout - PawCare</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3f7f3;
            color: #193b2b;
            padding: 35px 18px;
        }

        .checkout-container {
            max-width: 1050px;
            margin: auto;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 25px;
            color: #176b3b;
            text-decoration: none;
            font-weight: 600;
        }

        .checkout-title {
            margin-bottom: 25px;
        }

        .checkout-title h1 {
            color: #176b3b;
            font-size: 32px;
        }

        .checkout-title p {
            color: #718078;
            margin-top: 8px;
        }

        .checkout-layout {
            display: grid;
            grid-template-columns: 1.4fr 0.8fr;
            gap: 25px;
            align-items: start;
        }

        .checkout-card {
            background: white;
            padding: 28px;
            border-radius: 20px;
            box-shadow: 0 10px 35px rgba(22, 65, 40, 0.06);
            margin-bottom: 22px;
        }

        .checkout-card h2 {
            color: #176b3b;
            font-size: 21px;
            margin-bottom: 22px;
        }

        .form-group {
            margin-bottom: 17px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 13px;
            border: 1px solid #dce7de;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #176b3b;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .order-item {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #e8eee9;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .item-detail {
            color: #78867d;
            font-size: 13px;
            margin-top: 5px;
        }

        .item-price {
            color: #176b3b;
            font-weight: 700;
            white-space: nowrap;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            border-top: 1px solid #e8eee9;
            padding-top: 20px;
            margin-top: 10px;
            font-size: 19px;
            font-weight: 700;
        }

        .total-row strong {
            color: #176b3b;
        }

        .payment-option {
            background: #f1f8f1;
            border: 1px solid #dcebdc;
            border-radius: 12px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .payment-option input {
            accent-color: #176b3b;
        }

        .payment-option label {
            font-weight: 600;
        }

        .place-order-btn {
            width: 100%;
            border: none;
            background: #176b3b;
            color: white;
            padding: 16px;
            margin-top: 22px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .place-order-btn:hover {
            background: #10552e;
        }

        .error-message {
            color: #b42318;
            background: #fff0f0;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        @media(max-width: 750px) {
            .checkout-layout {
                grid-template-columns: 1fr;
            }

            .checkout-card {
                padding: 21px;
            }

            .checkout-title h1 {
                font-size: 26px;
            }
        }

        @media(max-width: 450px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>

<body>

<main class="checkout-container">

    <a href="cart.jsp" class="back-link">
        ← Back to Cart
    </a>

    <header class="checkout-title">
        <h1>Checkout 🐾</h1>
        <p>Complete your delivery details to continue.</p>
    </header>

    <% if (errorMessage != null) { %>

        <div class="error-message">
            <%= errorMessage %>
        </div>

    <% } else { %>

    <div class="checkout-layout">

        <!-- DELIVERY DETAILS -->

        <section>

            <div class="checkout-card">

                <h2>Delivery Information</h2>

                <form action="PlaceOrderServlet" method="post">

                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text"
                            id="fullName"
                            name="fullName"
                            required
                            maxlength="100"
                            placeholder="Enter your full name">
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel"
                            id="phone"
                            name="phone"
                            required
                            pattern="[0-9]{10}"
                            maxlength="10"
                            placeholder="Enter 10-digit mobile number">
                    </div>

                    <div class="form-group">
                        <label for="address">Delivery Address</label>
                        <textarea id="address"
                            name="address"
                            required
                            maxlength="500"
                            placeholder="House number, street, area..."></textarea>
                    </div>

                    <div class="form-row">

                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text"
                                id="city"
                                name="city"
                                required
                                maxlength="80"
                                placeholder="City">
                        </div>

                        <div class="form-group">
                            <label for="pincode">PIN Code</label>
                            <input type="text"
                                id="pincode"
                                name="pincode"
                                required
                                pattern="[0-9]{6}"
                                maxlength="6"
                                placeholder="6-digit PIN">
                        </div>

                    </div>

                    <h2 style="margin-top:25px;">
                        Payment Method
                    </h2>

                    <div class="payment-option">

                        <input type="radio"
                            id="cod"
                            name="paymentMethod"
                            value="COD"
                            checked>

                        <label for="cod">
                            Cash on Delivery (COD)
                        </label>

                    </div>

                    <button type="submit" class="place-order-btn">
                        Place Order →
                    </button>

                </form>

            </div>

        </section>


        <!-- ORDER SUMMARY -->

        <aside class="checkout-card">

            <h2>Order Summary</h2>

            <% for (Cart item : items) { %>

                <div class="order-item">

                    <div>
                        <div class="item-name">
                            <%= item.getProductName() %>
                        </div>

                        <div class="item-detail">
                            Quantity: <%= item.getQuantity() %>
                        </div>
                    </div>

                    <div class="item-price">
                        <%= money.format(item.getSubtotal()) %>
                    </div>

                </div>

            <% } %>

            <div class="total-row">
                <span>Total Amount</span>
                <strong><%= money.format(total) %></strong>
            </div>

        </aside>

    </div>

    <% } %>

</main>

</body>
</html>

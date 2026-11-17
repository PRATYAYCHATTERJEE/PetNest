
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%>

<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId = (Integer) session.getAttribute("lastOrderId");

    if (orderId == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    session.removeAttribute("lastOrderId");

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Order Successful - PawCare</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3f7f3;
            color: #193b2b;
        }

        .success-container {
            width: 100%;
            max-width: 550px;
            padding: 45px 35px;
            background: white;
            border-radius: 22px;
            text-align: center;
            box-shadow: 0 12px 40px rgba(22, 65, 40, 0.08);
        }

        .success-icon {
            width: 90px;
            height: 90px;
            margin: 0 auto 22px;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #e5f6e9;
            color: #176b3b;
            border-radius: 50%;
            font-size: 45px;
        }

        h1 {
            color: #176b3b;
            font-size: 30px;
            margin-bottom: 12px;
        }

        .message {
            color: #718078;
            line-height: 1.7;
            font-size: 15px;
        }

        .order-box {
            margin: 28px 0;
            padding: 20px;
            background: #f1f8f1;
            border-radius: 14px;
        }

        .order-label {
            color: #718078;
            font-size: 13px;
            margin-bottom: 7px;
        }

        .order-number {
            color: #176b3b;
            font-size: 25px;
            font-weight: 700;
        }

        .payment-info {
            margin-bottom: 25px;
            padding: 13px;
            background: #fff9e9;
            border-radius: 10px;
            color: #87651b;
            font-size: 14px;
        }

        .home-btn {
            display: block;
            width: 100%;
            padding: 15px;
            background: #176b3b;
            color: white;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 700;
            transition: 0.3s;
        }

        .home-btn:hover {
            background: #10552e;
            transform: translateY(-2px);
        }

        .footer-text {
            margin-top: 22px;
            color: #87938b;
            font-size: 13px;
        }

        @media(max-width: 480px) {

            .success-container {
                padding: 35px 22px;
            }

            h1 {
                font-size: 25px;
            }

        }

    </style>

</head>

<body>

    <main class="success-container">

        <div class="success-icon">
            ✓
        </div>

        <h1>Order Placed Successfully!</h1>

        <p class="message">
            Thank you for choosing PawCare.
            Your order has been received successfully.
            We'll get your order ready for delivery.
        </p>

        <div class="order-box">

            <p class="order-label">
                Your Order ID
            </p>

            <p class="order-number">
                #<%= orderId %>
            </p>

        </div>

        <div class="payment-info">
            💵 Payment Method: Cash on Delivery
        </div>

        <a href="<%= contextPath %>/home.jsp" class="home-btn">
            Continue Shopping →
        </a>

        <p class="footer-text">
            Thank you for being a part of PawCare 🐾
        </p>

    </main>

</body>

</html>

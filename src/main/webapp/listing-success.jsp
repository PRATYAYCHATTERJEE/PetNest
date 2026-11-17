
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("sellerLoggedIn") != Boolean.TRUE
            || session.getAttribute("sellerId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/seller-login.jsp"
        );
        return;
    }

    String sellerType = String.valueOf(
        session.getAttribute("sellerType")
    );

    boolean petSeller = "PET_SELLER".equals(sellerType);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Submission Successful | PawCare</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            background: #f1f8f2;
            font-family: Arial, Helvetica, sans-serif;
            color: #24412e;
        }

        .success-card {
            width: 100%;
            max-width: 520px;
            padding: 42px 28px;
            border-radius: 24px;
            background: #ffffff;
            text-align: center;
            box-shadow: 0 18px 55px rgba(30, 90, 48, 0.12);
        }

        .success-icon {
            width: 86px;
            height: 86px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 22px;
            border-radius: 50%;
            background: #e2f6e7;
            color: #19804a;
            font-size: 45px;
            font-weight: bold;
        }

        h1 {
            margin: 0 0 14px;
            color: #176b40;
            font-size: 27px;
        }

        p {
            color: #6a7a6e;
            font-size: 15px;
            line-height: 1.8;
        }

        .status {
            display: inline-block;
            margin: 12px 0 25px;
            padding: 8px 15px;
            border-radius: 30px;
            background: #e5f6e9;
            color: #176b40;
            font-size: 12px;
            font-weight: bold;
        }

        .actions {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 15px;
        }

        .button {
            display: inline-block;
            padding: 13px 19px;
            border-radius: 10px;
            background: #19804a;
            color: white;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
        }

        .button:hover {
            background: #126738;
        }

        .secondary {
            border: 1px solid #cfe1d3;
            background: white;
            color: #176b40;
        }

        .secondary:hover {
            background: #f0f8f1;
        }

        .brand {
            margin-top: 30px;
            color: #176b40;
            font-size: 17px;
            font-weight: bold;
        }

        @media (max-width: 450px) {
            .success-card {
                padding: 32px 20px;
            }

            h1 {
                font-size: 23px;
            }

            .actions {
                flex-direction: column;
            }

            .button {
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <main class="success-card">

        <div class="success-icon">&#10003;</div>

        <h1>
            <%= petSeller
                ? "Pet Submitted Successfully!"
                : "Product Submitted Successfully!" %>
        </h1>

        <p>
            Your <%= petSeller ? "pet listing" : "product listing" %>
            has been saved successfully. Thank you for being a part of PawCare!
        </p>

        <span class="status">✓ SUBMISSION COMPLETE</span>

        <p>
            Your listing has been submitted. Individual listings do not require
            additional admin approval.
        </p>

        <div class="actions">
            <a class="button"
               href="<%= request.getContextPath() %>/seller-dashboard.jsp">
                Back to Dashboard
            </a>

            <a class="button secondary"
               href="<%= request.getContextPath() %>/seller-dashboard.jsp#myListings">
                View My Listings
            </a>
        </div>

        <div class="brand">🐾 PawCare</div>

    </main>
</body>
</html>

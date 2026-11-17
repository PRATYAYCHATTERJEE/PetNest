

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

String contextPath = request.getContextPath();

BigDecimal total = BigDecimal.ZERO;
int count = 0;
int totalQuantity = 0;

String errorMessage = null;

NumberFormat money =
    NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

StringBuilder cartItems = new StringBuilder();

try {
    CartDao cartDao = new CartDao();

    List<Cart> items = cartDao.getCartItems(userId);

    total = cartDao.getCartTotal(userId);

    for (Cart item : items) {

        int id = item.getId();
        String displayName = item.getProductName();

        BigDecimal price = item.getPrice();
        int quantity = item.getQuantity();

        BigDecimal subtotal = item.getSubtotal();

        boolean isSellerPet =
            item.getSellerListingId() != null;

        String itemDescription = item.getDescription();

        String imageUrl = null;

        if (isSellerPet &&
            item.getImage() != null &&
            !item.getImage().trim().isEmpty()) {

            imageUrl = contextPath +
                "/uploads/seller-listings/" +
                item.getImage();
        }

        count++;
        totalQuantity += quantity;

        // Escape product name
        String safeName = displayName == null ? "" :
            displayName.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");

        // Escape image URL
        String safeImageUrl = imageUrl == null ? "" :
            imageUrl.replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");

        cartItems.append("<article class='cart-item'>");

        if (isSellerPet && !safeImageUrl.isEmpty()) {

            cartItems.append(
                "<div class='product-icon pet-image'>"
            );

            cartItems.append("<img src='")
                .append(safeImageUrl)
                .append("' alt='")
                .append(safeName)
                .append("'>");

            cartItems.append("</div>");

        } else {

            cartItems.append(
                "<div class='product-icon'>🐾</div>"
            );
        }

        cartItems.append("<div class='product-info'>")
            .append("<h3>")
            .append(safeName)
            .append("</h3>")
            .append("<p>")
            .append(itemDescription)
            .append("</p>")
            .append("<p class='quantity'>Quantity: ")
            .append(quantity)
            .append("</p>")
            .append("</div>");

        cartItems.append("<div class='price-info'>")
            .append("<strong>")
            .append(money.format(price))
            .append("</strong>")
            .append("<span>Subtotal: ")
            .append(money.format(subtotal))
            .append("</span>")
            .append("</div>");

        cartItems.append(
            "<form action='RemoveFromCartServlet' method='post'>"
        )
            .append("<input type='hidden' name='cartId' value='")
            .append(id)
            .append("'>")
            .append("<button class='remove-btn' type='submit' ")
            .append("aria-label='Remove item'>🗑</button>")
            .append("</form>");

        cartItems.append("</article>");
    }

} catch (Exception e) {

    application.log("Unable to load store cart", e);

    errorMessage =
        "Unable to load your cart. Please try again.";
}
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Your Cart - PawCare</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3f7f3;
            color: #193b2b;
            min-height: 100vh;
            padding: 35px 18px;
        }

        .cart-container {
            max-width: 1000px;
            margin: 0 auto;
            background: #fff;
            padding: 35px;
            border-radius: 22px;
            box-shadow: 0 10px 35px rgba(22, 65, 40, 0.07);
        }

        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 12px;
        }

        h1 {
            font-size: 32px;
            color: #176b3b;
        }

        .subtitle {
            color: #718078;
            margin-bottom: 30px;
        }

        .back-link {
            display: inline-block;
            text-decoration: none;
            color: #176b3b;
            font-weight: 600;
            margin-bottom: 28px;
        }

        .cart-count {
            background: #edf7ed;
            color: #176b3b;
            border-radius: 30px;
            padding: 10px 15px;
            font-size: 14px;
            font-weight: 600;
        }

        .cart-item {
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 22px 0;
            border-bottom: 1px solid #e8eee9;
        }

        .product-icon {
            width: 90px;
            height: 90px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            background: #edf7ed;
            border-radius: 16px;
            font-size: 30px;
            overflow: hidden;
        }

        .pet-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .product-info {
            flex: 1;
            min-width: 0;
        }

        .product-info h3 {
            font-size: 18px;
            overflow-wrap: anywhere;
            margin-bottom: 7px;
        }

        .product-info p,
        .price-info span {
            color: #78867d;
            font-size: 14px;
            margin-top: 5px;
        }

        .price-info {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 5px;
            white-space: nowrap;
        }

        .price-info strong {
            color: #176b3b;
            font-size: 17px;
        }

        .remove-btn {
            border: 0;
            background: #fff0f0;
            color: #c03939;
            padding: 12px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 18px;
        }

        .remove-btn:hover {
            background: #ffdddd;
        }

        .summary {
            max-width: 400px;
            margin: 28px 0 0 auto;
            padding: 24px;
            background: #f1f8f1;
            border-radius: 18px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            font-size: 21px;
            font-weight: 700;
        }

        .total-row strong {
            color: #176b3b;
        }

        .checkout-btn {
            display: block;
            width: 100%;
            margin-top: 22px;
            padding: 15px;
            text-align: center;
            border: 0;
            border-radius: 12px;
            background: #176b3b;
            color: white;
            font-size: 16px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .checkout-btn:hover {
            background: #10552e;
        }

        .empty-cart,
        .error-message {
            padding: 35px 15px;
            text-align: center;
            color: #718078;
        }

        .empty-cart .paw {
            font-size: 42px;
            margin-bottom: 12px;
        }

        .shop-link {
            display: inline-block;
            margin-top: 18px;
            padding: 12px 20px;
            border-radius: 10px;
            background: #176b3b;
            color: white;
            text-decoration: none;
            font-weight: 600;
        }

        .error-message {
            color: #b42318;
        }

        @media (max-width: 650px) {
            .cart-container {
                padding: 22px 17px;
            }

            h1 {
                font-size: 25px;
            }

            .cart-item {
                flex-wrap: wrap;
                gap: 12px;
            }

            .product-info {
                flex-basis: calc(100% - 110px);
            }

            .price-info {
                align-items: flex-start;
                margin-left: 102px;
            }

            .summary {
                max-width: none;
            }
        }
    </style>
</head>

<body>

<main class="cart-container">

    <a class="back-link" href="home.jsp">
        ← Back to PawCare
    </a>

    <header class="cart-header">

        <h1>Your PawCare Cart 🛒</h1>

        <span class="cart-count">
            <%= totalQuantity %> item(s)
        </span>

    </header>

    <p class="subtitle">
        Your saved pets and store products
    </p>

    <% if (errorMessage != null) { %>

        <div class="error-message">
            <%= errorMessage %>
        </div>

    <% } else if (count == 0) { %>

        <div class="empty-cart">

            <div class="paw">🐾</div>

            <h2>Your cart is empty</h2>

            <p>
                Add a pet or your favourite pet care products
                to get started.
            </p>

            <a class="shop-link" href="home.jsp">
                Continue Shopping
            </a>

        </div>

    <% } else { %>

        <section class="cart-items">

            <%= cartItems.toString() %>

        </section>

        <section class="summary">

            <div class="total-row">

                <span>Total</span>

                <strong>
                    <%= money.format(total) %>
                </strong>

            </div>

            <a class="checkout-btn" href="checkout.jsp">
    Proceed to Checkout →
</a>
        </section>

    <% } %>

</main>

</body>
</html>

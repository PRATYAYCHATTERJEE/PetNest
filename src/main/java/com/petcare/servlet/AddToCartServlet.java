
package com.petcare.servlet;

import com.petcare.dao.CartDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    private CartDao cartDao;

    @Override
    public void init() throws ServletException {
        cartDao = new CartDao();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                "Please log in before adding items."
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String listingIdText =
            request.getParameter("sellerListingId");

        // =====================================
        // SELLER-LISTED PET
        // =====================================

        if (listingIdText != null &&
                !listingIdText.trim().isEmpty()) {

            int listingId;

            try {
                listingId = Integer.parseInt(listingIdText.trim());

                if (listingId <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException e) {

                response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
                );

                response.getWriter().write(
                    "Invalid pet listing ID."
                );
                return;
            }

            try {

                boolean added =
                    cartDao.addSellerPet(userId, listingId);

                if (!added) {
                    response.setStatus(
                        HttpServletResponse.SC_NOT_FOUND
                    );

                    response.getWriter().write(
                        "Pet listing not found."
                    );
                    return;
                }

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(
                    "Pet added to cart successfully!"
                );

                return;

            } catch (SQLException e) {

                e.printStackTrace();

                response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );

                response.getWriter().write(
                    "Unable to add pet to cart."
                );
                return;
            }
        }

        // =====================================
        // STORE PRODUCT
        // =====================================

        String productName =
            request.getParameter("productName");

        String priceText =
            request.getParameter("price");

        if (productName == null ||
                productName.trim().isEmpty() ||
                priceText == null) {

            response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                "Product details are missing."
            );
            return;
        }

        productName = productName.trim();

        if (productName.length() > 150) {

            response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                "Product name is too long."
            );
            return;
        }

        BigDecimal price;

        try {

            price = new BigDecimal(priceText);

            if (price.compareTo(BigDecimal.ZERO) <= 0 ||
                price.compareTo(new BigDecimal("1000000")) > 0) {

                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {

            response.setStatus(
                HttpServletResponse.SC_BAD_REQUEST
            );

            response.getWriter().write(
                "Invalid product price."
            );
            return;
        }

        try {

            cartDao.addProduct(userId, productName, price);

            response.setStatus(HttpServletResponse.SC_OK);

            response.getWriter().write(
                "Product added to cart successfully!"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                "Unable to add product to cart."
            );
        }
    }
}

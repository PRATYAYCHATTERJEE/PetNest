
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/BuySellerPetServlet")
public class BuySellerPetServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check customer login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // 2. Get seller listing ID
        String listingIdText = request.getParameter("sellerListingId");

        if (listingIdText == null || listingIdText.trim().isEmpty()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Seller pet ID is missing."
            );
            return;
        }

        int listingId;

        try {
            listingId = Integer.parseInt(listingIdText);
            if (listingId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid seller pet ID."
            );
            return;
        }

        String petSql =
            "SELECT sl.id, sl.title, sl.price, sl.listing_status " +
            "FROM seller_listings sl " +
            "JOIN seller_applications sa ON sl.seller_id = sa.id " +
            "WHERE sl.id = ? " +
            "AND sl.listing_type = 'PET' " +
            "AND UPPER(COALESCE(sa.application_status, '')) = 'APPROVED' " +
            "FOR UPDATE";

        String orderSql =
            "INSERT INTO orders " +
            "(user_id, pet_id, seller_listing_id, amount, order_status) " +
            "VALUES (?, NULL, ?, ?, 'PLACED')";

        String myPetSql =
            "INSERT INTO my_pets " +
            "(user_id, pet_id, seller_listing_id, order_id) " +
            "VALUES (?, NULL, ?, ?)";

        String updateListingSql =
            "UPDATE seller_listings " +
            "SET listing_status = 'SOLD' " +
            "WHERE id = ? AND listing_status = 'AVAILABLE'";

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {

                BigDecimal price;

                // 3. Check and lock the seller listing
                try (PreparedStatement petPs =
                         conn.prepareStatement(petSql)) {

                    petPs.setInt(1, listingId);

                    try (ResultSet rs = petPs.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();

                            response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Pet listing not found or seller is not approved."
                            );
                            return;
                        }

                        String status = rs.getString("listing_status");

                        if (!"AVAILABLE".equalsIgnoreCase(status)) {
                            conn.rollback();

                            response.sendError(
                                HttpServletResponse.SC_CONFLICT,
                                "Sorry, this pet has already been sold."
                            );
                            return;
                        }

                        price = rs.getBigDecimal("price");
                    }
                }

                // 4. Create order
                int orderId;

                try (PreparedStatement orderPs =
                         conn.prepareStatement(
                             orderSql,
                             Statement.RETURN_GENERATED_KEYS
                         )) {

                    orderPs.setInt(1, userId);
                    orderPs.setInt(2, listingId);
                    orderPs.setBigDecimal(3, price);

                    orderPs.executeUpdate();

                    try (ResultSet keys = orderPs.getGeneratedKeys()) {

                        if (!keys.next()) {
                            throw new Exception(
                                "Could not generate order ID."
                            );
                        }

                        orderId = keys.getInt(1);
                    }
                }

                // 5. Add purchased pet to My Pets
                try (PreparedStatement myPetPs =
                         conn.prepareStatement(myPetSql)) {

                    myPetPs.setInt(1, userId);
                    myPetPs.setInt(2, listingId);
                    myPetPs.setInt(3, orderId);

                    myPetPs.executeUpdate();
                }

                // 6. Mark seller listing as SOLD
                try (PreparedStatement updatePs =
                         conn.prepareStatement(updateListingSql)) {

                    updatePs.setInt(1, listingId);

                    int updated = updatePs.executeUpdate();

                    if (updated != 1) {
                        throw new Exception(
                            "Unable to update pet availability."
                        );
                    }
                }

                // 7. Complete transaction
                conn.commit();

                System.out.println(
                    "SELLER PET PURCHASE SUCCESSFUL | User: " +
                    userId +
                    " | Listing: " +
                    listingId +
                    " | Order: " +
                    orderId
                );

                // 8. Redirect to existing My Pets page
                response.sendRedirect(
                    request.getContextPath() + "/MyPetsServlet"
                );

            } catch (Exception e) {

                conn.rollback();
                throw e;
            }

        } catch (Exception e) {

            getServletContext().log(
                "Seller pet purchase failed.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Purchase could not be completed. Please try again."
            );
        }
    }
}

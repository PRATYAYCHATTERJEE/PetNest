package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/BuyPetServlet")
public class BuyPetServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String petIdParameter = request.getParameter("petId");

        if (petIdParameter == null || petIdParameter.trim().isEmpty()) {
            response.getWriter().println("Pet ID is missing.");
            return;
        }

        int petId;

        try {
            petId = Integer.parseInt(petIdParameter);
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid Pet ID.");
            return;
        }

        String petSql = """
                SELECT id, name, price, status
                FROM pets
                WHERE id = ?
                """;

        String orderSql = """
                INSERT INTO orders
                (user_id, pet_id, amount, order_status)
                VALUES (?, ?, ?, 'PLACED')
                """;

        String myPetSql = """
                INSERT INTO my_pets
                (user_id, pet_id, order_id)
                VALUES (?, ?, ?)
                """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try (
                PreparedStatement petPs = conn.prepareStatement(petSql)
            ) {

                petPs.setInt(1, petId);

                try (ResultSet rs = petPs.executeQuery()) {

                    if (!rs.next()) {
                        response.getWriter().println("Pet not found.");
                        conn.rollback();
                        return;
                    }

                    String status = rs.getString("status");
                    double price = rs.getDouble("price");

                    // Check whether pet is still available
                    if (!"AVAILABLE".equalsIgnoreCase(status)) {
                        response.getWriter().println(
                            "Sorry, this pet is no longer available."
                        );
                        conn.rollback();
                        return;
                    }

                    int orderId;

                    // Create order
                    try (
                        PreparedStatement orderPs =
                            conn.prepareStatement(
                                orderSql,
                                java.sql.Statement.RETURN_GENERATED_KEYS
                            )
                    ) {

                        orderPs.setInt(1, userId);
                        orderPs.setInt(2, petId);
                        orderPs.setDouble(3, price);

                        orderPs.executeUpdate();

                        try (ResultSet generatedKeys =
                                 orderPs.getGeneratedKeys()) {

                            if (!generatedKeys.next()) {
                                throw new Exception(
                                    "Could not create order."
                                );
                            }

                            orderId = generatedKeys.getInt(1);
                        }
                    }

                    // Add pet to My Pets
                    try (
                        PreparedStatement myPetPs =
                            conn.prepareStatement(myPetSql)
                    ) {

                        myPetPs.setInt(1, userId);
                        myPetPs.setInt(2, petId);
                        myPetPs.setInt(3, orderId);

                        myPetPs.executeUpdate();
                    }

                    conn.commit();

                    System.out.println(
                        "ORDER SUCCESSFUL | User: " +
                        userId +
                        " | Pet: " +
                        petId +
                        " | Order: " +
                        orderId
                    );

                    response.sendRedirect("MyPetsServlet");

                }

            } catch (Exception e) {

                conn.rollback();
                throw e;
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");

            response.getWriter().println(
                "<h2>Purchase Error</h2>" +
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}
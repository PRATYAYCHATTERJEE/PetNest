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

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String cartIdValue = request.getParameter("cartId");

        if (cartIdValue == null || cartIdValue.trim().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdValue);

            String sql =
                "DELETE FROM store_cart WHERE id = ? AND user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, cartId);
                ps.setInt(2, userId);

                ps.executeUpdate();
            }

            response.sendRedirect("cart.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            throw new ServletException(
                "Unable to remove cart item.", e
            );
        }
    }
}

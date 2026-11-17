
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ApproveSellerServlet")
public class ApproveSellerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // GET: Load all seller applications as JSON
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (!"list".equals(action)) {
            sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    "{\"success\":false,\"message\":\"Invalid action\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String sql =
                "SELECT id, full_name, email, phone, seller_type, " +
                "business_name, address, application_status, created_at " +
                "FROM seller_applications ORDER BY created_at DESC";

        StringBuilder json = new StringBuilder();
        boolean first = true;

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new SQLException("Database connection returned null");
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                json.append("[");

                while (rs.next()) {

                    if (!first) {
                        json.append(",");
                    }

                    json.append("{")
                        .append("\"id\":").append(rs.getInt("id")).append(",")
                        .append("\"fullName\":")
                        .append(jsonString(rs.getString("full_name"))).append(",")
                        .append("\"email\":")
                        .append(jsonString(rs.getString("email"))).append(",")
                        .append("\"phone\":")
                        .append(jsonString(rs.getString("phone"))).append(",")
                        .append("\"sellerType\":")
                        .append(jsonString(rs.getString("seller_type"))).append(",")
                        .append("\"businessName\":")
                        .append(jsonString(rs.getString("business_name"))).append(",")
                        .append("\"address\":")
                        .append(jsonString(rs.getString("address"))).append(",")
                        .append("\"applicationStatus\":")
                        .append(jsonString(rs.getString("application_status"))).append(",")
                        .append("\"createdAt\":")
                        .append(jsonString(
                                String.valueOf(rs.getTimestamp("created_at"))
                        ))
                        .append("}");

                    first = false;
                }

                json.append("]");
            }

            response.getWriter().write(json.toString());

        } catch (SQLException e) {
            e.printStackTrace();

            sendJson(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"success\":false,\"message\":\"Database error while loading seller applications\"}");
        }
    }

    // POST: Approve or reject an application
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String sellerIdValue = request.getParameter("sellerId");

        if (!"approve".equals(action) && !"reject".equals(action)) {
            sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    "{\"success\":false,\"message\":\"Action must be approve or reject\"}");
            return;
        }

        int sellerId;

        try {
            sellerId = Integer.parseInt(sellerIdValue);

            if (sellerId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException | NullPointerException e) {
            sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    "{\"success\":false,\"message\":\"Invalid seller ID\"}");
            return;
        }

        String status = "approve".equals(action) ? "APPROVED" : "REJECTED";

        String sql =
                "UPDATE seller_applications " +
                "SET application_status = ? " +
                "WHERE id = ? AND application_status = 'PENDING'";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new SQLException("Database connection returned null");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setInt(2, sellerId);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated == 1) {
                    sendJson(response, HttpServletResponse.SC_OK,
                            "{\"success\":true,\"message\":\"Seller application " +
                            status.toLowerCase() + " successfully\"}");
                } else {
                    sendJson(response, HttpServletResponse.SC_CONFLICT,
                            "{\"success\":false,\"message\":\"Seller application not found or already reviewed\"}");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            sendJson(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "{\"success\":false,\"message\":\"Database error while updating seller application\"}");
        }
    }

    // Return a JSON string safely, including null values
    private String jsonString(String value) {

        if (value == null) {
            return "null";
        }

        StringBuilder result = new StringBuilder("\"");

        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);

            switch (c) {
                case '"':
                    result.append("\\\"");
                    break;
                case '\\':
                    result.append("\\\\");
                    break;
                case '\b':
                    result.append("\\b");
                    break;
                case '\f':
                    result.append("\\f");
                    break;
                case '\n':
                    result.append("\\n");
                    break;
                case '\r':
                    result.append("\\r");
                    break;
                case '\t':
                    result.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        result.append(String.format("\\u%04x", (int) c));
                    } else {
                        result.append(c);
                    }
                    break;
            }
        }

        result.append("\"");
        return result.toString();
    }

    // Send JSON responses
    private void sendJson(HttpServletResponse response,
                          int status,
                          String json) throws IOException {

        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
}


package com.petcare.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.petcare.util.DBConnection;

@WebServlet("/DoctorReviewServlet")
public class DoctorReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            !Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idValue = request.getParameter("id");
        String decision = request.getParameter("decision");
        String adminNote = request.getParameter("adminNote");

        if (idValue == null || !idValue.matches("\\d+") ||
            !("APPROVED".equals(decision) ||
              "REJECTED".equals(decision))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int doctorId;

        try {
            doctorId = Integer.parseInt(idValue);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        if (adminNote != null && adminNote.length() > 500) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String sql =
            "UPDATE doctor_applications " +
            "SET status = ?, admin_note = ?, reviewed_at = CURRENT_TIMESTAMP " +
            "WHERE id = ? AND status = 'PENDING'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setString(1, decision);
            statement.setString(2,
                adminNote == null || adminNote.trim().isEmpty()
                    ? null : adminNote.trim());
            statement.setInt(3, doctorId);

            int updated = statement.executeUpdate();

            if (updated == 0) {
                response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    "Application not found or already reviewed."
                );
                return;
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(
                "{\"success\":true,\"status\":\"" + decision + "\"}"
            );

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to review doctor application.", e
            );
        }
    }
}

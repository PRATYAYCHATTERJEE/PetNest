
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

@WebServlet("/DoctorNotificationServlet")
public class DoctorNotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String json(String value) {
        if (value == null) {
            return "null";
        }

        return "\"" + value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                + "\"";
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("userId") instanceof Integer)) {

            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                "{\"notifications\":[],\"message\":\"Please log in again.\"}"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql =
            "SELECT a.id, a.pet_name, a.appointment_date, " +
            "a.appointment_time, a.status, a.doctor_message, " +
            "a.responded_at, d.full_name " +
            "FROM appointments a " +
            "JOIN doctor_applications d ON d.id = a.doctor_id " +
            "WHERE a.user_id = ? " +
            "AND a.status IN ('CONFIRMED', 'CANCELLED') " +
            "AND a.doctor_message IS NOT NULL " +
            "AND a.responded_at IS NOT NULL " +
            "ORDER BY a.responded_at DESC, a.id DESC";

        StringBuilder output = new StringBuilder();
        output.append("{\"notifications\":[");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                boolean first = true;

                while (rs.next()) {

                    if (!first) {
                        output.append(",");
                    }
                    first = false;

                    String status = rs.getString("status");

                    String title = "CONFIRMED".equals(status)
                            ? "Appointment Approved"
                            : "Appointment Rejected";

                    String doctorName = rs.getString("full_name");
                    String petName = rs.getString("pet_name");
                    String message = rs.getString("doctor_message");

                    String date = rs.getDate("appointment_date").toString();
                    String time = rs.getTime("appointment_time").toString();

                    output.append("{")
                        .append("\"id\":").append(rs.getInt("id")).append(",")
                        .append("\"title\":").append(json(title)).append(",")
                        .append("\"status\":").append(json(status)).append(",")
                        .append("\"doctor\":").append(json(doctorName)).append(",")
                        .append("\"petName\":").append(json(petName)).append(",")
                        .append("\"date\":").append(json(date)).append(",")
                        .append("\"time\":").append(json(time)).append(",")
                        .append("\"message\":").append(json(message)).append(",")
                        .append("\"respondedAt\":")
                        .append(json(rs.getTimestamp("responded_at").toString()))
                        .append("}");
                }
            }

            output.append("]}");
            response.getWriter().write(output.toString());

        } catch (Exception e) {
            getServletContext().log(
                "Unable to load appointment notifications", e
            );

            response.setStatus(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            response.getWriter().write(
                "{\"notifications\":[],\"message\":\"Unable to load notifications.\"}"
            );
        }
    }
}

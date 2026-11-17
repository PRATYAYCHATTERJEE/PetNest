
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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/DoctorAppointmentsServlet")
public class DoctorAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Integer getDoctorId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null
                || !Boolean.TRUE.equals(session.getAttribute("isDoctor"))
                || !(session.getAttribute("doctorId") instanceof Integer)) {
            return null;
        }

        return (Integer) session.getAttribute("doctorId");
    }

    // Fetch appointments for the logged-in doctor
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        Integer doctorId = getDoctorId(request);

        if (doctorId == null) {
            response.sendRedirect(
                request.getContextPath() + "/Doclogin.jsp"
            );
            return;
        }

        List<Map<String, Object>> appointments = new ArrayList<>();

        String sql =
            "SELECT id, user_id, pet_name, pet_type, appointment_date, " +
            "appointment_time, reason, status, doctor_message, responded_at, " +
            "created_at FROM appointments " +
            "WHERE doctor_id = ? " +
            "ORDER BY appointment_date DESC, appointment_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();

                    item.put("id", rs.getInt("id"));
                    item.put("userId", rs.getInt("user_id"));
                    item.put("petName", rs.getString("pet_name"));
                    item.put("petType", rs.getString("pet_type"));
                    item.put("date", rs.getDate("appointment_date"));
                    item.put("time", rs.getTime("appointment_time"));
                    item.put("reason", rs.getString("reason"));
                    item.put("status", rs.getString("status"));
                    item.put("doctorMessage", rs.getString("doctor_message"));
                    item.put("respondedAt", rs.getTimestamp("responded_at"));
                    item.put("createdAt", rs.getTimestamp("created_at"));

                    appointments.add(item);
                }
            }

            request.setAttribute("appointments", appointments);

            request.getRequestDispatcher(
                "/doctor-appointments.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            getServletContext().log(
                "Unable to load doctor appointments", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load appointments."
            );
        }
    }

    // Approve or reject an appointment with a message
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String context = request.getContextPath();
        Integer doctorId = getDoctorId(request);

        if (doctorId == null) {
            response.sendRedirect(context + "/Doclogin.jsp");
            return;
        }

        String appointmentValue = request.getParameter("appointmentId");
        String action = request.getParameter("action");
        String message = request.getParameter("doctorMessage");

        int appointmentId;

        try {
            appointmentId = Integer.parseInt(appointmentValue);

            if (appointmentId <= 0) {
                throw new NumberFormatException();
            }
        } catch (Exception e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid appointment ID."
            );
            return;
        }

        if (!"APPROVE".equals(action) && !"REJECT".equals(action)) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid appointment action."
            );
            return;
        }

        message = message == null ? "" : message.trim();

        if (message.isEmpty() || message.length() > 500) {
            response.sendRedirect(
                context + "/doctor-dashboard.jsp#appointments"
            );
            return;
        }

        String newStatus =
            "APPROVE".equals(action) ? "CONFIRMED" : "CANCELLED";

        String sql =
            "UPDATE appointments SET status = ?, doctor_message = ?, " +
            "responded_at = CURRENT_TIMESTAMP " +
            "WHERE id = ? AND doctor_id = ? AND status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, message);
            ps.setInt(3, appointmentId);
            ps.setInt(4, doctorId);

            int updated = ps.executeUpdate();

            if (updated != 1) {
                response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    "Appointment not found, or it has already been processed."
                );
                return;
            }

            response.sendRedirect(
                context + "/doctor-dashboard.jsp#appointments"
            );

        } catch (Exception e) {
            getServletContext().log(
                "Unable to update appointment response", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to save the appointment response."
            );
        }
    }
}

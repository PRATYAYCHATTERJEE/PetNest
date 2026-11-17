
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
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String context = request.getContextPath();

        // Require a logged-in user
        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("userId") instanceof Integer)) {

            response.sendRedirect(context + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String doctorIdValue = request.getParameter("doctorId");
        String petName = request.getParameter("petName");
        String petType = request.getParameter("petType");
        String dateValue = request.getParameter("appointmentDate");
        String timeValue = request.getParameter("appointmentTime");
        String reason = request.getParameter("reason");

        // Validate required fields
        if (doctorIdValue == null ||
            petName == null ||
            dateValue == null ||
            timeValue == null ||
            petName.trim().isEmpty() ||
            dateValue.trim().isEmpty() ||
            timeValue.trim().isEmpty()) {

            redirectWithError(
                response, context, doctorIdValue, "missing"
            );
            return;
        }

        petName = petName.trim();
        petType = petType == null ? "" : petType.trim();
        reason = reason == null ? "" : reason.trim();

        // Validate input lengths
        if (petName.length() > 100 ||
            petType.length() > 50 ||
            reason.length() > 500) {

            redirectWithError(
                response, context, doctorIdValue, "invalid"
            );
            return;
        }

        final int doctorId;
        final LocalDate appointmentDate;
        final LocalTime appointmentTime;

        // Parse and validate appointment details
        try {
            doctorId = Integer.parseInt(doctorIdValue);
            appointmentDate = LocalDate.parse(dateValue);
            appointmentTime = LocalTime.parse(timeValue);

            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now()
                    .withSecond(0)
                    .withNano(0);

            if (doctorId <= 0 ||
                appointmentDate.isBefore(today) ||
                (appointmentDate.equals(today) &&
                 !appointmentTime.isAfter(now)) ||
                appointmentTime.getSecond() != 0 ||
                appointmentTime.getNano() != 0) {

                redirectWithError(
                    response, context, doctorIdValue, "invalid"
                );
                return;
            }

        } catch (RuntimeException e) {
            redirectWithError(
                response, context, doctorIdValue, "invalid"
            );
            return;
        }

        // Verify doctor and save appointment
        try (Connection conn = DBConnection.getConnection()) {

            if (conn == null) {
                throw new IllegalStateException(
                    "Database connection is unavailable."
                );
            }

            // Only approved doctors can receive appointments
            String doctorSql =
                "SELECT id FROM doctor_applications " +
                "WHERE id = ? AND status = 'APPROVED'";

            try (PreparedStatement ps =
                         conn.prepareStatement(doctorSql)) {

                ps.setInt(1, doctorId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        redirectWithError(
                            response, context, doctorIdValue,
                            "doctor"
                        );
                        return;
                    }
                }
            }

            // Insert appointment with PENDING status
            String insertSql =
                "INSERT INTO appointments " +
                "(doctor_id, user_id, pet_name, pet_type, " +
                "appointment_date, appointment_time, reason, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

            try (PreparedStatement ps =
                         conn.prepareStatement(insertSql)) {

                ps.setInt(1, doctorId);
                ps.setInt(2, userId);
                ps.setString(3, petName);

                if (petType.isEmpty()) {
                    ps.setNull(4, java.sql.Types.VARCHAR);
                } else {
                    ps.setString(4, petType);
                }

                ps.setDate(
                    5, Date.valueOf(appointmentDate)
                );

                ps.setTime(
                    6, Time.valueOf(appointmentTime)
                );

                if (reason.isEmpty()) {
                    ps.setNull(7, java.sql.Types.VARCHAR);
                } else {
                    ps.setString(7, reason);
                }

                int rowsInserted = ps.executeUpdate();

                if (rowsInserted != 1) {
                    throw new IllegalStateException(
                        "Appointment was not saved."
                    );
                }
            }

            // Show success message on the booking page
            response.sendRedirect(
                context + "/book-appointment.jsp?doctorId="
                + doctorId + "&appointment=success"
            );

        } catch (Exception e) {

            getServletContext().log(
                "Unable to book appointment", e
            );

            redirectWithError(
                response, context, doctorIdValue, "save"
            );
        }
    }

    // Redirect back to the booking page with a message code
    private void redirectWithError(
            HttpServletResponse response,
            String context,
            String doctorIdValue,
            String error)
            throws IOException {

        String safeDoctorId = "";

        if (doctorIdValue != null &&
            doctorIdValue.matches("[0-9]{1,10}")) {

            safeDoctorId = doctorIdValue;
        }

        response.sendRedirect(
            context + "/book-appointment.jsp?doctorId="
            + safeDoctorId + "&error=" + error
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendError(
            HttpServletResponse.SC_METHOD_NOT_ALLOWED,
            "Please submit the appointment form."
        );
    }
}

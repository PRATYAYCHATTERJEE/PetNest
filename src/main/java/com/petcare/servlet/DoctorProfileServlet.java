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
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/DoctorProfileServlet")
public class DoctorProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Require a logged-in PawCare user
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String idValue = request.getParameter("id");
        int doctorId;

        try {
            doctorId = Integer.parseInt(idValue);
            if (doctorId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid doctor ID."
            );
            return;
        }

        String sql =
            "SELECT id, full_name, email, phone, qualification, " +
            "specialization, registration_number, experience_years, " +
            "clinic_name, clinic_address, city, state, pin_code, status " +
            "FROM doctor_applications " +
            "WHERE id = ? AND status = 'APPROVED'";

        Map<String, Object> doctor = new LinkedHashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Approved doctor not found."
                    );
                    return;
                }

                doctor.put("id", rs.getInt("id"));
                doctor.put("fullName", rs.getString("full_name"));
                doctor.put("email", rs.getString("email"));
                doctor.put("phone", rs.getString("phone"));
                doctor.put("qualification", rs.getString("qualification"));
                doctor.put("specialization", rs.getString("specialization"));
                doctor.put("registrationNumber",
                           rs.getString("registration_number"));
                doctor.put("experienceYears",
                           rs.getInt("experience_years"));
                doctor.put("clinicName", rs.getString("clinic_name"));
                doctor.put("clinicAddress", rs.getString("clinic_address"));
                doctor.put("city", rs.getString("city"));
                doctor.put("state", rs.getString("state"));
                doctor.put("pinCode", rs.getString("pin_code"));
            }

        } catch (Exception e) {
            getServletContext().log(
                "Unable to load approved doctor profile.", e
            );

            throw new ServletException(
                "Unable to load doctor profile.", e
            );
        }

        request.setAttribute("doctor", doctor);

        request.getRequestDispatcher("/doctor-profile.jsp")
               .forward(request, response);
    }
}

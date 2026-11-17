
package com.petcare.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.petcare.util.DBConnection;

@WebServlet("/DoctorApplicationsServlet")
public class DoctorApplicationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Only logged-in administrators can view applications.
        HttpSession session = request.getSession(false);

        if (session == null ||
            !Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {

            if ("json".equalsIgnoreCase(request.getParameter("format"))) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(
                    "{\"error\":\"Admin login required\"}"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/admin-login.jsp"
                );
            }
            return;
        }

        List<DoctorApplication> applications = new ArrayList<>();

        String sql =
        	    "SELECT id, full_name, email, phone, qualification, " +
        	    "specialization, registration_number, experience_years, " +
        	    "clinic_name, clinic_address, city, state, pin_code, " +
        	    "registration_certificate, degree_certificate, " +
        	    "status, submitted_at " +
        	    "FROM doctor_applications " +
        	    "WHERE status = ? ORDER BY submitted_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "PENDING");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DoctorApplication d = new DoctorApplication();

                    d.id = rs.getInt("id");
                    d.fullName = rs.getString("full_name");
                    d.email = rs.getString("email");
                    d.phone = rs.getString("phone");
                    d.qualification = rs.getString("qualification");
                    d.specialization = rs.getString("specialization");
                    d.registrationNumber =
                        rs.getString("registration_number");
                    d.experienceYears =
                        rs.getString("experience_years");
                    d.clinicName = rs.getString("clinic_name");
                    d.city = rs.getString("city");
                    d.state = rs.getString("state");
                    d.status = rs.getString("status");
                    d.submittedAt = rs.getString("submitted_at");

                    applications.add(d);
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load doctor applications from the database.", e
            );
        }

        // Return JSON when requested by admin.js.
        if ("json".equalsIgnoreCase(request.getParameter("format"))) {

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try (PrintWriter out = response.getWriter()) {
                out.print("[");

                for (int i = 0; i < applications.size(); i++) {
                    DoctorApplication d = applications.get(i);

                    if (i > 0) {
                        out.print(",");
                    }

                    out.print("{");
                    out.print("\"id\":" + d.id + ",");
                    out.print("\"fullName\":\"" + jsonEscape(d.fullName) + "\",");
                    out.print("\"email\":\"" + jsonEscape(d.email) + "\",");
                    out.print("\"phone\":\"" + jsonEscape(d.phone) + "\",");
                    out.print("\"qualification\":\"" + jsonEscape(d.qualification) + "\",");
                    out.print("\"specialization\":\"" + jsonEscape(d.specialization) + "\",");
                    out.print("\"registrationNumber\":\"" + jsonEscape(d.registrationNumber) + "\",");
                    out.print("\"experienceYears\":\"" + jsonEscape(d.experienceYears) + "\",");
                    out.print("\"clinicName\":\"" + jsonEscape(d.clinicName) + "\",");
                    out.print("\"city\":\"" + jsonEscape(d.city) + "\",");
                    out.print("\"state\":\"" + jsonEscape(d.state) + "\",");
                    out.print("\"status\":\"" + jsonEscape(d.status) + "\",");
                    out.print("\"submittedAt\":\"" + jsonEscape(d.submittedAt) + "\"");
                    out.print("}");
                }

                out.print("]");
            }

        } else {
            // Direct browser access keeps using the existing admin.jsp.
            request.setAttribute("doctorApplications", applications);

            request.getRequestDispatcher("/admin.jsp")
                   .forward(request, response);
        }
    }

    private String jsonEscape(String value) {
        if (value == null) {
            return "";
        }

        StringBuilder result = new StringBuilder();

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
            }
        }

        return result.toString();
    }

    public static class DoctorApplication {
        public int id;
        public String fullName;
        public String email;
        public String phone;
        public String qualification;
        public String specialization;
        public String registrationNumber;
        public String experienceYears;
        public String clinicName;
        public String city;
        public String state;
        public String status;
        public String submittedAt;
        public String clinicAddress;
        public String pinCode;
        public String registrationCertificate;
        public String degreeCertificate;
    }
}

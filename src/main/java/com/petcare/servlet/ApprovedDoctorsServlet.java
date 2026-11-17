
package com.petcare.servlet;

import java.io.IOException;
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

import com.petcare.util.DBConnection;

@WebServlet("/ApprovedDoctorsServlet")
public class ApprovedDoctorsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public static class Doctor {
        private int id;
        private String fullName;
        private String qualification;
        private String specialization;
        private int experienceYears;
        private String clinicName;
        private String city;
        private String state;

        public Doctor(int id, String fullName, String qualification,
                      String specialization, int experienceYears,
                      String clinicName, String city, String state) {
            this.id = id;
            this.fullName = fullName;
            this.qualification = qualification;
            this.specialization = specialization;
            this.experienceYears = experienceYears;
            this.clinicName = clinicName;
            this.city = city;
            this.state = state;
        }

        public int getId() {
            return id;
        }

        public String getFullName() {
            return fullName;
        }

        public String getQualification() {
            return qualification;
        }

        public String getSpecialization() {
            return specialization;
        }

        public int getExperienceYears() {
            return experienceYears;
        }

        public String getClinicName() {
            return clinicName;
        }

        public String getCity() {
            return city;
        }

        public String getState() {
            return state;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Doctor> doctors = new ArrayList<>();

        String sql =
            "SELECT id, full_name, qualification, specialization, " +
            "experience_years, clinic_name, city, state " +
            "FROM doctor_applications " +
            "WHERE status = 'APPROVED' " +
            "ORDER BY full_name ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                doctors.add(new Doctor(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("qualification"),
                    rs.getString("specialization"),
                    rs.getInt("experience_years"),
                    rs.getString("clinic_name"),
                    rs.getString("city"),
                    rs.getString("state")
                ));
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load approved veterinarians.", e
            );
        }

        request.setAttribute("approvedDoctors", doctors);

        request.getRequestDispatcher("/approved-doctors.jsp")
               .forward(request, response);
    }
}

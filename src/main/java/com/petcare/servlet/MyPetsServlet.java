
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
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/MyPetsServlet")
public class MyPetsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int totalAppointments = 0;
        int totalOrderedItems = 0;
        List<Map<String, Object>> myPets = new ArrayList<>();

        // Existing pet-loading logic
        String petSql =
            "SELECT p.id, p.name, p.breed, p.animal_type, " +
            "p.gender, p.age, p.location, p.price, p.image, p.status " +
            "FROM my_pets mp " +
            "JOIN pets p ON mp.pet_id = p.id " +
            "WHERE mp.user_id = ? " +
            "ORDER BY mp.added_at DESC";

        // Approved doctors query
        String doctorSql =
            "SELECT id, full_name, qualification, specialization, " +
            "experience_years, clinic_name, city, state " +
            "FROM doctor_applications " +
            "WHERE status = 'APPROVED' " +
            "ORDER BY full_name ASC";

        try (Connection conn = DBConnection.getConnection()) {
        	String orderSql =
        		    "SELECT COALESCE(SUM(oi.quantity), 0) " +
        		    "FROM orders o " +
        		    "JOIN order_items oi ON o.id = oi.order_id " +
        		    "WHERE o.user_id = ?";

        		try (PreparedStatement ps = conn.prepareStatement(orderSql)) {
        		    ps.setInt(1, userId);

        		    try (ResultSet rs = ps.executeQuery()) {
        		        if (rs.next()) {
        		            totalOrderedItems = rs.getInt(1);
        		        }
        		    }
        		}
        	String appointmentSql =
        		    "SELECT COUNT(*) FROM appointments WHERE user_id = ?";

        		try (PreparedStatement ps = conn.prepareStatement(appointmentSql)) {
        		    ps.setInt(1, userId);

        		    try (ResultSet rs = ps.executeQuery()) {
        		        if (rs.next()) {
        		            totalAppointments = rs.getInt(1);
        		        }
        		    }
        		}
            // 1. Load the user's pets
            try (PreparedStatement ps = conn.prepareStatement(petSql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> pet = new LinkedHashMap<>();

                        pet.put("id", rs.getInt("id"));
                        pet.put("name", rs.getString("name"));
                        pet.put("breed", rs.getString("breed"));
                        pet.put("animalType", rs.getString("animal_type"));
                        pet.put("gender", rs.getString("gender"));
                        pet.put("age", rs.getString("age"));
                        pet.put("location", rs.getString("location"));
                        pet.put("price", rs.getBigDecimal("price"));
                        pet.put("image", rs.getString("image"));
                        pet.put("status", rs.getString("status"));

                        myPets.add(pet);
                    }
                }
            }

         // 1B. Load seller-uploaded pets purchased by the user
            String sellerPetSql =
                "SELECT sl.id, sl.title, sl.breed, sl.animal_type, " +
                "sl.gender, sl.age, sl.location, sl.price, sl.image " +
                "FROM my_pets mp " +
                "JOIN seller_listings sl ON mp.seller_listing_id = sl.id " +
                "WHERE mp.user_id = ? " +
                "AND sl.listing_type = 'PET' " +
                "ORDER BY mp.added_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(sellerPetSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Map<String, Object> pet = new LinkedHashMap<>();

                        pet.put("id", rs.getInt("id"));
                        pet.put("name", rs.getString("title"));
                        pet.put("breed", rs.getString("breed"));
                        pet.put("animalType", rs.getString("animal_type"));
                        pet.put("gender", rs.getString("gender"));
                        pet.put("age", rs.getString("age"));
                        pet.put("location", rs.getString("location"));
                        pet.put("price", rs.getBigDecimal("price"));

                        String image = rs.getString("image");

                        if (image != null && !image.trim().isEmpty()) {
                            image = request.getContextPath()
                                    + "/uploads/seller-listings/" + image;
                        }

                        pet.put("image", image);
                        pet.put("status", "OWNED");
                        pet.put("sourceType", "SELLER");

                        myPets.add(pet);
                    }
                }
            }
            
            
            
            
            
            // 2. Load approved doctors
            List<ApprovedDoctorsServlet.Doctor> approvedDoctors =
                new ArrayList<>();

            try (PreparedStatement ps = conn.prepareStatement(doctorSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    approvedDoctors.add(
                        new ApprovedDoctorsServlet.Doctor(
                            rs.getInt("id"),
                            rs.getString("full_name"),
                            rs.getString("qualification"),
                            rs.getString("specialization"),
                            rs.getInt("experience_years"),
                            rs.getString("clinic_name"),
                            rs.getString("city"),
                            rs.getString("state")
                        )
                    );
                }
            }

            // 3. Send both lists to the existing dashboard JSP
            request.setAttribute("myPets", myPets);
            request.setAttribute("approvedDoctors", approvedDoctors);
            request.setAttribute("totalPets", myPets.size());
            request.setAttribute("totalAppointments", totalAppointments);
            request.setAttribute("totalOrderedItems", totalOrderedItems);
            System.out.println("Purchased pets found: " + myPets.size());
            System.out.println("Approved doctors found: " + approvedDoctors.size());
            

            // Keep your existing dashboard
            request.getRequestDispatcher("/home.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            getServletContext().log(
                "Error retrieving pets and approved doctors", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load dashboard data. Check the Tomcat console."
            );
        }
    }
}

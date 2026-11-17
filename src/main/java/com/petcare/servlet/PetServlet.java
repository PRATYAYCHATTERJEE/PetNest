package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/PetServlet")
public class PetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String sql = """
                SELECT id, name, breed, animal_type, gender,
                       age, location, price, image, status
                FROM pets
                WHERE status = 'AVAILABLE'
                """;

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            PrintWriter out = response.getWriter();

            out.println("<h1>Available Pets</h1>");

            while (rs.next()) {

                out.println("<div>");

                out.println("<h2>" + rs.getString("name") + "</h2>");

                out.println("<p>Breed: "
                        + rs.getString("breed") + "</p>");

                out.println("<p>Animal: "
                        + rs.getString("animal_type") + "</p>");

                out.println("<p>Gender: "
                        + rs.getString("gender") + "</p>");

                out.println("<p>Age: "
                        + rs.getString("age") + "</p>");

                out.println("<p>Location: "
                        + rs.getString("location") + "</p>");

                out.println("<p>Price: ₹"
                        + rs.getDouble("price") + "</p>");

                out.println("<p>Status: "
                        + rs.getString("status") + "</p>");

                out.println("<hr>");
                out.println("</div>");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println(
                "<h2>Pet Loading Error</h2>" +
                "<p>" + e.getMessage() + "</p>"
            );
        }
    }
}
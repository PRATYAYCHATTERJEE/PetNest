package com.petcare.servlet;

import com.petcare.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get values from register.jsp
        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Check received values
        System.out.println("========== REGISTRATION ==========");
        System.out.println("Name     : " + fullName);
        System.out.println("Email    : " + email);
        System.out.println("Phone    : " + phone);
        System.out.println("Password : " + (password != null ? "RECEIVED" : "NULL"));

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Registration Error</h2>");
            response.getWriter().println("<p>Name, email and password are required.</p>");
            return;
        }

        String sql = """
                INSERT INTO users (full_name, email, phone, password)
                VALUES (?, ?, ?, ?)
                """;

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, fullName.trim());
            ps.setString(2, email.trim());
            ps.setString(3, phone);
            ps.setString(4, password);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                System.out.println("REGISTRATION SUCCESSFUL!");

                response.sendRedirect("login.jsp");

            } else {

                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<h2>Registration Failed</h2>");
            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h2>Registration Error</h2>");
            response.getWriter().println("<p>" + e.getMessage() + "</p>");
        }
    }
}
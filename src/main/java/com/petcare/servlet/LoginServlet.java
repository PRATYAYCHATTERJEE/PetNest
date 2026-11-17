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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String sql = "SELECT id, full_name, email FROM users WHERE email = ? AND password = ?";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // Login successful
                HttpSession session = request.getSession();

                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("full_name"));
                session.setAttribute("userEmail", rs.getString("email"));

                response.sendRedirect("MyPetsServlet");

            } else {

                // Login failed
                response.setContentType("text/html");

                response.getWriter().println(
                    "<h2>Login Failed</h2>" +
                    "<p>Invalid email or password.</p>" +
                    "<a href='login.jsp'>Try Again</a>"
                );
            }

        } catch (Exception e) {

            response.setContentType("text/html");

            response.getWriter().println(
                "<h2>Login Error</h2>" +
                "<p>" + e.getMessage() + "</p>"
            );

            e.printStackTrace();
        }
    }
}
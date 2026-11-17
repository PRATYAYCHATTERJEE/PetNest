
package com.petcare.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private String adminEmail;
    private String adminPasswordHash;

    @Override
    public void init() throws ServletException {

        // Local development credentials
        adminEmail = "p@gamil.com";

        // SHA-256 hash of password: 123456
        adminPasswordHash =
            "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92";
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean valid = false;

        if (email != null && password != null
                && email.trim().equalsIgnoreCase(adminEmail)) {

            try {
                MessageDigest digest =
                    MessageDigest.getInstance("SHA-256");

                byte[] hash = digest.digest(
                    password.getBytes(StandardCharsets.UTF_8)
                );

                StringBuilder hex = new StringBuilder();

                for (byte b : hash) {
                    hex.append(String.format("%02x", b & 0xff));
                }

                valid = MessageDigest.isEqual(
                    hex.toString().getBytes(StandardCharsets.UTF_8),
                    adminPasswordHash.getBytes(StandardCharsets.UTF_8)
                );

            } catch (Exception e) {
                throw new ServletException(
                    "Unable to validate administrator credentials.", e
                );
            }
        }

        if (valid) {

            // Invalidate any existing session before creating an admin session
            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);

            session.setAttribute("isAdmin", Boolean.TRUE);
            session.setAttribute("adminEmail", adminEmail);
            session.setMaxInactiveInterval(20 * 60);

            response.sendRedirect(
                request.getContextPath() + "/admin.jsp"
            );

        } else {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp?error=1"
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/admin-login.jsp"
        );
    }
}

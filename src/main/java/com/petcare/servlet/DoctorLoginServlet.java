
package com.petcare.servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.petcare.util.DBConnection;

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.isEmpty()) {
            response.sendRedirect(
                request.getContextPath() + "/Doclogin.jsp?error=empty"
            );
            return;
        }

        String sql =
            "SELECT id, full_name, email, password_hash, status " +
            "FROM doctor_applications WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setString(1, email.trim());

            try (ResultSet rs = statement.executeQuery()) {

                if (!rs.next()) {
                    loginFailed(response, request);
                    return;
                }

                int doctorId = rs.getInt("id");
                String fullName = rs.getString("full_name");
                String storedHash = rs.getString("password_hash");
                String status = rs.getString("status");

                // Only approved doctors may sign in.
                if (!"APPROVED".equals(status)) {
                    response.sendRedirect(
                        request.getContextPath() +
                        "/Doclogin.jsp?error=" +
                        ("PENDING".equals(status) ? "pending" : "rejected")
                    );
                    return;
                }

                if (!verifyPassword(password, storedHash)) {
                    loginFailed(response, request);
                    return;
                }

                // Create a fresh session after successful authentication.
                HttpSession oldSession = request.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("isDoctor", Boolean.TRUE);
                session.setAttribute("doctorId", doctorId);
                session.setAttribute("doctorName", fullName);
                session.setAttribute("doctorEmail", email.trim());
                session.setMaxInactiveInterval(30 * 60);

                response.sendRedirect(
                    request.getContextPath() + "/doctor-dashboard.jsp"
                );
                return;
            }

        } catch (Exception e) {
            throw new ServletException("Doctor login failed.", e);
        }
    }

    private boolean verifyPassword(String password, String storedHash)
            throws NoSuchAlgorithmException, InvalidKeySpecException {

        if (storedHash == null || storedHash.trim().isEmpty()) {
            return false;
        }

        /*
         * Expected registration format:
         * pbkdf2_sha256$iterations$saltBase64$hashBase64
         */
        String[] parts = storedHash.split("\\$");

        if (parts.length != 4 ||
            !"pbkdf2_sha256".equals(parts[0])) {
            return false;
        }

        int iterations = Integer.parseInt(parts[1]);
        byte[] salt = java.util.Base64.getDecoder().decode(parts[2]);
        byte[] expectedHash = java.util.Base64.getDecoder().decode(parts[3]);

        if (iterations < 10000 || iterations > 1000000 ||
            salt.length < 8 || expectedHash.length < 16) {
            return false;
        }

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            iterations,
            expectedHash.length * 8
        );

        byte[] actualHash = null;

        try {
            SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            actualHash = factory.generateSecret(spec).getEncoded();

            return MessageDigest.isEqual(actualHash, expectedHash);

        } finally {
            spec.clearPassword();

            if (actualHash != null) {
                Arrays.fill(actualHash, (byte) 0);
            }
        }
    }

    

    private void loginFailed(HttpServletResponse response,
                             HttpServletRequest request)
            throws IOException {

        response.sendRedirect(
            request.getContextPath() + "/Doclogin.jsp?error=invalid"
        );
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
            request.getContextPath() + "/Doclogin.jsp"
        );
    }
}

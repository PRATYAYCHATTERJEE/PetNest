
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.spec.InvalidKeySpecException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SellerLoginServlet")
public class SellerLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String HASH_ALGORITHM =
            "PBKDF2WithHmacSHA256";

    private static final int ITERATIONS = 600000;
    private static final int KEY_LENGTH = 256;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/seller-login.jsp"
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        email = email == null ? "" : email.trim();

        if (email.isEmpty() || password == null || password.isEmpty()) {
            showError(request, response,
                    "Please enter your email address and password.", email);
            return;
        }

        String sql =
                "SELECT id, full_name, email, password, seller_type, " +
                "application_status " +
                "FROM seller_applications WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    showError(request, response,
                            "Invalid email or password.", email);
                    return;
                }

                String storedPassword = rs.getString("password");

                if (!verifyPassword(password, storedPassword)) {
                    showError(request, response,
                            "Invalid email or password.", email);
                    return;
                }

                int sellerId = rs.getInt("id");
                String fullName = rs.getString("full_name");
                String sellerEmail = rs.getString("email");
                String sellerType = rs.getString("seller_type");
                String status = rs.getString("application_status");

                if ("PENDING".equalsIgnoreCase(status)) {
                    showError(request, response,
                            "Your seller application is still pending admin approval.",
                            email);
                    return;
                }

                if ("REJECTED".equalsIgnoreCase(status)) {
                    showError(request, response,
                            "Your seller application was rejected. Please contact PawCare support.",
                            email);
                    return;
                }

                if (!"APPROVED".equalsIgnoreCase(status)) {
                    showError(request, response,
                            "Your account cannot be accessed at this time.",
                            email);
                    return;
                }

                // Create a fresh session after successful authentication.
                HttpSession oldSession = request.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);

                session.setAttribute("sellerId", sellerId);
                session.setAttribute("sellerName", fullName);
                session.setAttribute("sellerEmail", sellerEmail);
                session.setAttribute("sellerType", sellerType);
                session.setAttribute("sellerLoggedIn", Boolean.TRUE);

                session.setMaxInactiveInterval(30 * 60);

                response.sendRedirect(
                        request.getContextPath() + "/seller-dashboard.jsp"
                );
            }

        } catch (SQLException e) {
            log("Database error during seller login", e);

            showError(request, response,
                    "A server error occurred. Please try again later.",
                    email);

        } catch (IllegalArgumentException e) {
            log("Invalid stored password format for seller login", e);

            showError(request, response,
                    "Unable to verify your account. Please contact support.",
                    email);
        }
    }

    private boolean verifyPassword(String password, String storedPassword)
            throws IllegalArgumentException {

        if (storedPassword == null) {
            return false;
        }

        String[] parts = storedPassword.split(":", -1);

        if (parts.length != 2) {
            return false;
        }

        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[1]);

        if (salt.length != 16 || expectedHash.length != 32) {
            return false;
        }

        char[] passwordChars = password.toCharArray();

        PBEKeySpec spec = new PBEKeySpec(
                passwordChars,
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        byte[] actualHash = null;

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance(HASH_ALGORITHM);

            actualHash = factory.generateSecret(spec).getEncoded();

            return MessageDigest.isEqual(expectedHash, actualHash);

        } catch (java.security.NoSuchAlgorithmException |
                 InvalidKeySpecException e) {

            throw new IllegalStateException(
                    "Password verification is unavailable.", e
            );

        } finally {
            spec.clearPassword();
            java.util.Arrays.fill(passwordChars, '\0');

            if (actualHash != null) {
                java.util.Arrays.fill(actualHash, (byte) 0);
            }
        }
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message,
                           String email)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);
        request.setAttribute("email", email);

        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        request.getRequestDispatcher("/seller-login.jsp")
               .forward(request, response);
    }
}

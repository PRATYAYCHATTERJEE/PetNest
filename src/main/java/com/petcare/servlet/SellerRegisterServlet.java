
package com.petcare.servlet;

import com.petcare.util.DBConnection;

import java.io.IOException;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SellerRegisterServlet")
@MultipartConfig
public class SellerRegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Securely hash the password using PBKDF2
    private String hashPassword(String password) throws Exception {

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        KeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                600000,
                256
        );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

        byte[] hash = factory.generateSecret(spec).getEncoded();

        return Base64.getEncoder().encodeToString(salt)
                + ":"
                + Base64.getEncoder().encodeToString(hash);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirm_password");
        String sellerType = request.getParameter("seller_type");
        String businessName = request.getParameter("business_name");
        String address = request.getParameter("address");

        // 1. Check required fields
        if (fullName == null || email == null || phone == null
                || password == null || confirmPassword == null
                || sellerType == null || address == null
                || fullName.trim().isEmpty()
                || email.trim().isEmpty()
                || phone.trim().isEmpty()
                || password.isEmpty()
                || confirmPassword.isEmpty()
                || address.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register.jsp?error=missing");
            return;
        }

        fullName = fullName.trim();
        email = email.trim().toLowerCase();
        phone = phone.trim();
        address = address.trim();

        // 2. Confirm passwords match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register.jsp?error=password");
            return;
        }

        // 3. Password validation
        if (password.length() < 8 || password.length() > 128) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register.jsp?error=weakpassword");
            return;
        }

        // 4. Validate seller type
        if (!"PET_SELLER".equals(sellerType)
                && !"PRODUCT_SELLER".equals(sellerType)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register.jsp?error=sellertype");
            return;
        }

        // 5. Validate field lengths
        if (fullName.length() > 100
                || email.length() > 150
                || phone.length() > 20
                || address.length() > 10000
                || (businessName != null
                    && businessName.trim().length() > 150)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register.jsp?error=invalid");
            return;
        }

        String insertSql =
                "INSERT INTO seller_applications "
                + "(full_name, email, phone, password, seller_type, "
                + "business_name, address, application_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new SQLException(
                        "DBConnection returned a null connection.");
            }

            // 6. Check for duplicate seller email
            String checkSql =
                    "SELECT id FROM seller_applications WHERE email = ?";

            try (PreparedStatement check =
                    con.prepareStatement(checkSql)) {

                check.setString(1, email);

                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect(
                                request.getContextPath()
                                + "/seller-register.jsp?error=exists");
                        return;
                    }
                }
            }

            // 7. Hash password before storing it
            String hashedPassword = hashPassword(password);

            // 8. Insert seller application as PENDING
            try (PreparedStatement ps =
                    con.prepareStatement(insertSql)) {

                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setString(4, hashedPassword);
                ps.setString(5, sellerType);

                if (businessName == null
                        || businessName.trim().isEmpty()) {
                    ps.setNull(6, java.sql.Types.VARCHAR);
                } else {
                    ps.setString(6, businessName.trim());
                }

                ps.setString(7, address);

                int rows = ps.executeUpdate();

                if (rows != 1) {
                    throw new SQLException(
                            "Seller application was not inserted.");
                }
            }

            // 9. Successful registration
            response.sendRedirect(
                    request.getContextPath()
                    + "/seller-register-success.jsp");

        } catch (SQLException e) {

            e.printStackTrace();

            getServletContext().log(
                    "Seller registration database error", e);

            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/seller-register.jsp?error=exists");
                return;
            }

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Registration failed. Check the Eclipse Console.");

        } catch (Exception e) {

            e.printStackTrace();

            getServletContext().log(
                    "Seller registration password hashing error", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Registration failed. Check the Eclipse Console.");
        }
    }
}

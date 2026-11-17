package com.petcare.servlet;

import com.petcare.util.DBConnection;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/EditSellerListingServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 7 * 1024 * 1024
)
public class EditSellerListingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024;

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private void sendJson(
            HttpServletResponse response,
            int status,
            String message) throws IOException {

        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String safe = message.replace("\\", "\\\\")
                              .replace("\"", "\\\"");

        response.getWriter().write(
            "{\"success\":" + (status == 200) +
            ",\"message\":\"" + safe + "\"}"
        );
    }

    private boolean isApprovedSeller(Connection con, int sellerId)
            throws SQLException {

        String sql =
            "SELECT id FROM seller_applications " +
            "WHERE id = ? AND application_status = 'APPROVED'";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sellerId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null
                || !Boolean.TRUE.equals(session.getAttribute("sellerLoggedIn"))
                || session.getAttribute("sellerId") == null) {

            sendJson(response, 401, "Please log in again.");
            return;
        }

        int sellerId;

        try {
            sellerId = Integer.parseInt(
                String.valueOf(session.getAttribute("sellerId"))
            );
        } catch (NumberFormatException e) {
            sendJson(response, 401, "Invalid seller session.");
            return;
        }

        String sellerType = clean(
            String.valueOf(session.getAttribute("sellerType"))
        );

        boolean petSeller = "PET_SELLER".equals(sellerType);

        if (!petSeller && !"PRODUCT_SELLER".equals(sellerType)) {
            sendJson(response, 403, "Invalid seller type.");
            return;
        }

        int listingId;

        try {
            listingId = Integer.parseInt(
                clean(request.getParameter("listingId"))
            );

            if (listingId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            sendJson(response, 400, "Invalid listing ID.");
            return;
        }

        // Validate price
        BigDecimal price;

        try {
            price = new BigDecimal(
                clean(request.getParameter("price"))
            );

            if (price.compareTo(BigDecimal.ZERO) <= 0
                    || price.scale() > 2
                    || price.precision() > 10) {

                sendJson(response, 400, "Enter a valid price.");
                return;
            }

        } catch (NumberFormatException | NullPointerException e) {
            sendJson(response, 400, "Enter a valid price.");
            return;
        }

        // Pet-specific editable fields
        String age = clean(request.getParameter("age"));
        String weight = clean(request.getParameter("weight"));
        String size = clean(request.getParameter("size"));
        String location = clean(request.getParameter("location"));

        if (petSeller) {
            if (age.length() > 50
                    || weight.length() > 50
                    || size.length() > 50
                    || location.isEmpty()
                    || location.length() > 200) {

                sendJson(response, 400, "Please check the pet details.");
                return;
            }

            if (!size.isEmpty()
                    && !size.equals("Small")
                    && !size.equals("Medium")
                    && !size.equals("Large")) {

                sendJson(response, 400, "Invalid pet size.");
                return;
            }
        }

        // Image is optional while editing
        Part imagePart;

        try {
            imagePart = request.getPart("image");
        } catch (IllegalStateException e) {
            sendJson(response, 400, "Image is too large.");
            return;
        }

        boolean hasNewImage =
            imagePart != null && imagePart.getSize() > 0;

        String newFileName = null;
        File savedFile = null;
        boolean imageSaved = false;

        if (hasNewImage) {

            if (imagePart.getSize() > MAX_IMAGE_SIZE) {
                sendJson(response, 400, "Image must be under 5 MB.");
                return;
            }

            String submittedName = imagePart.getSubmittedFileName();

            if (submittedName == null) {
                sendJson(response, 400, "Invalid image.");
                return;
            }

            String extension = "";
            int dot = submittedName.lastIndexOf('.');

            if (dot >= 0) {
                extension = submittedName.substring(dot).toLowerCase();
            }

            if (!extension.equals(".jpg")
                    && !extension.equals(".jpeg")
                    && !extension.equals(".png")
                    && !extension.equals(".webp")) {

                sendJson(response, 400, "Only JPG, PNG and WebP images are allowed.");
                return;
            }

            String contentType = imagePart.getContentType();

            if (contentType == null
                    || !(contentType.equalsIgnoreCase("image/jpeg")
                    || contentType.equalsIgnoreCase("image/png")
                    || contentType.equalsIgnoreCase("image/webp"))) {

                sendJson(response, 400, "Invalid image format.");
                return;
            }

            String realPath = getServletContext()
                .getRealPath("/uploads/seller-listings");

            if (realPath == null) {
                sendJson(response, 500, "Image storage is unavailable.");
                return;
            }

            File uploadDir = new File(realPath);

            if (!uploadDir.exists() && !uploadDir.mkdirs()) {
                sendJson(response, 500, "Could not create image folder.");
                return;
            }

            newFileName = UUID.randomUUID().toString() + extension;
            savedFile = new File(uploadDir, newFileName);

            if (!savedFile.getCanonicalPath().startsWith(
                    uploadDir.getCanonicalPath() + File.separator)) {

                sendJson(response, 400, "Invalid image path.");
                return;
            }

            try (java.io.InputStream input = imagePart.getInputStream()) {
                Files.copy(input, savedFile.toPath());
                imageSaved = true;
            }
        }

        String sql;

        if (petSeller) {
            sql = hasNewImage
                ? "UPDATE seller_listings SET age=?, weight=?, size=?, " +
                  "location=?, price=?, image=? " +
                  "WHERE id=? AND seller_id=? AND listing_type='PET' " +
                  "AND listing_status='AVAILABLE'"
                : "UPDATE seller_listings SET age=?, weight=?, size=?, " +
                  "location=?, price=? " +
                  "WHERE id=? AND seller_id=? AND listing_type='PET' " +
                  "AND listing_status='AVAILABLE'";
        } else {
            sql = hasNewImage
                ? "UPDATE seller_listings SET price=?, image=? " +
                  "WHERE id=? AND seller_id=? AND listing_type='PRODUCT' " +
                  "AND listing_status='AVAILABLE'"
                : "UPDATE seller_listings SET price=? " +
                  "WHERE id=? AND seller_id=? AND listing_type='PRODUCT' " +
                  "AND listing_status='AVAILABLE'";
        }

        try (Connection con = DBConnection.getConnection()) {

            if (!isApprovedSeller(con, sellerId)) {
                if (imageSaved) Files.deleteIfExists(savedFile.toPath());
                sendJson(response, 403, "Seller account is not approved.");
                return;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                int index = 1;

                if (petSeller) {
                    ps.setString(index++, age);
                    ps.setString(index++, weight);
                    ps.setString(index++, size);
                    ps.setString(index++, location);
                    ps.setBigDecimal(index++, price);

                    if (hasNewImage) {
                        ps.setString(index++, newFileName);
                    }
                } else {
                    ps.setBigDecimal(index++, price);

                    if (hasNewImage) {
                        ps.setString(index++, newFileName);
                    }
                }

                ps.setInt(index++, listingId);
                ps.setInt(index, sellerId);

                int updated = ps.executeUpdate();

                if (updated == 1) {
                    sendJson(response, 200, "Listing updated successfully.");
                } else {
                    sendJson(response, 409,
                        "Listing not found, not owned by you, or already sold.");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();

            sendJson(response, 500, "Could not update listing.");

        } finally {
            // Remove a newly uploaded image if the update did not succeed.
            // The old image is deliberately retained.
        }
    }
}

package com.petcare.dao;

import com.petcare.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class OrderDao {

    public int placeOrder(
            int userId,
            String fullName,
            String phone,
            String address,
            String city,
            String pincode,
            String paymentMethod
    ) throws SQLException {

        String cartSql =
            "SELECT id, product_name, seller_listing_id, price, quantity " +
            "FROM store_cart WHERE user_id = ? ORDER BY id FOR UPDATE";

        String petSql =
            "SELECT sl.id, sl.title, sl.price, sl.listing_status " +
            "FROM seller_listings sl " +
            "JOIN seller_applications sa ON sl.seller_id = sa.id " +
            "WHERE sl.id = ? " +
            "AND sl.listing_type = 'PET' " +
            "AND UPPER(COALESCE(sa.application_status, '')) = 'APPROVED' " +
            "FOR UPDATE";

        String orderSql =
            "INSERT INTO orders " +
            "(user_id, pet_id, seller_listing_id, amount, order_status, " +
            "full_name, phone, delivery_address, city, pincode, payment_method) " +
            "VALUES (?, NULL, NULL, ?, 'PLACED', ?, ?, ?, ?, ?, ?)";

        String itemSql =
            "INSERT INTO order_items " +
            "(order_id, item_type, seller_listing_id, product_name, " +
            "unit_price, quantity, subtotal) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

        String myPetSql =
            "INSERT INTO my_pets " +
            "(user_id, pet_id, seller_listing_id, order_id) " +
            "VALUES (?, NULL, ?, ?)";

        String updatePetSql =
            "UPDATE seller_listings " +
            "SET listing_status = 'SOLD' " +
            "WHERE id = ? AND listing_status = 'AVAILABLE'";

        String clearCartSql =
            "DELETE FROM store_cart WHERE user_id = ?";

        if (fullName == null || fullName.trim().isEmpty()
                || phone == null || !phone.matches("[0-9]{10}")
                || address == null || address.trim().isEmpty()
                || city == null || city.trim().isEmpty()
                || pincode == null || !pincode.matches("[0-9]{6}")
                || !"COD".equals(paymentMethod)) {

            throw new SQLException("Invalid checkout information.");
        }

        try (Connection conn = DBConnection.getConnection()) {

            boolean previousAutoCommit = conn.getAutoCommit();

            try {
                conn.setAutoCommit(false);

                BigDecimal total = BigDecimal.ZERO;
                int orderId;

                // 1. Lock and read cart items
                try (PreparedStatement cartPs =
                         conn.prepareStatement(cartSql)) {

                    cartPs.setInt(1, userId);

                    try (ResultSet cartRs = cartPs.executeQuery()) {

                        // We process items below after collecting them.
                        java.util.List<CartItem> cartItems =
                            new java.util.ArrayList<>();

                        while (cartRs.next()) {

                            CartItem item = new CartItem();

                            item.id = cartRs.getInt("id");
                            item.name =
                                cartRs.getString("product_name");

                            item.listingId =
                                cartRs.getInt("seller_listing_id");

                            if (cartRs.wasNull()) {
                                item.listingId = null;
                            }

                            item.price =
                                cartRs.getBigDecimal("price");

                            item.quantity =
                                cartRs.getInt("quantity");

                            if (item.price == null
                                    || item.price.compareTo(BigDecimal.ZERO) <= 0
                                    || item.quantity <= 0) {

                                throw new SQLException(
                                    "Invalid cart item or price."
                                );
                            }

                            cartItems.add(item);
                        }

                        if (cartItems.isEmpty()) {
                            throw new SQLException(
                                "Your cart is empty."
                            );
                        }

                        // 2. Validate items and calculate total
                        try (PreparedStatement petPs =
                                 conn.prepareStatement(petSql)) {

                            for (CartItem item : cartItems) {

                                if (item.listingId != null) {

                                    // A seller-listed pet must be quantity 1.
                                    if (item.quantity != 1) {
                                        throw new SQLException(
                                            "A seller-listed pet can only be purchased once."
                                        );
                                    }

                                    petPs.setInt(1, item.listingId);

                                    try (ResultSet petRs =
                                             petPs.executeQuery()) {

                                        if (!petRs.next()) {
                                            throw new SQLException(
                                                "Seller pet not found or seller is not approved."
                                            );
                                        }

                                        String status =
                                            petRs.getString("listing_status");

                                        if (!"AVAILABLE".equalsIgnoreCase(status)) {
                                            throw new SQLException(
                                                "A pet in your cart is no longer available."
                                            );
                                        }

                                        // Always use the current database price.
                                        item.name =
                                            petRs.getString("title");

                                        item.price =
                                            petRs.getBigDecimal("price");

                                        if (item.price == null ||
                                                item.price.compareTo(BigDecimal.ZERO) <= 0) {
                                            throw new SQLException(
                                                "Invalid seller pet price."
                                            );
                                        }
                                    }
                                }

                                BigDecimal subtotal =
                                    item.price.multiply(
                                        BigDecimal.valueOf(item.quantity)
                                    );

                                total = total.add(subtotal);
                            }
                        }

                        // 3. Create one order for the complete cart
                        try (PreparedStatement orderPs =
                                 conn.prepareStatement(
                                     orderSql,
                                     Statement.RETURN_GENERATED_KEYS
                                 )) {

                            orderPs.setInt(1, userId);
                            orderPs.setBigDecimal(2, total);
                            orderPs.setString(3, fullName.trim());
                            orderPs.setString(4, phone);
                            orderPs.setString(5, address.trim());
                            orderPs.setString(6, city.trim());
                            orderPs.setString(7, pincode);
                            orderPs.setString(8, paymentMethod);

                            orderPs.executeUpdate();

                            try (ResultSet keys =
                                     orderPs.getGeneratedKeys()) {

                                if (!keys.next()) {
                                    throw new SQLException(
                                        "Could not generate order ID."
                                    );
                                }

                                orderId = keys.getInt(1);
                            }
                        }

                        // 4. Insert order items and update seller pets
                        try (PreparedStatement itemPs =
                                 conn.prepareStatement(itemSql);
                             PreparedStatement myPetPs =
                                 conn.prepareStatement(myPetSql);
                             PreparedStatement updatePs =
                                 conn.prepareStatement(updatePetSql)) {

                            for (CartItem item : cartItems) {

                                BigDecimal subtotal =
                                    item.price.multiply(
                                        BigDecimal.valueOf(item.quantity)
                                    );

                                String itemType =
                                    item.listingId != null
                                        ? "PET"
                                        : "PRODUCT";

                                itemPs.setInt(1, orderId);
                                itemPs.setString(2, itemType);

                                if (item.listingId != null) {
                                    itemPs.setInt(3, item.listingId);
                                } else {
                                    itemPs.setNull(
                                        3,
                                        java.sql.Types.INTEGER
                                    );
                                }

                                itemPs.setString(4, item.name);
                                itemPs.setBigDecimal(5, item.price);
                                itemPs.setInt(6, item.quantity);
                                itemPs.setBigDecimal(7, subtotal);

                                itemPs.executeUpdate();

                                // Add purchased seller pets to My Pets.
                                if (item.listingId != null) {

                                    myPetPs.setInt(1, userId);
                                    myPetPs.setInt(2, item.listingId);
                                    myPetPs.setInt(3, orderId);

                                    myPetPs.executeUpdate();

                                    // Mark seller pet as SOLD.
                                    updatePs.setInt(1, item.listingId);

                                    int updated =
                                        updatePs.executeUpdate();

                                    if (updated != 1) {
                                        throw new SQLException(
                                            "Unable to update seller pet availability."
                                        );
                                    }
                                }
                            }
                        }

                        // 5. Clear cart only after successful inserts.
                        try (PreparedStatement clearPs =
                                 conn.prepareStatement(clearCartSql)) {

                            clearPs.setInt(1, userId);
                            clearPs.executeUpdate();
                        }
                    }
                }

                // 6. Commit everything together.
                conn.commit();

                return orderId;

            } catch (Exception e) {

                conn.rollback();

                if (e instanceof SQLException) {
                    throw (SQLException) e;
                }

                throw new SQLException(
                    "Order placement failed.", e
                );

            } finally {

                try {
                    conn.setAutoCommit(previousAutoCommit);
                } catch (SQLException e) {
                    // Connection will be closed by try-with-resources.
                }
            }
        }
    }


    // Internal cart item representation
    private static class CartItem {

        int id;
        String name;
        Integer listingId;
        BigDecimal price;
        int quantity;
    }
}

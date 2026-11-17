
package com.petcare.dao;

import com.petcare.model.Cart;
import com.petcare.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDao {

    // ==========================================
    // 1. ADD SELLER PET TO CART
    // ==========================================
    public boolean addSellerPet(int userId, int listingId)
            throws SQLException {

    	String selectSql =
    		    "SELECT sl.title, sl.price " +
    		    "FROM seller_listings sl " +
    		    "JOIN seller_applications sa " +
    		    "ON sl.seller_id = sa.id " +
    		    "WHERE sl.id = ? " +
    		    "AND sl.listing_type = 'PET' " +
    		    "AND sl.listing_status = 'AVAILABLE' " +
    		    "AND sa.application_status = 'APPROVED'";

        String insertSql =
            "INSERT INTO store_cart " +
            "(user_id, product_name, seller_listing_id, price, quantity) " +
            "VALUES (?, ?, ?, ?, 1) " +
            "ON DUPLICATE KEY UPDATE quantity = quantity + 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement selectPs =
                 con.prepareStatement(selectSql)) {

            selectPs.setInt(1, listingId);

            try (ResultSet rs = selectPs.executeQuery()) {

                if (!rs.next()) {
                    return false;
                }

                String petName = rs.getString("title");
                BigDecimal price = rs.getBigDecimal("price");

                String cartName =
                    "[SELLER_PET:" + listingId + "] " + petName;

                try (PreparedStatement insertPs =
                         con.prepareStatement(insertSql)) {

                    insertPs.setInt(1, userId);
                    insertPs.setString(2, cartName);
                    insertPs.setInt(3, listingId);
                    insertPs.setBigDecimal(4, price);

                    return insertPs.executeUpdate() > 0;
                }
            }
        }
    }


    // ==========================================
    // 2. ADD STORE PRODUCT TO CART
    // ==========================================
    public boolean addProduct(int userId, String productName,
            BigDecimal price)
throws SQLException {

String updateSql =
"UPDATE store_cart " +
"SET quantity = quantity + 1 " +
"WHERE user_id = ? " +
"AND product_name = ? " +
"AND seller_listing_id IS NULL " +
"AND price = ?";

String insertSql =
"INSERT INTO store_cart " +
"(user_id, product_name, seller_listing_id, price, quantity) " +
"VALUES (?, ?, NULL, ?, 1)";

try (Connection con = DBConnection.getConnection()) {

try (PreparedStatement updatePs =
   con.prepareStatement(updateSql)) {

updatePs.setInt(1, userId);
updatePs.setString(2, productName);
updatePs.setBigDecimal(3, price);

int updated = updatePs.executeUpdate();

if (updated > 0) {
  return true;
}
}

try (PreparedStatement insertPs =
   con.prepareStatement(insertSql)) {

insertPs.setInt(1, userId);
insertPs.setString(2, productName);
insertPs.setBigDecimal(3, price);

return insertPs.executeUpdate() > 0;
}
}
}

    // ==========================================
    // 3. GET ALL CART ITEMS FOR A USER
    // ==========================================
    public List<Cart> getCartItems(int userId)
            throws SQLException {

        List<Cart> cartList = new ArrayList<>();

        String sql =
            "SELECT sc.id, sc.user_id, sc.product_name, " +
            "sc.seller_listing_id, sc.price, sc.quantity, " +
            "sl.title AS pet_title, sl.image AS pet_image " +
            "FROM store_cart sc " +
            "LEFT JOIN seller_listings sl " +
            "ON sc.seller_listing_id = sl.id " +
            "WHERE sc.user_id = ? " +
            "ORDER BY sc.added_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Cart cart = new Cart();

                    cart.setId(rs.getInt("id"));
                    cart.setUserId(rs.getInt("user_id"));

                    int listingId =
                        rs.getInt("seller_listing_id");

                    if (rs.wasNull()) {
                        cart.setSellerListingId(null);
                        cart.setProductName(
                            rs.getString("product_name")
                        );
                        cart.setDescription("Pet care product");
                    } else {
                        cart.setSellerListingId(listingId);

                        String petTitle =
                            rs.getString("pet_title");

                        cart.setProductName(
                            petTitle != null
                                ? petTitle
                                : rs.getString("product_name")
                        );

                        cart.setImage(rs.getString("pet_image"));
                        cart.setDescription("Seller-listed Pet");
                    }

                    cart.setPrice(rs.getBigDecimal("price"));
                    cart.setQuantity(rs.getInt("quantity"));

                    cartList.add(cart);
                }
            }
        }

        return cartList;
    }


    // ==========================================
    // 4. REMOVE ITEM FROM CART
    // ==========================================
    public boolean removeCartItem(int cartId, int userId)
            throws SQLException {

        String sql =
            "DELETE FROM store_cart " +
            "WHERE id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }


    // ==========================================
    // 5. CALCULATE CART TOTAL
    // ==========================================
    public BigDecimal getCartTotal(int userId)
            throws SQLException {

        String sql =
            "SELECT COALESCE(SUM(price * quantity), 0) AS total " +
            "FROM store_cart WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getBigDecimal("total");
                }
            }
        }

        return BigDecimal.ZERO;
    }
}

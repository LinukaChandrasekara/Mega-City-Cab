package com.megacitycab.dao;

import com.megacitycab.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerDAO {
    public static boolean updateCustomerProfile(int userID, String name, String phone, String address, byte[] profilePicture) {
        String sql;
        if (profilePicture != null) {
            sql = "UPDATE Users SET Name = ?, Phone = ?, Address = ?, ProfilePicture = ? WHERE UserID = ?";
        } else {
            sql = "UPDATE Users SET Name = ?, Phone = ?, Address = ? WHERE UserID = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, phone);
            stmt.setString(3, address);

            if (profilePicture != null) {
                stmt.setBytes(4, profilePicture);
                stmt.setInt(5, userID);
            } else {
                stmt.setInt(4, userID);
            }

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Map<String, String>> getAvailableDiscounts() {
        List<Map<String, String>> discounts = new ArrayList<>();
        String sql = "SELECT Code, Description, DiscountPercentage FROM Discounts WHERE Status = 'Active'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Map<String, String> discount = new HashMap<>();
                discount.put("Code", rs.getString("Code"));
                discount.put("Description", rs.getString("Description"));
                discount.put("DiscountPercentage", rs.getString("DiscountPercentage"));
                discounts.add(discount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }
    public static byte[] getProfilePicture(int userID) {
        String sql = "SELECT ProfilePicture FROM Users WHERE UserID = ?";
        byte[] profilePicture = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                profilePicture = rs.getBytes("ProfilePicture");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return profilePicture;
    }
}

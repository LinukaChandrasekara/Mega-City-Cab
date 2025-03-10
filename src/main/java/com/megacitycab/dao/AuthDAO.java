package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.megacitycab.models.User;
import com.megacitycab.utils.DBConnection;

public class AuthDAO {

    public static User authenticate(String identifier, String password) {
        String sql = "SELECT * FROM Users WHERE (Email = ? OR Name = ?) AND Password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, identifier); // Check by Email
            stmt.setString(2, identifier); // Check by Username
            stmt.setString(3, password);   // Match password

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("UserID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Password"), // ✅ Add the password field (Security Note: Hash it)
                    rs.getString("Role"), 
                    rs.getBytes("ProfilePicture") // ✅ Correct order
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // ❌ Login failed
    }
}

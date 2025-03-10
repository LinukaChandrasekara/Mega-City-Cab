package com.megacitycab.dao;
import com.megacitycab.utils.*;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegisterDAO {
    public static boolean registerUser(String name, String email, String phone, String address, String password, String role, InputStream profilePictureStream) {
        String sql = "INSERT INTO Users (Name, Email, Phone, Address, Password, Role, ProfilePicture) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, address);
            stmt.setString(5, password);
            stmt.setString(6, role);

            if (profilePictureStream != null) {
                stmt.setBinaryStream(7, profilePictureStream);
            } else {
                stmt.setNull(7, java.sql.Types.BLOB);
            }

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
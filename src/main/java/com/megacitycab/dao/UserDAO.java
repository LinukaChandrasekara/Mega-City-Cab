package com.megacitycab.dao;

import com.megacitycab.models.User;
import com.megacitycab.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

	public List<User> getAllUsers() {
	    List<User> users = new ArrayList<>();
	    String query = "SELECT UserID, Name, Email, Phone, Address, Password, Role, ProfilePicture FROM Users";

	    try (Connection conn = DBConnection.getConnection();
	         Statement stmt = conn.createStatement();
	         ResultSet rs = stmt.executeQuery(query)) {

	        while (rs.next()) {
	            User user = new User(
	                    rs.getInt("UserID"),
	                    rs.getString("Name"),
	                    rs.getString("Email"),
	                    rs.getString("Phone"),
	                    rs.getString("Address"),
	                    rs.getString("Password"),
	                    rs.getString("Role"),
	                    rs.getBytes("ProfilePicture")
	            );
	            users.add(user);

	            // Debugging: Print each user
	            System.out.println("✅ User Fetched: " + user.getUserID() + " | " + user.getName() + " | " + user.getEmail());
	        }

	        // Debugging: Print total users fetched
	        System.out.println("📌 Total Users Fetched: " + users.size());

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return users;
	}


    public boolean addUser(User user) {
        String query = "INSERT INTO Users (Name, Email, Phone, Address, Password, Role, ProfilePicture) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getPassword());
            stmt.setString(6, user.getRole());
            stmt.setBytes(7, user.getProfilePicture());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(User user) {
        String query = "UPDATE Users SET Name=?, Email=?, Phone=?, Address=?, Role=?, ProfilePicture=? WHERE UserID=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getRole());
            stmt.setBytes(6, user.getProfilePicture());
            stmt.setInt(7, user.getUserID());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public static boolean updateDriverProfile(int driverID, String name, String phone, String address, byte[] profilePicture) {
        String query = "UPDATE Users SET Name=?, Phone=?, Address=?, ProfilePicture=? WHERE UserID=? AND Role='Driver'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, name);
            stmt.setString(2, phone);
            stmt.setString(3, address);
            stmt.setBytes(4, profilePicture);
            stmt.setInt(5, driverID);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userID) {
        String query = "DELETE FROM Users WHERE UserID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public static User getUserById(int userID) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Blob profileBlob = rs.getBlob("ProfilePicture");
                byte[] profileBytes = null;
                if (profileBlob != null) {
                    profileBytes = profileBlob.getBytes(1, (int) profileBlob.length());
                }
                
                return new User(
                    rs.getInt("UserID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Password"),
                    profileBytes,  // Direct byte array
                    rs.getString("Role"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

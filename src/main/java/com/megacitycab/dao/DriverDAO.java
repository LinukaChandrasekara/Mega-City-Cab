package com.megacitycab.dao;

import com.megacitycab.models.Driver;
import com.megacitycab.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DriverDAO {

	public static Driver getDriverById(int userID) {
	    String query = "SELECT UserID, Name, Email, Phone, Address, Password, Role, ProfilePicture FROM Users WHERE UserID=? AND Role='Driver'";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {

	        stmt.setInt(1, userID);
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            return new Driver(
	                    rs.getInt("UserID"),
	                    rs.getString("Name"),
	                    rs.getString("Email"),
	                    rs.getString("Phone"),
	                    rs.getString("Address"),
	                    rs.getString("Password"),
	                    rs.getString("Role"),
	                    rs.getBytes("ProfilePicture")
	            );
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

	public static List<Driver> getAllDrivers() {
	    List<Driver> drivers = new ArrayList<>();
	    String query = "SELECT u.UserID, u.Name, u.Email, u.Phone, u.ProfilePicture, " +
	                   "COALESCE(v.Type, 'N/A') AS VehicleType, " +
	                   "COALESCE(v.Model, 'N/A') AS Model, " +
	                   "COALESCE(v.LicensePlate, 'N/A') AS LicensePlate, " +
	                   "COALESCE(v.AvailabilityStatus, 'N/A') AS AvailabilityStatus " +
	                   "FROM Users u LEFT JOIN Vehicles v ON u.UserID = v.DriverID " +
	                   "WHERE u.Role = 'Driver'";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query);
	         ResultSet rs = stmt.executeQuery()) {

	        while (rs.next()) {
	            Driver driver = new Driver(
	                    rs.getInt("UserID"),
	                    rs.getString("Name"),
	                    rs.getString("Email"),
	                    rs.getString("Phone"),
	                    rs.getBytes("ProfilePicture"),
	                    rs.getString("VehicleType"),
	                    rs.getString("Model"),
	                    rs.getString("LicensePlate"),
	                    rs.getString("AvailabilityStatus")
	            );
	            drivers.add(driver);

	            // ✅ Debugging: Print each driver in Tomcat logs
	            System.out.println("✅ Driver Fetched: " + driver.getUserID() + " | " + driver.getName() + 
	                               " | " + driver.getEmail() + " | " + driver.getVehicleType() + 
	                               " | " + driver.getModel() + " | " + driver.getLicensePlate() + 
	                               " | " + driver.getStatus());
	        }

	        // ✅ Debugging: Print total drivers fetched
	        System.out.println("📌 Total Drivers Fetched: " + drivers.size());

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return drivers;
	}
    public static Map<String, String> getVehicleDetails(int driverID) {
        String query = "SELECT Type AS VehicleType, Model, LicensePlate FROM Vehicles WHERE DriverID=?";
        Map<String, String> vehicleDetails = new HashMap<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                vehicleDetails.put("VehicleType", rs.getString("VehicleType"));
                vehicleDetails.put("Model", rs.getString("Model"));
                vehicleDetails.put("LicensePlate", rs.getString("LicensePlate"));
            } else {
                vehicleDetails.put("VehicleType", "Not Assigned");
                vehicleDetails.put("Model", "N/A");
                vehicleDetails.put("LicensePlate", "N/A");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vehicleDetails;
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


}

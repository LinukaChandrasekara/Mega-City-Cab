package com.megacitycab.dao;

import com.megacitycab.models.Vehicle;
import com.megacitycab.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VehicleDAO {
	public static Vehicle getVehicleByDriverId(int driverId) {
	    String query = "SELECT * FROM Vehicles WHERE DriverID = ?";
	    
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {

	        stmt.setInt(1, driverId);
	        ResultSet rs = stmt.executeQuery();

	        if (rs.next()) {
	            System.out.println("✅ Vehicle Found in DB: " + rs.getString("Type") + " | " + rs.getString("Model") + " | " + rs.getString("LicensePlate"));

	            return new Vehicle(
	                rs.getInt("VehicleID"),
	                rs.getInt("DriverID"),
	                rs.getString("Type"),
	                rs.getString("Model"),
	                rs.getString("LicensePlate"),
	                rs.getString("AvailabilityStatus")
	            );
	        } else {
	            System.out.println("❌ No vehicle found for DriverID: " + driverId);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return null;
	}

    // ✅ Update vehicle details
	public static boolean updateVehicle(int driverID, String vehicleType, String model, String licensePlate, String availabilityStatus) {
	    String query = "INSERT INTO Vehicles (DriverID, Type, Model, LicensePlate, AvailabilityStatus) " +
	                   "VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE " +
	                   "Type = VALUES(Type), Model = VALUES(Model), LicensePlate = VALUES(LicensePlate), AvailabilityStatus = VALUES(AvailabilityStatus)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {

	        stmt.setInt(1, driverID);
	        stmt.setString(2, vehicleType);
	        stmt.setString(3, model);
	        stmt.setString(4, licensePlate);
	        stmt.setString(5, availabilityStatus);

	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}


	// ✅ Insert new vehicle details (if the driver does not have a vehicle yet)
	public static boolean insertVehicle(int driverId, String type, String model, String licensePlate, String availabilityStatus) {
	    String query = "INSERT INTO Vehicles (DriverID, Type, Model, LicensePlate, AvailabilityStatus) VALUES (?, ?, ?, ?, ?)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(query)) {

	        stmt.setInt(1, driverId);
	        stmt.setString(2, type);
	        stmt.setString(3, model);
	        stmt.setString(4, licensePlate);
	        stmt.setString(5, availabilityStatus); // ✅ Store availability status

	        return stmt.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

}


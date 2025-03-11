package com.megacitycab.dao;
import com.megacitycab.models.Booking;
import com.megacitycab.models.User;
import com.megacitycab.utils.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    public static List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("BookingID"),
                    rs.getInt("CustomerID"),
                    rs.getInt("DriverID"),
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    rs.getDouble("Distance"),
                    rs.getInt("EstimatedTime"),
                    rs.getString("VehicleType"),
                    rs.getDouble("Fare"),
                    rs.getDouble("Discount"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("BookingStatus"),
                    rs.getTimestamp("BookingDate")  // ✅ Fix: Ensure correct data type
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
 // ✅ Fetch assigned rides (Confirmed, Ongoing, Completed) for this driver
    public static List<Booking> getAssignedBookings(int driverID) {
        List<Booking> rides = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE DriverID = ? AND BookingStatus IN ('Confirmed', 'Ongoing', 'Completed')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                rides.add(new Booking(
                    rs.getInt("BookingID"),
                    rs.getInt("CustomerID"),
                    rs.getInt("DriverID"),
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    rs.getDouble("Distance"),
                    rs.getInt("EstimatedTime"),
                    rs.getString("VehicleType"),
                    rs.getDouble("Fare"),
                    rs.getDouble("Discount"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("BookingStatus"),
                    rs.getTimestamp("BookingDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rides;
    }
    public static List<Booking> getBookingsByCustomer(int customerID) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE CustomerID = ? ORDER BY BookingDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("BookingID"),
                    rs.getInt("CustomerID"),
                    rs.getInt("DriverID"),
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    rs.getDouble("Distance"),
                    rs.getInt("EstimatedTime"),
                    rs.getString("VehicleType"),
                    rs.getDouble("Fare"),
                    rs.getDouble("Discount"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("BookingStatus"),
                    rs.getTimestamp("BookingDate")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }


    public static boolean createBooking(int customerID, int driverID, double pickupLat, double pickupLng, 
            double dropoffLat, double dropoffLng, double distance, double fare, 
            double discount, String vehicleType) {
String sql = "INSERT INTO Bookings (CustomerID, DriverID, PickupLat, PickupLng, DropoffLat, DropoffLng, " +
"Distance, EstimatedTime, VehicleType, Fare, Discount, TotalAmount, BookingStatus) " +
"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

double totalAmount = fare - discount; // ✅ Ensure total amount is calculated

try (Connection conn = DBConnection.getConnection();
PreparedStatement stmt = conn.prepareStatement(sql)) {

stmt.setInt(1, customerID);
stmt.setInt(2, driverID);
stmt.setDouble(3, pickupLat);
stmt.setDouble(4, pickupLng);
stmt.setDouble(5, dropoffLat);
stmt.setDouble(6, dropoffLng);
stmt.setDouble(7, distance);
stmt.setInt(8, (int) (distance * 2)); // ✅ Rough estimated time in minutes
stmt.setString(9, vehicleType);
stmt.setDouble(10, fare);
stmt.setDouble(11, discount);
stmt.setDouble(12, totalAmount);

return stmt.executeUpdate() > 0;

} catch (SQLException e) {
e.printStackTrace();
return false;
}
}

    public static List<Booking> getRecentBookings(int customerID) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE CustomerID = ? ORDER BY BookingDate DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("BookingID"),
                    rs.getInt("CustomerID"),
                    rs.getInt("DriverID"),
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    rs.getDouble("Distance"),
                    rs.getInt("EstimatedTime"),
                    rs.getString("VehicleType"),
                    rs.getDouble("Fare"),
                    rs.getDouble("Discount"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("BookingStatus"),
                    rs.getTimestamp("BookingDate")  // ✅ Correct Timestamp usage
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    public static List<Booking> getAvailableBookingsByVehicleType(String vehicleType) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT BookingID, PickupLat, PickupLng, DropoffLat, DropoffLng, BookingStatus FROM Bookings WHERE VehicleType = ? AND BookingStatus = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, vehicleType);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                bookings.add(new Booking(
                    rs.getInt("BookingID"),
                    -1,  // No customer ID needed here
                    -1,  // No driver assigned yet
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    0.0,  // Distance not needed
                    0,  // Estimated time
                    vehicleType,
                    0.0,  // Fare not needed
                    0.0,  // Discount
                    0.0,  // Total Amount
                    rs.getString("BookingStatus"),
                    null  // No timestamp needed
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public static int findNearestAvailableDriver(double pickupLat, double pickupLng, String vehicleType) {
        String sql = "SELECT DriverID FROM Vehicles WHERE Type = ? AND AvailabilityStatus = 'Available' LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, vehicleType);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("DriverID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // No available driver found
    }
    public static Booking getBookingById(int bookingID) {
        String sql = "SELECT * FROM Bookings WHERE BookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Booking(
                    rs.getInt("BookingID"),
                    rs.getInt("CustomerID"),
                    rs.getInt("DriverID"),
                    rs.getDouble("PickupLat"),
                    rs.getDouble("PickupLng"),
                    rs.getDouble("DropoffLat"),
                    rs.getDouble("DropoffLng"),
                    rs.getDouble("Distance"),
                    rs.getInt("EstimatedTime"),
                    rs.getString("VehicleType"),
                    rs.getDouble("Fare"),
                    rs.getDouble("Discount"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("BookingStatus"),
                    rs.getTimestamp("BookingDate")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // No booking found
    }
    public static boolean assignDriverToBooking(int bookingID, int driverID) {
        String sql = "UPDATE Bookings SET DriverID = ?, BookingStatus = 'Confirmed' WHERE BookingID = ? AND BookingStatus = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, driverID);
            stmt.setInt(2, bookingID);

            return stmt.executeUpdate() > 0; // Returns true if update was successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean updateBookingStatus(int bookingID, String status) {
        String sql = "UPDATE Bookings SET BookingStatus = ? WHERE BookingID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, bookingID);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public static User getDriverById(int driverID) {
        String sql = "SELECT * FROM Users WHERE UserID = ? AND Role = 'Driver'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, driverID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getInt("UserID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Role"), sql, sql, null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }




}
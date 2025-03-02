package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BookingServlet")  // ✅ Ensure the servlet is mapped correctly
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp?message=Please login to confirm booking.");
            return;
        }

        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (!"customer".equals(role)) {
            response.sendRedirect("login.jsp?message=Only customers can book rides.");
            return;
        }

        System.out.println("DEBUG: Logged-in user: " + username + ", Role: " + role);

        
        



     // ✅ Check if session exists and has a valid role
     if (session == null || session.getAttribute("username") == null || session.getAttribute("role") == null) {
         response.sendRedirect("login.jsp?message=Please login to confirm booking.");
         return;
     }

     String role1 = (String) session.getAttribute("role");

     // ✅ Ensure only 'customer' can book
     if (!"customer".equals(role1)) {
         response.sendRedirect("login.jsp?message=Only customers can book rides.");
         return;
     }

        String action = request.getParameter("action");


        // ✅ Retrieve form parameters safely
        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String pickup = request.getParameter("pickup_location");
        String dropoff = request.getParameter("dropoff_location");
        String vehicleType = request.getParameter("vehicle_type");

        // ✅ Validate distance & fare to prevent crashes
        double distance, fare;
        try {
            distance = Double.parseDouble(request.getParameter("distance"));
            fare = Double.parseDouble(request.getParameter("fare"));
        } catch (NumberFormatException e) {
            response.sendRedirect("book.jsp?message=Invalid distance or fare. Please try again.");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                // ✅ Add Booking & Auto-Assign a Driver
                int driverId = findAvailableDriver(con, vehicleType);
                int bookingId = addBooking(con, customerName, phone, pickup, dropoff, vehicleType, distance, fare, driverId);

                if (bookingId > 0) {
                    response.sendRedirect("book_success.jsp?message=Booking confirmed successfully.");
                } else {
                    response.sendRedirect("book.jsp?message=Error booking ride. Try again.");
                }
            } else if ("update".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("booking_id"));
                updateBooking(con, bookingId, customerName, phone, pickup, dropoff, vehicleType, distance, fare);
                response.sendRedirect("manage_bookings.jsp?message=Booking updated successfully.");
            } else {
                response.sendRedirect("manage_bookings.jsp?message=Invalid action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("book.jsp?message=Booking failed. Contact support.");
        }
    }

    /**
     * ✅ Add a new booking and optionally assign a driver.
     */
    private int addBooking(Connection con, String customerName, String phone, String pickup, String dropoff,
            String vehicleType, double distance, double fare, int driverId) throws SQLException {
String sql = "INSERT INTO bookings (customer_name, phone, pickup_location, dropoff_location, vehicle_type, distance, fare, status, driver_id) " +
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";  // ✅ Correctly expects 9 parameters

try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
ps.setString(1, customerName);
ps.setString(2, phone);
ps.setString(3, pickup);
ps.setString(4, dropoff);
ps.setString(5, vehicleType);
ps.setDouble(6, distance);
ps.setDouble(7, fare);
ps.setString(8, "pending"); // ✅ Now correctly sets "pending" status
ps.setObject(9, driverId > 0 ? driverId : null); // ✅ Correctly assigns driver_id

int affectedRows = ps.executeUpdate();
if (affectedRows == 0) return -1;

try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
 if (generatedKeys.next()) {
     return generatedKeys.getInt(1);
 }
}
}
return -1;
}



    /**
     * ✅ Update an existing booking.
     */
    private void updateBooking(Connection con, int bookingId, String customerName, String phone, String pickup,
                               String dropoff, String vehicleType, double distance, double fare) throws SQLException {
        String sql = "UPDATE bookings SET customer_name=?, phone=?, pickup_location=?, dropoff_location=?, vehicle_type=?, distance=?, fare=? WHERE booking_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, pickup);
            ps.setString(4, dropoff);
            ps.setString(5, vehicleType);
            ps.setDouble(6, distance);
            ps.setDouble(7, fare);
            ps.setInt(8, bookingId);
            ps.executeUpdate();
        }
    }

    /**
     * ✅ Find an available driver based on vehicle type.
     */
    private int findAvailableDriver(Connection con, String vehicleType) throws SQLException {
        String sql = "SELECT driver_id FROM drivers WHERE status = 'available' AND assigned_vehicle_id IN " +
                     "(SELECT vehicle_id FROM vehicles WHERE vehicle_type = ?) LIMIT 1";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, vehicleType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int driverId = rs.getInt("driver_id");
                    updateDriverStatus(con, driverId, "busy");
                    return driverId;
                }
            }
        }
        return -1; // No available driver
    }

    /**
     * ✅ Update driver status (set to 'busy' after booking).
     */
    private void updateDriverStatus(Connection con, int driverId, String status) throws SQLException {
        String sql = "UPDATE drivers SET status = ? WHERE driver_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, driverId);
            ps.executeUpdate();
        }
    }
}

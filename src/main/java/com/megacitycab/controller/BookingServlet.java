package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;


public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");  // ✅ Added this line

        // Retrieve booking details from request
        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String pickup = request.getParameter("pickup_location");
        String dropoff = request.getParameter("dropoff_location");
        String vehicleType = request.getParameter("vehicle_type");
        double distance = Double.parseDouble(request.getParameter("distance"));
        double fare = Double.parseDouble(request.getParameter("fare"));

        try (Connection con = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                addBooking(con, customerName, phone, pickup, dropoff, vehicleType, distance, fare);
                response.sendRedirect("manage_bookings.jsp?message=Booking added successfully.");
            } else if ("update".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("booking_id"));
                updateBooking(con, bookingId, customerName, phone, pickup, dropoff, vehicleType, distance, fare);
                response.sendRedirect("manage_bookings.jsp?message=Booking updated successfully.");
            } else {
                response.sendRedirect("manage_bookings.jsp?message=Invalid action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error processing booking: " + e.getMessage());
        }
    }

    private void addBooking(Connection con, String customerName, String phone, String pickup, String dropoff,
                            String vehicleType, double distance, double fare) throws SQLException {
        String sql = "INSERT INTO bookings (customer_name, phone, pickup_location, dropoff_location, vehicle_type, distance, fare) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, pickup);
            ps.setString(4, dropoff);
            ps.setString(5, vehicleType);
            ps.setDouble(6, distance);
            ps.setDouble(7, fare);
            ps.executeUpdate();
        }
    }

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
}

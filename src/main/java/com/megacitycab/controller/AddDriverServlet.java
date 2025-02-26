package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AddDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String licenseNumber = request.getParameter("license_number");
        int experienceYears = Integer.parseInt(request.getParameter("experience_years"));
        String assignedVehicleIdParam = request.getParameter("assigned_vehicle_id");
        Integer assignedVehicleId = (assignedVehicleIdParam != null && !assignedVehicleIdParam.isEmpty()) ? Integer.parseInt(assignedVehicleIdParam) : null;

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false); // Start transaction

            // Insert into users table
            String userSql = "INSERT INTO users (username, password, full_name, phone_number, role) VALUES (?, ?, ?, ?, 'driver')";
            int userId;
            try (PreparedStatement userPs = con.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, username);
                userPs.setString(2, password);
                userPs.setString(3, name);
                userPs.setString(4, phone);
                userPs.executeUpdate();

                ResultSet generatedKeys = userPs.getGeneratedKeys();
                if (generatedKeys.next()) {
                    userId = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Failed to retrieve user_id.");
                }
            }

            // Insert into drivers table
            String driverSql = "INSERT INTO drivers (driver_id, license_number, experience_years, assigned_vehicle_id) VALUES (?, ?, ?, ?)";
            try (PreparedStatement driverPs = con.prepareStatement(driverSql)) {
                driverPs.setInt(1, userId);
                driverPs.setString(2, licenseNumber);
                driverPs.setInt(3, experienceYears);

                if (assignedVehicleId != null) {
                    driverPs.setInt(4, assignedVehicleId);
                } else {
                    driverPs.setNull(4, Types.INTEGER); // Handle null vehicle ID
                }

                driverPs.executeUpdate();
            }

            con.commit(); // Commit transaction
            response.sendRedirect("manage_drivers.jsp?message=Driver added successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_drivers.jsp?message=Error adding driver.");
        }
    }
}

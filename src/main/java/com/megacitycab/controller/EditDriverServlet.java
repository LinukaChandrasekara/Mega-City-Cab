package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class EditDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driver_id"));
        String fullName = request.getParameter("full_name");
        String phoneNumber = request.getParameter("phone_number");
        String vehicleModel = request.getParameter("vehicle");
        String status = request.getParameter("status");

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);  // 🔒 Begin transaction

            // 1️⃣ Update Users table: Update full name and phone number
            String updateUserSql = "UPDATE users SET full_name = ?, phone_number = ? WHERE user_id = ?";
            try (PreparedStatement psUser = con.prepareStatement(updateUserSql)) {
                psUser.setString(1, fullName);
                psUser.setString(2, phoneNumber);
                psUser.setInt(3, driverId);
                psUser.executeUpdate();
            }

            // 2️⃣ Update Drivers table: Update driver status
            String updateDriverSql = "UPDATE drivers SET status = ? WHERE driver_id = ?";
            try (PreparedStatement psDriver = con.prepareStatement(updateDriverSql)) {
                psDriver.setString(1, status);
                psDriver.setInt(2, driverId);
                psDriver.executeUpdate();
            }

            // 3️⃣ Handle vehicle update or assignment if a vehicle model is provided
            if (vehicleModel != null && !vehicleModel.trim().isEmpty()) {
                int vehicleId = -1;

                // 🔎 Check if driver already has an assigned vehicle
                String checkVehicleSql = "SELECT assigned_vehicle_id FROM drivers WHERE driver_id = ?";
                try (PreparedStatement psCheck = con.prepareStatement(checkVehicleSql)) {
                    psCheck.setInt(1, driverId);
                    ResultSet rs = psCheck.executeQuery();
                    if (rs.next()) {
                        vehicleId = rs.getInt("assigned_vehicle_id");
                    }
                }

                if (vehicleId != 0 && vehicleId != -1) {
                    // 🚗 Update existing assigned vehicle
                    String updateVehicleSql = "UPDATE vehicles SET model = ? WHERE vehicle_id = ?";
                    try (PreparedStatement psVehicle = con.prepareStatement(updateVehicleSql)) {
                        psVehicle.setString(1, vehicleModel);
                        psVehicle.setInt(2, vehicleId);
                        psVehicle.executeUpdate();
                    }
                } else {
                    // ➕ Insert new vehicle and assign it to the driver
                    String insertVehicleSql = "INSERT INTO vehicles (model, vehicle_type) VALUES (?, 'cab')";
                    try (PreparedStatement psInsert = con.prepareStatement(insertVehicleSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                        psInsert.setString(1, vehicleModel);
                        psInsert.executeUpdate();

                        // Assign new vehicle to driver
                        try (ResultSet generatedKeys = psInsert.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                int newVehicleId = generatedKeys.getInt(1);

                                String assignVehicleSql = "UPDATE drivers SET assigned_vehicle_id = ? WHERE driver_id = ?";
                                try (PreparedStatement psAssign = con.prepareStatement(assignVehicleSql)) {
                                    psAssign.setInt(1, newVehicleId);
                                    psAssign.setInt(2, driverId);
                                    psAssign.executeUpdate();
                                }
                            } else {
                                throw new Exception("Failed to retrieve new vehicle ID.");
                            }
                        }
                    }
                }
            }

            con.commit();  // ✅ Commit transaction if everything succeeded
            response.sendRedirect("manage_drivers.jsp?message=Driver updated successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            try (Connection con = DBUtil.getConnection()) {
                if (con != null) con.rollback();  // 🔄 Rollback on error
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            response.sendRedirect("manage_drivers.jsp?message=Error updating driver.");
        }
    }
}

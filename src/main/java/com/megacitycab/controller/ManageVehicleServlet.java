package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ManageVehicleServlet")
public class ManageVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String vehicleType = request.getParameter("vehicle_type");
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("license_plate");

        try (Connection con = DBUtil.getConnection()) {
            // Get driver_id
            int driverId = -1;
            try (PreparedStatement ps = con.prepareStatement("SELECT user_id FROM users WHERE username=?")) {
                ps.setString(1, username);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) driverId = rs.getInt("user_id");
            }

            if (driverId == -1) {
                response.sendRedirect("driver_dashboard.jsp?message=Driver not found.");
                return;
            }

            // Check if vehicle exists
            PreparedStatement checkVehicle = con.prepareStatement("SELECT * FROM drivers WHERE driver_id=?");
            checkVehicle.setInt(1, driverId);
            ResultSet rs = checkVehicle.executeQuery();

            if (rs.next()) {
                // Update existing vehicle
                int vehicleId = rs.getInt("assigned_vehicle_id");
                PreparedStatement updateVehicle = con.prepareStatement(
                    "UPDATE vehicles SET vehicle_type=?, model=?, license_plate=? WHERE vehicle_id=?"
                );
                updateVehicle.setString(1, vehicleType);
                updateVehicle.setString(2, model);
                updateVehicle.setString(3, licensePlate);
                updateVehicle.setInt(4, vehicleId);
                updateVehicle.executeUpdate();
                response.sendRedirect("driver_dashboard.jsp?message=Vehicle updated successfully.");
            } else {
                // Insert new vehicle and link to driver
                PreparedStatement insertVehicle = con.prepareStatement(
                    "INSERT INTO vehicles (vehicle_type, model, license_plate) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS
                );
                insertVehicle.setString(1, vehicleType);
                insertVehicle.setString(2, model);
                insertVehicle.setString(3, licensePlate);
                insertVehicle.executeUpdate();

                ResultSet generatedKeys = insertVehicle.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int vehicleId = generatedKeys.getInt(1);
                    PreparedStatement linkDriver = con.prepareStatement(
                        "INSERT INTO drivers (driver_id, assigned_vehicle_id) VALUES (?, ?)"
                    );
                    linkDriver.setInt(1, driverId);
                    linkDriver.setInt(2, vehicleId);
                    linkDriver.executeUpdate();
                    response.sendRedirect("driver_dashboard.jsp?message=Vehicle registered successfully.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("driver_dashboard.jsp?message=Error managing vehicle.");
        }
    }
}

package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class EditDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driver_id"));
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String vehicle = request.getParameter("vehicle");
        String status = request.getParameter("status");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE drivers SET name=?, phone=?, vehicle=?, status=? WHERE driver_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, phone);
                ps.setString(3, vehicle);
                ps.setString(4, status);
                ps.setInt(5, driverId);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_drivers.jsp?message=Driver updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_drivers.jsp?message=Error updating driver.");
        }
    }
}

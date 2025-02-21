package com.megacitycab.controller;
import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AssignDriverServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        int driverId = Integer.parseInt(request.getParameter("driver_id"));

        try (Connection con = DBUtil.getConnection()) {
            // Update the booking with driver assignment
            PreparedStatement ps = con.prepareStatement("UPDATE bookings SET driver_id=?, status='Assigned' WHERE id=?");
            ps.setInt(1, driverId);
            ps.setInt(2, bookingId);
            ps.executeUpdate();

            // Update the driver status to 'Busy'
            PreparedStatement updateDriver = con.prepareStatement("UPDATE drivers SET status='Busy' WHERE id=?");
            updateDriver.setInt(1, driverId);
            updateDriver.executeUpdate();

            response.sendRedirect("manage_bookings.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error assigning driver.");
        }
    }
}

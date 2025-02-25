package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateRideStatusServlet")
public class UpdateRideStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE bookings SET status=? WHERE booking_id=?");
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            int updatedRows = ps.executeUpdate();

            if (updatedRows > 0) {
                response.sendRedirect("driver_dashboard.jsp?message=Ride status updated.");
            } else {
                response.sendRedirect("driver_dashboard.jsp?message=Failed to update ride status.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("driver_dashboard.jsp?message=Error updating ride status.");
        }
    }
}

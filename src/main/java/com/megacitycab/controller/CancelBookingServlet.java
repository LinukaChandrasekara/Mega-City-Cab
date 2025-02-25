package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class CancelBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE bookings SET status='Canceled' WHERE booking_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingId);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("customer_dashboard.jsp?message=Booking canceled.");
            } else {
                response.sendRedirect("customer_dashboard.jsp?message=Error canceling booking.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error canceling booking: " + e.getMessage());
        }
    }
}

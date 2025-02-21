package com.megacitycab.controller;
import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UpdateBookingServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE bookings SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
            response.sendRedirect("manage_bookings.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating booking status.");
        }
    }
}

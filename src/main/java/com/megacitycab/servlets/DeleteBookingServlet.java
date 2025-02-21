package com.megacitycab.servlets;
import java.io.IOException;
import java.sql.*;
import com.megacitycab.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteBookingServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM bookings WHERE id=?");
            ps.setInt(1, bookingId);
            ps.executeUpdate();
            response.sendRedirect("manage_bookings.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting booking.");
        }
    }
}

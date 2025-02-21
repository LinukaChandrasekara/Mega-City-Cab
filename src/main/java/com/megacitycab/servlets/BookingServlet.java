package com.megacitycab.servlets;
import java.io.IOException;
import java.sql.*;

import com.megacitycab.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BookingServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerName = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String pickup = request.getParameter("pickup_location");
        String dropoff = request.getParameter("dropoff_location");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO bookings (customer_name, phone, pickup_location, dropoff_location, fare) VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, customerName);
            ps.setString(2, phone);
            ps.setString(3, pickup);
            ps.setString(4, dropoff);
            ps.setDouble(5, calculateFare(pickup, dropoff));
            ps.executeUpdate();
            response.sendRedirect("book_success.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Booking error!");
        }
    }

    private double calculateFare(String pickup, String dropoff) {
        return 500.0;  // Simplified fare calculation
    }
}
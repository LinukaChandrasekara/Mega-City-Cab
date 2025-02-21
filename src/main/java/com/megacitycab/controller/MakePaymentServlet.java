package com.megacitycab.controller;
import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MakePaymentServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        String paymentMethod = request.getParameter("payment_method");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO payments (booking_id, amount_paid, payment_status, payment_method) " +
                "VALUES (?, (SELECT fare FROM bookings WHERE id=?), 'Paid', ?)"
            );
            ps.setInt(1, bookingId);
            ps.setInt(2, bookingId);
            ps.setString(3, paymentMethod);
            ps.executeUpdate();

            response.sendRedirect("payment.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error processing payment.");
        }
    }
}

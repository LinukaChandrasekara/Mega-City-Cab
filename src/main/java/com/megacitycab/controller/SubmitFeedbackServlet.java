package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class SubmitFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        String feedbackText = request.getParameter("feedback");
        Date date = new Date(System.currentTimeMillis());

        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO feedback (customer_name, booking_id, feedback_text, date) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, bookingId);
            ps.setString(3, feedbackText);
            ps.setDate(4, date);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("customer_dashboard.jsp?message=Feedback submitted successfully.");
            } else {
                response.sendRedirect("customer_dashboard.jsp?message=Error submitting feedback.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error submitting feedback: " + e.getMessage());
        }
    }
}

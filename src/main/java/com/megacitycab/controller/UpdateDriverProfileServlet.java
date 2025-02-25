package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateDriverProfileServlet")
public class UpdateDriverProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("full_name");
        String nic = request.getParameter("nic");
        String phone = request.getParameter("phone_number");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE users SET full_name=?, nic=?, phone_number=? WHERE username=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, nic);
                ps.setString(3, phone);
                ps.setString(4, username);
                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect("driver_dashboard.jsp?message=Profile updated successfully.");
                } else {
                    response.sendRedirect("driver_dashboard.jsp?message=Failed to update profile.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("driver_dashboard.jsp?message=Error updating profile.");
        }
    }
}

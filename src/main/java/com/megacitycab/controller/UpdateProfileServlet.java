package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String nic = request.getParameter("nic");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE users SET name=?, nic=?, address=?, phone=? WHERE username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, nic);
            ps.setString(3, address);
            ps.setString(4, phone);
            ps.setString(5, username);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("customer_dashboard.jsp?message=Profile updated successfully.");
            } else {
                response.sendRedirect("customer_dashboard.jsp?message=Error updating profile.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error updating profile: " + e.getMessage());
        }
    }
}

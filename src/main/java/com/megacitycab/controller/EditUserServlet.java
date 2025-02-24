package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class EditUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("user_id"));
        String username = request.getParameter("username");
        String role = request.getParameter("role");
        String fullName = request.getParameter("full_name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String phone = request.getParameter("phone");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "UPDATE users SET username=?, role=?, full_name=?, address=?, nic=?, phone=? WHERE user_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, role);
                ps.setString(3, fullName);
                ps.setString(4, address);
                ps.setString(5, nic);
                ps.setString(6, phone);
                ps.setInt(7, userId);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_users.jsp?message=User updated successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_user.jsp?userId=" + userId + "&message=Error updating user.");
        }
    }
}

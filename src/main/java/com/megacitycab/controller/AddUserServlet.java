package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AddUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String fullName = request.getParameter("full_name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String phone = request.getParameter("phone");

        try (Connection con = DBUtil.getConnection()) {
            // Check if username exists
            PreparedStatement checkStmt = con.prepareStatement("SELECT * FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect("add_user.jsp?message=Username already exists!");
                return;
            }

            // Insert user
            String sql = "INSERT INTO users (username, password, role, full_name, address, nic, phone) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password); // For production: hash passwords!
                ps.setString(3, role);
                ps.setString(4, fullName);
                ps.setString(5, address);
                ps.setString(6, nic);
                ps.setString(7, phone);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_users.jsp?message=User added successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_user.jsp?message=Error adding user.");
        }
    }
}


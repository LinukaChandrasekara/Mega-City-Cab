package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AddDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String vehicle = request.getParameter("vehicle");
        String status = request.getParameter("status");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO drivers (name, phone, vehicle, status) VALUES (?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, phone);
                ps.setString(3, vehicle);
                ps.setString(4, status);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_drivers.jsp?message=Driver added successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_drivers.jsp?message=Error adding driver.");
        }
    }
}

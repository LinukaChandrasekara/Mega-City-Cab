package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class DeleteDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));

        try (Connection con = DBUtil.getConnection()) {
            String sql = "DELETE FROM drivers WHERE driver_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, driverId);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_drivers.jsp?message=Driver deleted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_drivers.jsp?message=Error deleting driver.");
        }
    }
}

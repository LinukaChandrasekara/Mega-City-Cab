package com.megacitycab.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class DeleteDriverServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));

        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false); // Begin transaction

            // 1. Delete from drivers
            String deleteDriverSQL = "DELETE FROM drivers WHERE driver_id = ?";
            try (PreparedStatement psDriver = con.prepareStatement(deleteDriverSQL)) {
                psDriver.setInt(1, driverId);
                psDriver.executeUpdate();
            }

            // 2. Delete from users
            String deleteUserSQL = "DELETE FROM users WHERE user_id = ?";
            try (PreparedStatement psUser = con.prepareStatement(deleteUserSQL)) {
                psUser.setInt(1, driverId);
                psUser.executeUpdate();
            }

            con.commit(); // Commit transaction
            response.sendRedirect("manage_drivers.jsp?message=Driver deleted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_drivers.jsp?message=Error deleting driver.");
        }
    }
}

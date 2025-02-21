package com.megacitycab.servlets;
import java.io.IOException;
import java.sql.*;
import com.megacitycab.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddDriverServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String vehicle = request.getParameter("vehicle");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO drivers (name, phone, vehicle, status) VALUES (?, ?, ?, 'Available')");
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, vehicle);
            ps.executeUpdate();
            response.sendRedirect("manage_drivers.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding driver.");
        }
    }
}

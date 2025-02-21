package com.megacitycab.servlets;
import java.io.IOException;
import java.sql.*;
import com.megacitycab.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteUserServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBUtil.getConnection()) {
            // Prevent admin deletion
            PreparedStatement checkUser = con.prepareStatement("SELECT username FROM users WHERE id=?");
            checkUser.setInt(1, userId);
            ResultSet rs = checkUser.executeQuery();
            
            if (rs.next() && rs.getString("username").equals("admin")) {
                response.sendRedirect("manage_users.jsp"); // Prevent admin deletion
                return;
            }

            // Delete user
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?");
            ps.setInt(1, userId);
            ps.executeUpdate();
            response.sendRedirect("manage_users.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting user.");
        }
    }
}

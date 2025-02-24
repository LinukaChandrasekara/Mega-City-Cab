package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));

        try (Connection con = DBUtil.getConnection()) {
            String sql = "DELETE FROM users WHERE user_id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            response.sendRedirect("manage_users.jsp?message=User deleted successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_users.jsp?message=Error deleting user.");
        }
    }
}

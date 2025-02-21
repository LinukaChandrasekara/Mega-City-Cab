package com.megacitycab.controller;
import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddUserServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBUtil.getConnection()) {
            // Check if the username already exists
            PreparedStatement checkUser = con.prepareStatement("SELECT * FROM users WHERE username=?");
            checkUser.setString(1, username);
            ResultSet rs = checkUser.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Username already exists! Choose another.");
                request.getRequestDispatcher("manage_users.jsp").forward(request, response);
            } else {
                // Insert the new user
                PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, password, role) VALUES (?, ?, ?)");
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, role);
                ps.executeUpdate();
                response.sendRedirect("manage_users.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding user.");
        }
    }
}


package com.megacitycab.servlets;
import java.io.IOException;
import java.sql.*;
import com.megacitycab.utils.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement checkUser = con.prepareStatement("SELECT * FROM users WHERE username=?");
            checkUser.setString(1, username);
            ResultSet rs = checkUser.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("message", "Username already exists! Choose another.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                PreparedStatement ps = con.prepareStatement("INSERT INTO users (username, password, role) VALUES (?, ?, 'customer')");
                ps.setString(1, username);
                ps.setString(2, password);
                ps.executeUpdate();
                request.setAttribute("message", "Registration successful! Please login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error!");
        }
    }
}

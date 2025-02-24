package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBUtil.getConnection()) {
            // Query to verify user credentials
            PreparedStatement ps = con.prepareStatement("SELECT role FROM users WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");

                // Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);

                // Create cookies for username and role
                Cookie usernameCookie = new Cookie("username", username);
                Cookie roleCookie = new Cookie("role", role);
                
                usernameCookie.setMaxAge(24 * 60 * 60); // 1 day
                roleCookie.setMaxAge(24 * 60 * 60);

                response.addCookie(usernameCookie);
                response.addCookie(roleCookie);

                // Redirect based on role
                switch (role) {
                    case "admin":
                        response.sendRedirect("adminDashboard.jsp?message=Welcome Admin!");
                        break;
                    case "driver":
                        response.sendRedirect("driverDashboard.jsp?message=Welcome Driver!");
                        break;
                    case "customer":
                    default:
                        response.sendRedirect("index.jsp?message=Login successful!");
                        break;
                }
            } else {
                // Invalid credentials
                request.setAttribute("error", "Invalid username or password. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred. Please try later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

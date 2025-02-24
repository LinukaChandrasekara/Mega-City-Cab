package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;

import com.megacitycab.dao.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBUtil.getConnection()) {
            // Check if the username already exists
            PreparedStatement checkUser = con.prepareStatement("SELECT * FROM users WHERE username = ?");
            checkUser.setString(1, username);
            ResultSet rs = checkUser.executeQuery();

            if (rs.next()) {
                // Username taken
                request.setAttribute("message", "Username already exists! Please choose another.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                // Insert new user with 'customer' role
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users (username, password, role) VALUES (?, ?, 'customer')"
                );
                ps.setString(1, username);
                ps.setString(2, password);
                ps.executeUpdate();

                request.setAttribute("message", "Registration successful! Please log in.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred during registration. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

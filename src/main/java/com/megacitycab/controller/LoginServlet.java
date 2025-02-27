package com.megacitycab.controller;

import java.io.IOException;
import java.sql.*;
import com.megacitycab.dao.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection con = DBUtil.getConnection()) {
            String sql = "SELECT user_id, role FROM users WHERE username=? AND password=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession(); // ✅ Ensure session is created
                        session.setAttribute("username", username);
                        session.setAttribute("role", rs.getString("role"));
                        session.setMaxInactiveInterval(30 * 60); // 30 minutes session timeout

                        // ✅ Redirect based on role
                        String role = rs.getString("role");
                        if ("admin".equals(role)) {
                            response.sendRedirect("admin_dashboard.jsp");
                        } else if ("customer".equals(role)) {
                            response.sendRedirect("customer_dashboard.jsp");
                        } else if ("driver".equals(role)) {
                            response.sendRedirect("driver_dashboard.jsp");
                        } else {
                            response.sendRedirect("login.jsp?message=Invalid role assigned.");
                        }
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("login.jsp?message=Invalid username or password.");
    }
}

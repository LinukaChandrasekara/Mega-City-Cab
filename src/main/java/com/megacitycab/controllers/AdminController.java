package com.megacitycab.controllers;

import com.megacitycab.dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("Views/login.jsp?error=Unauthorized Access!");
            return;
        }

        // Fetch dashboard stats
        int totalBookings = AdminDAO.getTotalBookings();
        int totalCustomers = AdminDAO.getTotalCustomers();
        int totalDrivers = AdminDAO.getTotalDrivers();
        double totalRevenue = AdminDAO.getTotalRevenue();

        // Set attributes for JSP
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalDrivers", totalDrivers);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("Views/Admin/admin_dashboard.jsp").forward(request, response);
    }
}

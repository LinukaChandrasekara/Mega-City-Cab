package com.megacitycab.controllers;

import com.megacitycab.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

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
        // ✅ Fetch live ride status (Pending, Confirmed, Ongoing)
        List<Map<String, String>> liveRides = BookingDAO.getLiveRides();
        request.setAttribute("liveRides", liveRides);

        // Set attributes for JSP
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalDrivers", totalDrivers);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("Views/Admin/admin_dashboard.jsp").forward(request, response);
    }
}

package com.megacitycab.controllers;

import com.megacitycab.dao.*;
import com.megacitycab.models.Booking;

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
        
        // ✅ Fetch all bookings
        List<Booking> bookings = BookingDAO.getAllBookings();
        System.out.println("DEBUG: Retrieved " + bookings.size() + " bookings");  // Debugging

        if (bookings.isEmpty()) {
            System.out.println("DEBUG: No bookings found in database.");
        } else {
            System.out.println("DEBUG: First booking - ID: " + bookings.get(0).getBookingID());
        }

        request.setAttribute("bookings", bookings);

        // Set attributes for JSP
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalDrivers", totalDrivers);
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/Views/Admin/manage_bookings.jsp").forward(request, response);

    }
}

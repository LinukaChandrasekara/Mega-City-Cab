package com.megacitycab.controllers;
import com.megacitycab.dao.*;
import com.megacitycab.models.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/BookingController")
public class BookingController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session Expired");
            return;
        }

        User customer = (User) session.getAttribute("user");

        // ✅ Fetch recent bookings for the logged-in customer
        List<Booking> recentBookings = BookingDAO.getRecentBookings(customer.getUserID());

        // ✅ Set recent bookings in request scope
        request.setAttribute("recentBookings", recentBookings);

        // ✅ Forward to customer dashboard
        request.getRequestDispatcher("Views/Customer/customer_dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            handleUpdateBooking(request, response);
        } else if ("cancel".equals(action)) {
            handleCancelBooking(request, response);
        }else if ("bookRide".equals(action)) {
            handleBookRide(request, response);
        }
    }
    private void handleBookRide(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession(false);
            User customer = (User) session.getAttribute("user");

            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session expired");
                return;
            }

            // ✅ Read request parameters
            double pickupLat = Double.parseDouble(request.getParameter("pickup_lat"));
            double pickupLng = Double.parseDouble(request.getParameter("pickup_lng"));
            double dropoffLat = Double.parseDouble(request.getParameter("dropoff_lat"));
            double dropoffLng = Double.parseDouble(request.getParameter("dropoff_lng"));
            double distance = Double.parseDouble(request.getParameter("distance"));
            double fare = Double.parseDouble(request.getParameter("fare"));
            String vehicleType = request.getParameter("vehicle_type");

            // ✅ Calculate discount
            double discount = 0;
            if (distance > 8 && distance <= 15) discount = 0.05 * fare;
            else if (distance > 15 && distance <= 30) discount = 0.10 * fare;
            else if (distance > 30 && distance <= 60) discount = 0.15 * fare;
            else if (distance > 60) discount = 0.20 * fare;

            int assignedDriverID = BookingDAO.findNearestAvailableDriver(pickupLat, pickupLng, vehicleType);
            if (assignedDriverID == -1) {
                response.sendRedirect("Views/Customer/book_ride.jsp?error=No drivers available");
                return;
            }

            boolean success = BookingDAO.createBooking(
                customer.getUserID(), assignedDriverID, pickupLat, pickupLng, dropoffLat, dropoffLng, distance, fare, discount, vehicleType
            );

            if (success) {
                response.sendRedirect("Views/Customer/booking_history.jsp?success=Ride Booked!");
            } else {
                response.sendRedirect("Views/Customer/book_ride.jsp?error=Failed to book ride.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Views/Customer/book_ride.jsp?error=Invalid booking details.");
        }
    }


    private void handleUpdateBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        String status = request.getParameter("status");

        boolean success = BookingDAO.updateBookingStatus(bookingID, status);

        if (success) {
            response.sendRedirect("BookingController?success=Booking updated successfully!");
        } else {
            response.sendRedirect("BookingController?error=Failed to update booking.");
        }
    }

    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));

        boolean success = BookingDAO.updateBookingStatus(bookingID, "Cancelled");

        if (success) {
            response.sendRedirect("BookingController?success=Booking cancelled successfully!");
        } else {
            response.sendRedirect("BookingController?error=Failed to cancel booking.");
        }
    }
}

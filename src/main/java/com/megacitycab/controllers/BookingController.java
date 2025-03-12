
package com.megacitycab.controllers;

import com.megacitycab.dao.*;
import com.megacitycab.models.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet("/BookingController")
public class BookingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session Expired");
            return;
        }

        User customer = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("generateInvoice".equals(action)) {
            generateInvoice(request, response);
            return;
        }

        // ✅ Fetch recent bookings for the logged-in customer
        List<Booking> recentBookings = BookingDAO.getRecentBookings(customer.getUserID());
        request.setAttribute("recentBookings", recentBookings);

        // ✅ Forward to customer dashboard
        request.getRequestDispatcher("Views/Customer/customer_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("bookRide".equals(action)) {
            handleBookRide(request, response);
        } else if ("update".equals(action)) {
            handleUpdateBooking(request, response);
        } else if ("cancel".equals(action)) {
            handleCancelBooking(request, response);
        } else if ("makePayment".equals(action)) {
            handlePayment(request, response);
        }
        // (No duplicate conditions here)
    }

    // ✅ Handle Ride Booking
    private void handleBookRide(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session Expired");
                return;
            }

            User customer = (User) session.getAttribute("user");

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
                customer.getUserID(), assignedDriverID,
                pickupLat, pickupLng, dropoffLat, dropoffLng,
                distance, fare, discount, vehicleType
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

    // ✅ Update Booking
    private void handleUpdateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIDParam = request.getParameter("bookingID");
        String status = request.getParameter("status");
        HttpSession session = request.getSession();

        if (bookingIDParam == null || bookingIDParam.isEmpty()) {
            session.setAttribute("errorMessage", "Error: Invalid booking ID.");
            // Use the full path to the Admin folder
            request.getRequestDispatcher("Views/Admin/manage_bookings.jsp").forward(request, response);
            return;
        }

        int bookingID;
        try {
            bookingID = Integer.parseInt(bookingIDParam);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Error: Booking ID must be a valid number.");
            request.getRequestDispatcher("Views/Admin/manage_bookings.jsp").forward(request, response);
            return;
        }

        boolean success = BookingDAO.updateBookingStatus(bookingID, status);

        if (success) {
            session.setAttribute("successMessage", "Booking updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to update booking.");
        }

        // Make sure you use the correct path for manage_bookings.jsp
        request.getRequestDispatcher("Views/Admin/manage_bookings.jsp").forward(request, response);
    }

    // ✅ Cancel Booking
    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));

        boolean success = BookingDAO.cancelBooking(bookingID);

        response.setContentType("text/plain");
        response.getWriter().write(success ? "Booking cancelled successfully!" : "Failed to cancel booking.");
    }

    // ✅ Handle Payment Processing
    private void handlePayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        boolean success = BookingDAO.updateBookingStatus(bookingID, "Completed");

        if (success) {
            response.sendRedirect("booking_history.jsp?success=Payment Successful!");
        } else {
            response.sendRedirect("invoice.jsp?bookingID=" + bookingID + "&error=Payment failed.");
        }
    }

    // ✅ Generate Invoice as PDF
    private void generateInvoice(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        Booking booking = BookingDAO.getBookingById(bookingID);
        User driver = BookingDAO.getDriverById(booking.getDriverID());

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=invoice_" + bookingID + ".pdf");

        try (OutputStream out = response.getOutputStream()) {
            Document document = new Document();
            PdfWriter.getInstance(document, out);
            document.open();

            document.add(new Paragraph("Mega City Cab Invoice",
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18)));
            document.add(new Paragraph("Customer: " + booking.getCustomerID()));
            document.add(new Paragraph("Driver: " + (driver != null ? driver.getName() : "Not Assigned")));
            document.add(new Paragraph("Vehicle Type: " + booking.getVehicleType()));
            document.add(new Paragraph("Pickup Location: Lat " + booking.getPickupLat() + ", Lng " + booking.getPickupLng()));
            document.add(new Paragraph("Dropoff Location: Lat " + booking.getDropoffLat() + ", Lng " + booking.getDropoffLng()));
            document.add(new Paragraph("Distance: " + booking.getDistance() + " km"));
            document.add(new Paragraph("Estimated Time: " + booking.getEstimatedTime() + " mins"));
            document.add(new Paragraph("Fare: $" + booking.getFare()));
            document.add(new Paragraph("Discount: $" + booking.getDiscount()));
            document.add(new Paragraph("Total: $" + booking.getTotalAmount()));

            document.close();
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}

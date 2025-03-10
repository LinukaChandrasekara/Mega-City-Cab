package com.megacitycab.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import com.megacitycab.dao.BookingDAO;
import com.megacitycab.dao.CustomerDAO;
import com.megacitycab.models.Booking;
import com.megacitycab.models.User;
@WebServlet("/CustomerController")
@MultipartConfig
public class CustomerController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // ✅ Ensure only customers can access
        if (session == null || session.getAttribute("user") == null || !"Customer".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
            return;
        }

        User customer = (User) session.getAttribute("user");
        // ✅ Fetch booking history
        List<Booking> recentBookings = BookingDAO.getRecentBookings(customer.getUserID());

        // ✅ Fetch available discounts
        List<Map<String, String>> discounts = CustomerDAO.getAvailableDiscounts();

        // ✅ Set data in request scope
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("discounts", discounts);

        // ✅ Forward to the customer dashboard
        request.getRequestDispatcher("Views/Customer/customer_dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            HttpSession session = request.getSession(false);
            User customer = (User) session.getAttribute("user");

            handleUpdateProfile(request, response, customer, session);
        } 
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User customer, HttpSession session) throws IOException, ServletException {
        String newName = request.getParameter("name");
        String newPhone = request.getParameter("phone");
        String newAddress = request.getParameter("address");

        Part filePart = request.getPart("profilePicture"); // Get profile picture file
        byte[] profilePicture = null;

        if (filePart != null && filePart.getSize() > 0) {
            InputStream inputStream = filePart.getInputStream();
            profilePicture = inputStream.readAllBytes();
        }

        // ✅ Update profile in the database
        boolean success = CustomerDAO.updateCustomerProfile(customer.getUserID(), newName, newPhone, newAddress, profilePicture);

        if (success) {
            // ✅ Update session data
            customer.setName(newName);
            customer.setPhone(newPhone);
            customer.setAddress(newAddress);
            if (profilePicture != null) {
                customer.setProfilePicture(profilePicture);
            }
            session.setAttribute("user", customer);
            response.sendRedirect("Views/Customer/manage_profile.jsp?success=Profile%20Updated!");
        } else {
            response.sendRedirect("Views/Customer/manage_profile.jsp?error=Failed%20to%20update%20profile.");
        }
    }

 
}
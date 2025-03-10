package com.megacitycab.controllers;
import com.megacitycab.dao.*;
import com.megacitycab.models.*;

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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@WebServlet("/DriverController")
@MultipartConfig
public class DriverController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession(false);

	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session%20Expired");
	        return;
	    }

	    String userRole = (String) session.getAttribute("userRole");

	    // ✅ Fix: Ensure userRole is correctly retrieved
	    if (userRole == null || (!userRole.equals("Driver") && !userRole.equals("Admin"))) {
	        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
	        return;
	    }

	    // ✅ If Driver, Load Dashboard Data
	    if ("Driver".equals(userRole)) {
	        Driver driver = (Driver) session.getAttribute("user");

	        if (driver == null) {
	            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session%20Expired");
	            return;
	        }

	        // ✅ Fetch the latest vehicle details
	        Vehicle vehicle = VehicleDAO.getVehicleByDriverId(driver.getUserID());

	        if (vehicle != null) {
	            session.setAttribute("vehicle", vehicle);
	            request.setAttribute("vehicleType", vehicle.getType());
	            request.setAttribute("vehicleModel", vehicle.getModel());
	            request.setAttribute("licensePlate", vehicle.getLicensePlate());
	        } else {
	            session.setAttribute("vehicle", null);
	            request.setAttribute("vehicleType", "Not Assigned");
	            request.setAttribute("vehicleModel", "N/A");
	            request.setAttribute("licensePlate", "N/A");
	        }
	        
	        
	        // ✅ Fetch available rides that match the driver’s vehicle type
	        List<Booking> availableRides = BookingDAO.getAvailableBookingsByVehicleType(vehicle.getType());
	        if (availableRides == null) {
	            availableRides = new ArrayList<>(); // Ensure it's never null
	        }
	        // ✅ Fetch assigned rides (Confirmed, Ongoing, Completed) for this driver
	        List<Booking> assignedRides = BookingDAO.getAssignedBookings(driver.getUserID());
	        if (assignedRides == null) {
	            assignedRides = new ArrayList<>();
	        }
	        
	        request.setAttribute("availableRides", availableRides);
	        request.setAttribute("assignedRides", assignedRides);

	        // ✅ Forward to dashboard
	        request.getRequestDispatcher("/Views/Driver/driver_dashboard.jsp").forward(request, response);
	        return;
	    }

	    // ✅ If Admin, Load All Drivers
	    if ("Admin".equals(userRole)) {
	        List<Driver> drivers = DriverDAO.getAllDrivers();
	        request.setAttribute("drivers", drivers);
	        request.getRequestDispatcher("/Views/Admin/manage_drivers.jsp").forward(request, response);
	    }
	}





	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String action = request.getParameter("action");
	    HttpSession session = request.getSession(false);

	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session Expired");
	        return;
	    }

	    Driver driver = (Driver) session.getAttribute("user");

        if ("updateVehicle".equals(action)) {
            handleUpdateVehicle(request, response);
        } else if ("acceptRide".equals(action)) {
            handleAcceptRide(request, response, null);
        } else if ("updateRideStatus".equals(action)) {
            handleUpdateRideStatus(request, response, null);
        } else if ("updateProfile".equals(action)) {
            handleUpdateProfile(request, response);
        }
    }

	private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
	    HttpSession session = request.getSession(false);
	    Driver driver = (Driver) session.getAttribute("user");

	    if (driver == null || !"Driver".equals(driver.getRole())) {
	        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
	        return;
	    }

	    String newName = request.getParameter("name");
	    String newPhone = request.getParameter("phone");
	    String newAddress = request.getParameter("address");

	    Part filePart = request.getPart("profilePicture");
	    byte[] profilePicture = null;

	    if (filePart != null && filePart.getSize() > 0) {
	        InputStream inputStream = filePart.getInputStream();
	        profilePicture = inputStream.readAllBytes();
	    }

	    boolean success = DriverDAO.updateDriverProfile(driver.getUserID(), newName, newPhone, newAddress, profilePicture);

	    if (success) {
	        // ✅ Update session with new profile data
	        driver.setName(newName);
	        driver.setPhone(newPhone);
	        driver.setAddress(newAddress);
	        if (profilePicture != null) {
	            driver.setProfilePicture(profilePicture);
	        }
	        session.setAttribute("user", driver);

	        // ✅ Redirect **before returning**, avoiding `IllegalStateException`
	        response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_profile.jsp?success=Profile%20Updated!");
	    } else {
	        response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_profile.jsp?error=Failed%20to%20update%20profile.");
	    }
	}
    private void handleUpdateVehicle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Driver driver = (Driver) session.getAttribute("user");

        if (driver == null || !"Driver".equals(driver.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
            return;
        }

        String vehicleType = request.getParameter("vehicleType");
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String availabilityStatus = request.getParameter("availabilityStatus");

        // ✅ Check if driver already has a vehicle
        Vehicle existingVehicle = VehicleDAO.getVehicleByDriverId(driver.getUserID());

        boolean success;
        if (existingVehicle != null) {
            success = VehicleDAO.updateVehicle(driver.getUserID(), vehicleType, model, licensePlate, availabilityStatus);
        } else {
            success = VehicleDAO.insertVehicle(driver.getUserID(), vehicleType, model, licensePlate, availabilityStatus);
        }

        if (success) {
            // ✅ Update session with new vehicle details
            Vehicle updatedVehicle = VehicleDAO.getVehicleByDriverId(driver.getUserID());
            session.setAttribute("vehicle", updatedVehicle);

            response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_vehicle.jsp?success=Vehicle%20Updated!");
        } else {
            response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_vehicle.jsp?error=Failed%20to%20update%20vehicle.");
        }
    }
    private void handleAcceptRide(HttpServletRequest request, HttpServletResponse response, Driver driver) throws IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));

        boolean success = BookingDAO.assignDriverToBooking(bookingID, driver.getUserID());

        if (success) {
            response.sendRedirect("DriverController?success=Ride Accepted!");
        } else {
            response.sendRedirect("DriverController?error=Failed to accept ride.");
        }
    }

    private void handleUpdateRideStatus(HttpServletRequest request, HttpServletResponse response, Driver driver) throws IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        String newStatus = request.getParameter("status");

        boolean success = BookingDAO.updateBookingStatus(bookingID, newStatus);

        if (success) {
            response.sendRedirect("DriverController?success=Ride Updated!");
        } else {
            response.sendRedirect("DriverController?error=Failed to update ride.");
        }
    }


    /*
    private void handleAcceptRide(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        HttpSession session = request.getSession(false);
        User driver = (User) session.getAttribute("user");

        if (driver == null || !"Driver".equalsIgnoreCase(driver.getRole())) {
            response.sendRedirect("DriverController?error=Unauthorized access.");
            return;
        }

        // Check if the booking exists and is available
        Booking booking = BookingDAO.getBookingById(bookingID);
        if (booking == null || !"Pending".equalsIgnoreCase(Booking.getStatus())) {
            response.sendRedirect("DriverController?error=Booking%20is%20not%20available%20or%20already%20assigned.");
            return;
        }

        // Assign the ride to the driver and update status to "Confirmed"
        boolean success = BookingDAO.assignDriverToBooking(bookingID, driver.getUserID());

        if (success) {
            response.sendRedirect("DriverController?success=Ride%20Accepted!");
        } else {
            response.sendRedirect("DriverController?error=Failed%20to%20accept%20ride.");
        }
    }
    


    private void handleUpdateRideStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        String newStatus = request.getParameter("status");

        boolean success = BookingDAO.updateBookingStatus(bookingID, newStatus);

        if (success) {
            response.sendRedirect("DriverController?success=Ride%20Updated!");
        } else {
            response.sendRedirect("DriverController?error=Failed%20to%20update%20ride.");
        }
    }*/
}

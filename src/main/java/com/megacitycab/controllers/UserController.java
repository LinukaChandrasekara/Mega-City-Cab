package com.megacitycab.controllers;

import com.megacitycab.dao.UserDAO;
import com.megacitycab.models.User;

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

@WebServlet("/UserController")
@MultipartConfig(maxFileSize = 16177215) // 16MB max file size
public class UserController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int userID = Integer.parseInt(request.getParameter("userID"));
            boolean success = userDAO.deleteUser(userID);

            if (success) {
                System.out.println("✅ User deleted successfully: " + userID);
            } else {
                System.out.println("❌ Failed to delete user: " + userID);
            }

            response.sendRedirect(request.getContextPath() + "/UserController");
            return; // Stop further execution
        }
    	// Fetch all users
        List<User> users = userDAO.getAllUsers();

        // Debugging: Print users count in console
        System.out.println("📌 UserController: Retrieved " + users.size() + " users.");

        // ✅ Ensure users list is set in request
        request.setAttribute("users", users);

        // ✅ Forward request to manage_users.jsp
        request.getRequestDispatcher("/Views/Admin/manage_users.jsp").forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Session Expired");
            return;
        }

        // Extract logged-in user
        User loggedUser = (User) session.getAttribute("user");


        InputStream inputStream = null;
        Part filePart = request.getPart("profilePicture");

        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }
        if ("updateDriverProfile".equals(action)) {
            byte[] profilePicBytes = inputStream != null ? inputStream.readAllBytes() : null;

            // ✅ Update only allowed fields
            User updatedUser = new User(
                    loggedUser.getUserID(), // Keep same user ID
                    request.getParameter("name"),
                    loggedUser.getEmail(), // Keep email unchanged
                    request.getParameter("phone"),
                    request.getParameter("address"),
                    null, // Do not update password here
                    loggedUser.getRole(),
                    profilePicBytes // Update profile picture if provided
            );


            boolean success = userDAO.updateUser(updatedUser);

            if (success) {
                session.setAttribute("user", updatedUser); // ✅ Update session with new details
                response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_profile.jsp?success=Profile Updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/Views/Driver/manage_profile.jsp?error=Failed to update profile");
            }
        }

        if ("add".equals(action)) {
            byte[] profilePicBytes = inputStream != null ? inputStream.readAllBytes() : null;
            User user = new User(0, request.getParameter("name"), request.getParameter("email"),
                    request.getParameter("phone"), request.getParameter("address"),
                    request.getParameter("password"), request.getParameter("role"), profilePicBytes);

            userDAO.addUser(user);
        } else if ("edit".equals(action)) {
            byte[] profilePicBytes = inputStream != null ? inputStream.readAllBytes() : null;
            User user = new User(Integer.parseInt(request.getParameter("userID")), request.getParameter("name"),
                    request.getParameter("email"), request.getParameter("phone"), request.getParameter("address"),
                    null, request.getParameter("role"), profilePicBytes);

            userDAO.updateUser(user);
        }

        response.sendRedirect("${pageContext.request.contextPath}../../manage_users.jsp");
    }
}

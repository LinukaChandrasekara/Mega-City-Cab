package com.megacitycab.controllers;
import com.megacitycab.dao.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/RegisterController")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10MB max file size
public class RegisterController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        // Handle file upload (only for drivers)
        InputStream profilePictureStream = null;
        if ("Driver".equals(role)) {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                profilePictureStream = filePart.getInputStream();
            }
        }

        boolean success = RegisterDAO.registerUser(name, email, phone, address, password, role, profilePictureStream);

        if (success) {
            response.sendRedirect("../login.jsp?success=Registered successfully!");
        } else {
            request.setAttribute("error", "Registration failed! Try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

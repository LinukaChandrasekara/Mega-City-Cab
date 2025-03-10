package com.megacitycab.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.megacitycab.dao.AuthDAO;
import com.megacitycab.dao.DriverDAO;
import com.megacitycab.models.User;
import com.megacitycab.models.Driver;

import java.io.IOException;

@WebServlet("/AuthController")
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        User user = AuthDAO.authenticate(identifier, password);

        if (user != null) {
            HttpSession session = request.getSession();

            if ("Driver".equals(user.getRole())) {
                Driver driver = DriverDAO.getDriverById(user.getUserID());

                if (driver != null) { 
                    session.setAttribute("user", driver); // Store full Driver object
                    session.setAttribute("userRole", driver.getRole()); 
                    System.out.println("🚀 Driver Logged In: " + driver.getName() + " | Role: " + driver.getRole());
                } else {
                    System.out.println("⚠️ Driver not found in DB for ID: " + user.getUserID());
                }
            } else {
                session.setAttribute("user", user);
                session.setAttribute("userRole", user.getRole());
                System.out.println("🚀 User Logged In: " + user.getName() + " | Role: " + user.getRole());
            }

            if ("on".equals(rememberMe)) {
                Cookie userCookie = new Cookie("userIdentifier", identifier);
                userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                response.addCookie(userCookie);
            }

            // ✅ Redirect based on role
            switch (user.getRole()) {
                case "Admin":
                    response.sendRedirect("AdminController?action=dashboard");
                    break;
                case "Customer":
                	response.sendRedirect("BookingController?action=dashboard");
                    break;
                case "Driver":
                    response.sendRedirect("DriverController?action=dashboard");
                    break;
                default:
                    session.invalidate();
                    request.setAttribute("error", "Invalid user role.");
                    request.getRequestDispatcher("Views/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid username/email or password.");
            request.getRequestDispatcher("Views/login.jsp").forward(request, response);
        }
    }


}

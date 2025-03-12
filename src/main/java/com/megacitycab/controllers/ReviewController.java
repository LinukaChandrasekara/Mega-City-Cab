package com.megacitycab.controllers;

import com.megacitycab.dao.ReviewDAO;
import com.megacitycab.models.Review;
import com.megacitycab.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/ReviewController")
public class ReviewController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("add".equals(action)) {
            int driverID = Integer.parseInt(request.getParameter("driverID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            boolean success = ReviewDAO.addReview(user.getUserID(), driverID, rating, comments);
            session.setAttribute("successMessage", success ? "Review added successfully!" : "Failed to add review.");
        } else if ("update".equals(action)) {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            boolean success = ReviewDAO.updateReview(reviewID, rating, comments);
            session.setAttribute("successMessage", success ? "Review updated successfully!" : "Failed to update review.");
        } else if ("delete".equals(action)) {
            int reviewID = Integer.parseInt(request.getParameter("reviewID"));

            boolean success = ReviewDAO.deleteReview(reviewID);
            session.setAttribute("successMessage", success ? "Review deleted successfully!" : "Failed to delete review.");
        }

        response.sendRedirect("reviews.jsp");
    }
}

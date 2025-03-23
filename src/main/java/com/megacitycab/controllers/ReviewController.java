package com.megacitycab.controllers;

import com.megacitycab.dao.BookingDAO;
import com.megacitycab.dao.ReviewDAO;
import com.megacitycab.dao.UserDAO;
import com.megacitycab.models.Booking;
import com.megacitycab.models.Review;
import com.megacitycab.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ReviewController")
public class ReviewController extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String message = "";
        String redirectPage = "login.jsp";

        if (user == null) {
            response.sendRedirect(redirectPage);
            return;
        }

        try {
            switch (action) {
            case "add":
                if ("Customer".equals(user.getRole())) {
                    int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                    int rating = Integer.parseInt(request.getParameter("rating"));
                    String comments = request.getParameter("comments");
                    
                    boolean added = ReviewDAO.addReview(
                        user.getUserID(), 
                        bookingID,
                        rating, 
                        comments
                    );
                    
                    if (added) {
                        session.setAttribute("message", "Review added successfully!");
                    } else {
                        session.setAttribute("error", "Failed to add review");
                    }
                    response.sendRedirect(request.getContextPath() + "/Views/Customer/customer_reviews.jsp");
                }
                break;

                case "update":
                    int reviewID = Integer.parseInt(request.getParameter("reviewID"));
                    Review existing = ReviewDAO.getReviewByBookingId(reviewID);
                    
                    if (existing != null && existing.getCustomerID() == user.getUserID()) {
                        int rating = Integer.parseInt(request.getParameter("rating"));
                        String comments = request.getParameter("comments");
                        
                        boolean updated = ReviewDAO.updateReview(reviewID, rating, comments);
                        message = updated ? "Review updated!" : "Update failed";
                    } else {
                        message = "Unauthorized update attempt";
                    }
                    redirectPage = "customer_reviews.jsp";
                    break;

                case "delete":
                    int delReviewID = Integer.parseInt(request.getParameter("reviewID"));
                    Review toDelete = ReviewDAO.getReviewByBookingId(delReviewID);
                    
                    if (toDelete != null && (
                            "Admin".equals(user.getRole()) || 
                            toDelete.getCustomerID() == user.getUserID())) {
                        
                        boolean deleted = ReviewDAO.deleteReview(delReviewID);
                        message = deleted ? "Review deleted!" : "Deletion failed";
                    } else {
                        message = "Unauthorized deletion attempt";
                    }
                    
                    redirectPage = "Admin".equals(user.getRole()) 
                            ? "admin_reviews.jsp" 
                            : "customer_reviews.jsp";
                    break;

                default:
                    message = "Invalid action";
                    redirectPage = "dashboard.jsp";
            }
        }catch (Exception e) {
            if (!response.isCommitted()) {
                session.setAttribute("error", "Error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/Views/Customer/customer_reviews.jsp");
                return;
            }
        }

        // Only execute if no redirect happened in switch
        if (!response.isCommitted()) {
            session.setAttribute("message", message);
            response.sendRedirect(redirectPage);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String redirectPage = "login.jsp";

        if (user == null) {
            response.sendRedirect(redirectPage);
            return;
        }

        try {
            switch (action) {
            case "add":
                if ("Customer".equals(user.getRole())) {
                    int bookingID = Integer.parseInt(request.getParameter("bookingID"));
                    
                    // Get booking details
                    Booking booking = BookingDAO.getBookingById(bookingID);
                    
                    if (booking == null || booking.getDriverID() == 0) {
                        throw new ServletException("Invalid booking");
                    }
                    
                    // Get driver details
                    User driver = UserDAO.getUserById(booking.getDriverID());
                    
                    request.setAttribute("driver", driver);
                    request.setAttribute("bookingID", bookingID);
                    redirectPage = "/Views/Customer/add_review.jsp";
                }
                break;
                case "admin":
                    if ("Admin".equals(user.getRole())) {
                        request.setAttribute("reviews", ReviewDAO.getAllReviews());
                        redirectPage = "/Views/Admin/admin_reviews.jsp";
                    }
                    break;

                case "driver":
                    if ("Driver".equals(user.getRole())) {
                        request.setAttribute("reviews", ReviewDAO.getReviewsByDriver(user.getUserID()));
                        request.setAttribute("averageRating", 
                                ReviewDAO.getAverageRating(user.getUserID()));
                        redirectPage = "/Views/Driver/driver_reviews.jsp";
                    }
                    break;

                case "edit":
                    if ("Customer".equals(user.getRole())) {
                        int reviewID = Integer.parseInt(request.getParameter("reviewID"));
                        Review review = ReviewDAO.getReviewByBookingId(reviewID);
                        
                        if (review != null && review.getCustomerID() == user.getUserID()) {
                            request.setAttribute("review", review);
                            redirectPage = "/Views/Customer/edit_review.jsp";
                        }
                    }
                    break;

                default:
                    redirectPage = "dashboard.jsp";
            }
            
            request.getRequestDispatcher(redirectPage).forward(request, response);
            
        }  catch (Exception e) {
            if (!response.isCommitted()) {
                session.setAttribute("message", "Error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            } else {
                // Log the error but can't redirect
                e.printStackTrace();
            }
        }
    }
}
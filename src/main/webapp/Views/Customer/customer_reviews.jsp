<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="com.megacitycab.models.User, com.megacitycab.models.Review, java.util.List"%>
<%@ page import="com.megacitycab.dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    Review editReview = (Review) request.getAttribute("review");
    List<Review> reviews = ReviewDAO.getReviewsByCustomer(user.getUserID());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= editReview != null ? "Edit Review" : "My Reviews" %> | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background-color: #212529;
            padding-top: 20px;
            color: white;
        }
        .sidebar h4 {
            text-align: center;
            color: #FFC107;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .sidebar a {
            color: white;
            padding: 12px;
            display: block;
            text-decoration: none;
            font-size: 16px;
            transition: 0.3s;
        }
        .sidebar a:hover {
            background-color: #343a40;
            padding-left: 18px;
        }
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .table thead {
            background-color: #FFC107;
            color: #212529;
        }
        .btn-warning {
            background-color: #FFC107;
            border: none;
            color: #212529;
        }
        .btn-danger {
            background-color: #DC3545;
            border: none;
        }
        .star-rating {
            color: #FFC107;
            font-size: 1.2rem;
        }
        .edit-form {
            max-width: 600px;
            margin: 0 auto;
        }
        .star-rating-form {
            direction: rtl;
            display: inline-block;
            unicode-bidi: bidi-override;
        }
        .star-rating-form input[type="radio"] {
            display: none;
        }
        .star-label {
            color: #ddd;
            font-size: 1.5rem;
            padding: 0 3px;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-rating-form input[type="radio"]:checked ~ .star-label,
        .star-label:hover,
        .star-label:hover ~ .star-label {
            color: #FFC107;
        }
        textarea.form-control {
            border: 2px solid #FFC107;
            border-radius: 8px;
            padding: 1rem;
            resize: vertical;
        }
        .driver-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #FFC107;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h4>Mega City Cab</h4>
    <a href="${pageContext.request.contextPath}/BookingController?action=dashboard"><i class="fas fa-home"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
    <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp"><i class="fas fa-taxi"></i> Book a Ride</a>
    <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp"><i class="fas fa-history"></i> Booking History</a>
    <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" 
       style="<%= editReview == null ? "background-color: #343a40; padding-left: 18px;" : "" %>">
        <i class="fas fa-star"></i> Reviews
    </a>
    <a href="${pageContext.request.contextPath}/Views/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="card card-custom p-4">
		<%
		    // Message handling
		    String message = (String) session.getAttribute("message");
		    String error = (String) session.getAttribute("error");
		    
		    if (message != null) { 
		        session.removeAttribute("message");
		%>
		    <div class="alert alert-success alert-dismissible fade show">
		        <%= message %>
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		<%
		    } 
		    if (error != null) {
		        session.removeAttribute("error");
		%>
		    <div class="alert alert-danger alert-dismissible fade show">
		        <%= error %>
		        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
		    </div>
		<%
		    }
		%>
        <% if (editReview != null) { %>
            <!-- Edit Review Form -->
            <h3 class="mb-4"><i class="fas fa-edit"></i> Edit Review</h3>
            
            <form action="ReviewController" method="post" class="edit-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="reviewID" value="<%= editReview.getReviewID() %>">
                
                <div class="mb-4">
                    <div class="d-flex align-items-center mb-3">
                        <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= editReview.getDriverID() %>" 
                             class="driver-avatar me-2" 
                             alt="Driver image">
                        <h5 class="mb-0"><%= editReview.getDriverName() %></h5>
                    </div>
                    
                    <div class="star-rating-form mb-3">
                        <% for (int i = 5; i >= 1; i--) { %>
                            <input type="radio" id="star<%= i %>" name="rating" 
                                   value="<%= i %>" <%= editReview.getRating() == i ? "checked" : "" %>>
                            <label for="star<%= i %>" class="star-label"><i class="fas fa-star"></i></label>
                        <% } %>
                    </div>
                </div>
                
                <div class="mb-4">
                    <textarea name="comments" class="form-control" 
                              rows="4" placeholder="Share your experience..."><%= editReview.getComments() %></textarea>
                </div>
                
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-warning flex-grow-1">
                        <i class="fas fa-save me-2"></i>Update Review
                    </button>
                    <a href="customer_reviews.jsp" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancel
                    </a>
                </div>
            </form>

        <% } else { %>
            <!-- Reviews List -->
            <h3 class="mb-4"><i class="fas fa-star"></i> My Reviews</h3>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-info alert-dismissible fade show">
                    <%= request.getAttribute("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="table-responsive">
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Driver</th>
                            <th>Rating</th>
                            <th>Comments</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Review review : reviews) { %>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= review.getDriverID() %>" 
                                         class="driver-avatar me-2" 
                                         alt="Driver image">
                                    <%= review.getDriverName() %>
                                </div>
                            </td>
                            <td>
                                <div class="star-rating">
                                    <% for(int i=0; i<review.getRating(); i++) { %>
                                        <i class="fas fa-star"></i>
                                    <% } %>
                                    <% for(int i=review.getRating(); i<5; i++) { %>
                                        <i class="far fa-star"></i>
                                    <% } %>
                                </div>
                            </td>
                            <td><%= review.getComments() %></td>
                            <td><%= review.getReviewDate().toString().split(" ")[0] %></td>

                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <% if (reviews.isEmpty()) { %>
                <div class="alert alert-warning mt-3">
                    <i class="fas fa-info-circle me-2"></i>
                    No reviews found. Start by reviewing your completed rides!
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
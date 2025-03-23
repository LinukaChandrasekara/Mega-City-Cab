<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.megacitycab.models.User, com.megacitycab.dao.UserDAO" %>
<%
	User loggedUser = (User) session.getAttribute("user");
		if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRole())) {
   			 response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Unauthorized%20Access");
    	return;
	}

    User driver = (User) request.getAttribute("driver");
    Integer bookingID = (Integer) request.getAttribute("bookingID");
    String errorMessage = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Review | Mega City Cab</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .card-custom {
            border-radius: 10px;
            background-color: #ffffff;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .star-rating-form {
            direction: rtl;
            display: inline-block;
            unicode-bidi: bidi-override;
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
        .heading-container {
            background: #ffc107;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            color: #212529;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="main-content" style="margin-left: 260px; padding: 20px;">
        <div class="card card-custom p-4">
            <div class="heading-container">
                <h3><i class="fas fa-star"></i> Add Review</h3>
            </div>

            <% if (driver == null) { %>
                <div class="alert alert-danger">
                    Driver information not found. Please try again.
                </div>
            <% } else { %>
                <% if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <%= errorMessage %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/ReviewController" method="post" class="edit-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="driverID" value="<%= driver.getUserID() %>">
                    <input type="hidden" name="bookingID" value="<%= bookingID %>">
                    
                    <div class="mb-4">
						<div class="d-flex align-items-center mb-3">
							<img src="${pageContext.request.contextPath}/GetProfilePicture?userID=<%= driver.getUserID() %>" 
							     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default_driver.png'"
							     class="driver-avatar me-2" 
							     alt="Driver image">
						    <h5 class="mb-0"><%= driver.getName() %></h5>
						</div>
						
						<input type="hidden" name="bookingID" value="<%= bookingID %>">
                        <div class="star-rating-form mb-3">
                            <% for (int i = 5; i >= 1; i--) { %>
                                <input type="radio" id="star<%= i %>" name="rating" 
                                       value="<%= i %>" required>
                                <label for="star<%= i %>" class="star-label"><i class="fas fa-star"></i></label>
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <textarea name="comments" class="form-control" 
                                  rows="4" placeholder="Share your experience..." required></textarea>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning flex-grow-1">
                            <i class="fas fa-save me-2"></i>Submit Review
                        </button>
                        <a href="customer_reviews.jsp" class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>Cancel
                        </a>
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page session="true" %>
<%
    String message = request.getParameter("message");
    if (message == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation - Mega City Cab</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5 text-center">
        <h2 class="text-success">🎉 Booking Confirmed!</h2>
        <p class="lead mt-3"><%= message %></p>
        <a href="bookingHistory.jsp" class="btn btn-primary mt-3">View Booking History</a>
        <a href="index.jsp" class="btn btn-secondary mt-3">Back to Home</a>
    </div>
</body>
</html>

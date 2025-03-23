<%@ page session="true" %>
<%@ page import="java.util.List, com.megacitycab.models.User" %>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null || !"Customer".equals(((User) userSession.getAttribute("user")).getRole())) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Only%20customers%20can%20book%20rides.");
        return;
    }

    User customer = (User) userSession.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book a Ride | Mega City Cab</title>

    <!-- Bootstrap & Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />

    <style>
        /* Sidebar Styles */
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

        /* General Styles */
        body {
            background-color: #f8f9fa;
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
        }
        /* Main Content Adjustment */
        .content {
            margin-left: 260px;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        /* Heading */
        .heading-container {
            background: #ffc107;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            color: #212529;
            font-weight: bold;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        /* Two-column Layout */
        .row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .col-left, .col-right {
            flex: 1;
            min-width: 48%;
        }
        /* Map */
        #map {
            height: 400px;
            width: 100%;
            border-radius: 8px;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        /* Buttons */
        .btn-custom {
            width: 100%;
            transition: 0.3s ease-in-out;
        }
        .btn-custom:hover {
            transform: scale(1.05);
        }
        /* Icons */
        .icon {
            font-size: 18px;
            margin-right: 5px;
        }
        @media (max-width: 768px) {
            .col-left, .col-right {
                flex: 100%;
                min-width: 100%;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <h4>Mega City Cab</h4>
        <a href="${pageContext.request.contextPath}/BookingController?action=dashboard""><i class="fas fa-home"></i> Dashboard</a>
        <a href="${pageContext.request.contextPath}/Views/Customer/manage_profile.jsp" class="nav-link text-white">
            <i class="fas fa-user"></i> Manage Profile
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/book_ride.jsp" class="nav-link text-white">
            <i class="fas fa-taxi"></i> Book a Ride
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/booking_history.jsp" class="nav-link text-white">
            <i class="fas fa-history"></i> Booking History
        </a>
        <a href="${pageContext.request.contextPath}/Views/Customer/customer_reviews.jsp" class="nav-link text-white">
            <i class="fas fa-star"></i> Reviews
        </a>
        <a href="${pageContext.request.contextPath}/Views/login.jsp" class="nav-link text-danger">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>

    <!-- Main Content -->
    <div class="content">
        <div class="container mt-4">
            <!-- Page Heading -->
            <div class="heading-container mb-4">
                <h2><i class="fas fa-taxi"></i> Book Your Ride</h2>
            </div>

            <div class="row">
                <!-- Left Column: Form Inputs -->
                <div class="col-left">
                    <form action="${pageContext.request.contextPath}/BookingController" method="post">
                        <input type="hidden" name="action" value="bookRide">

                        <div class="mb-3">
                            <label class="form-label"><i class="fas fa-user icon"></i> Full Name</label>
                            <input type="text" class="form-control" name="customer_name" value="<%= customer.getName() %>" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label"><i class="fas fa-phone icon"></i> Phone Number</label>
                            <input type="tel" class="form-control" name="phone" value="<%= customer.getPhone() %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label"><i class="fas fa-map-marker-alt icon"></i> Pickup Location</label>
                            <input type="text" class="form-control" id="pickup_location" name="pickup_location" required>
                            <input type="hidden" id="pickup_lat" name="pickup_lat">
                            <input type="hidden" id="pickup_lng" name="pickup_lng">
                        </div>

                        <div class="mb-3">
                            <label class="form-label"><i class="fas fa-map-pin icon"></i> Drop-off Location</label>
                            <input type="text" class="form-control" id="dropoff_location" name="dropoff_location" required>
                            <input type="hidden" id="dropoff_lat" name="dropoff_lat">
                            <input type="hidden" id="dropoff_lng" name="dropoff_lng">
                        </div>

                        <div class="mb-3">
                            <label class="form-label"><i class="fas fa-car icon"></i> Select Vehicle Type</label>
                            <select class="form-select" name="vehicle_type" id="vehicle_type" required>
                                <option value="Bike">Bike</option>
                                <option value="Car">Car</option>
                                <option value="Van">Van</option>
                            </select>
                        </div>

                        <button type="button" class="btn btn-info btn-custom" onclick="calculateRoute()">
                            <i class="fas fa-calculator"></i> Calculate Fare
                        </button>

                        <p id="fare_display" class="mt-3 text-center text-success fw-bold"></p>

                        <input type="hidden" id="distance" name="distance">
                        <input type="hidden" id="fare" name="fare">

                        <button type="submit" class="btn btn-warning btn-custom mt-3">
                            <i class="fas fa-check-circle"></i> Confirm Booking
                        </button>
                    </form>
                </div>

                <!-- Right Column: Map -->
                <div class="col-right">
                    <div id="map"></div>
                    <!-- Branding or Additional Information Below the Map -->
                    <div class="text-center mt-4 bg-light rounded">
                        <h5 class="text-warning"><i class="fas fa-road"></i> Ride with Confidence</h5>
                        <p class="text-muted">Mega City Cab ensures safe, affordable, and comfortable rides for you.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Map & Routing Scripts -->
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.min.js"></script>

    <script>
        const map = L.map('map').setView([6.9271, 79.8612], 12); // Colombo coordinates

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        const control = L.Routing.control({
            waypoints: [],
            routeWhileDragging: false
        }).addTo(map);

        function calculateRoute() {
            const pickup = document.getElementById("pickup_location").value;
            const dropoff = document.getElementById("dropoff_location").value;
            const vehicleType = document.getElementById("vehicle_type").value;

            if (!pickup || !dropoff) {
                alert("Please enter both pickup and drop-off locations.");
                return;
            }

            fetch("https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(pickup))
                .then(response => response.json())
                .then(pickupData => {
                    if (!pickupData[0]) throw new Error("Invalid pickup location.");
                    const pickupCoords = [parseFloat(pickupData[0].lat), parseFloat(pickupData[0].lon)];

                    document.getElementById("pickup_lat").value = pickupCoords[0];
                    document.getElementById("pickup_lng").value = pickupCoords[1];

                    return fetch("https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(dropoff))
                        .then(response => response.json())
                        .then(dropoffData => {
                            if (!dropoffData[0]) throw new Error("Invalid drop-off location.");
                            const dropoffCoords = [parseFloat(dropoffData[0].lat), parseFloat(dropoffData[0].lon)];

                            document.getElementById("dropoff_lat").value = dropoffCoords[0];
                            document.getElementById("dropoff_lng").value = dropoffCoords[1];

                            control.setWaypoints([
                                L.latLng(pickupCoords[0], pickupCoords[1]),
                                L.latLng(dropoffCoords[0], dropoffCoords[1])
                            ]);

                            const router = L.Routing.osrmv1({ serviceUrl: 'https://router.project-osrm.org/route/v1' });
                            router.route(
                                [
                                    { latLng: L.latLng(pickupCoords[0], pickupCoords[1]) },
                                    { latLng: L.latLng(dropoffCoords[0], dropoffCoords[1]) }
                                ],
                                (err, routes) => {
                                    if (err) {
                                        alert("Could not calculate route.");
                                        return;
                                    }
                                    const route = routes[0];
                                    const distanceInKm = route.summary.totalDistance / 1000;
                                    calculateFare(distanceInKm, vehicleType);
                                }
                            );
                        });
                })
                .catch(error => alert(error.message));
        }

        function calculateFare(distance, vehicleType) {
            const baseFares = { Bike: 2.00, Car: 3.00, Van: 5.00 };
            const perKmRates = { Bike: 0.80, Car: 1.20, Van: 1.80 };

            let fare = baseFares[vehicleType] + (distance * perKmRates[vehicleType]);
            let discount = 0;

            if (distance > 8 && distance <= 15) discount = 0.05;
            else if (distance > 15 && distance <= 30) discount = 0.10;
            else if (distance > 30 && distance <= 60) discount = 0.15;
            else if (distance > 60) discount = 0.20;

            const discountAmount = fare * discount;
            const totalFare = fare - discountAmount;

            document.getElementById("fare_display").innerText =
                "Distance: " + distance.toFixed(2) + " km | Estimated Fare: $" + totalFare.toFixed(2) +
                " (Discount: $" + discountAmount.toFixed(2) + ")";

            document.getElementById("distance").value = distance.toFixed(2);
            document.getElementById("fare").value = totalFare.toFixed(2);
        }

        function validateBooking() {
            const distance = document.getElementById("distance").value;
            const fare = document.getElementById("fare").value;

            if (!distance || !fare) {
                alert("Please calculate the fare before confirming the booking.");
                return false;
            }
            return true;
        }
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

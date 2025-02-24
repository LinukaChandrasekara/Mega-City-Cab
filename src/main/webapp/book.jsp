<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp?message=Please login to book a ride.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book a Ride</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        #map {
            height: 300px;
            width: 100%;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-warning text-center">Book Your Ride</h2>
        <form action="book" method="post">
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" name="customer_name" value="<%= username %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone Number</label>
                <input type="tel" class="form-control" name="phone" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Pickup Location</label>
                <input type="text" class="form-control" id="pickup_location" name="pickup_location" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Drop-off Location</label>
                <input type="text" class="form-control" id="dropoff_location" name="dropoff_location" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Select Vehicle Type</label>
                <select class="form-select" name="vehicle_type" id="vehicle_type" required>
                    <option value="bike">Bike</option>
                    <option value="cab">Cab</option>
                    <option value="van">Van</option>
                </select>
            </div>

            <div id="map"></div>
            <button type="button" class="btn btn-info w-100" onclick="calculateRoute()">Calculate Fare</button>
            <p id="fare_display" class="mt-3 text-center text-success fw-bold"></p>

            <input type="hidden" id="distance" name="distance">
            <input type="hidden" id="fare" name="fare">

            <button type="submit" class="btn btn-warning w-100 mt-3">Confirm Booking</button>
        </form>
    </div>

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

                    return fetch("https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(dropoff))
                        .then(response => response.json())
                        .then(dropoffData => {
                            if (!dropoffData[0]) throw new Error("Invalid drop-off location.");
                            const dropoffCoords = [parseFloat(dropoffData[0].lat), parseFloat(dropoffData[0].lon)];

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
                                    const durationInMinutes = route.summary.totalTime / 60;
                                    calculateFare(distanceInKm, vehicleType, durationInMinutes);
                                }
                            );
                        });
                })
                .catch(error => alert(error.message));
        }

        function calculateFare(distance, vehicleType, duration) {
            const baseFares = { bike: 2.00, cab: 3.00, van: 5.00 };
            const perKmRates = { bike: 0.80, cab: 1.20, van: 1.80 };

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
    </script>
</body>
</html>

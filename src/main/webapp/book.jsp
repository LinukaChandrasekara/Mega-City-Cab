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
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY&libraries=places"></script>

    <style>
        #map {
            height: 300px;
            width: 100%;
            margin-bottom: 20px;
        }
    </style>

    <script>
        let map, directionsService, directionsRenderer;

        function initMap() {
            directionsService = new google.maps.DirectionsService();
            directionsRenderer = new google.maps.DirectionsRenderer();
            
            map = new google.maps.Map(document.getElementById("map"), {
                center: { lat: 6.9271, lng: 79.8612 }, // Colombo coordinates
                zoom: 12,
            });
            directionsRenderer.setMap(map);

            const pickupInput = document.getElementById("pickup_location");
            const dropoffInput = document.getElementById("dropoff_location");

            new google.maps.places.Autocomplete(pickupInput);
            new google.maps.places.Autocomplete(dropoffInput);
        }

        function calculateRoute() {
            const pickup = document.getElementById("pickup_location").value;
            const dropoff = document.getElementById("dropoff_location").value;
            const vehicleType = document.getElementById("vehicle_type").value;

            if (pickup && dropoff) {
                directionsService.route({
                    origin: pickup,
                    destination: dropoff,
                    travelMode: google.maps.TravelMode.DRIVING,
                }, (response, status) => {
                    if (status === "OK") {
                        directionsRenderer.setDirections(response);
                        const distanceInKm = response.routes[0].legs[0].distance.value / 1000;
                        const durationInMinutes = response.routes[0].legs[0].duration.value / 60;
                        calculateFare(distanceInKm, vehicleType, durationInMinutes);
                    } else {
                        alert("Could not calculate route. Please try again.");
                    }
                });
            }
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
                `Distance: ${distance.toFixed(2)} km | Estimated Fare: $${totalFare.toFixed(2)} (Discount: $${discountAmount.toFixed(2)})`;

            document.getElementById("distance").value = distance.toFixed(2);
            document.getElementById("fare").value = totalFare.toFixed(2);
        }
    </script>
</head>
<body onload="initMap()">
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
</body>
</html>

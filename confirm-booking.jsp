<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Booking - Green Mobility</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow">
            <div class="card-body p-4">
                <h2 class="mb-4">Confirm Your Booking</h2>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } else if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("message") %>
                    </div>
                    <% if (request.getAttribute("co2Saved") != null) { %>
                        <p>CO2 saved: <%= request.getAttribute("co2Saved") %> kg</p>
                    <% } %>
                    <a href="browse.jsp" class="btn btn-success">Browse Slots</a>
                    <a href="my-bookings.jsp" class="btn btn-outline-success">My Bookings &amp; Impact</a>
                <% } else { %>
                    <p>Selected slot: <%= session.getAttribute("selectedSlotId") %></p>
                    <form action="confirm-booking" method="post">
                        <button type="submit" class="btn btn-success">Confirm Booking</button>
                        <a href="browse.jsp" class="btn btn-secondary">Cancel</a>
                    </form>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.greenmobility.dao.BookingImpactDAO,com.greenmobility.dao.BookingImpact,java.util.List,java.math.BigDecimal,java.text.SimpleDateFormat" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<BookingImpact> bookings = null;
    BigDecimal co2Total = BigDecimal.ZERO;
    String errorMessage = null;
    try {
        BookingImpactDAO impactDAO = new BookingImpactDAO();
        bookings = impactDAO.getPastBookings(studentId);
        if (!bookings.isEmpty()) {
            co2Total = bookings.get(bookings.size() - 1).getRunningCo2SavedKg();
        }
    } catch (Exception e) {
        errorMessage = e.getMessage();
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy, HH:mm");

    // ---- NEW: extra dashboard stats, derived from the same bookings list ----
    // These are calculated here in the page rather than a new DAO method,
    // since they're simple derived values from data we already fetched --
    // adding a whole new DB round-trip for these would be wasteful.
    int totalTrips = (bookings != null) ? bookings.size() : 0;
    BigDecimal avgCo2PerTrip = BigDecimal.ZERO;
    if (totalTrips > 0) {
        avgCo2PerTrip = co2Total.divide(new BigDecimal(totalTrips), 3, java.math.RoundingMode.HALF_UP);
    }
    // Rough equivalence: one mature tree absorbs about 21 kg of CO2 per year.
    // This is a commonly cited estimate, used here just to make the number 
    // more relatable -- not a scientifically precise claim.
    double treeEquivalent = co2Total.doubleValue() / 21.0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings &amp; Impact - Green Mobility</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand navbar-dark bg-success shadow-sm">
        <div class="container"><a class="navbar-brand fw-semibold" href="browse.jsp">🌱 Green Mobility</a>
            <div class="navbar-nav ms-auto"><a class="nav-link" href="browse.jsp">Browse slots</a><a class="nav-link active" href="my-bookings.jsp">My bookings</a></div>
        </div>
    </nav>
    <main class="container py-4 py-md-5">
        <p class="text-success text-uppercase fw-semibold small mb-1">Your travel record</p>
        <h1 class="display-6 fw-bold mb-4">My Bookings &amp; Impact</h1>

        <!-- ============ CARBON DASHBOARD: multi-stat row ============ -->
        <div class="row g-3 mb-4">
            <div class="col-md-3 col-6">
                <div class="card border-0 shadow-sm text-bg-success h-100">
                    <div class="card-body">
                        <div class="small text-white-50">Total CO<sub>2</sub> saved</div>
                        <div class="h3 fw-bold mb-0"><%= co2Total.setScale(3, java.math.RoundingMode.HALF_UP) %> kg</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="small text-muted">Total trips taken</div>
                        <div class="h3 fw-bold mb-0 text-success"><%= totalTrips %></div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="small text-muted">Avg. CO<sub>2</sub> saved / trip</div>
                        <div class="h3 fw-bold mb-0 text-success"><%= avgCo2PerTrip %> kg</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="small text-muted">🌳 Equivalent trees/year</div>
                        <div class="h3 fw-bold mb-0 text-success"><%= String.format("%.2f", treeEquivalent) %></div>
                    </div>
                </div>
            </div>
        </div>

        <% if (errorMessage != null) { %>
            <div class="alert alert-danger">Unable to load booking history: <%= errorMessage %></div>
        <% } else if (bookings.isEmpty()) { %>
            <div class="card border-0 shadow-sm text-center"><div class="card-body py-5">
                <div class="display-5 mb-3">🚗</div><h2 class="h4">No past bookings yet</h2>
                <p class="text-muted">Once you complete a journey, its CO<sub>2</sub> impact will appear here.</p>
                <a class="btn btn-success" href="browse.jsp">Browse available slots</a>
            </div></div>
        <% } else { %>
            <div class="card border-0 shadow-sm overflow-hidden"><div class="table-responsive"><table class="table table-hover align-middle mb-0">
                <thead class="table-success"><tr><th>Journey time</th><th>Vehicle</th><th>Route</th><th class="text-end">CO<sub>2</sub> saved</th><th class="text-end">Running total</th></tr></thead>
                <tbody><% for (BookingImpact booking : bookings) { %><tr>
                    <td><%= dateFormat.format(booking.getSlotTime()) %></td><td><%= booking.getVehicleType() %></td><td><%= booking.getRoute() %></td>
                    <td class="text-end text-success fw-semibold"><%= booking.getCo2SavedKg() %> kg</td><td class="text-end"><%= booking.getRunningCo2SavedKg() %> kg</td>
                </tr><% } %></tbody>
            </table></div></div>
        <% } %>
    </main>
</body>
</html>

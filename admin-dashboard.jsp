<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.greenmobility.dao.AdminDAO, com.greenmobility.dao.AdminBookingView" %>
<%@ page import="com.greenmobility.dao.SlotDAO, com.greenmobility.dao.Slot" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.List" %>

<%
    // Guard: only a logged-in ADMIN session (not a student session) can see this page.
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    AdminDAO adminDAO = new AdminDAO();
    SlotDAO slotDAO = new SlotDAO();
    String message = null;
    String errorMessage = null;

    String action = request.getParameter("action");

    if ("addSlot".equals(action)) {
        try {
            adminDAO.addSlot(
                request.getParameter("vehicleType"),
                request.getParameter("route"),
                Timestamp.valueOf(request.getParameter("slotTime").replace("T", " ") + ":00"),
                Integer.parseInt(request.getParameter("capacity")),
                Double.parseDouble(request.getParameter("distanceKm")),
                Double.parseDouble(request.getParameter("emissionFactor"))
            );
            message = "Slot added successfully.";
        } catch (Exception e) {
            errorMessage = "Failed to add slot: " + e.getMessage();
        }

    } else if ("updateSlot".equals(action)) {
        try {
            adminDAO.updateSlot(
                Integer.parseInt(request.getParameter("slotId")),
                request.getParameter("vehicleType"),
                request.getParameter("route"),
                Timestamp.valueOf(request.getParameter("slotTime").replace("T", " ") + ":00"),
                Integer.parseInt(request.getParameter("capacity")),
                Double.parseDouble(request.getParameter("distanceKm")),
                Double.parseDouble(request.getParameter("emissionFactor"))
            );
            message = "Slot updated successfully.";
        } catch (Exception e) {
            errorMessage = "Failed to update slot: " + e.getMessage();
        }

    } else if ("deleteSlot".equals(action)) {
        try {
            adminDAO.deleteSlot(Integer.parseInt(request.getParameter("slotId")));
            message = "Slot deleted.";
        } catch (Exception e) {
            errorMessage = "Failed to delete slot: " + e.getMessage();
        }
    }

    // If ?edit=<slotId> is present, pre-fill the form with that slot's
    // current data instead of showing a blank "add" form.
    Slot editingSlot = null;
    String editParam = request.getParameter("edit");
    if (editParam != null) {
        for (Slot s : slotDAO.getAllAvailableSlots()) {
            if (s.getSlotId() == Integer.parseInt(editParam)) {
                editingSlot = s;
                break;
            }
        }
    }

    List<Slot> allSlots = slotDAO.getAllAvailableSlots();
    List<AdminBookingView> allBookings = adminDAO.getAllBookingsWithDetails();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Green Mobility</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4 mb-5">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>🛠️ Admin Dashboard</h1>
            <a href="login.jsp" class="btn btn-outline-secondary">Logout</a>
        </div>

        <% if (message != null) { %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger"><%= errorMessage %></div>
        <% } %>

        <!-- ============ SLOT MANAGEMENT ============ -->
        <h3 class="mt-4"><%= editingSlot != null ? "Edit Slot #" + editingSlot.getSlotId() : "Add New Slot" %></h3>

        <form method="post" action="admin-dashboard.jsp" class="row g-2 mb-4">
            <input type="hidden" name="action" value="<%= editingSlot != null ? "updateSlot" : "addSlot" %>">
            <% if (editingSlot != null) { %>
                <input type="hidden" name="slotId" value="<%= editingSlot.getSlotId() %>">
            <% } %>

            <div class="col-md-2">
                <input type="text" name="vehicleType" class="form-control" placeholder="Vehicle Type"
                       value="<%= editingSlot != null ? editingSlot.getVehicleType() : "" %>" required>
            </div>
            <div class="col-md-2">
                <input type="text" name="route" class="form-control" placeholder="Route"
                       value="<%= editingSlot != null ? editingSlot.getRoute() : "" %>" required>
            </div>
            <div class="col-md-2">
                <input type="datetime-local" name="slotTime" class="form-control" required>
            </div>
            <div class="col-md-1">
                <input type="number" name="capacity" class="form-control" placeholder="Cap."
                       value="<%= editingSlot != null ? editingSlot.getCapacity() : "" %>" required>
            </div>
            <div class="col-md-2">
                <input type="number" step="0.1" name="distanceKm" class="form-control" placeholder="Distance km" required>
            </div>
            <div class="col-md-2">
                <input type="number" step="0.0001" name="emissionFactor" class="form-control" placeholder="Emission factor" required>
            </div>
            <div class="col-md-1">
                <button type="submit" class="btn btn-success w-100"><%= editingSlot != null ? "Update" : "Add" %></button>
            </div>
        </form>
        <p class="text-muted small">
            Note: date/time field doesn't pre-fill on edit (browser limitation with datetime-local) -- please re-enter it when editing.
        </p>

        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th><th>Type</th><th>Route</th><th>Time</th>
                    <th>Capacity</th><th>Booked</th><th>Distance</th><th>Emission</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Slot s : allSlots) { %>
                <tr>
                    <td><%= s.getSlotId() %></td>
                    <td><%= s.getVehicleType() %></td>
                    <td><%= s.getRoute() %></td>
                    <td><%= s.getSlotTime() %></td>
                    <td><%= s.getCapacity() %></td>
                    <td><%= s.getBookedCount() %></td>
                    <td><%= s.getRemaining() >= 0 ? "" : "" %><%= s.getCapacity() - s.getBookedCount() %> free</td>
                    <td>&mdash;</td>
                    <td>
                        <a href="admin-dashboard.jsp?edit=<%= s.getSlotId() %>" class="btn btn-sm btn-outline-primary">Edit</a>
                        <form method="post" action="admin-dashboard.jsp" style="display:inline;"
                              onsubmit="return confirm('Delete this slot? This also removes its bookings.');">
                            <input type="hidden" name="action" value="deleteSlot">
                            <input type="hidden" name="slotId" value="<%= s.getSlotId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <!-- ============ ALL BOOKINGS & CO2 (ACROSS EVERY STUDENT) ============ -->
        <h3 class="mt-5">All Student Bookings & Impact</h3>
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Student</th><th>Email</th><th>Vehicle</th><th>Route</th>
                    <th>Booked At</th><th>Student's Total CO2 Saved</th>
                </tr>
            </thead>
            <tbody>
                <% for (AdminBookingView b : allBookings) { %>
                <tr>
                    <td><%= b.getStudentName() %></td>
                    <td><%= b.getEmail() %></td>
                    <td><%= b.getVehicleType() %></td>
                    <td><%= b.getRoute() %></td>
                    <td><%= b.getBookedAt() %></td>
                    <td><span class="badge bg-success"><%= b.getTotalCo2SavedKg() %> kg</span></td>
                </tr>
                <% } %>
            </tbody>
        </table>

    </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.greenmobility.dao.SlotDAO, com.greenmobility.dao.Slot, java.util.List" %>

<%
    SlotDAO slotDAO = new SlotDAO();
    List<Slot> slots = null;
    String errorMessage = null;

    try {
        slots = slotDAO.getAllAvailableSlots();
    } catch (Exception e) {
        errorMessage = e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Green Mobility - Browse Slots</title>
    <%-- 
      This single line pulls in Bootstrap's CSS from a CDN (a server 
      that hosts the file for anyone to use) -- no download or install 
      needed, just this link tag. This is what your project brief means 
      by "HTML/CSS/Bootstrap".
    --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%-- 
      "container" and "mt-4" (margin-top) are Bootstrap CSS CLASSES --
      they don't change what the HTML tag does, just how it's styled. 
      This is the core idea of using a CSS framework: your <div>, 
      <table>, <button> tags stay the same, you just add class="..." 
      attributes to style them.
    --%>
    <div class="container mt-4">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h1>Available Vehicle Slots</h1>
            <div class="d-flex gap-2">
                <a href="my-bookings.jsp" class="btn btn-success">My Bookings &amp; Impact</a>
                <a href="login.jsp" class="btn btn-outline-secondary">Logout / Switch User</a>
            </div>
        </div>

        <% if (errorMessage != null) { %>
            <div class="alert alert-danger">Error loading slots: <%= errorMessage %></div>
        <% } else { %>

            <table class="table table-striped table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Slot ID</th>
                        <th>Vehicle Type</th>
                        <th>Route</th>
                        <th>Time</th>
                        <th>Capacity</th>
                        <th>Booked</th>
                        <th>Remaining</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Slot slot : slots) { %>
                        <tr>
                            <td><%= slot.getSlotId() %></td>
                            <td><%= slot.getVehicleType() %></td>
                            <td><%= slot.getRoute() %></td>
                            <td><%= slot.getSlotTime() %></td>
                            <td><%= slot.getCapacity() %></td>
                            <td><%= slot.getBookedCount() %></td>
                            <td>
                                <%-- 
                                  This bit of conditional logic shows a colored 
                                  Bootstrap "badge" -- green if slots remain, 
                                  red if the slot is full. This kind of small 
                                  inline scriptlet for DISPLAY logic (not DB 
                                  logic) is generally fine to keep -- it's the 
                                  DB/business logic you want to avoid putting 
                                  directly in JSP, not simple display formatting.
                                --%>
                                <% if (slot.getRemaining() > 0) { %>

    <span class="badge bg-success">
        <%= slot.getRemaining() %> available
    </span>

    <br><br>

    <a href="choose-slot?slotId=<%= slot.getSlotId() %>"
       class="btn btn-sm btn-success">
        Book
    </a>

<% } else { %>

    <span class="badge bg-danger">Full</span>

<% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>

        <% } %>

    </div>
</body>
</html>

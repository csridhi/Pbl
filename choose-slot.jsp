<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.greenmobility.dao.SlotDAO" %>
<%@ page import="com.greenmobility.dao.Slot" %>
<%@ page import="java.util.List" %>

<%
    Integer studentId = (Integer) session.getAttribute("studentId");

    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String slotIdParam = request.getParameter("slotId");

    if (slotIdParam == null) {
        response.sendRedirect("browse.jsp");
        return;
    }

    int slotId = Integer.parseInt(slotIdParam);

    Slot selectedSlot = null;

    try {
        SlotDAO slotDAO = new SlotDAO();
        List<Slot> slots = slotDAO.getAllAvailableSlots();

        for (Slot slot : slots) {
            if (slot.getSlotId() == slotId) {
                selectedSlot = slot;
                break;
            }
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        return;
    }

    if (selectedSlot == null || selectedSlot.getRemaining() <= 0) {
        response.sendRedirect("browse.jsp");
        return;
    }

    session.setAttribute("selectedSlotId", slotId);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Choose Slot - Green Mobility</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="card shadow">
        <div class="card-body p-4">

            <h2 class="mb-4">🌱 Confirm Your Slot</h2>

            <p>
                <strong>Vehicle:</strong>
                <%= selectedSlot.getVehicleType() %>
            </p>

            <p>
                <strong>Route:</strong>
                <%= selectedSlot.getRoute() %>
            </p>

            <p>
                <strong>Time:</strong>
                <%= selectedSlot.getSlotTime() %>
            </p>

            <p>
                <strong>Capacity:</strong>
                <%= selectedSlot.getCapacity() %>
            </p>

            <p>
                <strong>Available:</strong>
                <%= selectedSlot.getRemaining() %>
            </p>

            <form action="confirm-booking.jsp" method="post">

                <button type="submit" class="btn btn-success">
                    Confirm Booking
                </button>

                <a href="browse.jsp" class="btn btn-secondary">
                    Cancel
                </a>

            </form>

        </div>
    </div>

</div>

</body>
</html>
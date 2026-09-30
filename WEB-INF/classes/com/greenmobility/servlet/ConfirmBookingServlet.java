package com.greenmobility.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.greenmobility.db.DBConnection;

@WebServlet("/confirm-booking")
public class ConfirmBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final BigDecimal CAR_EMISSION_FACTOR_KG_PER_KM = new BigDecimal("0.192");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("studentId");
        Integer slotId = (Integer) session.getAttribute("selectedSlotId");

        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (slotId == null) {
            response.sendRedirect("browse.jsp");
            return;
        }

        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);

            try {
                String claimSql =
                    "UPDATE Vehicles_Slots " +
                    "SET booked_count = booked_count + 1 " +
                    "WHERE slot_id = ? AND booked_count < capacity";

                try (PreparedStatement statement = connection.prepareStatement(claimSql)) {
                    statement.setInt(1, slotId);
                    if (statement.executeUpdate() == 0) {
                        connection.rollback();
                        showMessage(request, response, "slot just filled up", true);
                        return;
                    }
                }

                BigDecimal distanceKm;
                BigDecimal vehicleEmissionFactor;
                String slotSql =
                    "SELECT distance_km, emission_factor " +
                    "FROM Vehicles_Slots WHERE slot_id = ?";

                try (PreparedStatement statement = connection.prepareStatement(slotSql)) {
                    statement.setInt(1, slotId);
                    try (ResultSet resultSet = statement.executeQuery()) {
                        if (!resultSet.next()) {
                            throw new SQLException("Selected slot was not found.");
                        }
                        distanceKm = resultSet.getBigDecimal("distance_km");
                        vehicleEmissionFactor = resultSet.getBigDecimal("emission_factor");
                    }
                }

                BigDecimal co2Saved = distanceKm.multiply(
                    CAR_EMISSION_FACTOR_KG_PER_KM.subtract(vehicleEmissionFactor));

                String bookingSql =
                    "INSERT INTO Bookings (student_id, slot_id, distance_km, co2_saved_kg) " +
                    "VALUES (?, ?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(bookingSql)) {
                    statement.setInt(1, studentId);
                    statement.setInt(2, slotId);
                    statement.setBigDecimal(3, distanceKm);
                    statement.setBigDecimal(4, co2Saved);
                    statement.executeUpdate();
                }

                String studentSql =
                    "UPDATE Students " +
                    "SET total_co2_saved_kg = NVL(total_co2_saved_kg, 0) + ? " +
                    "WHERE student_id = ?";
                try (PreparedStatement statement = connection.prepareStatement(studentSql)) {
                    statement.setBigDecimal(1, co2Saved);
                    statement.setInt(2, studentId);
                    statement.executeUpdate();
                }

                connection.commit();
                session.removeAttribute("selectedSlotId");
                request.setAttribute("co2Saved", co2Saved);
                showMessage(request, response, "Booking confirmed.", false);
            } catch (Exception e) {
                connection.rollback();
                throw new ServletException(e);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Unable to complete booking: " + e.getMessage());
            forward(request, response);
        }
    }

    private void showMessage(HttpServletRequest request, HttpServletResponse response,
            String message, boolean error) throws ServletException, IOException {
        if (error) {
            request.setAttribute("errorMessage", message);
        } else {
            request.setAttribute("message", message);
        }
        forward(request, response);
    }

    private void forward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/confirm-booking.jsp");
        dispatcher.forward(request, response);
    }
}
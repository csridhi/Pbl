package com.greenmobility.dao;

import com.greenmobility.db.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/** Person C: booking-history JOIN and per-student running CO2 total. */
public class BookingImpactDAO {
    private static final String HISTORY_SQL =
        "SELECT b.booking_id, b.booked_at, vs.slot_time, vs.vehicle_type, vs.route, " +
        "ROUND(vs.distance_km * (0.1920 - vs.emission_factor), 3) AS co2_saved_kg, " +
        "SUM(ROUND(vs.distance_km * (0.1920 - vs.emission_factor), 3)) OVER " +
        "(ORDER BY b.booked_at, b.booking_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) " +
        "AS running_co2_saved_kg " +
        "FROM Bookings b " +
        "INNER JOIN Vehicles_Slots vs ON vs.slot_id = b.slot_id " +
        "WHERE b.student_id = ? AND vs.slot_time <= SYSTIMESTAMP " +
        "ORDER BY b.booked_at, b.booking_id";

    public List<BookingImpact> getPastBookings(int studentId) throws Exception {
        List<BookingImpact> bookings = new ArrayList<BookingImpact>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(HISTORY_SQL)) {
            statement.setInt(1, studentId);
            try (ResultSet results = statement.executeQuery()) {
                while (results.next()) {
                    BookingImpact booking = new BookingImpact();
                    booking.setBookingId(results.getInt("booking_id"));
                    booking.setBookedAt(results.getTimestamp("booked_at"));
                    booking.setSlotTime(results.getTimestamp("slot_time"));
                    booking.setVehicleType(results.getString("vehicle_type"));
                    booking.setRoute(results.getString("route"));
                    booking.setCo2SavedKg(results.getBigDecimal("co2_saved_kg"));
                    booking.setRunningCo2SavedKg(results.getBigDecimal("running_co2_saved_kg"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }

    public BigDecimal getImpactTotal(int studentId) throws Exception {
        List<BookingImpact> bookings = getPastBookings(studentId);
        return bookings.isEmpty() ? BigDecimal.ZERO : bookings.get(bookings.size() - 1).getRunningCo2SavedKg();
    }
}

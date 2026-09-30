package com.greenmobility.dao;

import com.greenmobility.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    /** Checks email+password against the Admins table (separate from Students). */
    public Admin authenticate(String email, String password) throws SQLException {
        String sql = "SELECT admin_id, name, email FROM Admins WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Admin admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setName(rs.getString("name"));
                    admin.setEmail(rs.getString("email"));
                    return admin;
                }
                return null;
            }
        }
    }

    /** Adds a new vehicle slot. */
    public void addSlot(String vehicleType, String route, Timestamp slotTime,
                         int capacity, double distanceKm, double emissionFactor) throws SQLException {
        String sql = "INSERT INTO Vehicles_Slots (vehicle_type, route, slot_time, capacity, booked_count, distance_km, emission_factor) " +
                     "VALUES (?, ?, ?, ?, 0, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vehicleType);
            stmt.setString(2, route);
            stmt.setTimestamp(3, slotTime);
            stmt.setInt(4, capacity);
            stmt.setDouble(5, distanceKm);
            stmt.setDouble(6, emissionFactor);
            stmt.executeUpdate();
        }
    }

    /** Updates an existing slot's details. */
    public void updateSlot(int slotId, String vehicleType, String route, Timestamp slotTime,
                            int capacity, double distanceKm, double emissionFactor) throws SQLException {
        String sql = "UPDATE Vehicles_Slots SET vehicle_type = ?, route = ?, slot_time = ?, " +
                     "capacity = ?, distance_km = ?, emission_factor = ? WHERE slot_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, vehicleType);
            stmt.setString(2, route);
            stmt.setTimestamp(3, slotTime);
            stmt.setInt(4, capacity);
            stmt.setDouble(5, distanceKm);
            stmt.setDouble(6, emissionFactor);
            stmt.setInt(7, slotId);
            stmt.executeUpdate();
        }
    }

    /**
     * Deletes a slot. Bookings referencing this slot must be removed first 
     * (foreign key constraint) -- this is a simple cascading delete suitable 
     * for a PBL demo. A production system would likely just deactivate a 
     * slot instead of hard-deleting it, to preserve booking history.
     */
    public void deleteSlot(int slotId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement delBookings = conn.prepareStatement(
                    "DELETE FROM Bookings WHERE slot_id = ?")) {
                delBookings.setInt(1, slotId);
                delBookings.executeUpdate();
            }
            try (PreparedStatement delSlot = conn.prepareStatement(
                    "DELETE FROM Vehicles_Slots WHERE slot_id = ?")) {
                delSlot.setInt(1, slotId);
                delSlot.executeUpdate();
            }
            conn.commit();
        }
    }

    /** Returns every student's bookings joined with slot info, for the admin's overview table. */
    public List<AdminBookingView> getAllBookingsWithDetails() throws SQLException {
        List<AdminBookingView> results = new ArrayList<>();
        String sql =
            "SELECT s.name AS student_name, s.email, s.total_co2_saved_kg, " +
            "       v.vehicle_type, v.route, b.booked_at " +
            "FROM Bookings b " +
            "JOIN Students s ON b.student_id = s.student_id " +
            "JOIN Vehicles_Slots v ON b.slot_id = v.slot_id " +
            "ORDER BY b.booked_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                AdminBookingView row = new AdminBookingView();
                row.setStudentName(rs.getString("student_name"));
                row.setEmail(rs.getString("email"));
                row.setTotalCo2SavedKg(rs.getBigDecimal("total_co2_saved_kg"));
                row.setVehicleType(rs.getString("vehicle_type"));
                row.setRoute(rs.getString("route"));
                row.setBookedAt(rs.getTimestamp("booked_at"));
                results.add(row);
            }
        }
        return results;
    }
}

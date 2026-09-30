package com.greenmobility.dao;
import com.greenmobility.db.DBConnection;
import java.sql.Connection;
import  java.sql.PreparedStatement;

public class BookingDAO {
    // Book a slot only if seats are available
    public boolean bookSlot(int studentId, int slotId) throws Exception {

        Connection con = DBConnection.getConnection();

        try {
            con.setAutoCommit(false);

            // Atomic conflict check
            String updateSql =
                "UPDATE Vehicles_Slots " +
                "SET booked_count = booked_count + 1 " +
                "WHERE slot_id = ? AND booked_count < capacity";

            PreparedStatement ps = con.prepareStatement(updateSql);
            ps.setInt(1, slotId);

            int updated = ps.executeUpdate();

            if (updated == 0) {
                con.rollback();
                return false;
            }

            // Insert booking
            String insertSql =
                "INSERT INTO Bookings (student_id, slot_id) VALUES (?, ?)";

            ps = con.prepareStatement(insertSql);
            ps.setInt(1, studentId);
            ps.setInt(2, slotId);

            ps.executeUpdate();

            con.commit();
            return true;

        } catch (Exception e) {
            con.rollback();
            throw e;

        } finally {
            con.setAutoCommit(true);
            con.close();
        }
    }
}
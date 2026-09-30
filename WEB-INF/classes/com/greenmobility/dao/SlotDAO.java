package com.greenmobility.dao;

import com.greenmobility.db.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SlotDAO {

    /**
     * Returns all vehicle slots with their current availability.
     * This is the REAL implementation -- it actually queries Oracle.
     */
    public List<Slot> getAllAvailableSlots() throws SQLException {
        List<Slot> slots = new ArrayList<>();

        String sql = "SELECT slot_id, vehicle_type, route, slot_time, capacity, booked_count FROM Vehicles_Slots";

        // try-with-resources automatically closes conn/stmt/rs even if an 
        // exception happens -- this replaces the manual finally-block 
        // cleanup we had in browse.jsp before.
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Slot slot = new Slot();
                slot.setSlotId(rs.getInt("slot_id"));
                slot.setVehicleType(rs.getString("vehicle_type"));
                slot.setRoute(rs.getString("route"));
                slot.setSlotTime(rs.getTimestamp("slot_time"));
                slot.setCapacity(rs.getInt("capacity"));
                slot.setBookedCount(rs.getInt("booked_count"));
                slots.add(slot);
            }
        }

        return slots;
    }

    /**
     * STUB METHOD -- for Person B to code against right now.
     * 
     * This currently always returns true (pretends every booking succeeds) 
     * so that Person B can build and test booking.jsp's flow immediately, 
     * without needing the real conflict-check logic to exist yet.
     * 
     * THE REAL VERSION (to be filled in later -- by whoever ends up 
     * implementing the booking logic) will run:
     *   UPDATE Vehicles_Slots 
     *   SET booked_count = booked_count + 1 
     *   WHERE slot_id = ? AND booked_count < capacity
     * and return true only if exactly 1 row was updated (meaning there 
     * was room), false if 0 rows were updated (slot was full).
     * 
     * IMPORTANT: the method SIGNATURE below (name, parameters, return 
     * type) is the "contract" -- as long as this doesn't change, 
     * booking.jsp's code calling this method won't need to change 
     * when the real logic gets filled in.
     */
    public boolean bookSlot(int slotId, int studentId) throws SQLException {
        // TODO: replace with real atomic UPDATE + row-count check
        return true; // fake success, for now
    }
}

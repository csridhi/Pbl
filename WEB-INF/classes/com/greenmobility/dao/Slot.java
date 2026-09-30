package com.greenmobility.dao;

import java.sql.Timestamp;

/**
 * A plain "bean" -- just holds data for one row from Vehicles_Slots.
 * No logic here, just fields + getters/setters. JSP pages will loop 
 * over a List<Slot> and call these getters (e.g. slot.getRoute()) to 
 * display each one, using JSP EXPRESSIONS rather than digging into a 
 * ResultSet directly on the page -- this is a big part of why your 
 * learning objectives ask you to minimize scriptlets.
 */
public class Slot {
    private int slotId;
    private String vehicleType;
    private String route;
    private Timestamp slotTime;
    private int capacity;
    private int bookedCount;

    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getRoute() { return route; }
    public void setRoute(String route) { this.route = route; }

    public Timestamp getSlotTime() { return slotTime; }
    public void setSlotTime(Timestamp slotTime) { this.slotTime = slotTime; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getBookedCount() { return bookedCount; }
    public void setBookedCount(int bookedCount) { this.bookedCount = bookedCount; }

    // Convenience method -- NOT a DB column, just a calculated value.
    // JSP can call slot.getRemaining() directly instead of doing 
    // capacity - bookedCount math inside a scriptlet.
    public int getRemaining() {
        return capacity - bookedCount;
    }
}

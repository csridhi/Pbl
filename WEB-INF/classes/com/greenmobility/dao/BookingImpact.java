package com.greenmobility.dao;

import java.math.BigDecimal;
import java.sql.Timestamp;

/** One completed booking together with the CO2 saving it produced. */
public class BookingImpact {
    private int bookingId;
    private Timestamp bookedAt;
    private Timestamp slotTime;
    private String vehicleType;
    private String route;
    private BigDecimal co2SavedKg;
    private BigDecimal runningCo2SavedKg;

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    public Timestamp getBookedAt() { return bookedAt; }
    public void setBookedAt(Timestamp bookedAt) { this.bookedAt = bookedAt; }
    public Timestamp getSlotTime() { return slotTime; }
    public void setSlotTime(Timestamp slotTime) { this.slotTime = slotTime; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getRoute() { return route; }
    public void setRoute(String route) { this.route = route; }
    public BigDecimal getCo2SavedKg() { return co2SavedKg; }
    public void setCo2SavedKg(BigDecimal co2SavedKg) { this.co2SavedKg = co2SavedKg; }
    public BigDecimal getRunningCo2SavedKg() { return runningCo2SavedKg; }
    public void setRunningCo2SavedKg(BigDecimal runningCo2SavedKg) { this.runningCo2SavedKg = runningCo2SavedKg; }
}

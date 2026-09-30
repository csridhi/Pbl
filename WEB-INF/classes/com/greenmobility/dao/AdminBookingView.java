package com.greenmobility.dao;

import java.math.BigDecimal;
import java.sql.Timestamp;

/** One row in the admin's "all bookings across all students" table. */
public class AdminBookingView {
    private String studentName;
    private String email;
    private BigDecimal totalCo2SavedKg;
    private String vehicleType;
    private String route;
    private Timestamp bookedAt;

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public BigDecimal getTotalCo2SavedKg() { return totalCo2SavedKg; }
    public void setTotalCo2SavedKg(BigDecimal totalCo2SavedKg) { this.totalCo2SavedKg = totalCo2SavedKg; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getRoute() { return route; }
    public void setRoute(String route) { this.route = route; }

    public Timestamp getBookedAt() { return bookedAt; }
    public void setBookedAt(Timestamp bookedAt) { this.bookedAt = bookedAt; }
}

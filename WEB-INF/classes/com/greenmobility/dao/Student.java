package com.greenmobility.dao;

import java.math.BigDecimal;

public class Student {
    private int studentId;
    private String name;
    private String email;
    private BigDecimal totalCo2SavedKg;

    // Deliberately NO password field here -- once we've verified login,
    // we never need to carry the password around in memory afterward.
    // This "Student" object represents a LOGGED-IN user's public info,
    // not their full DB record.

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public BigDecimal getTotalCo2SavedKg() { return totalCo2SavedKg; }
    public void setTotalCo2SavedKg(BigDecimal totalCo2SavedKg) { this.totalCo2SavedKg = totalCo2SavedKg; }
}

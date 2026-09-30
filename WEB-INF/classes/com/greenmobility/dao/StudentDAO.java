package com.greenmobility.dao;

import com.greenmobility.db.DBConnection;
import java.sql.*;

public class StudentDAO {

    /**
     * Checks email+password against the Students table.
     * Returns the matching Student if found, or null if no match 
     * (wrong email OR wrong password -- we don't tell the caller which, 
     * since revealing "email exists but password wrong" vs "email doesn't 
     * exist" is a minor security leak in real systems. For a PBL demo 
     * this distinction matters less, but it's a good habit).
     */
    public Student authenticate(String email, String password) throws SQLException {
        String sql = "SELECT student_id, name, email, total_co2_saved_kg " +
                     "FROM Students WHERE email = ? AND password = ?";

        // PreparedStatement (not Statement) -- this is important: it 
        // safely inserts the email/password values as PARAMETERS rather 
        // than concatenating them into the SQL string. Concatenating 
        // user input directly into SQL is how SQL injection attacks 
        // happen (e.g. someone typing ' OR '1'='1 as a password).
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Student student = new Student();
                    student.setStudentId(rs.getInt("student_id"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    student.setTotalCo2SavedKg(rs.getBigDecimal("total_co2_saved_kg"));
                    return student;
                }
                return null; // no matching row -- login failed
            }
        }
    }
}

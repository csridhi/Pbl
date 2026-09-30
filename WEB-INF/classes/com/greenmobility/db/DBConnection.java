package com.greenmobility.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL =
        "jdbc:oracle:thin:@localhost:1521:orcl";
    private static final String USERNAME = "SYSTEM";
    private static final String PASSWORD = "GreenMobility123";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC driver is not available.", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}

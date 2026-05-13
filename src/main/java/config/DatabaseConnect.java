package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnect {

    private static final String URL =
            "jdbc:mysql://localhost:3306/hotel_management";

    private static final String USER = "root";

    private static final String PASSWORD = "D05022006d";

    public static Connection getConnection() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );

        } catch (Exception e) {

            e.printStackTrace();
        }

        return null;
    }
}
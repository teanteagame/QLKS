package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnect {

    // Thông tin kết nối trực tiếp tới Aiven
    private static final String URL =
            "jdbc:mysql://qlks-teanteagame.h.aivencloud.com:22331/hotel_management?ssl-mode=REQUIRED";

    private static final String USER = "avnadmin";

    private static final String PASSWORD = "AVNS_1ixtKWgnlSnULFmvqNW";

    public static Connection getConnection() {
        try {
            // Nạp Driver MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Thiết lập kết nối
            return DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD
            );
        } catch (Exception e) {
            System.err.println("❌ Lỗi kết nối server Aiven: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
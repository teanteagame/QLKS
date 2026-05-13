package dao;

import config.DatabaseConnect;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO {

    // Lấy doanh thu tiền phòng
    public double getRoomRevenue(String start, String end) {
        String sql = "SELECT SUM(room_total) FROM invoices WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, start + " 00:00:00");
            ps.setString(2, end + " 23:59:59");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Lấy doanh thu dịch vụ
    public double getServiceRevenue(String start, String end) {
        String sql = "SELECT SUM(service_total) FROM invoices WHERE created_at BETWEEN ? AND ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, start + " 00:00:00");
            ps.setString(2, end + " 23:59:59");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Lấy doanh thu theo từng ngày để vẽ biểu đồ
    public Map<String, Double> getDailyRevenue(String start, String end) {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = "SELECT DATE(created_at) as date, SUM(total_amount) as total " +
                     "FROM invoices WHERE created_at BETWEEN ? AND ? " +
                     "GROUP BY DATE(created_at) ORDER BY date ASC";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, start + " 00:00:00");
            ps.setString(2, end + " 23:59:59");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("date"), rs.getDouble("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data;
    }
}
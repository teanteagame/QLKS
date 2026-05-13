package dao;

import config.DatabaseConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Customer;

public class CustomerDAO {

    // Hàm lấy ID khách hàng nếu đã tồn tại, nếu không có trả về -1
    public int getCustomerIdByCitizenId(String citizenId) {
        String sql = "SELECT customer_id FROM customers WHERE citizen_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, citizenId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customer_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int insertCustomer(Customer customer) {
        // Kiểm tra xem khách đã tồn tại chưa trước khi INSERT
        int existingId = getCustomerIdByCitizenId(customer.getCitizenId());
        if (existingId != -1) {
            return existingId; // Trả về ID cũ nếu khách quay lại
        }

        String sql = "INSERT INTO customers(full_name, citizen_id, phone, email) VALUES(?, ?, ?, ?)";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getCitizenId());
            ps.setString(3, customer.getPhone());
            ps.setString(4, customer.getEmail());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}
package dao;

import config.DatabaseConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Booking;
import model.BookingDetail;

public class BookingDAO {

    // Giữ nguyên các hàm insertBooking và updateRoomStatus của bạn
    public boolean insertBooking(Booking booking) {
        String sql = "INSERT INTO bookings(customer_id, room_id, employee_id, rental_type_id, check_in, room_price, booking_status) VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setInt(2, booking.getRoomId());
            ps.setInt(3, booking.getEmployeeId());
            ps.setInt(4, booking.getRentalTypeId());
            ps.setTimestamp(5, booking.getCheckIn());
            ps.setDouble(6, booking.getRoomPrice());
            ps.setString(7, booking.getBookingStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateRoomStatus(int roomId) {
        String sql = "UPDATE rooms SET status = 'OCCUPIED' WHERE room_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

public ArrayList<BookingDetail> getBookingHistory() {
    ArrayList<BookingDetail> list = new ArrayList<>();
    // Đã đổi i.payment_date thành i.created_at theo đúng ảnh database
    String sql = "SELECT b.booking_id, c.full_name, r.room_number, rt.type_name, " +
                 "b.check_in, i.created_at, i.total_amount " + 
                 "FROM bookings b " +
                 "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                 "LEFT JOIN rooms r ON b.room_id = r.room_id " +
                 "LEFT JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                 "LEFT JOIN invoices i ON b.booking_id = i.booking_id " +
                 "WHERE b.booking_status = 'CHECKED_OUT' " +
                 "ORDER BY i.created_at DESC";
    
    try (Connection conn = DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            BookingDetail detail = new BookingDetail();
            detail.setBookingId(rs.getInt("booking_id"));
            detail.setCustomerName(rs.getString("full_name") != null ? rs.getString("full_name") : "Khách vãng lai");
            detail.setRoomNumber(rs.getString("room_number"));
            detail.setRoomType(rs.getString("type_name"));
            detail.setCheckIn(rs.getTimestamp("check_in"));
            
            // Lấy dữ liệu từ cột created_at
            detail.setPaymentDate(rs.getTimestamp("created_at")); 
            detail.setRoomPrice(rs.getDouble("total_amount")); 
            list.add(detail);
        }
    } catch (Exception e) {
        e.printStackTrace(); 
    }
    return list;
}
}
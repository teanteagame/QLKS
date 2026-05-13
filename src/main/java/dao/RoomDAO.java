package dao;

import config.DatabaseConnect;
import java.sql.*;
import java.util.ArrayList;
import model.Room;
import model.RoomType;
import model.BookingDetail;

public class RoomDAO {

    public ArrayList<Room> getAllRooms() {
    ArrayList<Room> list = new ArrayList<>();
    String sql = "SELECT r.*, rt.*, "
            + "(SELECT b.booking_id FROM bookings b "
            + " WHERE b.room_id = r.room_id AND b.booking_status = 'CHECKED_IN' "
            + " ORDER BY b.booking_id DESC LIMIT 1) as current_booking_id "
            + "FROM rooms r "
            + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
            + "WHERE r.status != 'DELETED' "
            + "ORDER BY r.room_number ASC";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Room room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setStatus(rs.getString("status"));
            room.setBookingId(rs.getInt("current_booking_id"));
            room.setImageUrl(rs.getString("image_url")); // Lấy ảnh từ DB

            RoomType type = new RoomType();
            type.setRoomTypeId(rs.getInt("room_type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setHourlyPrice(rs.getDouble("hourly_price"));
            room.setRoomType(type);
            list.add(room);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

    public double getRoomPrice(int roomId, int rentalTypeId) {
        String sql = "SELECT rt.hourly_price, rt.overnight_price, rt.daily_price "
                + "FROM rooms r "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE r.room_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    if (rentalTypeId == 1) return rs.getDouble("hourly_price");
                    if (rentalTypeId == 2) return rs.getDouble("overnight_price");
                    if (rentalTypeId == 3) return rs.getDouble("daily_price");
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public BookingDetail getBookingDetail(int bookingId) {
        String sql = "SELECT b.booking_id, r.room_id, c.full_name, r.room_number, "
                + "rt.type_name, b.check_in, b.room_price, b.rental_type_id "
                + "FROM bookings b "
                + "JOIN customers c ON b.customer_id = c.customer_id "
                + "JOIN rooms r ON b.room_id = r.room_id "
                + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
                + "WHERE b.booking_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingDetail d = new BookingDetail();
                    d.setBookingId(rs.getInt("booking_id"));
                    d.setRoomId(rs.getInt("room_id"));
                    d.setCustomerName(rs.getString("full_name"));
                    d.setRoomNumber(rs.getString("room_number"));
                    d.setRoomType(rs.getString("type_name"));
                    d.setCheckIn(rs.getTimestamp("check_in"));
                    d.setRoomPrice(rs.getDouble("room_price"));
                    d.setRentalTypeId(rs.getInt("rental_type_id"));
                    return d;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    
    public boolean addRoom(String roomNumber, int roomTypeId, String imageUrl) {
    String sql = "INSERT INTO rooms (room_number, room_type_id, status, image_url) VALUES (?, ?, 'AVAILABLE', ?)";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, roomNumber);
        ps.setInt(2, roomTypeId);
        ps.setString(3, imageUrl);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); return false; }
}

public boolean deleteRoom(int roomId) {
    String sql = "UPDATE rooms SET status = 'DELETED' WHERE room_id = ? AND status != 'OCCUPIED'";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roomId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { 
        e.printStackTrace(); 
        return false; 
    }
}

public Room getRoomById(int id) {
    String sql = "SELECT r.*, rt.* FROM rooms r "
               + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
               + "WHERE r.room_id = ?";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setStatus(rs.getString("status"));
                room.setImageUrl(rs.getString("image_url")); // Lấy ảnh
                
                RoomType type = new RoomType();
                type.setRoomTypeId(rs.getInt("room_type_id"));
                type.setTypeName(rs.getString("type_name"));
                room.setRoomType(type);
                return room;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return null;
}

public boolean updateRoom(int roomId, String roomNumber, int roomTypeId, String status, String imageUrl) {
    String sql = "UPDATE rooms SET room_number = ?, room_type_id = ?, status = ?, image_url = ? WHERE room_id = ?";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, roomNumber);
        ps.setInt(2, roomTypeId);
        ps.setString(3, status);
        ps.setString(4, imageUrl);
        ps.setInt(5, roomId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); return false; }
}

public ArrayList<Room> getFilteredRooms(Integer typeId, String status) {
    ArrayList<Room> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
          "SELECT r.*, rt.*, "
        + "(SELECT b.booking_id FROM bookings b WHERE b.room_id = r.room_id AND b.booking_status = 'CHECKED_IN' ORDER BY b.booking_id DESC LIMIT 1) as current_booking_id "
        + "FROM rooms r JOIN room_types rt ON r.room_type_id = rt.room_type_id WHERE r.status != 'DELETED' ");

    if (typeId != null && typeId > 0) sql.append(" AND r.room_type_id = ").append(typeId);
    if (status != null && !status.isEmpty() && !"ALL".equals(status)) sql.append(" AND r.status = '").append(status).append("'");
    sql.append(" ORDER BY r.room_number ASC");

    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString());
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Room room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setStatus(rs.getString("status"));
            room.setBookingId(rs.getInt("current_booking_id"));
            room.setImageUrl(rs.getString("image_url")); // Lấy ảnh

            RoomType type = new RoomType();
            type.setRoomTypeId(rs.getInt("room_type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setHourlyPrice(rs.getDouble("hourly_price"));
            room.setRoomType(type);
            list.add(room);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// Lấy danh sách các phòng có status là 'DELETED'
public ArrayList<Room> getDeletedRooms() {
    ArrayList<Room> list = new ArrayList<>();
    String sql = "SELECT r.*, rt.* FROM rooms r "
            + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
            + "WHERE r.status = 'DELETED' "
            + "ORDER BY r.room_number ASC";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Room room = new Room();
            room.setRoomId(rs.getInt("room_id"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setStatus(rs.getString("status"));
            RoomType type = new RoomType();
            type.setRoomTypeId(rs.getInt("room_type_id"));
            type.setTypeName(rs.getString("type_name"));
            room.setRoomType(type);
            list.add(room);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// Khôi phục phòng và chuyển trạng thái sang MAINTENANCE
public boolean restoreRoom(int roomId) {
    String sql = "UPDATE rooms SET status = 'MAINTENANCE' WHERE room_id = ?";
    try (Connection conn = config.DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roomId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { e.printStackTrace(); return false; }
}
}
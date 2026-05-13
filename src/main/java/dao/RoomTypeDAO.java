package dao;

import config.DatabaseConnect;
import java.sql.*;
import java.util.ArrayList;
import model.RoomType;

public class RoomTypeDAO {

    public ArrayList<RoomType> getAllRoomTypes() {
        ArrayList<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setHourlyPrice(rs.getDouble("hourly_price"));
                rt.setOvernightPrice(rs.getDouble("overnight_price"));
                rt.setDailyPrice(rs.getDouble("daily_price"));
                list.add(rt);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public RoomType getRoomTypeById(int id) {
        String sql = "SELECT * FROM room_types WHERE room_type_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RoomType rt = new RoomType();
                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setTypeName(rs.getString("type_name"));
                rt.setHourlyPrice(rs.getDouble("hourly_price"));
                rt.setOvernightPrice(rs.getDouble("overnight_price"));
                rt.setDailyPrice(rs.getDouble("daily_price"));
                return rt;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean addRoomType(RoomType rt) {
        String sql = "INSERT INTO room_types (type_name, hourly_price, overnight_price, daily_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getTypeName());
            ps.setDouble(2, rt.getHourlyPrice());
            ps.setDouble(3, rt.getOvernightPrice());
            ps.setDouble(4, rt.getDailyPrice());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateRoomType(RoomType rt) {
        String sql = "UPDATE room_types SET type_name=?, hourly_price=?, overnight_price=?, daily_price=? WHERE room_type_id=?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rt.getTypeName());
            ps.setDouble(2, rt.getHourlyPrice());
            ps.setDouble(3, rt.getOvernightPrice());
            ps.setDouble(4, rt.getDailyPrice());
            ps.setInt(5, rt.getRoomTypeId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteRoomType(int id) throws SQLException {
        // Lưu ý: Sẽ lỗi nếu có phòng đang tham chiếu tới loại này (Khóa ngoại)
        String sql = "DELETE FROM room_types WHERE room_type_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
package dao;

import config.DatabaseConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Service;

public class ServiceDAO {

    public ArrayList<Service> getAllAvailableServices() {
        ArrayList<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE status = 1";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setUnit(rs.getString("unit"));
                s.setPrice(rs.getDouble("price"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addServiceToBooking(int bookingId, int serviceId, int quantity, double unitPrice) {
        String sql = "INSERT INTO booking_services (booking_id, service_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, serviceId);
            ps.setInt(3, quantity);
            ps.setDouble(4, unitPrice);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalServiceMoneyByBookingId(int bookingId) {
        String sql = "SELECT SUM(quantity * unit_price) as total FROM booking_services WHERE booking_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public ArrayList<Service> getAllServices() {
        ArrayList<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setUnit(rs.getString("unit"));
                s.setPrice(rs.getDouble("price"));
                s.setStatus(rs.getBoolean("status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addService(Service s) {
        String sql = "INSERT INTO services (service_name, category_id, unit, price, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setInt(2, s.getCategoryId());
            ps.setString(3, s.getUnit());
            ps.setDouble(4, s.getPrice());
            ps.setBoolean(5, s.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(Service s) {
        String sql = "UPDATE services SET service_name=?, category_id=?, unit=?, price=?, status=? WHERE service_id=?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getServiceName());
            ps.setInt(2, s.getCategoryId());
            ps.setString(3, s.getUnit());
            ps.setDouble(4, s.getPrice());
            ps.setBoolean(5, s.isStatus());
            ps.setInt(6, s.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteService(int id) {
        String sql = "DELETE FROM services WHERE service_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setServiceName(rs.getString("service_name"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setUnit(rs.getString("unit"));
                    s.setPrice(rs.getDouble("price"));
                    s.setStatus(rs.getBoolean("status"));
                    return s;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
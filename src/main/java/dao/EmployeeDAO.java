package dao;

import config.DatabaseConnect;
import java.sql.*;
import java.util.ArrayList;
import model.Employee;

public class EmployeeDAO {

    public ArrayList<Employee> getAllEmployees() {
        ArrayList<Employee> list = new ArrayList<>();
        // Chỉ lấy những nhân viên có status = 1
        String sql = "SELECT e.*, r.role_name FROM employees e "
                   + "JOIN roles r ON e.role_id = r.role_id "
                   + "WHERE e.status = 1 "
                   + "ORDER BY e.employee_id DESC";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("employee_id"));
                e.setFullName(rs.getString("full_name"));
                e.setPhone(rs.getString("phone"));
                e.setEmail(rs.getString("email"));
                e.setRoleId(rs.getInt("role_id"));
                e.setRoleName(rs.getString("role_name"));
                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addEmployeeWithAccount(Employee emp) throws SQLException {
        Connection conn = null;
        PreparedStatement psEmp = null;
        PreparedStatement psAcc = null;
        try {
            conn = DatabaseConnect.getConnection();
            conn.setAutoCommit(false);
            // Thêm status = 1 khi tạo mới
            String sqlEmp = "INSERT INTO employees (full_name, phone, email, role_id, status) VALUES (?, ?, ?, ?, 1)";
            psEmp = conn.prepareStatement(sqlEmp, Statement.RETURN_GENERATED_KEYS);
            psEmp.setString(1, emp.getFullName());
            psEmp.setString(2, emp.getPhone());
            psEmp.setString(3, emp.getEmail());
            psEmp.setInt(4, emp.getRoleId());
            psEmp.executeUpdate();
            
            ResultSet rs = psEmp.getGeneratedKeys();
            if (rs.next()) {
                int empId = rs.getInt(1);
                String sqlAcc = "INSERT INTO accounts (employee_id, username, password_hash, status) VALUES (?, ?, ?, 1)";
                psAcc = conn.prepareStatement(sqlAcc);
                psAcc.setInt(1, empId);
                psAcc.setString(2, emp.getPhone()); 
                psAcc.setString(3, "123");
                psAcc.executeUpdate();
                conn.commit();
                return true;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
        return false;
    }

    public boolean deleteEmployee(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement psEmp = null;
        PreparedStatement psAcc = null;
        try {
            conn = DatabaseConnect.getConnection();
            conn.setAutoCommit(false);

            // 1. Vô hiệu hóa tài khoản (status = 0)
            String sqlAcc = "UPDATE accounts SET status = 0 WHERE employee_id = ?";
            psAcc = conn.prepareStatement(sqlAcc);
            psAcc.setInt(1, id);
            psAcc.executeUpdate();

            // 2. Đổi trạng thái nhân viên thành 0 (Xóa mềm)
            String sqlEmp = "UPDATE employees SET status = 0 WHERE employee_id = ?";
            psEmp = conn.prepareStatement(sqlEmp);
            psEmp.setInt(1, id);
            int result = psEmp.executeUpdate();

            conn.commit();
            return result > 0;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    public Employee getEmployeeById(int id) {
        String sql = "SELECT * FROM employees WHERE employee_id = ? AND status = 1";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("employee_id"));
                e.setFullName(rs.getString("full_name"));
                e.setPhone(rs.getString("phone"));
                e.setEmail(rs.getString("email"));
                e.setRoleId(rs.getInt("role_id"));
                return e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateEmployee(Employee emp) {
        String sql = "UPDATE employees SET full_name=?, phone=?, email=?, role_id=? WHERE employee_id=?";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getFullName());
            ps.setString(2, emp.getPhone());
            ps.setString(3, emp.getEmail());
            ps.setInt(4, emp.getRoleId());
            ps.setInt(5, emp.getEmployeeId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public ArrayList<Employee> getInactiveEmployees() {
        ArrayList<Employee> list = new ArrayList<>();
        String sql = "SELECT e.*, r.role_name FROM employees e "
                   + "JOIN roles r ON e.role_id = r.role_id "
                   + "WHERE e.status = 0 "
                   + "ORDER BY e.employee_id DESC";
        try (Connection conn = DatabaseConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Employee e = new Employee();
                e.setEmployeeId(rs.getInt("employee_id"));
                e.setFullName(rs.getString("full_name"));
                e.setPhone(rs.getString("phone"));
                e.setEmail(rs.getString("email"));
                e.setRoleName(rs.getString("role_name"));
                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean reactivateEmployee(int id) throws SQLException {
        Connection conn = null;
        PreparedStatement psEmp = null;
        PreparedStatement psAcc = null;
        try {
            conn = DatabaseConnect.getConnection();
            conn.setAutoCommit(false);

            // 1. Khôi phục nhân viên (status = 1)
            String sqlEmp = "UPDATE employees SET status = 1 WHERE employee_id = ?";
            psEmp = conn.prepareStatement(sqlEmp);
            psEmp.setInt(1, id);
            psEmp.executeUpdate();

            // 2. Khôi phục tài khoản (status = 1)
            String sqlAcc = "UPDATE accounts SET status = 1 WHERE employee_id = ?";
            psAcc = conn.prepareStatement(sqlAcc);
            psAcc.setInt(1, id);
            psAcc.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }
    
    // Thêm vào EmployeeDAO.java
    public boolean updatePassword(int employeeId, String newPassword) {
    String sql = "UPDATE accounts SET password_hash = ? WHERE employee_id = ?";
    try (Connection conn = DatabaseConnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, newPassword); // Hiện tại bạn đang dùng plain text theo PasswordUtils
        ps.setInt(2, employeeId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
}
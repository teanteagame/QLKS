package dao;

import config.DatabaseConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Account;

public class AccountDAO {

    public Account login(String username, String password) {        
        String sql = "SELECT a.*, r.role_name "
                + "FROM accounts a "
                + "JOIN employees e ON a.employee_id = e.employee_id "
                + "JOIN roles r ON e.role_id = r.role_id "
                + "WHERE a.username = ? "
                + "AND a.password_hash = ? "
                + "AND a.status = 1";

        try {
            Connection conn = DatabaseConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setEmployeeId(rs.getInt("employee_id"));
                account.setUsername(rs.getString("username"));
                account.setPasswordHash(rs.getString("password_hash"));
                account.setStatus(rs.getBoolean("status"));
                account.setRoleName(rs.getString("role_name"));
                return account;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }   
    
    public String getEmployeeName(String username, String password)
    {
        String sql = "SELECT a.*, r.role_name, e.full_name "
                + "FROM accounts a "
                + "JOIN employees e ON a.employee_id = e.employee_id "
                + "JOIN roles r ON e.role_id = r.role_id "
                + "WHERE a.username = ? "
                + "AND a.password_hash = ? "
                + "AND a.status = 1";

        try {
            Connection conn = DatabaseConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
               String result = rs.getString("full_name");
               return result;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
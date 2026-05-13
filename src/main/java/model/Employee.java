package model;

public class Employee {

    private int employeeId;
    private String fullName;
    private String phone;
    private String email;
    private int roleId;
    private String roleName;

    public Employee() {
    }

    public Employee(int employeeId, String fullName, String phone, String email, int roleId) {
        this.employeeId = employeeId;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.roleId = roleId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
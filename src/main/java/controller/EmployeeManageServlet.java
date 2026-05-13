package controller;

import dao.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;

@WebServlet(name = "EmployeeManageServlet", urlPatterns = {"/employee-management"})
public class EmployeeManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        EmployeeDAO dao = new EmployeeDAO();
        String action = request.getParameter("action");

        try {
            // 1. Xử lý Xóa nhân viên
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteEmployee(id);
                response.sendRedirect(request.getContextPath() + "/employee-management");
                return;
            }

            // 2. Xử lý Kích hoạt lại tài khoản đã nghỉ
            if ("reactivate".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.reactivateEmployee(id);
                response.sendRedirect(request.getContextPath() + "/employee-management?action=showInactive");
                return;
            }

            // 3. Xử lý hiển thị danh sách nhân viên đã nghỉ
            if ("showInactive".equals(action)) {
                request.setAttribute("employeeList", dao.getInactiveEmployees());
                request.setAttribute("isInactiveView", true);
                request.getRequestDispatcher("view/employee-management.jsp").forward(request, response);
                return;
            }

            // 4. Xử lý Sửa (Lấy dữ liệu đổ vào form tại trang chính)
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = dao.getEmployeeById(id);
                request.setAttribute("editEmp", emp); // Gửi đối tượng cần sửa về trang chính
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Mặc định: Hiển thị danh sách nhân viên đang làm việc trên trang quản lý
        request.setAttribute("employeeList", dao.getAllEmployees());
        request.setAttribute("isInactiveView", false);
        request.getRequestDispatcher("view/employee-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        EmployeeDAO dao = new EmployeeDAO();
        String idStr = request.getParameter("employeeId");
        
        // Khởi tạo đối tượng từ dữ liệu Form
        Employee emp = new Employee();
        emp.setFullName(request.getParameter("fullName"));
        emp.setPhone(request.getParameter("phone"));
        emp.setEmail(request.getParameter("email"));
        emp.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        try {
            if (idStr == null || idStr.isEmpty()) {
                // Thêm mới
                dao.addEmployeeWithAccount(emp);
            } else {
                // Cập nhật
                emp.setEmployeeId(Integer.parseInt(idStr));
                dao.updateEmployee(emp);
            }
            response.sendRedirect(request.getContextPath() + "/employee-management");
        } catch (Exception e) {
            // Nếu lỗi, quay lại trang quản lý và hiển thị thông báo lỗi cùng dữ liệu đã nhập
            request.setAttribute("error", "Không thể lưu nhân viên: " + e.getMessage());
            request.setAttribute("editEmp", emp);
            request.setAttribute("employeeList", dao.getAllEmployees());
            request.setAttribute("isInactiveView", false);
            request.getRequestDispatcher("view/employee-management.jsp").forward(request, response);
        }
    }
}
package controller;

import dao.EmployeeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Employee;

@WebServlet(name = "EmployeeManageServlet", urlPatterns =
{
    "/employee-management"
})
public class EmployeeManageServlet extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        EmployeeDAO dao = new EmployeeDAO();
        String action = request.getParameter("action");

        try
        {
            // 1. Xử lý Xóa nhân viên
            if ("delete".equals(action))
            {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteEmployee(id);
                response.sendRedirect(request.getContextPath() + "/employee-management");
                return;
            }

            // 2. Xử lý Kích hoạt lại tài khoản đã nghỉ
            if ("reactivate".equals(action))
            {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.reactivateEmployee(id);
                response.sendRedirect(request.getContextPath() + "/employee-management?action=showInactive");
                return;
            }

            // 3. Xử lý hiển thị danh sách nhân viên đã nghỉ
            // Trong phương thức doGet của EmployeeManageServlet.java
            if ("showInactive".equals(action))
            {
                request.setAttribute("isInactiveView", true);
                request.setAttribute("employeeList", dao.getInactiveEmployees());
            } else
            {
                request.setAttribute("isInactiveView", false); // Đảm bảo luôn có giá trị false nếu là danh sách chính
                request.setAttribute("employeeList", dao.getAllEmployees());
            }

            // 4. Xử lý Sửa (Lấy dữ liệu đổ vào form tại trang chính)
            if ("edit".equals(action))
            {
                int id = Integer.parseInt(request.getParameter("id"));
                Employee emp = dao.getEmployeeById(id);
                request.setAttribute("editEmp", emp); // Gửi đối tượng cần sửa về trang chính
            }

        } catch (Exception e)
        {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        // Mặc định: Hiển thị danh sách nhân viên đang làm việc trên trang quản lý
        request.setAttribute("employeeList", dao.getAllEmployees());
        request.setAttribute("isInactiveView", false);
        request.getRequestDispatcher("view/employee-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        EmployeeDAO dao = new EmployeeDAO();
        String idStr = request.getParameter("employeeId");
        String newPassword = request.getParameter("password"); // Lấy mật khẩu từ form

        Employee emp = new Employee();
        emp.setFullName(request.getParameter("fullName"));
        emp.setPhone(request.getParameter("phone"));
        emp.setEmail(request.getParameter("email"));
        emp.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        try
        {
            if (idStr == null || idStr.isEmpty())
            {
                // Trường hợp thêm mới nhân viên
                dao.addEmployeeWithAccount(emp);
                // Mật khẩu mặc định khi tạo mới đã được xử lý trong addEmployeeWithAccount là "123"
            } else
            {
                // Trường hợp cập nhật hồ sơ
                int empId = Integer.parseInt(idStr);
                emp.setEmployeeId(empId);
                dao.updateEmployee(emp);

                // LOGIC QUAN TRỌNG: Chỉ đổi mật khẩu nếu người dùng có nhập vào ô password
                if (newPassword != null && !newPassword.trim().isEmpty())
                {
                    dao.updatePassword(empId, newPassword.trim());
                }
            }
            response.sendRedirect(request.getContextPath() + "/employee-management");
        } catch (Exception e)
        {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("editEmp", emp);
            request.setAttribute("employeeList", dao.getAllEmployees());
            request.getRequestDispatcher("view/employee-management.jsp").forward(request, response);
        }
    }
}

package controller;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Service;

@WebServlet(name = "ServiceManageServlet", urlPatterns = {"/service-management"})
public class ServiceManageServlet extends HttpServlet {

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    ServiceDAO dao = new ServiceDAO();
    String action = request.getParameter("action");
    
    // 1. Xử lý xóa
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deleteService(id);
        response.sendRedirect(request.getContextPath() + "/service-management");
        return;
    }
    
    // 2. Xử lý sửa (giữ lại để truyền dữ liệu editService vào JSP)
    if ("edit".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        Service s = dao.getServiceById(id);
        request.setAttribute("editService", s); 
        // Sau đó để nó trôi xuống phần hiện danh sách bên dưới
    }

    // 3. Mặc định hiện danh sách (Dùng chung cho cả hiển thị thường, Add và Edit)
    request.setAttribute("serviceList", dao.getAllServices());
    request.getRequestDispatcher("view/service-management.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ServiceDAO dao = new ServiceDAO();
        String idStr = request.getParameter("serviceId");
        
        Service s = new Service();
        s.setServiceName(request.getParameter("serviceName"));
        s.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        s.setUnit(request.getParameter("unit"));
        s.setPrice(Double.parseDouble(request.getParameter("price")));
        s.setStatus(request.getParameter("status") != null);

        if (idStr == null || idStr.isEmpty()) {
            dao.addService(s);
        } else {
            s.setServiceId(Integer.parseInt(idStr));
            dao.updateService(s);
        }
        
        // Redirect luôn dùng contextPath để an toàn
        response.sendRedirect(request.getContextPath() + "/service-management");
    }
}
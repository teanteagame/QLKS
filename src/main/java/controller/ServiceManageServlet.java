package controller;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import model.Service;

@WebServlet(name = "ServiceManageServlet", urlPatterns = {"/service-management"})
public class ServiceManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ServiceDAO dao = new ServiceDAO();
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteService(id);
            response.sendRedirect(request.getContextPath() + "/service-management");
            return;
        }
        
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("editService", dao.getServiceById(id)); 
        }

        // QUAN TRỌNG: Gửi cả danh sách dịch vụ và danh sách danh mục sang JSP
        request.setAttribute("serviceList", dao.getAllServices());
        request.setAttribute("categories", dao.getAllCategories()); // Map<Integer, String>
        
        request.getRequestDispatcher("view/service-management.jsp").forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    ServiceDAO dao = new ServiceDAO();
    String idStr = request.getParameter("serviceId");
    
    // Khởi tạo đối tượng Service và set các thuộc tính cơ bản
    Service s = new Service();
    s.setServiceName(request.getParameter("serviceName"));
    s.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
    s.setUnit(request.getParameter("unit"));
    s.setPrice(Double.parseDouble(request.getParameter("price")));
    s.setStatus(request.getParameter("status") != null);
    
    // 1. Lấy tên file ảnh dịch vụ
    String imageUrl = request.getParameter("imageUrl");
    if (imageUrl == null || imageUrl.trim().isEmpty()) {
        imageUrl = "default-service.jpg";
    }
    s.setImageUrl(imageUrl); // Set ảnh vào model

    try {
        if (idStr == null || idStr.isEmpty()) {
            dao.addService(s);
        } else {
            s.setServiceId(Integer.parseInt(idStr));
            dao.updateService(s);
        }
        response.sendRedirect(request.getContextPath() + "/service-management");
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi: " + e.getMessage());
        doGet(request, response);
    }
}
}
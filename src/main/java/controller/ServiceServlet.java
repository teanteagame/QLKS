package controller;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/service"})
public class ServiceServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
    String catIdStr = request.getParameter("catId");
    int catId = (catIdStr != null) ? Integer.parseInt(catIdStr) : 0;

    ServiceDAO dao = new ServiceDAO();
    // Gửi danh sách danh mục để hiện menu lọc
    request.setAttribute("categories", dao.getAllCategories());
    // Gửi danh sách dịch vụ đã lọc
    request.setAttribute("services", dao.getServicesByCategory(catId));
    
    request.setAttribute("bookingId", bookingId);
    request.setAttribute("selectedCat", catId);
    request.getRequestDispatcher("view/service.jsp").forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));

        ServiceDAO serviceDAO = new ServiceDAO();
        if (serviceDAO.addServiceToBooking(bookingId, serviceId, quantity, price)) {
            response.sendRedirect("rooms");
        } else {
            request.setAttribute("error", "Không thể thêm dịch vụ.");
            doGet(request, response);
        }
    }
}
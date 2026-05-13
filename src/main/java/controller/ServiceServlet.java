package controller;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import model.Service;

@WebServlet(name = "ServiceServlet", urlPatterns = {"/service"})
public class ServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        ServiceDAO serviceDAO = new ServiceDAO();
        ArrayList<Service> services = serviceDAO.getAllAvailableServices();

        request.setAttribute("bookingId", bookingId);
        request.setAttribute("services", services);
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
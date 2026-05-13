package controller;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        DashboardDAO dashboardDAO = new DashboardDAO();
        
        // Lấy các chỉ số thống kê
        double totalRevenue = dashboardDAO.getTotalRevenue();
        int totalBookings = dashboardDAO.getTotalBookings();
        int occupiedRooms = dashboardDAO.getOccupiedRooms();
        int totalRooms = dashboardDAO.getTotalRooms();
        
        // Gửi dữ liệu sang JSP
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("occupiedRooms", occupiedRooms);
        request.setAttribute("totalRooms", totalRooms);
        
        request.getRequestDispatcher("view/dashboard.jsp").forward(request, response);
    }
}
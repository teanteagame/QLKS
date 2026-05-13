package controller;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "ReportServlet", urlPatterns = {"/statistics"})
public class ReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        ReportDAO dao = new ReportDAO();
        
        // Lấy ngày từ form
        String startStr = request.getParameter("startDate");
        String endStr = request.getParameter("endDate");

        // Mặc định 30 ngày gần nhất
        LocalDate endDate = (endStr == null || endStr.isEmpty()) ? LocalDate.now() : LocalDate.parse(endStr);
        LocalDate startDate = (startStr == null || startStr.isEmpty()) ? endDate.minusDays(30) : LocalDate.parse(startStr);

        // Lấy dữ liệu thực từ DAO
        double roomRev = dao.getRoomRevenue(startDate.toString(), endDate.toString());
        double serviceRev = dao.getServiceRevenue(startDate.toString(), endDate.toString());
        Map<String, Double> dailyData = dao.getDailyRevenue(startDate.toString(), endDate.toString());

        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        double avgRev = (roomRev + serviceRev) / (daysBetween > 0 ? daysBetween : 1);

        // Định dạng dữ liệu cho Chart.js
        String labels = dailyData.keySet().stream().map(d -> "'" + d + "'").collect(Collectors.joining(", ", "[", "]"));
        String values = dailyData.values().stream().map(String::valueOf).collect(Collectors.joining(", ", "[", "]"));

        request.setAttribute("roomRevenue", roomRev);
        request.setAttribute("serviceRevenue", serviceRev);
        request.setAttribute("averageRevenue", avgRev);
        request.setAttribute("chartLabels", labels);
        request.setAttribute("chartValues", values);

        request.getRequestDispatcher("view/statistics.jsp").forward(request, response);
    }
}
package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import  model.BookingDetail;
import java.util.ArrayList;

@WebServlet(name = "BookingHistoryServlet", urlPatterns = {"/booking-history"})
public class BookingHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
     BookingDAO dao = new  BookingDAO();
ArrayList<BookingDetail> list = dao.getBookingHistory();
request.setAttribute("historyList", list); // Tên này phải khớp với c:forEach trong JSP
        request.getRequestDispatcher("view/booking-history.jsp").forward(request, response);
    }
}
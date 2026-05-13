package controller;

import dao.InvoiceDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.BookingDetail;
import model.Invoice;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice"})
public class InvoiceServlet extends HttpServlet {

   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            RoomDAO roomDAO = new RoomDAO();
            BookingDetail detail = roomDAO.getBookingDetail(bookingId); // Đã JOIN room_types
            
            if (detail != null) {
                // Tính toán tiền phòng tự động
                long duration = System.currentTimeMillis() - detail.getCheckIn().getTime();
                double roomTotal = detail.getRoomPrice();
                
                if (detail.getRentalTypeId() == 1) { // Tính theo giờ
                    long hours = duration / (1000 * 60 * 60);
                    if (hours > 1) roomTotal = hours * detail.getRoomPrice();
                }

                ServiceDAO serviceDAO = new ServiceDAO();
                double serviceTotal = serviceDAO.getTotalServiceMoneyByBookingId(bookingId);

                request.setAttribute("detail", detail);
                request.setAttribute("calculatedRoomTotal", roomTotal);
                request.setAttribute("serviceTotal", serviceTotal);
                request.getRequestDispatcher("view/invoice.jsp").forward(request, response);
            }
        } catch (Exception e) { response.sendRedirect("rooms"); }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            double roomTotal = Double.parseDouble(request.getParameter("roomTotal"));
            double serviceTotal = Double.parseDouble(request.getParameter("serviceTotal"));
            String paymentMethod = request.getParameter("paymentMethod");

            Invoice invoice = new Invoice();
            invoice.setBookingId(bookingId);
            invoice.setRoomTotal(roomTotal);
            invoice.setServiceTotal(serviceTotal);
            invoice.setTotalAmount(roomTotal + serviceTotal);
            invoice.setPaymentMethod(paymentMethod);
            invoice.setPaymentStatus("PAID");

            InvoiceDAO invoiceDAO = new InvoiceDAO();
            if (invoiceDAO.createInvoice(invoice)) {
                invoiceDAO.checkoutBooking(bookingId);
                invoiceDAO.updateRoomAvailable(roomId);
                response.sendRedirect("rooms");
            }
        } catch (Exception e) {
            doGet(request, response);
        }
    }
}
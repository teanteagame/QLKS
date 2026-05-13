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
import java.util.*;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice"})
public class InvoiceServlet extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    try {
        // 1. Lấy mã đặt phòng từ tham số request
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        
        // 2. Lấy thông tin chi tiết đặt phòng (bao gồm thông tin Phòng và Loại phòng)
        RoomDAO roomDAO = new RoomDAO();
        BookingDetail detail = roomDAO.getBookingDetail(bookingId); 
        
        if (detail != null) {
            // 3. Tính toán tiền phòng tự động dựa trên thời gian thực tế
            long checkInTime = detail.getCheckIn().getTime();
            long currentTime = System.currentTimeMillis();
            long duration = currentTime - checkInTime;
            
            double roomTotal = detail.getRoomPrice(); // Giá mặc định của loại phòng
            
            // Logic tính tiền theo giờ (Rental Type ID = 1)
            if (detail.getRentalTypeId() == 1) { 
                long hours = duration / (1000 * 60 * 60);
                // Nếu ở quá 1 giờ thì tính theo đơn giá nhân số giờ
                if (hours > 1) {
                    roomTotal = hours * detail.getRoomPrice();
                }
            }

            // 4. Xử lý dữ liệu dịch vụ (Cập nhật để hiển thị minh bạch)
            ServiceDAO serviceDAO = new ServiceDAO();
            
            // Lấy danh sách chi tiết từng món (Sử dụng Inner Class đã tạo trong ServiceDAO)
            List<ServiceDAO.ServiceUsage> serviceUsageList = serviceDAO.getServiceUsageDetails(bookingId);
            
            // Lấy tổng tiền dịch vụ để hiển thị và lưu trữ
            double serviceTotal = serviceDAO.getTotalServiceMoneyByBookingId(bookingId);

            // 5. Đẩy toàn bộ dữ liệu sang JSP để hiển thị
            request.setAttribute("detail", detail); // Thông tin khách và phòng
            request.setAttribute("calculatedRoomTotal", roomTotal); // Tiền phòng đã tính toán
            request.setAttribute("serviceUsageList", serviceUsageList); // CHI TIẾT: Nước, Cola...
            request.setAttribute("serviceTotal", serviceTotal); // Tổng cộng tiền dịch vụ

            // 6. Chuyển hướng đến trang hóa đơn
            request.getRequestDispatcher("view/invoice.jsp").forward(request, response);
        } else {
            response.sendRedirect("rooms");
        }
    } catch (Exception e) { 
        // Trả về trang sơ đồ phòng nếu có lỗi xảy ra
        response.sendRedirect("rooms"); 
    }
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
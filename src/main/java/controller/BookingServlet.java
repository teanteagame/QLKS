package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import model.Account;
import model.Booking;
import model.Customer;
import model.Room;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            RoomDAO roomDAO = new RoomDAO();
            ArrayList<Room> rooms = roomDAO.getAllRooms();
            Room currentRoom = null;
            
            for (Room r : rooms) {
                if (r.getRoomId() == roomId) {
                    currentRoom = r;
                    break;
                }
            }
            
            if (currentRoom != null) {
                request.setAttribute("room", currentRoom);
                request.getRequestDispatcher("view/booking.jsp").forward(request, response);
            } else {
                response.sendRedirect("rooms");
            }
        } catch (Exception e) {
            response.sendRedirect("rooms");
        }
    }

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int rentalTypeId = Integer.parseInt(request.getParameter("rentalTypeId"));
            
            RoomDAO roomDAO = new RoomDAO();
            double roomPrice = roomDAO.getRoomPrice(roomId, rentalTypeId); // Lấy giá từ room_types

            Customer customer = new Customer();
            customer.setFullName(request.getParameter("fullName"));
            customer.setCitizenId(request.getParameter("citizenId"));
            customer.setPhone(request.getParameter("phone"));
            customer.setEmail(request.getParameter("email"));

            CustomerDAO customerDAO = new CustomerDAO();
            int customerId = customerDAO.insertCustomer(customer);

            if (customerId != -1) {
                Account account = (Account) request.getSession().getAttribute("account");
                Booking b = new Booking();
                b.setCustomerId(customerId);
                b.setRoomId(roomId);
                b.setEmployeeId(account.getEmployeeId());
                b.setRentalTypeId(rentalTypeId);
                b.setCheckIn(new Timestamp(System.currentTimeMillis()));
                b.setRoomPrice(roomPrice);
                b.setBookingStatus("CHECKED_IN");

                BookingDAO bookingDAO = new BookingDAO();
                if (bookingDAO.insertBooking(b)) {
                    bookingDAO.updateRoomStatus(roomId);
                    response.sendRedirect(request.getContextPath() + "/rooms");
                }
            }
        } catch (Exception e) { response.sendRedirect("rooms"); }
    }
}
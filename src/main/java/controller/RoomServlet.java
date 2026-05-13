package controller;

import dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.RoomTypeDAO;

@WebServlet(name = "RoomServlet", urlPatterns = {"/rooms"})
public class RoomServlet extends HttpServlet {

 @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    RoomDAO roomDAO = new RoomDAO();
    RoomTypeDAO typeDAO = new RoomTypeDAO();

    // 1. Lấy tham số lọc từ URL (ví dụ: ?typeId=1&status=AVAILABLE)
    String typeIdParam = request.getParameter("typeId");
    String status = request.getParameter("status");

    // Nếu tham số rỗng thì mặc định là 0 (Tất cả)
    Integer typeId = (typeIdParam != null && !typeIdParam.isEmpty()) ? Integer.parseInt(typeIdParam) : 0;

    // 2. Lấy dữ liệu đã được lọc từ Database
    request.setAttribute("roomList", roomDAO.getFilteredRooms(typeId, status));
    request.setAttribute("typeList", typeDAO.getAllRoomTypes()); // Cần thiết cho dropdown
    
    // 3. Gửi lại tham số cũ để giữ trạng thái đã chọn trên giao diện (UX)
    request.setAttribute("selectedType", typeId);
    request.setAttribute("selectedStatus", status);

    request.getRequestDispatcher("view/rooms.jsp").forward(request, response);
}
}
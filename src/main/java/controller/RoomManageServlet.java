package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RoomManageServlet", urlPatterns = {"/room-management"})
public class RoomManageServlet extends HttpServlet {
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    RoomDAO roomDAO = new RoomDAO();
    RoomTypeDAO typeDAO = new RoomTypeDAO();
    String action = request.getParameter("action");

    // Xử lý Khôi phục phòng
    if ("restore".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        roomDAO.restoreRoom(id);
        response.sendRedirect(request.getContextPath() + "/room-management?action=showDeleted");
        return;
    }

    // Xử lý Xóa mềm (Đã làm ở bước trước)
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        roomDAO.deleteRoom(id);
        response.sendRedirect(request.getContextPath() + "/room-management");
        return;
    }

    if ("edit".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("editRoom", roomDAO.getRoomById(id));
    }
    
    // Điều hướng hiển thị: Danh sách thường hoặc Danh sách đã xóa
    if ("showDeleted".equals(action)) {
        request.setAttribute("isDeletedView", true);
        request.setAttribute("roomList", roomDAO.getDeletedRooms());
    } else {
        request.setAttribute("roomList", roomDAO.getAllRooms());
    }

    request.setAttribute("typeList", typeDAO.getAllRoomTypes());
    request.getRequestDispatcher("view/room-management.jsp").forward(request, response);
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    String idStr = request.getParameter("roomId");
    String roomNumber = request.getParameter("roomNumber");
    int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
    String status = request.getParameter("status");
    
    // 1. Lấy tên file ảnh từ Form
    String imageUrl = request.getParameter("imageUrl");
    
    // 2. Xử lý giá trị mặc định nếu để trống
    if (imageUrl == null || imageUrl.trim().isEmpty()) {
        imageUrl = "default-room.jpg";
    }

    RoomDAO dao = new RoomDAO();
    try {
        if (idStr == null || idStr.isEmpty()) {
            // Thêm mới (Gọi hàm DAO đã cập nhật tham số imageUrl)
            dao.addRoom(roomNumber, roomTypeId, imageUrl);
        } else {
            // Cập nhật
            int roomId = Integer.parseInt(idStr);
            dao.updateRoom(roomId, roomNumber, roomTypeId, status, imageUrl);
        }
        response.sendRedirect(request.getContextPath() + "/room-management");
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi xử lý dữ liệu: " + e.getMessage());
        doGet(request, response);
    }
}
}
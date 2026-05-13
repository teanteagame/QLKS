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

    if ("edit".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("editRoom", roomDAO.getRoomById(id));
    }
    
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        roomDAO.deleteRoom(id);
        response.sendRedirect(request.getContextPath() + "/room-management");
        return;
    }

    request.setAttribute("roomList", roomDAO.getAllRooms());
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

    RoomDAO dao = new RoomDAO();
    if (idStr == null || idStr.isEmpty()) {
        dao.addRoom(roomNumber, roomTypeId);
    } else {
        dao.updateRoom(Integer.parseInt(idStr), roomNumber, roomTypeId, status);
    }
    response.sendRedirect(request.getContextPath() + "/room-management");
}
}
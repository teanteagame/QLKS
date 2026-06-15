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
   
    String typeIdParam = request.getParameter("typeId");
    String status = request.getParameter("status");
    
    Integer typeId = (typeIdParam != null && !typeIdParam.isEmpty()) ? Integer.parseInt(typeIdParam) : 0;
    
    request.setAttribute("roomList", roomDAO.getFilteredRooms(typeId, status));
    request.setAttribute("typeList", typeDAO.getAllRoomTypes()); 
       
    request.setAttribute("selectedType", typeId);
    request.setAttribute("selectedStatus", status);

    request.getRequestDispatcher("view/rooms.jsp").forward(request, response);
}
}
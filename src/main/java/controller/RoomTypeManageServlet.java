package controller;

import dao.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.RoomType;

@WebServlet(name = "RoomTypeManageServlet", urlPatterns = {"/room-type-management"})
public class RoomTypeManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RoomTypeDAO dao = new RoomTypeDAO();
        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("editType", dao.getRoomTypeById(id));
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteRoomType(id);
                response.sendRedirect(request.getContextPath() + "/room-type-management");
                return;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Không thể xóa loại phòng đang có phòng hoạt động!");
        }

        request.setAttribute("typeList", dao.getAllRoomTypes());
        request.getRequestDispatcher("view/room-type-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        RoomTypeDAO dao = new RoomTypeDAO();
        String idStr = request.getParameter("roomTypeId");
        
        RoomType rt = new RoomType();
        rt.setTypeName(request.getParameter("typeName"));
        rt.setHourlyPrice(Double.parseDouble(request.getParameter("hourlyPrice")));
        rt.setOvernightPrice(Double.parseDouble(request.getParameter("overnightPrice")));
        rt.setDailyPrice(Double.parseDouble(request.getParameter("dailyPrice")));

        if (idStr == null || idStr.isEmpty()) {
            dao.addRoomType(rt);
        } else {
            rt.setRoomTypeId(Integer.parseInt(idStr));
            dao.updateRoomType(rt);
        }
        response.sendRedirect(request.getContextPath() + "/room-type-management");
    }
}
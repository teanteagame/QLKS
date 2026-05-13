package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter này dùng để kiểm tra quyền hạn (Role-based Access Control).
 * Nó đảm bảo chỉ những tài khoản có vai trò 'MANAGER' mới được truy cập Dashboard.
 */
@WebFilter(urlPatterns = {
    "/dashboard",
    "/service-management"
})
public class AuthorizationFilter extends HttpFilter implements Filter {

    @Override
    protected void doFilter(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        // Lấy vai trò đã lưu trong Session khi đăng nhập (từ AuthServlet)
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Kiểm tra xem vai trò có phải là MANAGER hay không
        if ("MANAGER".equalsIgnoreCase(role)) {
            // Nếu đúng là Manager, cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Nếu không phải Manager, từ chối truy cập. 
            // Bạn có thể redirect về trang rooms hoặc hiện lỗi 403 Forbidden.
            
            // Cách 1: Redirect về trang chính và gửi thông báo lỗi
            request.setAttribute("error", "You do not have permission to access the Dashboard!");
            response.sendRedirect(request.getContextPath() + "/rooms");
            
            /* // Cách 2: Trả về mã lỗi 403 chuẩn HTTP
            // response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied"); 
            */
        }
    }
}
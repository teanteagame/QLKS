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

@WebFilter(urlPatterns = {
    "/rooms",
    "/booking",
    "/service",
    "/invoice",
    "/dashboard"
})
public class AuthenticationFilter extends HttpFilter implements Filter {

    @Override
    protected void doFilter(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpSession session =
                request.getSession(false);

        boolean loggedIn =
                session != null
                && session.getAttribute("account") != null;

        if (loggedIn) {

            chain.doFilter(request, response);

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
        }
    }
}
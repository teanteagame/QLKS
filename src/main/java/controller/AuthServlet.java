package controller;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;

@WebServlet(name = "AuthServlet", urlPatterns =
{
    "/login"
})
public class AuthServlet extends HttpServlet
{

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException
    {

        String action
                = request.getParameter("action");

        if ("logout".equals(action))
        {

            HttpSession session
                    = request.getSession();

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        request.getRequestDispatcher(
                "view/auth/login.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException
    {

        String username
                = request.getParameter("username");

        String password
                = request.getParameter("password");

        AccountDAO accountDAO
                = new AccountDAO();

        Account account
                = accountDAO.login(username, password);

        if (account != null)
        {

            HttpSession session
                    = request.getSession();

            session.setAttribute(
                    "account",
                    account
            );

            session.setAttribute(
                    "role",
                    account.getRoleName()
            );

            response.sendRedirect("rooms");

        } else
        {

            request.setAttribute(
                    "error",
                    "Invalid username or password"
            );

            request.getRequestDispatcher(
                    "view/auth/login.jsp"
            ).forward(request, response);
        }
    }
}

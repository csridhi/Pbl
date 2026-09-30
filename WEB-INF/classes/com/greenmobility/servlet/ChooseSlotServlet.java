package com.greenmobility.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/choose-slot")
public class ChooseSlotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String slotIdParam = request.getParameter("slotId");
        if (slotIdParam == null) {
            response.sendRedirect("browse.jsp");
            return;
        }

        try {
            int slotId = Integer.parseInt(slotIdParam);
            session.setAttribute("selectedSlotId", slotId);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/confirm-booking.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("browse.jsp");
        }
    }
}

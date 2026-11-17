
package com.petcare.servlet;

import com.petcare.dao.OrderDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Check customer login
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // 2. Get checkout details
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String pincode = request.getParameter("pincode");
        String paymentMethod = request.getParameter("paymentMethod");

        // 3. Validate checkout details
        if (fullName == null || fullName.trim().isEmpty()
                || phone == null || !phone.matches("[0-9]{10}")
                || address == null || address.trim().isEmpty()
                || city == null || city.trim().isEmpty()
                || pincode == null || !pincode.matches("[0-9]{6}")
                || !"COD".equals(paymentMethod)) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter valid checkout details."
            );
            return;
        }

        // 4. Place order
        try {

            int orderId = orderDao.placeOrder(
                userId,
                fullName,
                phone,
                address,
                city,
                pincode,
                paymentMethod
            );

            // 5. Save order ID
            session.setAttribute("lastOrderId", orderId);

            // 6. Redirect to confirmation page
            response.sendRedirect(
                request.getContextPath() + "/order-success.jsp"
            );

        } catch (SQLException e) {

            getServletContext().log(
                "Order placement failed for user: " + userId,
                e
            );

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Your order could not be placed. Please check your cart and try again."
            );

        } catch (Exception e) {

            getServletContext().log(
                "Unexpected checkout error.", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Something went wrong while placing your order."
            );
        }
    }
}

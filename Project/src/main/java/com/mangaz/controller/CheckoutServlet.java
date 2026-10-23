package com.mangaz.controller;

import com.mangaz.dao.CartDAO;
import com.mangaz.dao.DeliveryAddressDAO;
import com.mangaz.dao.OrderDAO;
import com.mangaz.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final DeliveryAddressDAO addressDAO = new DeliveryAddressDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        Cart cart = cartDAO.getCartByUserId(user.getId());
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        try {
            DeliveryAddress defaultAddress = addressDAO.getDefaultAddress(user.getId());
            List<DeliveryAddress> addresses = addressDAO.findByUserId(user.getId());

            req.setAttribute("cart", cart);
            req.setAttribute("defaultAddress", defaultAddress);
            req.setAttribute("addresses", addresses);

            req.getRequestDispatcher("/CheckOut.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Cart cart = cartDAO.getCartByUserId(user.getId());
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String recipientName = req.getParameter("recipientName");
        String phoneNumber = req.getParameter("phoneNumber");
        String shippingAddress = req.getParameter("shippingAddress");

        String deliveryMethod = req.getParameter("delivery");
        if (deliveryMethod == null || deliveryMethod.isEmpty()) {
            deliveryMethod = "Vận chuyển nhanh";
        }

        BigDecimal shippingFee = new BigDecimal("41000");
        if ("Vận chuyển trong ngày".equals(deliveryMethod)) {
            shippingFee = new BigDecimal("81000");
        }

        String paymentMethod = req.getParameter("payment-method");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "COD";
        }

        Order order = new Order();
        order.setUserId(user.getId());
        order.setRecipientName(recipientName);
        order.setPhoneNumber(phoneNumber);
        order.setShippingAddress(shippingAddress);
        order.setDeliveryMethod(deliveryMethod);
        order.setShippingFee(shippingFee);
        order.setPaymentMethod(paymentMethod);

        BigDecimal merchandiseSubtotal = cart.getCartTotal();
        order.setTotalAmount(merchandiseSubtotal.add(shippingFee));

        List<OrderDetail> details = new ArrayList<>();
        for (CartItem item : cart.getItems()) {
            OrderDetail detail = new OrderDetail();
            detail.setListingId(item.getListingId());
            detail.setQuantity(item.getQuantity());
            detail.setPrice(item.getProductPrice());
            details.add(detail);
        }
        order.setDetails(details);

        boolean success = orderDAO.createOrder(order);
        if (success) {
            // Đặt thuộc tính đánh dấu thành công
            req.setAttribute("orderSuccess", true);
            req.getRequestDispatcher("/CheckOut.jsp").forward(req, resp);
        } else {
            req.setAttribute("errorMessage", "Đặt hàng không thành công. Vui lòng kiểm tra lại số lượng tồn kho.");
            doGet(req, resp);
        }
    }
}

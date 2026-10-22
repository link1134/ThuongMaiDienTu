package com.mangaz.controller;

import com.mangaz.dao.CartDAO;
import com.mangaz.dao.DeliveryAddressDAO;
import com.mangaz.model.Cart;
import com.mangaz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final DeliveryAddressDAO addressDAO = new DeliveryAddressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String path = req.getServletPath();
        if ("/cart".equals(path)) {
            Cart cart = cartDAO.getCartByUserId(user.getId());
            req.setAttribute("cart", cart);
            try {
                req.setAttribute("defaultAddress", addressDAO.getDefaultAddress(user.getId()));
                req.setAttribute("addresses", addressDAO.findByUserId(user.getId()));
            } catch (Exception e) {
                e.getMessage();
            }
            req.getRequestDispatcher("/Cart.jsp").forward(req, resp);
        }

    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        String path = req.getServletPath();
        try {
            if ("/cart/add".equals(path)) {
                int listingId = Integer.parseInt(req.getParameter("listingId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cartDAO.addToCart(user.getId(), listingId, quantity);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            else if ("/cart/update".equals(path)) {
                int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cartDAO.updateQuantity(cartItemId, quantity);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            else if ("/cart/remove".equals(path)) {
                int cartItemId = Integer.parseInt(req.getParameter("cartItemId"));
                cartDAO.removeCartItem(cartItemId);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/cart?error=true");
        }
    }
}

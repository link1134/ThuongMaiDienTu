package com.mangaz.controller;

import com.mangaz.dao.CartDAO;
import com.mangaz.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class CartCountFilter extends HttpFilter implements Filter {

    @Override
    protected void doFilter(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        User user = (User) request.getSession().getAttribute("user");

        if (user != null) {
            CartDAO cartDAO = new CartDAO();

            int cartItemCount = cartDAO.getCartItemCount(user.getId());

            request.setAttribute("cartItemCount", cartItemCount);
        } else {
            request.setAttribute("cartItemCount", 0);
        }

        chain.doFilter(request, response);
    }
}
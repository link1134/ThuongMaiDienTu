package com.mangaz.filter;

import com.mangaz.dao.FavoriteDAO;
import com.mangaz.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class FavoriteCountFilter implements Filter {

    private final FavoriteDAO favoriteDAO = new FavoriteDAO();

    @Override
    public void doFilter(jakarta.servlet.ServletRequest request,
                         jakarta.servlet.ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        int favoriteCount = 0;

        if (session != null && session.getAttribute("user") != null) {

            User user = (User) session.getAttribute("user");

            favoriteCount = favoriteDAO.countFavorites(user.getId());
        }

        req.setAttribute("favoriteCount", favoriteCount);

        chain.doFilter(req, resp);
    }
}

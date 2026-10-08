package com.mangaz.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mangaz.dao.UserDAO;
import com.mangaz.model.User;
import com.mangaz.util.ConfigUtil;
import com.mangaz.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

@WebServlet("/google-callback")
public class GoogleCallbackServlet extends HttpServlet {
    private final Properties config = ConfigUtil.load("google.properties");
    private final UserDAO userDAO = new UserDAO();
    private final ObjectMapper mapper = new ObjectMapper();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String state = req.getParameter("state");
        HttpSession session = req.getSession(false);
        if (session == null || state == null || !state.equals(session.getAttribute("googleState"))) {
            resp.sendError(400, "Invalid OAuth state"); return;
        }
        session.removeAttribute("googleState");
        String code = req.getParameter("code");
        if (code == null) { resp.sendRedirect(req.getContextPath() + "/Login.jsp?googleError=cancelled"); return; }
        try {
            String tokenJson = postForm("https://oauth2.googleapis.com/token", "code=" + enc(code)
                    + "&client_id=" + enc(config.getProperty("google.clientId"))
                    + "&client_secret=" + enc(config.getProperty("google.clientSecret"))
                    + "&redirect_uri=" + enc(config.getProperty("google.redirectUri"))
                    + "&grant_type=authorization_code");
            JsonNode token = mapper.readTree(tokenJson);
            String accessToken = token.path("access_token").asText(null);
            if (accessToken == null) throw new IllegalStateException("Google did not return access token");
            HttpRequest userReq = HttpRequest.newBuilder(URI.create("https://www.googleapis.com/oauth2/v3/userinfo"))
                    .header("Authorization", "Bearer " + accessToken).GET().build();
            String userJson = HttpClient.newHttpClient().send(userReq, HttpResponse.BodyHandlers.ofString()).body();
            JsonNode googleUser = mapper.readTree(userJson);
            String email = googleUser.path("email").asText(null);
            String name = googleUser.path("name").asText("Google User");
            if (email == null || email.isBlank()) throw new IllegalStateException("Google email missing");
            User user = userDAO.findByEmail(email.toLowerCase());
            if (user == null) {
                String base = email.substring(0, email.indexOf('@')).replaceAll("[^A-Za-z0-9_]", "");
                if (base.length() < 3) base = "googleuser";
                String username = base;
                int i = 1;
                while (userDAO.findByUsername(username) != null) username = base + (++i);
                user = new User(); user.setUsername(username); user.setEmail(email.toLowerCase());
                user.setPassword(PasswordUtil.hashPassword(java.util.UUID.randomUUID().toString()));
                user.setFullName(name); int id = userDAO.createUser(user);
                user = userDAO.findById(id); userDAO.setEmailVerified(id);
                user = userDAO.findById(id);
            }
            if (!user.isEnabled()) throw new IllegalStateException("Account disabled");
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/main");
        } catch (Exception e) { throw new ServletException("Google login failed", e); }
    }

    private String postForm(String url, String form) throws Exception {
        HttpRequest r = HttpRequest.newBuilder(URI.create(url)).header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(form)).build();
        return HttpClient.newHttpClient().send(r, HttpResponse.BodyHandlers.ofString()).body();
    }
    private String enc(String s) { return URLEncoder.encode(s == null ? "" : s, StandardCharsets.UTF_8); }
}

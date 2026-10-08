package com.mangaz.controller;

import com.mangaz.util.ConfigUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.UUID;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {
    private final Properties config = ConfigUtil.load("google.properties");
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String clientId = config.getProperty("google.clientId");
        String redirectUri = config.getProperty("google.redirectUri");
        if (clientId == null || clientId.startsWith("YOUR_")) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp?googleError=config"); return;
        }
        String state = UUID.randomUUID().toString();
        req.getSession().setAttribute("googleState", state);
        String url = "https://accounts.google.com/o/oauth2/v2/auth?client_id=" + enc(clientId)
                + "&redirect_uri=" + enc(redirectUri) + "&response_type=code&scope="
                + enc("openid email profile") + "&state=" + enc(state);
        resp.sendRedirect(url);
    }
    private String enc(String s) { return URLEncoder.encode(s, StandardCharsets.UTF_8); }
}

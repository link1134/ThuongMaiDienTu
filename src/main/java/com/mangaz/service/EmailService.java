package com.mangaz.service;

import com.mangaz.util.ConfigUtil;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailService {

    private static final String DEFAULT_BASE_URL = "http://localhost:8080/ThuongMaiDienTu";

    private final Properties config = ConfigUtil.load("mail.properties");

    private String get(String key, String defaultValue) {
        String value = config.getProperty(key);
        return (value == null || value.isBlank()) ? defaultValue : value.trim();
    }

    // =========================================================
    // GỬI EMAIL QUA SMTP
    // =========================================================

    private void send(String to, String subject, String body) throws MessagingException {

        String host = get("mail.host", "smtp.gmail.com");
        String port = get("mail.port", "587");
        String username = get("mail.username", null);
        // App Password của Gmail hiển thị có dấu cách
        String password = get("mail.password", "").replaceAll("\\s+", "");
        String from = get("mail.from", username);

        if (username == null || password.isEmpty()) {
            throw new MessagingException(
                    "Chưa cấu hình mail.username / mail.password trong mail.properties");
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject, "UTF-8");
        message.setText(body, "UTF-8");

        Transport.send(message);
    }

    private String baseUrl() {
        String url = get("app.baseUrl", DEFAULT_BASE_URL);
        return url.endsWith("/") ? url.substring(0, url.length() - 1) : url;
    }

    // =========================================================
    // EMAIL XÁC NHẬN
    // =========================================================

    public void sendVerificationEmail(String email, String token) throws MessagingException {

        String link = baseUrl() + "/verify-email?token=" + token;

        String body = "Chào bạn,\n\n"
                + "Hãy mở liên kết sau để xác nhận email:\n"
                + link
                + "\n\n"
                + "Liên kết có hiệu lực 30 phút.";

        send(email, "Xác nhận email MangaZ", body);
    }

    // =========================================================
    // EMAIL RESET PASSWORD
    // =========================================================

    public void sendResetPasswordEmail(String email, String token) throws MessagingException {

        String link = baseUrl() + "/reset-password?token=" + token;

        String body = "Chào bạn,\n\n"
                + "Hãy mở liên kết sau để đặt lại mật khẩu:\n"
                + link
                + "\n\n"
                + "Liên kết có hiệu lực 30 phút.";

        send(email, "Đặt lại mật khẩu MangaZ", body);
    }
}
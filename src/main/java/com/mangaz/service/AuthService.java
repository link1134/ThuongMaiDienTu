package com.mangaz.service;

import com.mangaz.dao.UserDAO;
import com.mangaz.model.User;
import com.mangaz.util.PasswordUtil;
import com.mangaz.util.TokenUtil;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

public class AuthService {

    private static final int TOKEN_MINUTES = 30;

    private final UserDAO userDAO = new UserDAO();
    private final EmailService emailService = new EmailService();


    // =========================================================
    // KẾT QUẢ ĐĂNG KÝ
    // =========================================================

    public static final class RegisterResult {

        private final boolean success;
        private final String message;

        private RegisterResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        /** true: đã tạo mới hoặc đã gửi (lại) email xác nhận. */
        public boolean isSuccess() {
            return success;
        }

        /** Thông báo hiển thị cho người dùng. */
        public String getMessage() {
            return message;
        }

        static RegisterResult ok(String message) {
            return new RegisterResult(true, message);
        }

        static RegisterResult error(String message) {
            return new RegisterResult(false, message);
        }
    }


    // =========================================================
    // TIỆN ÍCH TOKEN / EMAIL
    // =========================================================

    private Timestamp newExpiry() {
        return Timestamp.from(Instant.now().plus(TOKEN_MINUTES, ChronoUnit.MINUTES));
    }

    /**
     * Tạo token xác nhận mới (xóa token cũ) và gửi email.
     *
     * @return true nếu gửi email thành công
     */
    private boolean issueVerificationEmail(User user) throws SQLException {

        String token = TokenUtil.generateToken();

        userDAO.saveVerificationToken(user.getId(), token, newExpiry());

        try {
            emailService.sendVerificationEmail(user.getEmail(), token);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    // =========================================================
    // ĐĂNG KÝ
    // =========================================================

    public RegisterResult register(
            String username,
            String email,
            String password,
            String confirmPassword,
            String fullName
    ) throws Exception {

        username = username == null ? "" : username.trim();
        email = email == null ? "" : email.trim().toLowerCase();
        fullName = fullName == null ? "" : fullName.trim();


        // ---------------------------------------------------------
        // Kiểm tra dữ liệu
        // ---------------------------------------------------------

        if (username.isEmpty()
                || email.isEmpty()
                || password == null
                || password.isEmpty()) {

            return RegisterResult.error("Vui lòng nhập đầy đủ thông tin.");
        }

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return RegisterResult.error("Email không hợp lệ.");
        }

        if (email.length() > 255) {
            return RegisterResult.error("Email quá dài.");
        }

        if (username.length() < 3 || username.length() > 50) {
            return RegisterResult.error("Tên tài khoản phải từ 3 đến 50 ký tự.");
        }

        if (fullName.length() > 100) {
            return RegisterResult.error("Họ tên tối đa 100 ký tự.");
        }

        if (password.length() < 8) {
            return RegisterResult.error("Mật khẩu phải có ít nhất 8 ký tự.");
        }

        if (!password.equals(confirmPassword)) {
            return RegisterResult.error("Mật khẩu xác nhận không khớp.");
        }


        // ---------------------------------------------------------
        // Tìm tài khoản đã tồn tại theo username / email
        // ---------------------------------------------------------

        User byUsername = userDAO.findByUsername(username);
        User byEmail = userDAO.findByEmail(email);

        // ---------------------------------------------------------
        // 1. Username + email cùng một tài khoản
        // ---------------------------------------------------------

        if (byUsername != null && byEmail != null
                && byUsername.getId() == byEmail.getId()) {

            // Đã xác nhận -> báo đã tồn tại
            if (byUsername.isEmailVerified()) {
                return RegisterResult.error("Tên tài khoản và email đã được sử dụng.");
            }

            // Chưa xác nhận -> gửi lại email xác nhận
            if (!issueVerificationEmail(byUsername)) {
                return RegisterResult.error(
                        "Tài khoản đã tồn tại nhưng chưa xác nhận email. "
                                + "Không thể gửi lại email xác nhận lúc này, vui lòng thử lại sau.");
            }

            return RegisterResult.ok(
                    "Tài khoản đã tồn tại nhưng email chưa được xác nhận. "
                            + "Chúng tôi đã gửi lại email xác nhận, vui lòng kiểm tra hộp thư.");
        }


        // ---------------------------------------------------------
        // 2. Username đã tồn tại (email khác)
        // ---------------------------------------------------------

        if (byUsername != null) {
            return RegisterResult.error("Tên tài khoản đã tồn tại.");
        }


        // ---------------------------------------------------------
        // 3. Username khác, email đã tồn tại
        // ---------------------------------------------------------

        if (byEmail != null) {

            if (byEmail.isEmailVerified()) {
                return RegisterResult.error("Email đã được sử dụng.");
            }

            return RegisterResult.error(
                    "Email đã tồn tại nhưng chưa được xác nhận. "
                            + "Vui lòng đăng ký bằng đúng tên tài khoản đã dùng trước đó "
                            + "hoặc đăng nhập để nhận lại email xác nhận.");
        }


        // ---------------------------------------------------------
        // Tạo tài khoản mới
        // ---------------------------------------------------------

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setFullName(fullName);

        int userId;

        try {
            userId = userDAO.createUser(user);
        } catch (SQLException e) {
            // 2627 / 2601: vi phạm UNIQUE (đăng ký trùng đồng thời)
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                return RegisterResult.error("Tên tài khoản hoặc email đã được sử dụng.");
            }
            throw e;
        }

        if (userId <= 0) {
            return RegisterResult.error("Không thể tạo tài khoản.");
        }

        user.setId(userId);

        boolean sent = issueVerificationEmail(user);

        if (!sent) {
            return RegisterResult.ok(
                    "Đăng ký thành công nhưng chưa gửi được email xác nhận. "
                            + "Hãy đăng nhập hoặc đăng ký lại để nhận email xác nhận mới.");
        }

        return RegisterResult.ok(
                "Đăng ký thành công. Hãy kiểm tra email để xác nhận tài khoản.");
    }


    // =========================================================
    // KIỂM TRA LỖI ĐĂNG NHẬP
    // =========================================================

    public String getLoginError(
            String identifier,
            String password
    ) throws Exception {

        if (identifier == null
                || identifier.trim().isEmpty()
                || password == null
                || password.isEmpty()) {

            return "Vui lòng nhập tên tài khoản/email và mật khẩu.";
        }

        User user = findForLogin(identifier);

        if (user == null) {
            return "Tài khoản hoặc mật khẩu không đúng.";
        }

        if (!user.isEnabled()) {
            return "Tài khoản của bạn đã bị vô hiệu hóa.";
        }

        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            return "Tài khoản hoặc mật khẩu không đúng.";
        }

        if (!user.isEmailVerified()) {

            boolean sent = issueVerificationEmail(user);

            return sent
                    ? "Email của tài khoản chưa được xác nhận. "
                    + "Chúng tôi đã gửi lại email xác nhận, vui lòng kiểm tra hộp thư."
                    : "Email của tài khoản chưa được xác nhận. "
                    + "Không thể gửi lại email xác nhận lúc này, vui lòng thử lại sau.";
        }

        return null;
    }

    private User findForLogin(String identifier) throws SQLException {

        identifier = identifier.trim();

        // Email không phân biệt hoa/thường (đã lưu lowercase)
        String lookup = identifier.contains("@") ? identifier.toLowerCase() : identifier;

        return userDAO.findByUsernameOrEmail(lookup);
    }


    // =========================================================
    // ĐĂNG NHẬP
    // =========================================================

    public User login(
            String identifier,
            String password
    ) throws Exception {

        if (identifier == null
                || identifier.trim().isEmpty()
                || password == null
                || password.isEmpty()) {

            return null;
        }

        User user = findForLogin(identifier);

        if (user == null || !user.isEnabled()) {
            return null;
        }

        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            return null;
        }

        if (!user.isEmailVerified()) {
            return null;
        }

        return user;
    }


    // =========================================================
    // GỬI LẠI EMAIL XÁC NHẬN
    // =========================================================

    public String resendVerificationEmail(
            String identifier
    ) throws Exception {

        if (identifier == null || identifier.trim().isEmpty()) {
            return "Vui lòng nhập email hoặc tên tài khoản.";
        }

        User user = findForLogin(identifier);

        if (user == null) {
            return "Không tìm thấy tài khoản.";
        }

        if (user.isEmailVerified()) {
            return "Email của tài khoản này đã được xác nhận.";
        }

        if (!issueVerificationEmail(user)) {
            return "Không thể gửi email xác nhận lúc này, vui lòng thử lại sau.";
        }

        return null;
    }


    // =========================================================
    // XÁC NHẬN EMAIL
    // =========================================================

    public boolean verifyEmail(
            String token
    ) throws SQLException {

        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        token = token.trim();

        int userId = userDAO.findUserIdByVerificationToken(token);

        if (userId <= 0) {
            return false;
        }

        userDAO.setEmailVerified(userId);
        userDAO.deleteVerificationToken(token);

        return true;
    }


    // =========================================================
    // QUÊN MẬT KHẨU
    // =========================================================

    public void requestPasswordReset(
            String identifier
    ) throws Exception {

        if (identifier == null || identifier.trim().isEmpty()) {
            return;
        }

        identifier = identifier.trim();

        User user = identifier.contains("@")
                ? userDAO.findByEmail(identifier.toLowerCase())
                : userDAO.findByUsername(identifier);

        // Không tiết lộ tài khoản có tồn tại hay không
        if (user == null) {
            return;
        }

        String token = TokenUtil.generateToken();

        userDAO.saveResetToken(user.getId(), token, newExpiry());

        try {
            emailService.sendResetPasswordEmail(user.getEmail(), token);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    // =========================================================
    // KIỂM TRA RESET TOKEN
    // =========================================================

    public boolean isResetTokenValid(
            String token
    ) throws SQLException {

        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        return userDAO.findUserIdByResetToken(token.trim()) > 0;
    }


    // =========================================================
    // RESET PASSWORD
    // =========================================================

    public boolean resetPassword(
            String token,
            String password,
            String confirm
    ) throws Exception {

        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        if (password == null
                || password.length() < 8
                || !password.equals(confirm)) {

            return false;
        }

        token = token.trim();

        int userId = userDAO.findUserIdByResetToken(token);

        if (userId <= 0) {
            return false;
        }

        // BCrypt
        userDAO.updatePassword(userId, PasswordUtil.hashPassword(password));
        userDAO.deleteResetToken(token);

        return true;
    }


    // =========================================================
    // TÌM USER THEO ID
    // =========================================================

    public User findById(
            int id
    ) throws SQLException {

        return userDAO.findById(id);
    }
}
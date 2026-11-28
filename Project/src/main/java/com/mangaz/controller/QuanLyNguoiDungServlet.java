package com.mangaz.controller;

import com.mangaz.dao.AdminUserDAO;
import com.mangaz.dao.AdminUserDAO.UserRow;
import com.mangaz.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/userManager")
public class QuanLyNguoiDungServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final String FLASH_TYPE = "userMgrFlashType";
    private static final String FLASH_MSG = "userMgrFlashMsg";

    private final AdminUserDAO userDAO = new AdminUserDAO();

    // =========================================================
    // GET: hiển thị danh sách (tìm kiếm + lọc + phân trang)
    // =========================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User admin = requireAdmin(req, resp);
        if (admin == null) return;

        String keyword = trim(req.getParameter("q"));
        String status = normalizeStatus(req.getParameter("status"));
        int page = parsePositiveInt(req.getParameter("page"), 1);

        try {
            int total = userDAO.countUsers(keyword, status);
            int totalPages = Math.max(1, (int) Math.ceil(total / (double) PAGE_SIZE));
            page = Math.min(page, totalPages);

            List<UserRow> users = userDAO.searchUsers(
                    keyword, status, (page - 1) * PAGE_SIZE, PAGE_SIZE);

            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, startPage + 4);
            startPage = Math.max(1, endPage - 4);

            req.setAttribute("users", users);
            req.setAttribute("totalUsers", total);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("startPage", startPage);
            req.setAttribute("endPage", endPage);
            req.setAttribute("fromIndex", total == 0 ? 0 : (page - 1) * PAGE_SIZE + 1);
            req.setAttribute("toIndex", (page - 1) * PAGE_SIZE + users.size());
            req.setAttribute("keyword", keyword);
            req.setAttribute("status", status);
            req.setAttribute("currentUserId", admin.getId());
        } catch (SQLException e) {
            throw new ServletException("Không thể tải danh sách người dùng", e);
        }

        // Thông báo kết quả của thao tác POST trước đó (hiện 1 lần)
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(FLASH_MSG) != null) {
            req.setAttribute("flashType", session.getAttribute(FLASH_TYPE));
            req.setAttribute("flashMessage", session.getAttribute(FLASH_MSG));
            session.removeAttribute(FLASH_TYPE);
            session.removeAttribute(FLASH_MSG);
        }

        req.getRequestDispatcher("/QuanLyNguoiDung.jsp").forward(req, resp);
    }

    // =========================================================
    // POST: khóa/mở khóa, sửa, xóa
    // =========================================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User admin = requireAdmin(req, resp);
        if (admin == null) return;

        String action = req.getParameter("action");
        int targetId = parsePositiveInt(req.getParameter("id"), -1);

        try {
            UserRow target = targetId > 0 ? userDAO.findById(targetId) : null;

            if (target == null) {
                flash(req, "error", "Không tìm thấy tài khoản.");
            } else if ("toggleLock".equals(action)) {
                handleToggleLock(req, admin, target);
            } else if ("delete".equals(action)) {
                handleDelete(req, admin, target);
            } else if ("update".equals(action)) {
                handleUpdate(req, admin, target);
            } else {
                flash(req, "error", "Thao tác không hợp lệ.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            flash(req, "error", "Có lỗi cơ sở dữ liệu, vui lòng thử lại.");
        }

        resp.sendRedirect(buildBackUrl(req));
    }

    private void handleToggleLock(HttpServletRequest req, User admin, UserRow target)
            throws SQLException {
        if (target.getId() == admin.getId()) {
            flash(req, "error", "Bạn không thể tự khóa tài khoản của mình.");
            return;
        }
        if ("Admin".equalsIgnoreCase(target.getRole())) {
            flash(req, "error", "Không thể khóa tài khoản quản trị.");
            return;
        }
        boolean newState = !target.isEnabled();
        userDAO.setEnabled(target.getId(), newState);
        flash(req, "success", (newState ? "Đã mở khóa tài khoản @" : "Đã khóa tài khoản @")
                + target.getUsername() + ".");
    }

    private void handleDelete(HttpServletRequest req, User admin, UserRow target) {
        if (target.getId() == admin.getId()) {
            flash(req, "error", "Bạn không thể tự xóa tài khoản của mình.");
            return;
        }
        if ("Admin".equalsIgnoreCase(target.getRole())) {
            flash(req, "error", "Không thể xóa tài khoản quản trị.");
            return;
        }
        try {
            userDAO.deleteUser(target.getId());
            flash(req, "success", "Đã xóa tài khoản @" + target.getUsername() + ".");
        } catch (SQLException e) {
            if (e.getErrorCode() == 547) { // vi phạm khóa ngoại
                flash(req, "error", "Không thể xóa @" + target.getUsername()
                        + " vì tài khoản đã có dữ liệu liên quan (đơn hàng, bài đăng, bình luận...). "
                        + "Hãy dùng chức năng khóa tài khoản thay thế.");
            } else {
                e.printStackTrace();
                flash(req, "error", "Không thể xóa tài khoản, vui lòng thử lại.");
            }
        }
    }

    private void handleUpdate(HttpServletRequest req, User admin, UserRow target)
            throws SQLException {
        String fullName = trim(req.getParameter("fullName"));
        String phone = trim(req.getParameter("phoneNumber"));
        String role = req.getParameter("role");
        boolean enabled = "1".equals(req.getParameter("enabled"));

        if (fullName.length() > 100) {
            flash(req, "error", "Họ tên tối đa 100 ký tự.");
            return;
        }
        if (!phone.isEmpty() && !phone.matches("[0-9+()\\-\\s]{1,20}")) {
            flash(req, "error", "Số điện thoại không hợp lệ.");
            return;
        }

        // Với chính mình: giữ nguyên vai trò và trạng thái (tránh tự hạ quyền / tự khóa)
        if (target.getId() == admin.getId()) {
            role = target.getRole();
            enabled = target.isEnabled();
        } else if (!"Admin".equals(role) && !"User".equals(role)) {
            flash(req, "error", "Vai trò không hợp lệ.");
            return;
        }
        // Tài khoản quản trị khác không bị khóa từ trang này
        if ("Admin".equals(role)) {
            enabled = true;
        }

        userDAO.updateUser(target.getId(),
                fullName.isEmpty() ? null : fullName,
                phone.isEmpty() ? null : phone,
                role, enabled);
        flash(req, "success", "Đã cập nhật tài khoản @" + target.getUsername() + ".");
    }

    // =========================================================
    // Tiện ích
    // =========================================================
    /** Chỉ cho Admin đã đăng nhập; trả về null nếu đã xử lý (redirect / 403). */
    private User requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("user") instanceof User)) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return user;
    }

    private void flash(HttpServletRequest req, String type, String message) {
        HttpSession session = req.getSession();
        session.setAttribute(FLASH_TYPE, type);
        session.setAttribute(FLASH_MSG, message);
    }

    /** Quay lại đúng trang/bộ lọc đang xem sau khi thao tác. */
    private String buildBackUrl(HttpServletRequest req) {
        String q = trim(req.getParameter("q"));
        String status = normalizeStatus(req.getParameter("status"));
        int page = parsePositiveInt(req.getParameter("page"), 1);
        return req.getContextPath() + "/admin/userManager?q="
                + URLEncoder.encode(q, StandardCharsets.UTF_8)
                + "&status=" + URLEncoder.encode(status, StandardCharsets.UTF_8)
                + "&page=" + page;
    }

    private String normalizeStatus(String s) {
        return ("active".equals(s) || "locked".equals(s)) ? s : "";
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private int parsePositiveInt(String s, int fallback) {
        try {
            int v = Integer.parseInt(s);
            return v > 0 ? v : fallback;
        } catch (Exception e) {
            return fallback;
        }
    }
}

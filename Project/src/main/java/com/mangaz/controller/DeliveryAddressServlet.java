
package com.mangaz.controller;

import com.mangaz.dao.DeliveryAddressDAO;
import com.mangaz.model.DeliveryAddress;
import com.mangaz.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/delivery-addresses")
public class DeliveryAddressServlet extends HttpServlet {

    private final DeliveryAddressDAO addressDAO =
            new DeliveryAddressDAO();

    private User getLoggedInUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);

        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("user");

        if (!(value instanceof User)) {
            return null;
        }

        return (User) value;
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        User user = getLoggedInUser(req);

        if (user == null) {
            resp.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Vui lòng đăng nhập lại."
            );
            return;
        }

        try {
            List<DeliveryAddress> addresses =
                    addressDAO.findByUserId(user.getId());

            req.setAttribute("addresses", addresses);

            req.getRequestDispatcher(
                    "/address-list-items.jsp"
            ).forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể tải danh sách địa chỉ.", e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User user = getLoggedInUser(req);

        if (user == null) {
            resp.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Vui lòng đăng nhập lại."
            );
            return;
        }

        try {
            String recipientName = req.getParameter("recipientName");
            String phoneNumber = req.getParameter("recipientPhone");

            String provinceCodeText = req.getParameter("provinceCode");
            String provinceName = req.getParameter("provinceName");

            String wardCodeText = req.getParameter("wardCode");
            String wardName = req.getParameter("wardName");

            String detailAddress = req.getParameter("detailAddress");
            String isDefaultText = req.getParameter("isDefault");

            if (isBlank(recipientName)
                    || isBlank(phoneNumber)
                    || isBlank(provinceCodeText)
                    || isBlank(provinceName)
                    || isBlank(wardCodeText)
                    || isBlank(wardName)
                    || isBlank(detailAddress)) {

                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Vui lòng nhập đầy đủ thông tin địa chỉ."
                );
                return;
            }

            int provinceCode = Integer.parseInt(provinceCodeText);
            int wardCode = Integer.parseInt(wardCodeText);

            if (provinceCode <= 0 || wardCode <= 0
                    || recipientName.trim().length() > 100
                    || phoneNumber.trim().length() > 20
                    || provinceName.trim().length() > 100
                    || wardName.trim().length() > 100
                    || detailAddress.trim().length() > 500) {

                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Dữ liệu địa chỉ không hợp lệ."
                );
                return;
            }

            DeliveryAddress address = new DeliveryAddress();

            // Lấy UserId từ session, tuyệt đối không lấy từ form.
            address.setUserId(user.getId());

            address.setRecipientName(recipientName.trim());
            address.setPhoneNumber(phoneNumber.trim());

            address.setProvinceCode(provinceCode);
            address.setCityProvince(provinceName.trim());

            address.setWardCode(wardCode);
            address.setWard(wardName.trim());

            address.setAddressDetail(detailAddress.trim());

            boolean isDefault =
                    "true".equalsIgnoreCase(isDefaultText);

            address.setDefaultAddress(isDefault);

            addressDAO.insert(address);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().write("Lưu địa chỉ thành công.");

        } catch (NumberFormatException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Mã tỉnh/thành hoặc phường/xã không hợp lệ."
            );

        } catch (SQLException e) {
            throw new ServletException(
                    "Không thể lưu địa chỉ vào database.", e
            );
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

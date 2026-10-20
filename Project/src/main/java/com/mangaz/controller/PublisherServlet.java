package com.mangaz.controller;

import com.mangaz.dao.CategoryDAO;
import com.mangaz.dao.PublisherDAO;
import com.mangaz.model.Publisher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublisherServlet", urlPatterns = {"/admin/publishers"})
public class PublisherServlet extends HttpServlet {

    private PublisherDAO publisherDAO = new PublisherDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.getRequestDispatcher("/ThemNhaXuatBan.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Publisher publisher = publisherDAO.getPublisherById(id);
            request.setAttribute("publisher", publisher);
            request.getRequestDispatcher("/SuaNhaXuatBan.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            publisherDAO.deletePublisherLogic(id);
            response.sendRedirect(request.getContextPath() + "/admin/publishers");

        } else {
            // Danh sách có phân trang
            int page = 1;
            int pageSize = 5;

            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            int totalPublishers = publisherDAO.countPublishers();
            int totalCategories = categoryDAO.countCategories();
            int totalPages = (int) Math.ceil((double) totalPublishers / pageSize);

            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            List<Publisher> publishers = publisherDAO.getPublishersByPage(page, pageSize);

            int startItem = totalPublishers == 0 ? 0 : (page - 1) * pageSize + 1;
            int endItem = Math.min(page * pageSize, totalPublishers);

            request.setAttribute("publishers", publishers);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPublishers", totalPublishers);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);

            request.getRequestDispatcher("/QuanLyNhaXuatBan.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            String publisherCode = request.getParameter("publisherCode");
            String publisherName = request.getParameter("publisherName");
            String country = request.getParameter("country");
            String description = request.getParameter("description");
            String website = request.getParameter("website");
            String foundedYearStr = request.getParameter("foundedYear");
            String statusStr = request.getParameter("status");

            Publisher pub = new Publisher();
            pub.setPublisherCode(publisherCode);
            pub.setPublisherName(publisherName);
            pub.setCountry(country);
            pub.setDescription(description);
            pub.setWebsite(website);
            pub.setStatus("1".equals(statusStr));

            if (foundedYearStr != null && !foundedYearStr.trim().isEmpty()) {
                try {
                    pub.setFoundedYear(Integer.parseInt(foundedYearStr.trim()));
                } catch (NumberFormatException e) {
                    pub.setFoundedYear(null);
                }
            }

            boolean isSuccess = publisherDAO.insertPublisher(pub);
            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/admin/publishers");
            } else {
                request.setAttribute("errorMessage", "Thêm thất bại! Mã Nhà xuất bản có thể đã tồn tại.");
                request.getRequestDispatcher("/ThemNhaXuatBan.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            int publisherId = Integer.parseInt(request.getParameter("publisherId"));
            String publisherCode = request.getParameter("publisherCode");
            String publisherName = request.getParameter("publisherName");
            String country = request.getParameter("country");
            String description = request.getParameter("description");
            String website = request.getParameter("website");
            String foundedYearStr = request.getParameter("foundedYear");
            String statusStr = request.getParameter("status");

            Publisher pub = new Publisher();
            pub.setPublisherId(publisherId);
            pub.setPublisherCode(publisherCode);
            pub.setPublisherName(publisherName);
            pub.setCountry(country);
            pub.setDescription(description);
            pub.setWebsite(website);
            pub.setStatus("1".equals(statusStr));

            if (foundedYearStr != null && !foundedYearStr.trim().isEmpty()) {
                try {
                    pub.setFoundedYear(Integer.parseInt(foundedYearStr.trim()));
                } catch (NumberFormatException e) {
                    pub.setFoundedYear(null);
                }
            }

            boolean isSuccess = publisherDAO.updatePublisher(pub);
            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/admin/publishers");
            } else {
                request.setAttribute("publisher", pub);
                request.setAttribute("errorMessage", "Cập nhật thất bại!");
                request.getRequestDispatcher("/SuaNhaXuatBan.jsp").forward(request, response);
            }
        }
    }
}
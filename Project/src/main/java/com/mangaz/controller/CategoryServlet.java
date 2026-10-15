package com.mangaz.controller;

import com.mangaz.dao.CategoryDAO;
import com.mangaz.dao.PublisherDAO;
import com.mangaz.model.Category;
import com.mangaz.model.Publisher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/admin/categories"})
public class CategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();
    private PublisherDAO publisherDAO = new PublisherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Mở form Thêm
            List<Publisher> publishers = publisherDAO.getAllPublishers();
            request.setAttribute("publishers", publishers);
            request.getRequestDispatcher("/ThemDanhMuc.jsp").forward(request, response);

        } else if ("edit".equals(action)) {
            // Mở form Sửa
            int categoryId = Integer.parseInt(request.getParameter("id"));
            Category category = categoryDAO.getCategoryById(categoryId);
            List<Publisher> publishers = publisherDAO.getAllPublishers();

            request.setAttribute("category", category);
            request.setAttribute("publishers", publishers);
            request.getRequestDispatcher("/SuaDanhMuc.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            // Xóa logic (Chuyển Status = 0)
            int categoryId = Integer.parseInt(request.getParameter("id"));
            categoryDAO.deleteCategoryLogic(categoryId);
            response.sendRedirect(request.getContextPath() + "/admin/categories");

        } else {
            // Mặc định: Hiển thị danh sách
            List<Category> categories = categoryDAO.getAllCategories();
            int totalCategories = categoryDAO.countCategories();
            int totalPublishers = publisherDAO.countPublishers();

            request.setAttribute("categories", categories);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalPublishers", totalPublishers);

            request.getRequestDispatcher("/QuanLyDanhMuc.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            // Thêm mới
            String categoryCode = request.getParameter("categoryCode");
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String statusStr = request.getParameter("status");
            String[] selectedPublisherIds = request.getParameterValues("publisherIds");

            Category newCategory = new Category();
            newCategory.setCategoryCode(categoryCode);
            newCategory.setCategoryName(categoryName);
            newCategory.setDescription(description);
            newCategory.setStatus("1".equals(statusStr));

            boolean isSuccess = categoryDAO.insertCategory(newCategory, selectedPublisherIds);

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            } else {
                request.setAttribute("publishers", publisherDAO.getAllPublishers());
                request.setAttribute("errorMessage", "Thêm thất bại! Mã thể loại có thể đã tồn tại.");
                request.getRequestDispatcher("/ThemDanhMuc.jsp").forward(request, response);
            }

        } else if ("update".equals(action)) {
            // Cập nhật
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String categoryCode = request.getParameter("categoryCode");
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String statusStr = request.getParameter("status");
            String[] selectedPublisherIds = request.getParameterValues("publisherIds");

            Category category = new Category();
            category.setCategoryId(categoryId);
            category.setCategoryCode(categoryCode);
            category.setCategoryName(categoryName);
            category.setDescription(description);
            category.setStatus("1".equals(statusStr));

            boolean isSuccess = categoryDAO.updateCategory(category, selectedPublisherIds);

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/admin/categories");
            } else {
                request.setAttribute("category", categoryDAO.getCategoryById(categoryId));
                request.setAttribute("publishers", publisherDAO.getAllPublishers());
                request.setAttribute("errorMessage", "Cập nhật thất bại!");
                request.getRequestDispatcher("/SuaDanhMuc.jsp").forward(request, response);
            }
        }
    }
}
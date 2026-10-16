package com.mangaz.model;

import java.sql.Timestamp;
import java.util.List;

public class Category {
    private int categoryId;
    private String categoryCode;
    private String categoryName;
    private String description;
    private Integer parentCategoryId;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<Publisher> publishers;

    /*Constructor*/

    public Category() {
    }

    public Category(int categoryId, String categoryCode, String categoryName, String description, Integer parentCategoryId, boolean status, Timestamp createdAt, Timestamp updatedAt, List<Publisher> publishers) {
        this.categoryId = categoryId;
        this.categoryCode = categoryCode;
        this.categoryName = categoryName;
        this.description = description;
        this.parentCategoryId = parentCategoryId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.publishers = publishers;
    }

    /*Getter va Setter*/

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryCode() {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode) {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getParentCategoryId() {
        return parentCategoryId;
    }

    public void setParentCategoryId(Integer parentCategoryId) {
        this.parentCategoryId = parentCategoryId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<Publisher> getPublishers() {
        return publishers;
    }

    public void setPublishers(List<Publisher> publishers) {
        this.publishers = publishers;
    }
}
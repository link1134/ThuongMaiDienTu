package com.mangaz.model;

import java.sql.Timestamp;

public class Publisher {
    private int publisherId;
    private String publisherCode;
    private String publisherName;
    private String country;
    private String description;
    private String website;
    private String logoUrl;
    private Integer foundedYear; // Dùng Integer để có thể nhận giá trị NULL từ DB
    private boolean status;      // true: Hiển thị, false: Ẩn
    private Timestamp createdAt;
    private Timestamp updatedAt;

    /*Constructor*/
    public Publisher() {
    }

    public Publisher(int publisherId, String publisherCode, String publisherName, String country,
                     String description, String website, String logoUrl, Integer foundedYear,
                     boolean status, Timestamp createdAt, Timestamp updatedAt) {
        this.publisherId = publisherId;
        this.publisherCode = publisherCode;
        this.publisherName = publisherName;
        this.country = country;
        this.description = description;
        this.website = website;
        this.logoUrl = logoUrl;
        this.foundedYear = foundedYear;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Publisher(int publisherId, String publisherCode, String publisherName) {
        this.publisherId = publisherId;
        this.publisherCode = publisherCode;
        this.publisherName = publisherName;
    }

    /*Getter va Setter*/
    public int getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(int publisherId) {
        this.publisherId = publisherId;
    }

    public String getPublisherCode() {
        return publisherCode;
    }

    public void setPublisherCode(String publisherCode) {
        this.publisherCode = publisherCode;
    }

    public String getPublisherName() {
        return publisherName;
    }

    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public Integer getFoundedYear() {
        return foundedYear;
    }

    public void setFoundedYear(Integer foundedYear) {
        this.foundedYear = foundedYear;
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
}
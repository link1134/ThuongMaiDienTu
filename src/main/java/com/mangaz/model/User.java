package com.mangaz.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private int id;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private boolean emailVerified;
    private boolean enabled;
    private Timestamp createdAt;

    public User() {}

    public User(int id, String username, String email, String password, String fullName,
                boolean emailVerified, boolean enabled, Timestamp createdAt) {
        this.id = id; this.username = username; this.email = email; this.password = password;
        this.fullName = fullName; this.emailVerified = emailVerified; this.enabled = enabled; this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public boolean isEmailVerified() { return emailVerified; }
    public void setEmailVerified(boolean emailVerified) { this.emailVerified = emailVerified; }
    public boolean isEnabled() { return enabled; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

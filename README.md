# MangaZ / ThuongMaiDienTu - Authentication

Backend authentication implemented with **Java Servlet + JSP + MVC + JDBC + Microsoft SQL Server + Tomcat + Maven**.

## Features
- Register
- BCrypt password hashing
- Email verification token
- Login with username OR email
- Session login/logout
- AuthFilter for protected Main page
- Forgot/reset password
- Google OAuth 2.0 skeleton

## 1. Requirements
- JDK 17
- IntelliJ IDEA
- Maven
- Apache Tomcat 10.1
- Microsoft SQL Server
- SQL Server Management Studio 22

## 2. Database
Open SSMS 22 -> New Query -> open `database.sql` -> Execute.

This creates database `MangaZ` and tables `Users`, `EmailVerificationTokens`, `PasswordResetTokens`.

## 3. Database configuration
Copy/edit `src/main/resources/db.properties.example` to `src/main/resources/db.properties` and set your SQL Server credentials.

Default URL expects SQL Server TCP port 1433. If your instance uses another port, change it.

## 4. Email
Copy `mail.properties.example` to `mail.properties` and configure Gmail SMTP App Password. Until configured, the application prints verification/reset links to the IntelliJ console for local testing.

## 5. Google Login
Copy `google.properties.example` to `google.properties`. Create an OAuth 2.0 Web application in Google Cloud and use:
`http://localhost:8080/ThuongMaiDienTu/google-callback`
as an authorized redirect URI.

## 6. IntelliJ / Tomcat
1. Open this folder as a Maven project.
2. Reload Maven.
3. Add Tomcat 10.1 as an Application Server.
4. Create a Tomcat Local run configuration.
5. Deploy artifact `ThuongMaiDienTu:war exploded`.
6. Run.
7. Open `http://localhost:8080/ThuongMaiDienTu/Login.jsp`.

## 7. Authentication flow
`JSP -> Servlet -> Service -> DAO -> JDBC -> SQL Server`

## Important
Do not commit real database passwords, Gmail App Passwords or Google Client Secrets.

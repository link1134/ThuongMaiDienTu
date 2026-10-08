# Chạy project trong IntelliJ IDEA + SQL Server + SSMS 22

## 1. SQL Server / SSMS 22
1. Mở SQL Server Management Studio 22.
2. Kết nối đúng SQL Server instance của bạn.
3. Mở `database.sql`.
4. Execute.
5. Kiểm tra:
   ```sql
   USE MangaZ;
   SELECT * FROM Users;
   ```

## 2. Cấu hình Java
- JDK: 17
- Maven: IntelliJ có thể dùng Maven tích hợp.

## 3. Cấu hình database
Mở:
`src/main/resources/db.properties`

Sửa:
```properties
db.url=jdbc:sqlserver://localhost:1433;databaseName=MangaZ;encrypt=true;trustServerCertificate=true
db.username=sa
db.password=YOUR_SQL_SERVER_PASSWORD
```

Nếu SQL Server của bạn dùng instance/port khác, sửa `db.url` theo cấu hình thực tế.

## 4. Cấu hình Tomcat
1. File -> Settings -> Build, Execution, Deployment -> Application Servers.
2. Add Apache Tomcat 10.1.
3. Run -> Edit Configurations.
4. Add `Tomcat Server -> Local`.
5. Tab Deployment -> Add -> Artifact -> `ThuongMaiDienTu:war exploded`.
6. Application context: `/ThuongMaiDienTu`.
7. Run.

Mở:
`http://localhost:8080/ThuongMaiDienTu/Login.jsp`

## 5. Test nhanh không cần email thật
Khi `mail.properties` vẫn chứa `YOUR_...`, ứng dụng sẽ in verification/reset URL vào **Run console của IntelliJ**.

Ví dụ:
```text
[DEV EMAIL] To: test@gmail.com | Xác nhận email MangaZ
http://localhost:8080/ThuongMaiDienTu/verify-email?token=...
```

Copy link đó vào trình duyệt để verify.

## 6. Google Login
Sửa `src/main/resources/google.properties`:
```properties
google.clientId=...
google.clientSecret=...
google.redirectUri=http://localhost:8080/ThuongMaiDienTu/google-callback
```
Trong Google Cloud OAuth Client, Authorized redirect URI phải giống chính xác URI trên.

## 7. Lưu ý
Không commit password SQL Server, Gmail App Password hoặc Google Client Secret.

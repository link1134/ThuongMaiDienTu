<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Đặt lại mật khẩu - MangaZ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ForgotPassword.css">
    <style>.auth-message{padding:12px 14px;border-radius:10px;margin-bottom:18px;font-size:13px}.auth-error{background:#fef2f2;color:#b91c1c}.auth-success{background:#ecfdf5;color:#047857}.simple-reset{max-width:520px;margin:80px auto;padding:32px;background:#fff;border-radius:20px;box-shadow:0 12px 36px rgba(0,0,0,.08)}.simple-reset input{width:100%;padding:14px;border:1px solid #e2e8f0;border-radius:10px;margin:8px 0 18px}.simple-reset button{width:100%;padding:14px;border:0;border-radius:10px;background:#4151e6;color:#fff;font-weight:700}</style>
</head>
<body class="site-body">
<div class="simple-reset"><h2 class="card-heading">Đặt lại mật khẩu</h2><% if(request.getAttribute("error")!=null){%><div class="auth-message auth-error"><%=request.getAttribute("error")%></div><%}%><form method="post" action="${pageContext.request.contextPath}/reset-password">
    <input type="hidden" name="token" value="<%= request.getAttribute("token") == null ? "" : request.getAttribute("token") %>">
    <label>MẬT KHẨU MỚI</label>
    <input type="password" name="password" required minlength="8"><label>XÁC NHẬN MẬT KHẨU</label><input type="password" name="confirmPassword" required minlength="8">
    <button type="submit">Đặt lại mật khẩu</button>
</form>
</div>
</body>
</html>
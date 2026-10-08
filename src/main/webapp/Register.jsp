<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký tài khoản - MangaZ Collector Exchange</title> <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Register.css" />
</head>

<body class="site-body"> <!-- BEGIN: MainHeader -->
    <header class="main-header"> <a href="${pageContext.request.contextPath}/Login.jsp" class="brand-link">
            <div class="brand-logo-icon"> <svg class="book-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M19 2H6c-1.2 0-2 .8-2 2v16c0 1.2.8 2 2 2h13c.6 0 1-.4 1-1V3c0-.6-.4-1-1-1zm-1 18H6c-.6 0-1-.4-1-1s.4-1 1-1h12v2zm0-4H6c-.3 0-.6.1-.8.2-.1-.2-.2-.4-.2-.7V4c0-.6.4-1 1-1h12v13z">
                    </path>
                    <path d="M8 6h8v2H8zm0 4h8v2H8z"></path>
                </svg> </div>
            <div class="brand-text-container"> <span class="brand-title">MANGAZ</span> <span
                    class="brand-subtitle">COLLECTOR EXCHANGE</span> </div>
        </a>
        <div class="header-support"> <span>Cần trợ giúp?</span> <a href="#" class="support-link"> <span>Trung tâm hỗ
                    trợ</span> <svg class="support-arrow-icon" fill="none" stroke="currentColor" stroke-width="2.5"
                    viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                        stroke-linecap="round" stroke-linejoin="round"></path>
                </svg> </a> </div>
    </header> <!-- END: MainHeader --> <!-- BEGIN: MainContent -->
    <main class="main-content">
        <div class="content-grid-container"> <!-- BEGIN: LeftHeroColumn -->
            <section class="hero-column">
                <div class="hero-tag-pill"> <span class="pulse-dot"></span> <span>Sàn trao đổi &amp; sưu tầm Manga #1
                        Việt Nam</span> </div>
                <div class="headline-block">
                    <h1 class="main-heading"> KHÁM PHÁ VÙNG ĐẤT<br /> CỦA NHỮNG CUỐN<br /> <span
                            class="manga-accent-wrapper"> MANGA <span class="accent-underline"></span> </span> </h1>
                    <p class="hero-description"> Chào mừng trở lại Otaku! Nơi kết nối niềm đam mê truyện tranh Nhật Bản,
                        giao lưu ấn bản giới hạn và săn deal hiếm mỗi ngày. </p>
                </div>
                <div class="hero-card-wrapper">
                    <div class="decorative-blob"></div>
                    <div class="card-visual-frame">
                        <div class="image-inner-container"> <img
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuD94RBqDopvV-XkV_-3YKTx6U9Ax9SdBLYFfcMeiT6SX2Vgmf52D2KxJXL6Otp6_GSVhyqfZTRbRY9Xb66VyckrU7hpqTqC9-SKbSo7NAnMHpUvA3tHK6izI_nZpiPSKhArEbjgHQ8KCuHvGdRZlJv9SjKJtB-skk_caJ99s11KCzvZN87aZ70NekSkmgjWVylyBHa7aWdaupWBWarEtH2lgkPchrWDXjhLbtq0TlNp2y4lCoY3RDrCn9XJXCXe-Jyg2g"
                                alt="Bộ sưu tập truyện tranh Manga kinh điển" class="manga-hero-image" /> </div>
                        <!-- Floating Badges -->
                        <div class="floating-badge badge-top-left">
                            <div class="badge-icon-box icon-amber"> <svg class="badge-svg" viewBox="0 0 24 24"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"></path>
                                </svg> </div>
                            <div class="badge-text-group"> <span class="badge-eyebrow">BẢO ĐẢM</span> <span
                                    class="badge-title">Trao đổi an toàn</span> </div>
                        </div>
                        <div class="floating-badge badge-top-right">
                            <div class="badge-icon-box icon-books">📚</div>
                            <div class="badge-text-group"> <span class="badge-eyebrow">KHO TRUYỆN</span> <span
                                    class="badge-title">+50,000 đầu sách</span> </div>
                        </div>
                        <div class="floating-badge badge-bottom-left"> <span class="badge-fire-icon">🔥</span> <span
                                class="badge-title">Deal hiếm mỗi ngày</span> </div>
                    </div>
                </div>
            </section> <!-- END: LeftHeroColumn --> <!-- BEGIN: RightAuthColumn -->
            <section class="auth-column">
                <div class="login-card"> <!-- Card Header -->
                    <div class="login-card-header">
                        <% if (request.getAttribute("error") != null) { %><div class="auth-message auth-error"><%= request.getAttribute("error") %></div><% } %>
                        <% if (request.getAttribute("success") != null) { %><div class="auth-message auth-success"><%= request.getAttribute("success") %></div><% } %>
                        <h2 class="card-heading">Đăng ký tài khoản</h2>
                        <p class="signup-prompt"> Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/Login.jsp" class="signup-link">Đăng nhập
                                ngay</a> </p>
                    </div> <!-- Register Form -->
                    <form class="login-form" method="post" action="${pageContext.request.contextPath}/register" > <!-- Full Name Field -->
                        <div class="form-field-group"> <label for="fullname" class="field-label">HỌ VÀ TÊN</label>
                            <div class="input-control">
                                <div class="field-prefix-icon"> <svg class="input-icon" fill="none"
                                        stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                                            stroke-linecap="round" stroke-linejoin="round"></path>
                                    </svg> </div> <input id="fullname" name="fullName" type="text" class="text-input"
                                    placeholder="Nguyễn Văn A" />
                            </div>
                        </div> <!-- Email or Username Field -->
                        <div class="form-field-group"> <label for="username" class="field-label">EMAIL HOẶC TÊN ĐĂNG
                                NHẬP</label>
                            <div class="input-control">
                                <div class="field-prefix-icon field-prefix-symbol">@</div> <input id="email" name="email" type="text" class="text-input" placeholder="otaku@mangaz.vn" />
                            </div>
                        </div> <div class="form-field-group"><label for="username" class="field-label">TÊN ĐĂNG NHẬP</label><div class="input-control"><div class="field-prefix-icon field-prefix-symbol">@</div><input id="username" name="username" type="text" class="text-input" placeholder="otaku123" required /></div></div> <!-- Password Field -->
                        <div class="form-field-group"> <label for="password" class="field-label">MẬT KHẨU</label>
                            <div class="input-control">
                                <div class="field-prefix-icon"> <svg class="input-icon" fill="none"
                                        stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                            stroke-linecap="round" stroke-linejoin="round"></path>
                                    </svg> </div> <input id="password" name="password" type="password"
                                    class="text-input password-input" placeholder="••••••••••••" value="" />
                                <button type="button" class="password-toggle-btn" aria-label="Hiển thị mật khẩu"> <svg
                                        class="input-icon" fill="none" stroke="currentColor" stroke-width="2"
                                        viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" stroke-linecap="round"
                                            stroke-linejoin="round"></path>
                                        <path
                                            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                                            stroke-linecap="round" stroke-linejoin="round"></path>
                                    </svg> </button>
                            </div>
                        </div> <!-- Confirm Password Field -->
                        <div class="form-field-group"> <label for="confirm-password" class="field-label">XÁC NHẬN MẬT
                                KHẨU</label>
                            <div class="input-control">
                                <div class="field-prefix-icon"> <svg class="input-icon" fill="none"
                                        stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                                            stroke-linecap="round" stroke-linejoin="round"></path>
                                    </svg> </div> <input id="confirm-password" name="confirmPassword" type="password"
                                    class="text-input password-input" placeholder="••••••••••••" value="" />
                            </div>
                        </div> <!-- Terms Checkbox -->
                        <div class="remember-device-group terms-checkbox-group"> <input id="terms" name="terms"
                                type="checkbox" class="checkbox-input" /> <label for="terms" class="checkbox-label"> Tôi
                                đồng ý với <a href="#" class="terms-link-inline">Điều khoản dịch vụ</a> và <a href="#"
                                    class="terms-link-inline">Chính sách bảo mật</a> của MangaZ. </label> </div>
                        <!-- Main Submit Button -->
                        <div class="submit-action-wrapper"> <button type="submit" class="primary-submit-btn"> <span>Tạo
                                    tài khoản MangaZ</span> <svg class="submit-arrow" fill="none" stroke="currentColor"
                                    stroke-width="2.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M14 5l7 7m0 0l-7 7m7-7H3" stroke-linecap="round" stroke-linejoin="round">
                                    </path>
                                </svg> </button> </div>
                    </form> <!-- Divider -->
                    <div class="form-divider">
                        <div class="divider-line"></div>
                        <div class="divider-text">HOẶC TIẾP TỤC VỚI</div>
                    </div> <!-- Social Login Section -->
                    <div class="social-login-group"> <!-- Google Button --> <a href="${pageContext.request.contextPath}/google-login" class="social-btn" style="text-decoration:none;">
                            <svg class="social-icon" viewBox="0 0 24 24">
                                <path
                                    d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                                    fill="#4285F4"></path>
                                <path
                                    d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                                    fill="#34A853"></path>
                                <path
                                    d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"
                                    fill="#FBBC05"></path>
                                <path
                                    d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"
                                    fill="#EA4335"></path>
                            </svg> <span>Tiếp tục với Google</span> </a> <!-- Discord Button --> <button
                            type="button" class="social-btn"> <svg class="social-icon discord-icon" viewBox="0 0 24 24">
                                <path
                                    d="M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515.074.074 0 0 0-.079.037c-.21.375-.444.864-.608 1.25a18.27 18.27 0 0 0-5.487 0 12.64 12.64 0 0 0-.617-1.25.077.077 0 0 0-.079-.037A19.736 19.736 0 0 0 3.677 4.37a.07.07 0 0 0-.032.027C.533 9.046-.32 13.58.099 18.057a.082.082 0 0 0 .031.057 19.9 19.9 0 0 0 5.993 3.03.078.078 0 0 0 .084-.028c.462-.63.874-1.295 1.226-1.994.021-.041.001-.09-.041-.106a13.107 13.107 0 0 1-1.872-.892.077.077 0 0 1-.008-.128 10.2 10.2 0 0 0 .372-.292.074.074 0 0 1 .077-.01c3.928 1.793 8.18 1.793 12.061 0a.074.074 0 0 1 .078.01c.12.098.246.198.373.292a.077.077 0 0 1-.006.127 12.299 12.299 0 0 1-1.873.893.077.077 0 0 0-.041.107c.36.698.772 1.362 1.225 1.993a.076.076 0 0 0 .084.028 19.839 19.839 0 0 0 6.002-3.03.077.077 0 0 0 .032-.054c.5-5.177-.838-9.674-3.549-13.66a.061.061 0 0 0-.031-.028zM8.02 15.33c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.956-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.956 2.418-2.157 2.418zm7.975 0c-1.183 0-2.157-1.085-2.157-2.419 0-1.333.955-2.419 2.157-2.419 1.21 0 2.176 1.096 2.157 2.42 0 1.333-.946 2.418-2.157 2.418z">
                                </path>
                            </svg> <span>Tiếp tục với Discord</span> </button> <!-- Apple Button --> <button
                            type="button" class="social-btn"> <svg class="social-icon apple-icon" viewBox="0 0 24 24">
                                <path
                                    d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 6.84c.65-.79 1.09-1.89.97-2.99-1 .04-2.18.66-2.88 1.48-.59.68-1.11 1.79-.97 2.87 1.11.09 2.23-.57 2.88-1.36z">
                                </path>
                            </svg> <span>Tiếp tục với Apple</span> </button> </div> <!-- Bottom Terms Notice -->
                    <p class="terms-notice"> Bằng việc tiếp tục, bạn đồng ý với <a href="#" class="terms-link">Điều
                            khoản sử dụng</a> và <a href="#" class="terms-link">Chính sách bảo mật</a> của MangaZ. </p>
                </div>
            </section> <!-- END: RightAuthColumn -->
        </div>
    </main> <!-- END: MainContent --> <!-- BEGIN: PageFooter -->
    <footer class="page-footer">
        <div class="footer-copyright"> © 2025 <span class="brand-bold">MangaZ</span> Inc. Bản quyền thuộc về cộng đồng
            Otaku Việt Nam. </div>
        <nav class="footer-nav"> <a href="#" class="footer-link">Quy định trao đổi</a> <a href="#"
                class="footer-link">Bảo vệ bản quyền</a> <a href="#" class="footer-link">Hỗ trợ đối tác</a> </nav>
    </footer> <!-- END: PageFooter -->
<script>document.querySelectorAll('.password-toggle-btn').forEach(function(b){b.addEventListener('click',function(){var i=this.parentElement.querySelector('input'); if(i){i.type=i.type==='password'?'text':'password';}});});</script></body>

</html>
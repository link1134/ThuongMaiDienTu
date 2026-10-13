<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - MangaZ Collector Exchange</title> <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ForgotPassword.css" />
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
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuAR4Rx6p4CCDZ8XZEuO0dcvzS-gBo3vYJ1gpVBbUCxAXJGCOj_IQrxfzdepTyNkUFFEB6fnwtvg8IrnZu6RM8N3QedgfiHSalTLyX4IetYyRBWPWvxY-9QR46biqxGPUloD0v5R7Mwa6-kA3ejwry4GvzxFskY4QC9_YnU2LOWi2skTapZeJr0e3pAuKQLE5gRSSlnyxNLB1XD6IlQ39YQ3Iw3DkDxO1ngrKO96GJnF3PdVAQXma0NZ4Oui4cXCsCro1g"
                                alt="Bộ sưu tập truyện tranh Manga cổ" class="manga-hero-image" /> </div>
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
                <div class="login-card"> <!-- Back Link -->
                    <div class="back-action-row"> <a href="${pageContext.request.contextPath}/Login.jsp" class="back-link"> <svg class="back-arrow-icon"
                                fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"
                                xmlns="http://www.w3.org/2000/svg">
                                <path d="M10 19l-7-7m0 0l7-7m-7 7h18" stroke-linecap="round" stroke-linejoin="round">
                                </path>
                            </svg> <span>Quay lại đăng nhập</span> </a> </div> <!-- Card Header -->
                    <div class="login-card-header">
                        <% if (request.getAttribute("error") != null) { %><div class="auth-message auth-error"><%= request.getAttribute("error") %></div><% } %>
                        <% if (request.getAttribute("success") != null) { %><div class="auth-message auth-success"><%= request.getAttribute("success") %></div><% } %>
                        <h2 class="card-heading">Quên mật khẩu?</h2>
                        <p class="signup-prompt"> Đừng lo lắng! Hãy nhập địa chỉ email hoặc tên tài khoản đã đăng ký của
                            bạn. MangaZ sẽ gửi liên kết để đặt lại mật khẩu trong tích tắc. </p>
                    </div> <!-- Reset Password Form -->
                    <form class="login-form" method="post" action="${pageContext.request.contextPath}/forgot-password" > <!-- Email / Username Field -->
                        <div class="form-field-group"> <label for="identifier" class="field-label">EMAIL HOẶC TÊN ĐĂNG
                                NHẬP</label>
                            <div class="input-control">
                                <div class="field-prefix-icon field-prefix-symbol">@</div> <input id="identifier"
                                    name="identifier" type="text" class="text-input" placeholder="otaku@mangaz.vn"
                                    required />
                            </div>
                        </div> <!-- Primary Submit Button -->
                        <div class="submit-action-wrapper"> <button type="submit" class="primary-submit-btn"> <span>Gửi
                                    liên kết đặt lại</span> <svg class="submit-arrow" fill="none" stroke="currentColor"
                                    stroke-width="2.5" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M14 5l7 7m0 0l-7 7m7-7H3" stroke-linecap="round" stroke-linejoin="round">
                                    </path>
                                </svg> </button> </div>
                    </form> <!-- Info Notice Box -->
                    <div class="info-callout-box"> <svg class="info-callout-icon" fill="none" stroke="currentColor"
                            stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"></circle>
                            <path d="M12 16v-4m0-4h.01" stroke-linecap="round"></path>
                        </svg>
                        <p class="info-callout-text"> Kiểm tra cả hòm thư <strong>Spam</strong> hoặc <strong>Thư
                                rác</strong> nếu bạn không nhận được email trong vòng 2 phút. </p>
                    </div> <!-- Divider -->
                    <div class="form-divider">
                        <div class="divider-line"></div>
                        <div class="divider-text">HOẶC</div>
                    </div> <!-- Secondary Recovery Actions -->
                    <div class="recovery-links-group">
                        <p class="recovery-item-text"> Bạn nhớ lại mật khẩu rồi? <a href="#"
                                class="primary-link-action">Đăng nhập ngay</a> </p>
                        <p class="recovery-item-text"> Cần trợ giúp trực tiếp? <a href="#"
                                class="secondary-link-action">Liên hệ hỗ trợ kỹ thuật</a> </p>
                    </div> <!-- Bottom Terms Notice -->
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
</body>

</html> 
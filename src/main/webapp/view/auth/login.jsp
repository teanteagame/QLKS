<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Hotel Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">  
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-card">
            <h1 style="text-align: center; margin-bottom: 30px;">🏨 QLKS LOGIN</h1>
            
            <form method="post" action="login">
                <div class="form-group">
                    <label class="form-label">Tài khoản</label>
                    <input type="text" name="username" class="input-field" placeholder="SĐT hoặc TĐN" required autofocus>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="input-field" placeholder="Mật khẩu" required>
                </div>
                                
                <div style="text-align: center; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">ĐĂNG NHẬP</button>
                </div>
            </form>

            <c:if test="${not empty error}">                
                <div style="text-align: center; margin-top: 25px; color: var(--danger); font-size: 0.9rem; font-weight: 600;">
                    ⚠️ ${error}
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
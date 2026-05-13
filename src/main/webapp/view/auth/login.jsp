<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Hotel Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">  
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="login-wrapper"> <%-- Thêm wrapper này để căn giữa form --%>
        <div class="login-card">
            <h1>🏨 QLKS LOGIN</h1>
            
            <form method="post" action="login">
                <div class="form-group">
                    <label>Tài khoản</label>
                    <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required>
                </div>
                
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
                </div>
                
                <button type="submit" class="btn-login">ĐĂNG NHẬP</button>
            </form>

            <c:if test="${not empty error}">
                <div class="error-box">
                    ${error}
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
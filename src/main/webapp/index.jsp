<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <%-- Chỉ sử dụng 1 file CSS duy nhất --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="welcome-screen">
        <div class="loader"></div>
        <h2>Đang kết nối hệ thống...</h2>
        
        <%-- Truyền trạng thái đăng nhập qua thuộc tính ẩn để JS xử lý --%>
        <input type="hidden" id="isLoggedIn" value="${not empty sessionScope.account}">
    </div>

    <%-- Nhúng file JS xử lý chung --%>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script>
        // Khởi tạo điều hướng từ file common.js
        CommonUtils.handleInitialRedirect('isLoggedIn');
    </script>
</body>
</html>
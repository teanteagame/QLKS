<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .welcome-screen {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background: var(--primary);
            color: white;
        }
        .loader {
            border: 4px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top: 4px solid white;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin-bottom: 20px;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div class="welcome-screen">
        <div class="loader"></div>
        <h2>Đang kết nối hệ thống...</h2>
        
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <script>setTimeout(() => { window.location.href = 'rooms'; }, 500);</script>
            </c:when>
            <c:otherwise>
                <script>setTimeout(() => { window.location.href = 'login'; }, 500);</script>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
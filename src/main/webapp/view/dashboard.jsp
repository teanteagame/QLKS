<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manager Dashboard - Hotel Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <div class="admin-layout">
            <%-- Nhúng Sidebar --%>
            <jsp:include page="common/navbar.jsp"/>

            <%-- Nội dung chính bên phải --%>
            <main class="main-content">
                <h1>Bảng điều khiển quản lý</h1>

                <div class="stats-grid">
                    <div class="stat-card" style="border-left-color: #27ae60;">
                        <p>Tổng doanh thu</p>
                        <h2>${totalRevenue} VNĐ</h2>
                    </div>
                    <div class="stat-card" style="border-left-color: #3498db;">
                        <p>Tổng lượt đặt phòng</p>
                        <h2>${totalBookings}</h2>
                    </div>
                    <div class="stat-card" style="border-left-color: #f1c40f;">
                        <p>Công suất phòng</p>
                        <h2>${occupiedRooms} / ${totalRooms}</h2>
                    </div>
                </div>

                <hr style="border: 0; border-top: 1px solid #ddd; margin: 40px 0;">

                <h3>🚀 Vận hành hằng ngày</h3>
                <div class="action-grid" style="margin-bottom: 40px;">
                    <a href="${pageContext.request.contextPath}/rooms" class="action-card" style="border-bottom: 4px solid var(--success-color);">
                        <span class="icon">🏨</span>
                        <span>Sơ đồ phòng (Live)</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/booking-history" class="action-card">
                        <span class="icon">🕒</span>
                        <span>Lịch sử đặt phòng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/statistics" class="action-card">
                        <span class="icon">📈</span>
                        <span>Thống kê chi tiết</span>
                    </a>
                </div>

                <h3>⚙️ Thiết lập hệ thống</h3>
                <div class="action-grid">
                    <a href="${pageContext.request.contextPath}/room-management" class="action-card">
                        <span class="icon">🛏️</span>
                        <span>Quản lý danh sách phòng</span>
                    </a>
                    <%-- ĐIỀU HƯỚNG BỊ THIẾU --%>
                    <a href="${pageContext.request.contextPath}/room-type-management" class="action-card">
                        <span class="icon">💰</span>
                        <span>Quản lý loại phòng & Giá</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/service-management" class="action-card">
                        <span class="icon">🍔</span>
                        <span>Quản lý danh mục dịch vụ</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/employee-management" class="action-card">
                        <span class="icon">👥</span>
                        <span>Quản lý nhân viên</span>
                    </a>
                </div>
            </main>
        </div>
    </body>
</html>
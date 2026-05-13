<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bảng điều khiển - Hotel Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <div class="admin-layout">
            <%-- Nhúng Sidebar --%>
            <jsp:include page="common/navbar.jsp"/>

            <main class="main-content">
                <h1 style="margin-bottom: 30px;">📊 Bảng điều khiển quản lý</h1>

                <%-- KHỐI THỐNG KÊ NHANH (Sử dụng .grid-container và các biến border) --%>
                <div class="grid-container">
                    <div class="card border-success">
                        <p style="color: var(--gray); font-weight: 600;">Tổng doanh thu</p>
                        <h2 style="margin: 10px 0 0 0; color: var(--success);">${totalRevenue} VNĐ</h2>
                    </div>
                    <div class="card border-accent">
                        <p style="color: var(--gray); font-weight: 600;">Tổng lượt đặt phòng</p>
                        <h2 style="margin: 10px 0 0 0; color: var(--accent);">${totalBookings}</h2>
                    </div>
                    <div class="card border-warning">
                        <p style="color: var(--gray); font-weight: 600;">Công suất phòng</p>
                        <h2 style="margin: 10px 0 0 0; color: var(--warning);">${occupiedRooms} / ${totalRooms}</h2>
                    </div>
                </div>

                <div style="border-top: 1px solid var(--border-color); margin: 40px 0;"></div>
 
                <h3 style="margin-bottom: 20px;">🚀 Vận hành hằng ngày</h3>
                <div class="grid-container">
                    <a href="${pageContext.request.contextPath}/rooms" class="card text-center border-success">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">🏨</span>
                        <span style="font-weight: 600;">Sơ đồ phòng (Live)</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/booking-history" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">🕒</span>
                        <span style="font-weight: 600;">Lịch sử đặt phòng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/statistics" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">📈</span>
                        <span style="font-weight: 600;">Thống kê chi tiết</span>
                    </a>
                </div>
               
                <h3 style="margin: 40px 0 20px 0;">⚙️ Thiết lập hệ thống</h3>
                <div class="grid-container">
                    <a href="${pageContext.request.contextPath}/room-management" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">🛏️</span>
                        <span style="font-weight: 600;">Quản lý danh sách phòng</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/room-type-management" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">💰</span>
                        <span style="font-weight: 600;">Quản lý loại phòng & Giá</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/service-management" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">🍔</span>
                        <span style="font-weight: 600;">Quản lý danh mục dịch vụ</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/employee-management" class="card text-center">
                        <span style="font-size: 2.5rem; margin-bottom: 10px;">👥</span>
                        <span style="font-weight: 600;">Quản lý nhân viên</span>
                    </a>
                </div>
            </main>
        </div>
    </body>
</html>
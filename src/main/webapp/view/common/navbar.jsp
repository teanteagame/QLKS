<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="sidebar">
    <div class="sidebar-header">
        <span class="hotel-icon">🏨</span>
        <span class="hotel-name">HOTEL ADMIN</span>
    </div>

    <div class="user-info">
        <p class="welcome-text">Chào, <strong>${sessionScope.account.username}</strong></p>
        <span class="role-badge">${sessionScope.role}</span>
    </div>

    <div class="menu-items">
        <a href="${pageContext.request.contextPath}/rooms" 
           class="menu-link ${pageContext.request.requestURI.contains('rooms') ? 'active' : ''}">
            <span class="icon">🛏️</span> Sơ đồ phòng
        </a>

        <c:if test="${sessionScope.role == 'MANAGER'}">
            <a href="${pageContext.request.contextPath}/dashboard" 
               class="menu-link ${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                <span class="icon">📊</span> Bảng điều khiển
            </a>
            
            <a href="${pageContext.request.contextPath}/booking-history" 
               class="menu-link ${pageContext.request.requestURI.contains('booking-history') ? 'active' : ''}">
                <span class="icon">🕒</span> Lịch sử giao dịch
            </a>
            
            <a href="${pageContext.request.contextPath}/room-management" 
               class="menu-link ${pageContext.request.requestURI.contains('room-management') ? 'active' : ''}">
                <span class="icon">⚙️</span> Quản lý phòng
            </a>
        </c:if>
    </div>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">
            <span class="icon">🚪</span> Đăng xuất
        </a>
    </div>
</nav>
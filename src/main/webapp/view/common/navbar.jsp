<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="sidebar">
    <div class="sidebar-header">
        <span class="hotel-icon">🏨</span>
        <span class="hotel-name">HOTEL ADMIN</span>
    </div>

    <div class="user-info">
        <p class="welcome-text" style="margin-bottom: 8px;">Chào, <strong>${sessionScope.employeeWorking}</strong></p>     
        <span class="badge" style="background: rgba(255,255,255,0.2); color: white; text-transform: uppercase;">
            ${sessionScope.role}
        </span>
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

            <%-- Bổ sung Quản lý dịch vụ vào sidebar để đồng bộ với Dashboard [cite: 72] --%>
            <a href="${pageContext.request.contextPath}/service-management" 
               class="menu-link ${pageContext.request.requestURI.contains('service-management') ? 'active' : ''}">
                <span class="icon">🍔</span> Quản lý dịch vụ
            </a>
        </c:if>
    </div>

    <div class="sidebar-footer">    
        <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">
            <span class="icon">🚪</span> Đăng xuất
        </a>
    </div>
</nav>
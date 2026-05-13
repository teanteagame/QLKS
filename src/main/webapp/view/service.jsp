<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gọi dịch vụ - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <div>
                    <h1>🛒 Gọi dịch vụ</h1>
                    <p style="color: #666; margin-top: 5px;">
                        Đang thực hiện cho: <strong>Đơn đặt phòng #${bookingId}</strong>
                    </p>
                </div>
                <a href="rooms" class="btn" style="background: #eee; color: #333;">← Quay lại sơ đồ</a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error" style="margin-bottom: 25px;">
                    ⚠️ ${error}
                </div>
            </c:if>

            <%-- HIỂN THỊ DẠNG MENU THẺ --%>
            <div class="service-grid">
                <c:forEach items="${services}" var="s">
                    <div class="service-item-card">
                        <form method="post" action="service" class="service-order-form">
                            <input type="hidden" name="bookingId" value="${bookingId}">
                            <input type="hidden" name="serviceId" value="${s.serviceId}">
                            <input type="hidden" name="price" value="${s.price}">
                            
                            <div class="service-icon-circle">
                                <%-- Icon giả lập theo tên hoặc loại nếu có, ở đây dùng chung --%>
                                🍽️
                            </div>

                            <span class="service-title">${s.serviceName}</span>
                            <div class="service-meta">ĐVT: ${s.unit}</div>
                            
                            <div class="service-price-tag">${s.price} VNĐ</div>

                            <div class="qty-control">
                                <label style="font-size: 0.8rem;">SL:</label>
                                <input type="number" name="quantity" value="1" min="1">
                            </div>

                            <button type="submit" class="btn btn-info btn-block">
                                ➕ THÊM VÀO ĐƠN
                            </button>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty services}">
                <div class="alert-error" style="background: #fdfdfd; color: #999;">
                    Hiện chưa có dịch vụ nào đang kinh doanh.
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>
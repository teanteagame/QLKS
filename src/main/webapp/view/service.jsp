<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gọi dịch vụ - Hotel Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <%-- Tiêu đề và Thông tin đơn --%>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <div>
                    <h1>🛒 Thực đơn Dịch vụ</h1>
                    <p style="color: var(--gray); margin-top: 5px;">
                        Phục vụ đơn đặt phòng: <strong>#${bookingId}</strong>
                    </p>
                </div>
                <a href="rooms" class="btn btn-outline">← Quay lại</a>
            </div>

            <%-- THANH LỌC DANH MỤC (Sử dụng inline flex để tiết kiệm class) --%>
            <div style="display: flex; gap: 10px; margin-bottom: 30px; overflow-x: auto; padding-bottom: 10px;">
                <a href="service?bookingId=${bookingId}&catId=0" 
                   class="btn ${selectedCat == 0 ? 'btn-primary' : 'btn-outline'}" style="border-radius: 30px;">
                   Tất cả
                </a>
                <c:forEach items="${categories}" var="cat">
                    <a href="service?bookingId=${bookingId}&catId=${cat.key}" 
                       class="btn ${selectedCat == cat.key ? 'btn-primary' : 'btn-outline'}" style="border-radius: 30px;">
                       ${cat.value}
                    </a>
                </c:forEach>
            </div>

            <%-- LƯỚI DỊCH VỤ (Sử dụng .grid-container và .card thống nhất) --%>
            <div class="grid-container">
                <c:forEach items="${services}" var="s">
                    <div class="card">
                        <form action="service" method="post" class="service-order-form">
                            <input type="hidden" name="bookingId" value="${bookingId}">
                            <input type="hidden" name="serviceId" value="${s.serviceId}">
                            <input type="hidden" name="price" value="${s.price}">
                            
                            <%-- Ảnh dịch vụ (Sử dụng .card-img-top) --%>
                            <div class="card-img-top" 
                                 style="background-image: url('${pageContext.request.contextPath}/assets/images/services/${not empty s.imageUrl ? s.imageUrl : 'default-service.jpg'}');">
                                <div style="position: absolute; bottom: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 6px; font-weight: bold;">
                                    <fmt:formatNumber value="${s.price}" type="number"/> đ
                                </div>
                            </div>

                            <div style="flex-grow: 1;">
                                <h3 style="margin-bottom: 5px;">${s.serviceName}</h3>
                                <p style="font-size: 0.85rem; color: var(--gray);">ĐVT: ${s.unit}</p>
                            </div>

                            <div style="margin-top: 15px; display: flex; align-items: center; justify-content: space-between; gap: 10px;">
                                <div style="display: flex; align-items: center; gap: 5px;">
                                    <label style="font-size: 0.8rem; font-weight: 600;">SL:</label>
                                    <input type="number" name="quantity" value="1" min="1" class="input-field" style="width: 60px; padding: 5px; text-align: center;">
                                </div>
                                <button type="submit" class="btn btn-primary btn-add-service" style="flex-grow: 1;">
                                    ➕ THÊM
                                </button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty services}">
                <div style="text-align: center; padding: 60px; color: var(--gray); border: 2px dashed var(--border-color); border-radius: 12px;">
                    <p style="font-size: 3rem; margin-bottom: 10px;">🍽️</p>
                    <p>Hiện không tìm thấy dịch vụ nào trong mục này.</p>
                </div>
            </c:if>
        </main>
    </div>

    <%-- NHÚNG LOGIC XỬ LÝ AJAX TỪ FILE RIÊNG --%>
    <script src="${pageContext.request.contextPath}/assets/js/order-handler.js"></script>
    <script>
        // Khởi tạo tính năng gọi món AJAX
        OrderHandler.initAjax('service-order-form');
    </script>
</body>
</html>
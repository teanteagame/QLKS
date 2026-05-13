<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sơ đồ phòng - Hotel Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <div class="admin-layout">
            <jsp:include page="common/navbar.jsp"/>

            <main class="main-content">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h1>Sơ đồ quản lý phòng</h1>

                    <%-- Thanh lọc tối giản --%>
                    <form action="rooms" method="get" class="filter-bar">
                        <select name="typeId" class="form-control" style="width: auto;">
                            <option value="0">Tất cả loại phòng</option>
                            <c:forEach items="${typeList}" var="t">
                                <option value="${t.roomTypeId}" ${selectedType == t.roomTypeId ? 'selected' : ''}>
                                    ${t.typeName}
                                </option>
                            </c:forEach>
                        </select>

                        <select name="status" class="form-control" style="width: auto;">
                            <option value="ALL">Tất cả trạng thái</option>
                            <option value="AVAILABLE" ${selectedStatus == 'AVAILABLE' ? 'selected' : ''}>Sẵn sàng</option>
                            <option value="OCCUPIED" ${selectedStatus == 'OCCUPIED' ? 'selected' : ''}>Đang có khách</option>
                            <option value="MAINTENANCE" ${selectedStatus == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                        </select>

                        <button type="submit" class="btn-login" style="width: auto; padding: 8px 20px;">Lọc</button>
                    </form>
                </div>

                <%-- HIỂN THỊ DẠNG LƯỚI (GRID) --%>
                <div class="room-grid">
                    <c:forEach items="${roomList}" var="room">
                        <div class="room-card ${room.status}">
                            <div class="room-header">
                                <span class="room-number">P.${room.roomNumber}</span>
                                <span class="badge ${room.status}">${room.status}</span>
                            </div>

                            <div class="room-info">
                                <strong>${room.roomType.typeName}</strong><br>
                                <small>${room.roomType.hourlyPrice}đ / giờ</small>
                            </div>

                            <div class="room-actions" style="margin-top: auto; display: flex; flex-direction: column; gap: 10px;">
                                <c:choose>
                                    <%-- Phòng Sẵn sàng: Nút xanh lá to rõ --%>
                                    <c:when test="${room.status == 'AVAILABLE'}">
                                        <a href="booking?roomId=${room.roomId}" class="btn btn-success">
                                            <span>➕</span> ĐẶT PHÒNG
                                        </a>
                                    </c:when>

                                    <c:when test="${room.status == 'OCCUPIED'}">
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; width: 100%;">
                                            <a href="service?bookingId=${room.bookingId}" class="btn btn-info" title="Gọi dịch vụ">
                                                <span>🍔</span> DV
                                            </a>
                                            <a href="invoice?bookingId=${room.bookingId}" class="btn btn-warning" title="Trả phòng">
                                                <span>💳</span> TRẢ
                                            </a>
                                        </div>
                                    </c:when>

                                    <%-- Phòng Bảo trì: Nút xám --%>
                                    <c:otherwise>
                                        <div class="btn btn-disabled">
                                            <span>🛠️</span> ĐANG BẢO TRÌ
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <p style="margin-top: 30px; color: #7f8c8d; font-size: 0.9rem;">
                    <em>* Sơ đồ hiển thị tổng cộng ${roomList.size()} phòng dựa trên bộ lọc.</em>
                </p>
            </main>
        </div>
    </body>
</html>
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
                <%-- Header và Thanh lọc --%>
                <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px;">
                    <div>
                        <h1>🏨 Sơ đồ quản lý phòng</h1>
                        <p style="color: var(--gray); margin-top: 5px;">Theo dõi trạng thái vận hành trực tiếp</p>
                    </div>

                    <form action="rooms" method="get" style="display: flex; gap: 15px; align-items: flex-end;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Loại phòng</label>
                            <select name="typeId" class="input-field" style="width: 180px;">
                                <option value="0">Tất cả loại phòng</option>
                                <c:forEach items="${typeList}" var="t">
                                    <option value="${t.roomTypeId}" ${selectedType == t.roomTypeId ? 'selected' : ''}>
                                        ${t.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="input-field" style="width: 180px;">
                                <option value="ALL">Tất cả trạng thái</option>
                                <option value="AVAILABLE" ${selectedStatus == 'AVAILABLE' ? 'selected' : ''}>Trống (Available)</option>
                                <option value="OCCUPIED" ${selectedStatus == 'OCCUPIED' ? 'selected' : ''}>Có khách (Occupied)</option>
                                <option value="MAINTENANCE" ${selectedStatus == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì (Maintenance)</option>
                                <option value="HIDDEN" ${selectedStatus == 'HIDDEN' ? 'selected' : ''}>Đang ẩn (Hidden)</option>
                            </select>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="height: 45px;">🔍 LỌC</button>
                    </form>
                </div>

                <%-- LƯỚI HIỂN THỊ PHÒNG (Sử dụng .grid-container đã thống nhất) --%>
                <div class="grid-container">
                    <c:forEach items="${roomList}" var="room">
                        <%-- Thẻ card kết hợp biến màu border theo trạng thái --%>
                        <div class="card ${room.status == 'AVAILABLE' ? 'border-success' : 
                                          room.status == 'OCCUPIED' ? 'border-warning' : 'border-danger'}">
                            
                            <%-- Ảnh minh họa (Sử dụng .card-img-top) --%>
                            <div class="card-img-top" 
                                 style="background-image: url('${pageContext.request.contextPath}/assets/images/rooms/${not empty room.imageUrl ? room.imageUrl : 'default-room.jpg'}');">
                                <div style="position: absolute; top: 10px; right: 10px;">
                                    <span class="badge ${room.status}">${room.status}</span>
                                </div>
                            </div>

                            <div style="flex-grow: 1;">
                                <h3 style="margin-bottom: 5px;">Phòng ${room.roomNumber}</h3>
                                <span style="font-size: 0.85rem; color: var(--gray); background: #eee; padding: 2px 8px; border-radius: 4px;">
                                    ${room.roomType.typeName}
                                </span>
                            </div>

                            <div style="margin-top: 20px;">
                                <c:choose>
                                    <c:when test="${room.status == 'AVAILABLE'}">
                                        <a href="booking?roomId=${room.roomId}" class="btn btn-success btn-block">
                                            📝 ĐẶT PHÒNG
                                        </a>
                                    </c:when>

                                    <c:when test="${room.status == 'OCCUPIED'}">
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
                                            <a href="service?bookingId=${room.bookingId}" class="btn btn-primary" title="Dịch vụ">
                                                🍔 DV
                                            </a>
                                            <a href="invoice?bookingId=${room.bookingId}" class="btn btn-warning" title="Thanh toán">
                                                💳 TRẢ
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="btn btn-outline btn-block" style="cursor: not-allowed; opacity: 0.7;">
                                            🛠️ TẠM NGƯNG
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Thông báo khi không có dữ liệu --%>
                <c:if test="${empty roomList}">
                    <div style="text-align: center; padding: 80px; border: 2px dashed var(--border-color); border-radius: 12px; color: var(--gray);">
                        <p style="font-size: 1.2rem;">Không tìm thấy phòng nào phù hợp với bộ lọc hiện tại.</p>
                    </div>
                </c:if>

                <div style="margin-top: 30px; border-top: 1px solid var(--border-color); padding-top: 15px; color: var(--gray); font-size: 0.9rem;">
                    <p>* Hệ thống đang hiển thị tổng cộng ${roomList.size()} phòng đang hoạt động.</p>
                </div>
            </main>
        </div>
    </body>
</html>
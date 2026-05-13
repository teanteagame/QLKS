<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý phòng - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <%-- Header trang --%>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1>⚙️ Quản lý danh sách phòng 
                    <c:if test="${isDeletedView}"><span style="color: var(--danger);">(Đã xóa)</span></c:if>
                </h1>
                <div style="display: flex; gap: 10px;">
                    <c:choose>
                        <c:when test="${isDeletedView}">
                            <a href="room-management" class="btn btn-primary">🔙 Quay lại danh sách</a>
                        </c:when>
                        <c:otherwise>
                            <a href="room-management?action=showDeleted" class="btn btn-outline" style="color: var(--danger);">
                                🗑️ Xem phòng đã xóa
                            </a>
                            <a href="dashboard" class="btn btn-outline">← Dashboard</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- FORM THÊM/SỬA PHÒNG (Ẩn khi đang xem danh sách đã xóa) --%>
            <c:if test="${!isDeletedView}">
                <div class="card border-accent" style="margin-bottom: 30px;">
                    <h3 style="margin-bottom: 20px;">${editRoom == null ? '➕ Thêm phòng mới' : '📝 Cập nhật thông tin phòng'}</h3>
                    <form action="room-management" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                        <input type="hidden" name="roomId" value="${editRoom.roomId}">

                        <div class="form-group">
                            <label class="form-label">Số phòng</label>
                            <input type="text" name="roomNumber" class="input-field" 
                                   value="${editRoom.roomNumber}" placeholder="Ví dụ: 101" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Loại phòng</label>
                            <select name="roomTypeId" class="input-field">
                                <c:forEach items="${typeList}" var="t">
                                    <option value="${t.roomTypeId}" ${editRoom.roomType.roomTypeId == t.roomTypeId ? 'selected' : ''}>
                                        ${t.typeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tên file ảnh (trong /rooms/)</label>
                            <input type="text" name="imageUrl" class="input-field" 
                                   value="${editRoom.imageUrl}" placeholder="vd: room101.jpg">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Trạng thái thiết lập</label>
                            <c:choose>
                                <c:when test="${editRoom.status == 'OCCUPIED'}">
                                    <input type="hidden" name="status" value="OCCUPIED">
                                    <input type="text" class="input-field" value="Đang có khách" disabled style="background: #f0f0f0;">
                                </c:when>
                                <c:otherwise>
                                    <select name="status" class="input-field">
                                        <option value="AVAILABLE" ${editRoom.status == 'AVAILABLE' ? 'selected' : ''}>Sẵn sàng</option>
                                        <option value="MAINTENANCE" ${editRoom.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                                        <option value="HIDDEN" ${editRoom.status == 'HIDDEN' ? 'selected' : ''}>Ẩn</option>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div style="grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                            <c:if test="${editRoom != null}">
                                <a href="room-management" class="btn btn-outline">HỦY</a>
                            </c:if>
                            <button type="submit" class="btn btn-success">LƯU THÔNG TIN</button>
                        </div>
                    </form>
                </div>
            </c:if>

            <%-- BẢNG DANH SÁCH --%>
            <div class="table-responsive">
                <table class="custom-table" id="roomTable">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Ảnh</th>
                            <th>Số phòng</th>
                            <th>Loại phòng</th>
                            <th>Trạng thái</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${roomList}" var="r">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.imageUrl ? r.imageUrl : 'default-room.jpg'}" 
                                         style="width: 60px; height: 40px; border-radius: 6px; object-fit: cover; border: 1px solid var(--border-color);">
                                </td>
                                <td><strong>${r.roomNumber}</strong></td>
                                <td>${r.roomType.typeName}</td>
                                <td><span class="badge ${r.status}">${r.status}</span></td>
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${isDeletedView}">
                                            <a href="room-management?action=restore&id=${r.roomId}" 
                                               class="btn btn-success" style="padding: 5px 12px; font-size: 0.8rem;">♻️ Khôi phục</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="room-management?action=edit&id=${r.roomId}" class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem;">Sửa</a>
                                            <c:choose>
                                                <c:when test="${r.status == 'AVAILABLE' || r.status == 'MAINTENANCE'}">
                                                    <a href="room-management?action=delete&id=${r.roomId}" 
                                                       class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem; color: var(--danger);"
                                                       onclick="return confirm('Xác nhận xóa phòng ${r.roomNumber}?')">Xóa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray); font-size: 0.8rem; margin-left: 10px;">🔒 Khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <%-- Nhúng logic xử lý bảng từ file riêng --%>
    <script src="${pageContext.request.contextPath}/assets/js/table-manager.js"></script>
</body>
</html>
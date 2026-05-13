<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thiết lập phòng - Hotel Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <div class="admin-layout">
            <jsp:include page="common/navbar.jsp"/>

            <main class="main-content">
                <div class="page-header">
                    <h1>⚙️ Quản lý danh sách phòng</h1>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn" style="background: #eee; color: #333;">
                        ← Dashboard
                    </a>
                </div>

                <%-- PHẦN 1: FORM THÊM / CẬP NHẬT --%>
                <div class="mgmt-card" style="border-left: 5px solid var(--accent);">
                    <h3>${editRoom == null ? '➕ Thêm phòng mới' : '📝 Cập nhật thông tin phòng'}</h3>
                    <form action="${pageContext.request.contextPath}/room-management" method="post" class="grid-form">
                        <input type="hidden" name="roomId" value="${editRoom.roomId}">

                        <div class="form-group">
                            <label class="form-label">Số phòng</label>
                            <input type="text" name="roomNumber" class="input-field" 
                                   value="${editRoom.roomNumber}" placeholder="Ví dụ: 101, 202..." required>
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

                        <div class="form-group full-width" style="display: flex; gap: 15px; align-items: flex-end;">
                            <div style="flex: 1;">
                                <label class="form-label">Trạng thái thiết lập</label>
                                <c:choose>
                                    <%-- TRƯỜNG HỢP PHÒNG ĐANG CÓ KHÁCH: KHÓA THAY ĐỔI --%>
                                    <c:when test="${editRoom.status == 'OCCUPIED'}">
                                        <input type="hidden" name="status" value="OCCUPIED">
                                        <select class="input-field" disabled style="background-color: #eee; cursor: not-allowed;">
                                            <option value="OCCUPIED">OCCUPIED (Đang có khách - Khóa hệ thống)</option>
                                        </select>
                                        <small style="color: var(--danger-color); font-style: italic;">
                                            * Cần thực hiện Thanh toán để trả phòng này.
                                        </small>
                                    </c:when>

                                    <%-- CÁC TRƯỜNG HỢP KHÁC: CHO PHÉP THAY ĐỔI --%>
                                    <c:otherwise>
                                        <select name="status" class="input-field">
                                            <option value="AVAILABLE" ${editRoom.status == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE (Sẵn sàng)</option>
                                            <option value="MAINTENANCE" ${editRoom.status == 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE (Bảo trì)</option>
                                            <option value="HIDDEN" ${editRoom.status == 'HIDDEN' ? 'selected' : ''}>HIDDEN (Ẩn)</option>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <button type="submit" class="btn btn-success">
                                    ${editRoom == null ? 'LƯU PHÒNG' : 'CẬP NHẬT'}
                                </button>
                                <c:if test="${editRoom != null}">
                                    <a href="${pageContext.request.contextPath}/room-management" class="btn" style="background: #eee; color: #333;">Hủy</a>
                                </c:if>
                            </div>
                        </div>
                    </form>
                </div>

                <%-- PHẦN 2: BẢNG DANH SÁCH --%>
                <div class="mgmt-card">
                    <h3>📋 Danh sách phòng hiện có</h3>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Số phòng</th>
                                <th>Loại phòng</th>
                                <th>Trạng thái</th>
                                <th style="text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${roomList}" var="r">
                                <tr>
                                    <td><strong>${r.roomNumber}</strong></td>
                                    <td>${r.roomType.typeName}</td>
                                    <td><span class="badge ${r.status}">${r.status}</span></td>
                                    <td style="text-align: center;">
                                        <a href="${pageContext.request.contextPath}/room-management?action=edit&id=${r.roomId}" 
                                           class="action-link btn-edit">Sửa</a>

                                        <c:choose>
                                            <c:when test="${r.status == 'AVAILABLE'}">
                                                <a href="${pageContext.request.contextPath}/room-management?action=delete&id=${r.roomId}" 
                                                   class="action-link btn-delete" 
                                                   onclick="return confirm('Xóa phòng ${r.roomNumber}?')">Xóa</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#ccc; font-size: 0.8rem; margin-left: 10px;" title="Phòng đang có khách hoặc bảo trì">🔒 Khóa</span>
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
    </body>
</html>
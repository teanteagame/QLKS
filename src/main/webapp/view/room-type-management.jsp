<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Loại phòng - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <div class="page-header">
                <h1>💰 Thiết lập Loại phòng & Giá</h1>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error" style="margin-bottom: 20px;">
                    ⚠️ ${error}
                </div>
            </c:if>

            <%-- PHẦN 1: FORM THÊM / SỬA GIÁ --%>
            <div class="mgmt-card" style="border-left: 5px solid var(--warning-color);">
                <h3>${editType == null ? '➕ Thêm loại phòng mới' : '📝 Cập nhật đơn giá'}</h3>
                <form action="${pageContext.request.contextPath}/room-type-management" method="post" class="grid-form">
                    <input type="hidden" name="roomTypeId" value="${editType.roomTypeId}">
                    
                    <div class="form-group full-width">
                        <label class="form-label">Tên loại phòng</label>
                        <input type="text" name="typeName" class="input-field" 
                               value="${editType.typeName}" placeholder="Ví dụ: Standard, VIP, Family..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá theo GIỜ</label>
                        <div class="price-input-group">
                            <input type="number" name="hourlyPrice" class="input-field" 
                                   value="${editType.hourlyPrice}" step="1000" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá qua ĐÊM</label>
                        <div class="price-input-group">
                            <input type="number" name="overnightPrice" class="input-field" 
                                   value="${editType.overnightPrice}" step="1000" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá theo NGÀY</label>
                        <div class="price-input-group">
                            <input type="number" name="dailyPrice" class="input-field" 
                                   value="${editType.dailyPrice}" step="1000" required>
                        </div>
                    </div>

                    <div class="form-group" style="display: flex; align-items: flex-end; gap: 10px;">
                        <button type="submit" class="btn btn-success" style="width: 100%;">
                            ${editType == null ? 'LƯU LOẠI PHÒNG' : 'CẬP NHẬT GIÁ'}
                        </button>
                        <c:if test="${editType != null}">
                            <a href="${pageContext.request.contextPath}/room-type-management" class="btn" style="background: #eee; color: #333;">Hủy</a>
                        </c:if>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH GIÁ --%>
            <div class="mgmt-card">
                <h3>📋 Bảng giá chi tiết</h3>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Loại phòng</th>
                            <th style="text-align: right;">Giá Giờ</th>
                            <th style="text-align: right;">Giá Đêm</th>
                            <th style="text-align: right;">Giá Ngày</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${typeList}" var="t">
                            <tr>
                                <td><strong>${t.typeName}</strong></td>
                                <td style="text-align: right; color: var(--accent-color); font-weight: 600;">
                                    <fmt:formatNumber value="${t.hourlyPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: right; color: var(--accent-color); font-weight: 600;">
                                    <fmt:formatNumber value="${t.overnightPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: right; color: var(--accent-color); font-weight: 600;">
                                    <fmt:formatNumber value="${t.dailyPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/room-type-management?action=edit&id=${t.roomTypeId}" 
                                       class="action-link btn-edit">Sửa giá</a>
                                    <a href="${pageContext.request.contextPath}/room-type-management?action=delete&id=${t.roomTypeId}" 
                                       class="action-link btn-delete" 
                                       onclick="return confirm('Xóa loại phòng ${t.typeName}? Thao tác này sẽ lỗi nếu đang có phòng thuộc loại này.')">Xóa</a>
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
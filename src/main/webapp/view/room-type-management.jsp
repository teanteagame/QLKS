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
            <div class="page-header" style="margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
                <h1>💰 Thiết lập Loại phòng & Giá</h1>
                <a href="dashboard" class="btn btn-outline">← Dashboard</a>
            </div>

            <c:if test="${not empty error}">
                <div class="badge status-danger" style="display: block; margin-bottom: 25px; padding: 12px; text-transform: none; text-align: center;">
                    ⚠️ ${error}
                </div>
            </c:if>

            <%-- PHẦN 1: FORM THÊM / SỬA GIÁ (Sử dụng card và grid layout) --%>
            <div class="card border-warning" style="margin-bottom: 30px;">
                <h3 style="margin-bottom: 20px;">${editType == null ? '➕ Thêm loại phòng mới' : '📝 Cập nhật đơn giá'}</h3>
                
                <form action="room-type-management" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                    <input type="hidden" name="roomTypeId" value="${editType.roomTypeId}">
                    
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label class="form-label">Tên loại phòng</label>
                        <input type="text" name="typeName" class="input-field" 
                               value="${editType.typeName}" placeholder="Ví dụ: Standard, VIP, Family..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá theo GIỜ (VNĐ)</label>
                        <input type="number" name="hourlyPrice" class="input-field" 
                               value="${editType.hourlyPrice}" step="1000" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá qua ĐÊM (VNĐ)</label>
                        <input type="number" name="overnightPrice" class="input-field" 
                               value="${editType.overnightPrice}" step="1000" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá theo NGÀY (VNĐ)</label>
                        <input type="number" name="dailyPrice" class="input-field" 
                               value="${editType.dailyPrice}" step="1000" required>
                    </div>

                    <div style="grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                        <c:if test="${editType != null}">
                            <a href="room-type-management" class="btn btn-outline">Hủy</a>
                        </c:if>
                        <button type="submit" class="btn btn-success" style="min-width: 150px;">
                            ${editType == null ? 'LƯU LOẠI PHÒNG' : 'CẬP NHẬT GIÁ'}
                        </button>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH GIÁ --%>
            <div class="table-responsive">
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
                                <td style="text-align: right; color: var(--accent); font-weight: 600;">
                                    <fmt:formatNumber value="${t.hourlyPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: right; color: var(--accent); font-weight: 600;">
                                    <fmt:formatNumber value="${t.overnightPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: right; color: var(--accent); font-weight: 600;">
                                    <fmt:formatNumber value="${t.dailyPrice}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: center;">
                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                        <a href="room-type-management?action=edit&id=${t.roomTypeId}" 
                                           class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem;">Sửa</a>
                                        <a href="room-type-management?action=delete&id=${t.roomTypeId}" 
                                           class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem; color: var(--danger);"
                                           onclick="return confirm('Xác nhận xóa loại phòng ${t.typeName}?')">Xóa</a>
                                    </div>
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
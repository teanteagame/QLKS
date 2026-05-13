<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Dịch vụ - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <%-- Nhúng thanh điều hướng Sidebar --%>
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <div class="page-header">
                <h1>🍔 Quản lý Danh mục Dịch vụ</h1>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn" style="background: #eee; color: #333;">
                    ← Dashboard
                </a>
            </div>

            <%-- PHẦN 1: BIỂU MẪU NHẬP LIỆU (THÊM HOẶC SỬA) --%>
            <div class="mgmt-card" style="border-left: 5px solid var(--accent-color);">
                <h3>
                    <c:choose>
                        <c:when test="${not empty editService}">
                            📝 Cập nhật thông tin dịch vụ (Mã: #${editService.serviceId})
                        </c:when>
                        <c:otherwise>
                            ➕ Thêm dịch vụ mới
                        </c:otherwise>
                    </c:choose>
                </h3>
                
                <form action="${pageContext.request.contextPath}/service-management" method="post" class="grid-form">
                    <%-- Input ẩn để Servlet phân biệt Add (trống) và Update (có ID) --%>
                    <input type="hidden" name="serviceId" value="${editService.serviceId}">
                    
                    <div class="form-group">
                        <label class="form-label">Tên dịch vụ</label>
                        <input type="text" name="serviceName" class="input-field" 
                               value="${editService.serviceName}" placeholder="Ví dụ: Nước suối, Mì ly..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mã phân loại (Category ID)</label>
                        <input type="number" name="categoryId" class="input-field" 
                               value="${not empty editService ? editService.categoryId : ''}" 
                               placeholder="Nhập mã loại dịch vụ..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Đơn vị tính</label>
                        <input type="text" name="unit" class="input-field" 
                               value="${editService.unit}" placeholder="Chai, Cái, Lần..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Đơn giá</label>
                        <div class="price-input-group">
                            <input type="number" name="price" class="input-field" 
                                   value="${editService.price}" step="500" required>
                        </div>
                    </div>

                    <div class="form-group full-width" style="display: flex; align-items: center; justify-content: space-between; gap: 15px; background: #f9f9f9; padding: 15px; border-radius: 8px;">
                        <div>
                            <label class="form-label" style="display: inline-flex; align-items: center; cursor: pointer; margin: 0;">
                                <input type="checkbox" name="status" value="true" 
                                       ${(empty editService or editService.status) ? 'checked' : ''} 
                                       style="width: 20px; height: 20px; margin-right: 10px;">
                                <span>Đang kinh doanh</span>
                            </label>
                        </div>
                        
                        <div style="display: flex; gap: 10px;">
                            <c:if test="${not empty editService}">
                                <a href="${pageContext.request.contextPath}/service-management" class="btn" style="background: #eee; color: #333;">
                                    HỦY BỎ
                                </a>
                            </c:if>
                            <button type="submit" class="btn btn-success" style="min-width: 150px;">
                                ${not empty editService ? 'CẬP NHẬT' : 'LƯU DỊCH VỤ'}
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH DỊCH VỤ --%>
            <div class="mgmt-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 style="margin: 0; border: none;">📋 Danh sách dịch vụ hiện có</h3>
                    <span style="font-size: 0.85rem; color: #888;">Tổng cộng: ${serviceList.size()} dịch vụ</span>
                </div>
                
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Mã loại</th>
                            <th>Tên dịch vụ</th>
                            <th>ĐVT</th>
                            <th style="text-align: right;">Đơn giá (VNĐ)</th>
                            <th style="text-align: center;">Trạng thái</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${serviceList}" var="s">
                            <tr class="${editService.serviceId == s.serviceId ? 'row-highlight' : ''}">
                                <td><span style="color: #999; font-family: monospace;">#${s.categoryId}</span></td>
                                <td>
                                    <div style="display: flex; align-items: center;">
                                        <div class="service-icon-placeholder" style="width: 30px; height: 30px; background: #f0f0f0; border-radius: 4px; display: flex; align-items: center; justify-content: center; margin-right: 10px;">
                                            📦
                                        </div>
                                        <strong>${s.serviceName}</strong>
                                    </div>
                                </td>
                                <td>${s.unit}</td>
                                <td style="text-align: right; font-weight: 600; color: var(--accent-color);">
                                    <fmt:formatNumber value="${s.price}" type="number" groupingUsed="true"/>
                                </td>
                                <td style="text-align: center;">
                                    <span class="status-badge ${s.status ? 'status-active' : 'status-inactive'}" 
                                          style="padding: 4px 10px; border-radius: 12px; font-size: 0.8rem;">
                                        ${s.status ? 'Kinh doanh' : 'Ngừng'}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/service-management?action=edit&id=${s.serviceId}" 
                                       class="action-link btn-edit">Sửa</a>
                                    <a href="${pageContext.request.contextPath}/service-management?action=delete&id=${s.serviceId}" 
                                       class="action-link btn-delete" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa dịch vụ: ${s.serviceName}?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty serviceList}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: #999;">
                                    Hiện chưa có dịch vụ nào trong danh mục.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <style>
       
    </style>
</body>
</html>
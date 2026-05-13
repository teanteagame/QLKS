<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Dịch vụ - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <%-- Header trang --%>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1>🍔 Quản lý Danh mục Dịch vụ</h1>
                <a href="dashboard" class="btn btn-outline">← Dashboard</a>
            </div>

            <%-- PHẦN 1: FORM THÊM/SỬA (Sử dụng card và grid layout) --%>
            <div class="card border-accent" style="margin-bottom: 30px;">
                <h3 style="margin-bottom: 20px;">${not empty editService ? '📝 Cập nhật dịch vụ' : '➕ Thêm dịch vụ mới'}</h3>
                
                <form action="service-management" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                    <input type="hidden" name="serviceId" value="${editService.serviceId}">

                    <div class="form-group">
                        <label class="form-label">Tên dịch vụ</label>
                        <input type="text" name="serviceName" class="input-field" value="${editService.serviceName}" placeholder="Ví dụ: Coca Cola" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Phân loại</label>
                        <select name="categoryId" class="input-field" required>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.key}" ${editService.categoryId == cat.key ? 'selected' : ''}>
                                    ${cat.value}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Tên file ảnh (trong /services/)</label>
                        <input type="text" name="imageUrl" class="input-field" 
                               value="${editService.imageUrl}" placeholder="Ví dụ: coca.jpg">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Đơn vị</label>
                        <input type="text" name="unit" class="input-field" value="${editService.unit}" placeholder="Lon, Cái, Đĩa..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Giá tiền (VNĐ)</label>
                        <input type="number" name="price" class="input-field" value="${editService.price}" required>
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 10px; padding-top: 35px;">
                        <input type="checkbox" name="status" id="sStatus" style="width: 18px; height: 18px;" ${(editService == null || editService.status) ? 'checked' : ''}>
                        <label for="sStatus" style="font-weight: 600; cursor: pointer;">Đang kinh doanh</label>
                    </div>

                    <div style="grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                        <c:if test="${not empty editService}">
                            <a href="service-management" class="btn btn-outline">HỦY</a>
                        </c:if>
                        <button type="submit" class="btn btn-success" style="min-width: 150px;">LƯU DỊCH VỤ</button>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH (Sử dụng table-responsive và custom-table) --%>
            <div class="table-responsive">
                <table class="custom-table" id="serviceTable">
                    <thead>
                        <tr>
                            <th style="width: 80px;">Ảnh</th>
                            <th>Tên dịch vụ</th>
                            <th>Phân loại</th>
                            <th>Đơn vị</th>
                            <th style="text-align: right;">Đơn giá</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${serviceList}" var="s">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}/assets/images/services/${not empty s.imageUrl ? s.imageUrl : 'default-service.jpg'}" 
                                         style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover; border: 1px solid var(--border-color);">
                                </td>
                                <td><strong>${s.serviceName}</strong></td>
                                <td>
                                    <span class="badge" style="background: #f0f2f5; color: var(--secondary);">
                                        ${categories[s.categoryId]}
                                    </span>
                                </td>
                                <td>${s.unit}</td>
                                <td style="text-align: right; font-weight: bold; color: var(--accent);">
                                    <fmt:formatNumber value="${s.price}" type="number"/> đ
                                </td>
                                <td style="text-align: center;">
                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                        <a href="service-management?action=edit&id=${s.serviceId}" 
                                           class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem;">Sửa</a>
                                        <a href="service-management?action=delete&id=${s.serviceId}" 
                                           class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem; color: var(--danger);"
                                           onclick="return confirm('Xác nhận xóa dịch vụ ${s.serviceName}?')">Xóa</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <%-- Nhúng công cụ xử lý bảng --%>
    <script src="${pageContext.request.contextPath}/assets/js/table-manager.js"></script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân sự - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <%-- Nhúng Sidebar điều hướng --%>
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <div class="page-header">
                <h1>👥 Quản lý đội ngũ nhân viên</h1>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/employee-management?action=showInactive" class="btn" style="background: #f8d7da; color: #721c24;">
                        Nhân viên đã nghỉ
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn" style="background: #eee; color: #333;">
                        ← Dashboard
                    </a>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error" style="margin-bottom: 20px;">
                    ⚠️ ${error}
                </div>
            </c:if>

            <%-- PHẦN 1: BIỂU MẪU NHẬP LIỆU (THÊM / SỬA) --%>
            <div class="mgmt-card" style="border-left: 5px solid var(--accent-color);">
                <h3>${empty editEmp ? '➕ Đăng ký nhân viên mới' : '📝 Cập nhật hồ sơ nhân viên'}</h3>
                
                <form action="${pageContext.request.contextPath}/employee-management" method="post" class="grid-form">
                    <%-- SỬA LỖI: Dùng employeeId thay vì accountId --%>
                    <input type="hidden" name="employeeId" value="${editEmp.employeeId}">
                    
                    <div class="form-group">
                        <label class="form-label">Họ và Tên</label>
                        <input type="text" name="fullName" class="input-field" 
                               value="${editEmp.fullName}" placeholder="Ví dụ: Nguyễn Văn A" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email công việc</label>
                        <input type="email" name="email" class="input-field" 
                               value="${editEmp.email}" placeholder="email@example.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="input-field" 
                               value="${editEmp.phone}" placeholder="Số liên lạc..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Vai trò hệ thống</label>
                        <select name="roleId" class="input-field">
                            <option value="1" ${editEmp.roleId == 1 ? 'selected' : ''}>Quản lý (MANAGER)</option>
                            <option value="2" ${editEmp.roleId == 2 ? 'selected' : ''}>Nhân viên (STAFF)</option>
                        </select>
                    </div>

                    <div class="form-group full-width" style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                        <c:if test="${not empty editEmp}">
                            <a href="${pageContext.request.contextPath}/employee-management" class="btn" style="background: #eee; color: #333;">HỦY</a>
                        </c:if>
                        <button type="submit" class="btn btn-success" style="min-width: 150px;">
                            ${empty editEmp ? 'LƯU NHÂN VIÊN' : 'CẬP NHẬT HỒ SƠ'}
                        </button>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH NHÂN VIÊN --%>
            <div class="mgmt-card">
                <h3>📋 Danh sách tài khoản nhân sự ${isInactiveView ? '(Đã nghỉ việc)' : '(Đang làm việc)'}</h3>
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Họ và Tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th style="text-align: center;">Vai trò</th>
                            <th style="text-align: center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${employeeList}" var="e">
                            <%-- SỬA LỖI: So sánh bằng employeeId để highlight dòng đang sửa --%>
                            <tr class="${editEmp.employeeId == e.employeeId ? 'row-highlight' : ''}">
                                <td><strong>${e.fullName}</strong></td>
                                <td>${e.email}</td>
                                <td>${e.phone}</td>
                                <td style="text-align: center;">
                                    <span class="role-badge ${e.roleId == 1 ? 'role-manager' : 'role-staff'}" 
                                          style="padding: 4px 10px; border-radius: 4px; font-size: 0.75rem; font-weight: bold;">
                                        ${e.roleId == 1 ? 'MANAGER' : 'STAFF'}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${not isInactiveView}">
                                            <%-- Giao diện nhân viên đang làm việc --%>
                                            <a href="${pageContext.request.contextPath}/employee-management?action=edit&id=${e.employeeId}" 
                                               class="action-link btn-edit">Sửa</a>
                                            
                                            <%-- Chặn không cho Manager tự xóa chính mình --%>
                                            <c:choose>
                                                <c:when test="${sessionScope.account.accountId != e.employeeId}">
                                                    <a href="${pageContext.request.contextPath}/employee-management?action=delete&id=${e.employeeId}" 
                                                       class="action-link btn-delete" 
                                                       onclick="return confirm('Xác nhận cho nhân viên ${e.fullName} nghỉ việc?')">Xóa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #ccc; font-size: 0.8rem; margin-left: 10px;" title="Tài khoản đang đăng nhập">(Đang trực)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- Giao diện nhân viên đã nghỉ --%>
                                            <a href="${pageContext.request.contextPath}/employee-management?action=reactivate&id=${e.employeeId}" 
                                               class="btn btn-success" style="padding: 4px 8px; font-size: 0.8rem;">Kích hoạt lại</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty employeeList}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 40px; color: #999;">
                                    Chưa có dữ liệu nhân viên để hiển thị.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <style>
        .row-highlight { background-color: #fffde7 !important; outline: 2px solid var(--warning-color); }
        .role-manager { background-color: #fef3c7; color: #92400e; border: 1px solid #f59e0b; }
        .role-staff { background-color: #e0f2fe; color: #075985; border: 1px solid #0ea5e9; }
    </style>
</body>
</html>
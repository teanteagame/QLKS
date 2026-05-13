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
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <%-- Header trang --%>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1>👥 Quản lý đội ngũ nhân viên 
                    <c:if test="${isInactiveView}"><span style="color: var(--danger);">(Đã nghỉ)</span></c:if>
                </h1>
                <div style="display: flex; gap: 10px;">
                    <c:choose>
                        <c:when test="${isInactiveView}">
                            <a href="employee-management" class="btn btn-primary">🔙 Quay lại danh sách chính</a>
                        </c:when>
                        <c:otherwise>
                            <a href="employee-management?action=showInactive" class="btn btn-outline" style="color: var(--danger);">
                                🚫 Xem nhân viên đã nghỉ
                            </a>
                            <a href="dashboard" class="btn btn-outline">← Dashboard</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="badge status-danger" style="display: block; margin-bottom: 25px; padding: 12px; text-transform: none; text-align: center;">
                    ⚠️ ${error}
                </div>
            </c:if>

            <%-- PHẦN 1: FORM THÊM/SỬA (Sử dụng card và grid-container) --%>
            <div class="card border-accent" style="margin-bottom: 30px;">
                <h3 style="margin-bottom: 20px;">${empty editEmp ? '➕ Đăng ký nhân viên mới' : '📝 Cập nhật hồ sơ nhân viên'}</h3>

                <form action="employee-management" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                    <input type="hidden" name="employeeId" value="${editEmp.employeeId}">

                    <div class="form-group">
                        <label class="form-label">Họ và Tên</label>
                        <input type="text" name="fullName" class="input-field" 
                               value="${editEmp.fullName}" placeholder="Nguyễn Văn A" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email công việc</label>
                        <input type="email" name="email" class="input-field" 
                               value="${editEmp.email}" placeholder="email@example.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="input-field" 
                               value="${editEmp.phone}" placeholder="090..." required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mật khẩu hệ thống</label>
                        <input type="password" name="password" class="input-field" 
                               placeholder="${empty editEmp ? 'Mật khẩu khởi tạo' : 'Để trống nếu không đổi'}" 
                               ${empty editEmp ? 'required' : ''}>
                        <c:if test="${not empty editEmp}">
                            <small style="color: var(--warning); font-size: 0.8rem; display: block; margin-top: 5px;">
                                ⚠️ Chỉ nhập nếu muốn thay đổi mật khẩu.
                            </small>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Vai trò hệ thống</label>
                        <select name="roleId" class="input-field">
                            <option value="1" ${editEmp.roleId == 1 ? 'selected' : ''}>Quản lý (MANAGER)</option>
                            <option value="2" ${editEmp.roleId == 2 ? 'selected' : ''}>Nhân viên (STAFF)</option>
                        </select>
                    </div>

                    <div style="grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">
                        <c:if test="${not empty editEmp}">
                            <a href="employee-management" class="btn btn-outline">HỦY</a>
                        </c:if>
                        <button type="submit" class="btn btn-success" style="min-width: 150px;">
                            ${empty editEmp ? 'LƯU NHÂN VIÊN' : 'CẬP NHẬT HỒ SƠ'}
                        </button>
                    </div>
                </form>
            </div>

            <%-- PHẦN 2: BẢNG DANH SÁCH --%>
            <div class="table-responsive">
                <table class="custom-table" id="employeeTable">
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
                            <tr style="${editEmp.employeeId == e.employeeId ? 'background: #f0f7ff;' : ''}">
                                <td><strong>${e.fullName}</strong></td>
                                <td>${e.email}</td>
                                <td>${e.phone}</td>
                                <td style="text-align: center;">
                                    <span class="badge ${e.roleId == 1 ? 'status-warning' : 'status-active'}">
                                        ${e.roleId == 1 ? 'MANAGER' : 'STAFF'}
                                    </span>
                                </td>
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${not isInactiveView}">
                                            <a href="employee-management?action=edit&id=${e.employeeId}" class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem;">Sửa</a>
                                            <c:choose>
                                                <c:when test="${sessionScope.account.employeeId != e.employeeId}">
                                                    <a href="employee-management?action=delete&id=${e.employeeId}" 
                                                       class="btn btn-outline" style="padding: 5px 12px; font-size: 0.8rem; color: var(--danger);"
                                                       onclick="return confirm('Cho nhân viên ${e.fullName} nghỉ việc?')">Xóa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray); font-size: 0.8rem; margin-left: 10px;">(Đang trực)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="employee-management?action=reactivate&id=${e.employeeId}" 
                                               class="btn btn-success" style="padding: 5px 12px; font-size: 0.8rem;">Kích hoạt lại</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty employeeList}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 40px; color: var(--gray);">
                                    Chưa có dữ liệu nhân viên để hiển thị.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
    
    <%-- Nhúng công cụ xử lý bảng --%>
    <script src="${pageContext.request.contextPath}/assets/js/table-manager.js"></script>
</body>
</html>
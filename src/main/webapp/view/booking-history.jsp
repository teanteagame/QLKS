<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử giao dịch - Hotel Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <div class="admin-layout">
            <jsp:include page="common/navbar.jsp"/>

            <main class="main-content">
                <%-- Header và Ô tìm kiếm nhanh --%>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <h1>🕒 Lịch sử giao dịch</h1>
                    <div style="width: 350px;">
                        <input type="text" id="historySearch" class="input-field" 
                               placeholder="Tìm tên khách, số phòng, loại phòng...">
                    </div>
                </div>

                <%-- Bảng dữ liệu (Sử dụng .table-responsive và .custom-table) --%>
                <div class="table-responsive">
                    <table class="custom-table" id="historyTable">
                        <thead>
                            <tr>
                                <%-- Gọi logic từ TableManager trong file JS riêng --%>
                                <th style="cursor: pointer;" onclick="TableManager.sortTable('historyTable', 0)">Mã Đơn</th>
                                <th style="cursor: pointer;" onclick="TableManager.sortTable('historyTable', 1)">Khách hàng</th>
                                <th style="cursor: pointer;" onclick="TableManager.sortTable('historyTable', 2)">Phòng</th>
                                <th>Loại hình</th>
                                <th style="cursor: pointer;" onclick="TableManager.sortTable('historyTable', 4, 'date')">Ngày nhận</th>
                                <th style="cursor: pointer;" onclick="TableManager.sortTable('historyTable', 5, 'date')">Ngày thanh toán</th>
                                <th style="cursor: pointer; text-align: right;" onclick="TableManager.sortTable('historyTable', 6, 'number')">Tổng tiền (VNĐ)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${historyList}" var="h">
                                <tr>
                                    <td><span style="color: var(--gray); font-family: monospace;">#${h.bookingId}</span></td>
                                    <td><strong>${h.customerName}</strong></td>
                                    <td>Phòng ${h.roomNumber}</td>
                                    <td><span class="badge" style="background: #eef2f7; color: var(--secondary);">${h.roomType}</span></td>
                                    <td style="font-size: 0.85rem; color: var(--gray);">
                                        <fmt:formatDate value="${h.checkIn}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--gray);">
                                        <c:choose>
                                            <c:when test="${not empty h.paymentDate}">
                                                <fmt:formatDate value="${h.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="font-style: italic; color: #ccc;">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: right; font-weight: 600; color: var(--accent);">
                                        <fmt:formatNumber value="${h.roomPrice}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty historyList}">
                                <tr id="noDataRow">
                                    <td colspan="7" style="text-align: center; padding: 50px; color: var(--gray);">
                                        📭 Chưa có lịch sử giao dịch nào được ghi nhận.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <p style="margin-top: 25px; color: var(--gray); font-size: 0.85rem;">
                    <em>* Dữ liệu được sắp xếp mặc định theo thời gian thanh toán mới nhất. Nhấn vào tiêu đề cột để sắp xếp lại.</em>
                </p>
            </main>
        </div>

        <%-- NHÚNG LOGIC XỬ LÝ BẢNG TỪ FILE RIÊNG --%>
        <script src="${pageContext.request.contextPath}/assets/js/table-manager.js"></script>
        <script>
            // Kích hoạt tính năng tìm kiếm nhanh
            TableManager.initSearch('historySearch', 'historyTable');
        </script>
    </body>
</html>
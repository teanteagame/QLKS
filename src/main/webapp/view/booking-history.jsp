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
                <div class="search-header">
                    <h1>🕒 Lịch sử giao dịch</h1>

                    <div class="search-input-group">
                        <input type="text" id="historySearch" placeholder="Tìm tên khách, số phòng, loại phòng...">
                    </div>
                </div>

                <div class="history-container">
                    <table class="custom-table" id="historyTable">
                        <thead>
                            <tr>
                                <%-- Gắn hàm sortTable(index) vào các cột cần sắp xếp --%>
                                <th class="sortable" onclick="sortTable(0)">Mã Đơn</th>
                                <th class="sortable" onclick="sortTable(1)">Khách hàng</th>
                                <th class="sortable" onclick="sortTable(2)">Phòng</th>
                                <th>Loại hình</th>
                                <th class="sortable" onclick="sortTable(4)">Ngày nhận</th>
                                <th class="sortable" onclick="sortTable(5)">Ngày thanh toán</th>
                                <th class="sortable" onclick="sortTable(6)" style="text-align: right;">Tổng tiền (VNĐ)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${historyList}" var="h">
                                <tr>
                                    <td><span style="color: #888; font-family: monospace;">#${h.bookingId}</span></td>
                                    <td><strong>${h.customerName}</strong></td>
                                    <td>Phòng ${h.roomNumber}</td>
                                    <td><span class="badge" style="background: #eef2f7; color: #34495e;">${h.roomType}</span></td>
                                    <td style="font-size: 0.85rem; color: #666;">
                                        <fmt:formatDate value="${h.checkIn}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td style="font-size: 0.85rem; color: #666;">
                                        <c:choose>
                                            <c:when test="${not empty h.paymentDate}">
                                                <fmt:formatDate value="${h.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="font-style: italic; color: #ccc;">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="price-cell">
                                        <fmt:formatNumber value="${h.roomPrice}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty historyList}">
                                <tr id="noDataRow">
                                    <td colspan="7" style="text-align: center; padding: 50px; color: #999;">
                                        📭 Chưa có lịch sử giao dịch nào được ghi nhận.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <p style="margin-top: 20px; color: #7f8c8d; font-size: 0.9rem;">
                    <em>* Dữ liệu được sắp xếp theo thời gian thanh toán mới nhất.</em>
                </p>
            </main>
        </div>

        <%-- SCRIPT TÌM KIẾM NHANH --%>
        <script>
            // Hàm tìm kiếm (đã có từ trước)
            document.getElementById('historySearch').addEventListener('keyup', function () {
                let filter = this.value.toLowerCase();
                let rows = document.querySelectorAll('#historyTable tbody tr:not(#noDataRow)');
                rows.forEach(row => {
                    let text = row.textContent.toLowerCase();
                    row.style.display = text.includes(filter) ? '' : 'none';
                });
            });

            // HÀM SẮP XẾP BẢNG (MỚI)
            function sortTable(n) {
                let table = document.getElementById("historyTable");
                let rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                switching = true;
                dir = "asc";

                // Xóa các class asc/desc cũ ở các header khác
                let headers = table.querySelectorAll('th.sortable');
                headers.forEach(h => {
                    if (h !== headers[n])
                        h.classList.remove('asc', 'desc');
                });

                while (switching) {
                    switching = false;
                    rows = table.rows;
                    // Lặp qua các hàng dữ liệu (bỏ qua header và hàng 'noData')
                    for (i = 1; i < (rows.length - 1); i++) {
                        if (rows[i].id === "noDataRow")
                            continue;
                        shouldSwitch = false;
                        x = rows[i].getElementsByTagName("TD")[n];
                        y = rows[i + 1].getElementsByTagName("TD")[n];

                        let xVal = x.innerText.toLowerCase().trim();
                        let yVal = y.innerText.toLowerCase().trim();

                        // Logic xử lý theo loại dữ liệu của từng cột
                        if (n === 6) { // Cột Tổng tiền: Chuyển về số để so sánh
                            xVal = parseFloat(xVal.replace(/,/g, '')) || 0;
                            yVal = parseFloat(yVal.replace(/,/g, '')) || 0;
                        } else if (n === 4 || n === 5) { // Cột Ngày tháng (dd/mm/yyyy): Đảo ngược để so sánh chuỗi
                            xVal = xVal.split(' ')[0].split('/').reverse().join('');
                            yVal = yVal.split(' ')[0].split('/').reverse().join('');
                        }

                        if (dir == "asc") {
                            if (xVal > yVal) {
                                shouldSwitch = true;
                                break;
                            }
                        } else if (dir == "desc") {
                            if (xVal < yVal) {
                                shouldSwitch = true;
                                break;
                            }
                        }
                    }
                    if (shouldSwitch) {
                        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                        switching = true;
                        switchcount++;
                    } else {
                        if (switchcount == 0 && dir == "asc") {
                            dir = "desc";
                            switching = true;
                        }
                    }
                }
                // Cập nhật icon mũi tên cho header đang chọn
                headers[n].classList.toggle('asc', dir === 'asc');
                headers[n].classList.toggle('desc', dir === 'desc');
            }
        </script>
    </body>
</html>
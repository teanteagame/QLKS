<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo chuyên sâu - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <h1>📊 Phân tích doanh thu & Hiệu suất</h1>

            <%-- THANH LỌC THỜI GIAN --%>
            <form action="statistics" method="get" class="report-filter-bar">
                <div class="form-group">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" name="startDate" class="input-field" value="${param.startDate}">
                </div>
                <div class="form-group">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" name="endDate" class="input-field" value="${param.endDate}">
                </div>
                <button type="submit" class="btn btn-info" style="height: 45px;">🔍 Áp dụng lọc</button>
                <a href="statistics" class="btn" style="height: 45px; background: #eee; color: #333; line-height: 25px;">Làm mới</a>
            </form>

            <%-- THỐNG KÊ CHI TIẾT THEO KHOẢNG --%>
            <div class="stat-group-grid">
                <div class="mini-stat-card revenue-room">
                    <p>Tiền phòng</p>
                    <h4><fmt:formatNumber value="${roomRevenue}" type="number"/> đ</h4>
                </div>
                <div class="mini-stat-card revenue-service">
                    <p>Tiền dịch vụ</p>
                    <h4><fmt:formatNumber value="${serviceRevenue}" type="number"/> đ</h4>
                </div>
                <div class="mini-stat-card" style="border-left-color: #27ae60;">
                    <p>Tổng cộng</p>
                    <h4><fmt:formatNumber value="${roomRevenue + serviceRevenue}" type="number"/> đ</h4>
                </div>
                <div class="mini-stat-card" style="border-left-color: #f39c12;">
                    <p>Trung bình/Ngày</p>
                    <h4><fmt:formatNumber value="${averageRevenue}" type="number"/> đ</h4>
                </div>
            </div>

            <div class="chart-grid">
                <div class="chart-card">
                    <h3>Biến động doanh thu theo thời gian</h3>
                    <div class="chart-wrapper">
                        <canvas id="timeSeriesChart"></canvas>
                    </div>
                </div>
                <div class="chart-card">
                    <h3>Cơ cấu doanh thu</h3>
                    <div class="chart-wrapper">
                        <canvas id="revenueSourceChart"></canvas>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // KIỂM TRA DỮ LIỆU ĐẦU VÀO (Sửa lỗi biểu đồ không hiển thị)
        const labels = ${chartLabels != null ? chartLabels : '[]'};
        const dataValues = ${chartValues != null ? chartValues : '[]'};

        if (labels.length === 0) {
            console.warn("Dữ liệu biểu đồ trống hoặc sai định dạng.");
        }

        // 1. Biểu đồ đường (Line Chart) cho phép xem theo khoảng thời gian
        new Chart(document.getElementById('timeSeriesChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (đ)',
                    data: dataValues,
                    borderColor: '#3498db',
                    backgroundColor: 'rgba(52, 152, 219, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } }
            }
        });

        // 2. Biểu đồ tròn so sánh Tiền phòng vs Tiền dịch vụ
        new Chart(document.getElementById('revenueSourceChart'), {
            type: 'pie',
            data: {
                labels: ['Tiền phòng', 'Tiền dịch vụ'],
                datasets: [{
                    data: [${roomRevenue}, ${serviceRevenue}],
                    backgroundColor: ['#3498db', '#9b59b6']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    </script>
</body>
</html>
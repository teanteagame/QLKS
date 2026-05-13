<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo chuyên sâu - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <%-- Nhúng thư viện Chart.js --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <h1>📊 Phân tích doanh thu & Hiệu suất</h1>

            <%-- THANH LỌC THỜI GIAN (Sử dụng Palette chung) --%>
            <form action="statistics" method="get" class="card" style="margin-bottom: 30px; padding: 20px;">
                <div style="display: flex; gap: 20px; align-items: flex-end; flex-wrap: wrap;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="startDate" class="input-field" value="${param.startDate}">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="endDate" class="input-field" value="${param.endDate}">
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="height: 45px;">🔍 Áp dụng</button>
                        <a href="statistics" class="btn btn-outline" style="height: 45px;">Làm mới</a>
                    </div>
                </div>
            </form>

            <%-- KHỐI THỐNG KÊ TỔNG QUAN (Sử dụng grid-container và card) --%>
            <div class="grid-container">
                <div class="card border-accent">
                    <p style="color: var(--gray); font-size: 0.9rem;">Tiền phòng</p>
                    <h3 style="color: var(--accent);"><fmt:formatNumber value="${roomRevenue}" type="number"/> đ</h3>
                </div>
                <div class="card border-warning">
                    <p style="color: var(--gray); font-size: 0.9rem;">Tiền dịch vụ</p>
                    <h3 style="color: var(--warning);"><fmt:formatNumber value="${serviceRevenue}" type="number"/> đ</h3>
                </div>
                <div class="card border-success">
                    <p style="color: var(--gray); font-size: 0.9rem;">Tổng cộng</p>
                    <h3 style="color: var(--success);"><fmt:formatNumber value="${roomRevenue + serviceRevenue}" type="number"/> đ</h3>
                </div>
                <div class="card">
                    <p style="color: var(--gray); font-size: 0.9rem;">Trung bình/Ngày</p>
                    <h3><fmt:formatNumber value="${averageRevenue}" type="number"/> đ</h3>
                </div>
            </div>

            <%-- KHỐI BIỂU ĐỒ --%>
            <div class="grid-container" style="grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));">
                <div class="card" style="min-height: 400px;">
                    <h3 style="margin-bottom: 20px;">Biến động doanh thu theo thời gian</h3>
                    <div style="flex-grow: 1; position: relative;">
                        <canvas id="timeSeriesChart"></canvas>
                    </div>
                </div>
                <div class="card" style="min-height: 400px;">
                    <h3 style="margin-bottom: 20px;">Cơ cấu doanh thu</h3>
                    <div style="flex-grow: 1; position: relative;">
                        <canvas id="revenueSourceChart"></canvas>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%-- NHÚNG LOGIC VẼ BIỂU ĐỒ TỪ FILE RIÊNG --%>
    <script src="${pageContext.request.contextPath}/assets/js/chart-renderer.js"></script>
    <script>
        // Truyền dữ liệu từ Server sang JS [cite: 360-362]
        const labels = ${chartLabels != null ? chartLabels : '[]'};
        const dataValues = ${chartValues != null ? chartValues : '[]'};
        const roomRevenue = ${roomRevenue};
        const serviceRevenue = ${serviceRevenue};

        // Khởi tạo biểu đồ thông qua ChartRenderer
        ChartRenderer.renderTimeSeries('timeSeriesChart', labels, dataValues);
        ChartRenderer.renderRevenueSource('revenueSourceChart', roomRevenue, serviceRevenue);
    </script>
</body>
</html>
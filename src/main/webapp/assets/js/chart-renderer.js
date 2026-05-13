/**
 * chart-renderer.js - Tiện ích vẽ biểu đồ hệ thống
 */
const ChartRenderer = {
    // 1. Biểu đồ đường (Doanh thu theo thời gian)
    renderTimeSeries: function(canvasId, labels, data) {
        const ctx = document.getElementById(canvasId);
        if (!ctx) return;

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (đ)',
                    data: data,
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
    },

    // 2. Biểu đồ tròn (Cơ cấu Tiền phòng vs Tiền dịch vụ)
    renderRevenueSource: function(canvasId, roomRev, serviceRev) {
        const ctx = document.getElementById(canvasId);
        if (!ctx) return;

        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Tiền phòng', 'Tiền dịch vụ'],
                datasets: [{
                    data: [roomRev, serviceRev],
                    backgroundColor: ['#3498db', '#9b59b6']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    }
};
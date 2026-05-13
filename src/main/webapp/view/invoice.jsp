<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <h1 style="margin-bottom: 30px;">💳 Thủ tục trả phòng</h1>

            <div class="bill-container">
                <%-- PHẦN ĐẦU HÓA ĐƠN --%>
                <div class="bill-header">
                    <div class="hotel-info">
                        <h3>HOTEL MANAGEMENT</h3>
                        <p>Số 123, Đường ABC, Quận XYZ</p>
                        <p>Hotline: 0123.456.789</p>
                    </div>
                    <div class="bill-to" style="text-align: right;">
                        <h4>HÓA ĐƠN THANH TOÁN</h4>
                        <p>Mã đơn: <strong>#${detail.bookingId}</strong></p>
                        <p>Ngày: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/></p>
                    </div>
                </div>

                <%-- THÔNG TIN KHÁCH HÀNG --%>
                <div class="bill-to">
                    <h4>Khách hàng</h4>
                    <p><strong>${detail.customerName}</strong></p>
                    <p>Phòng: ${detail.roomNumber} - ${detail.roomType}</p>
                    <p>Vào lúc: <fmt:formatDate value="${detail.checkIn}" pattern="dd/MM/yyyy HH:mm"/></p>
                </div>

                <%-- CHI TIẾT DỊCH VỤ --%>
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>Mô tả khoản mục</th>
                            <th style="text-align: right;">Thành tiền (VNĐ)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Tiền phòng (${detail.roomType})</td>
                            <td style="text-align: right;">
                                <fmt:formatNumber value="${calculatedRoomTotal}" type="number" groupingUsed="true"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Tổng tiền dịch vụ sử dụng</td>
                            <td style="text-align: right;">
                                <fmt:formatNumber value="${serviceTotal}" type="number" groupingUsed="true"/>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <%-- TỔNG CỘNG --%>
                <div class="total-wrapper">
                    <div class="total-row">
                        <span>Tiền phòng:</span>
                        <strong><fmt:formatNumber value="${calculatedRoomTotal}" type="number" groupingUsed="true"/></strong>
                    </div>
                    <div class="total-row">
                        <span>Tiền dịch vụ:</span>
                        <strong><fmt:formatNumber value="${serviceTotal}" type="number" groupingUsed="true"/></strong>
                    </div>
                    <div class="grand-total">
                        <span>TỔNG CỘNG:</span>
                        <span><fmt:formatNumber value="${calculatedRoomTotal + serviceTotal}" type="number" groupingUsed="true"/> VNĐ</span>
                    </div>
                </div>

                <hr style="margin: 40px 0; border: 0; border-top: 1px dashed #ccc;">

                <%-- FORM XÁC NHẬN --%>
                <form method="post" action="invoice">
                    <input type="hidden" name="bookingId" value="${detail.bookingId}"> 
                    <input type="hidden" name="roomId" value="${detail.roomId}"> 
                    <input type="hidden" name="roomTotal" value="${calculatedRoomTotal}"> 
                    <input type="hidden" name="serviceTotal" value="${serviceTotal}"> 

                    <div style="margin-bottom: 25px;">
                        <label class="form-label">Phương thức thanh toán:</label>
                        <select name="paymentMethod" class="input-field" style="max-width: 300px;">
                            <option value="CASH">💵 Tiền mặt</option>
                            <option value="BANK_TRANSFER">🏦 Chuyển khoản</option>
                            <option value="CARD">💳 Quẹt thẻ</option>
                        </select>
                    </div>

                    <div style="display: flex; gap: 15px;">
                        <button type="submit" class="btn btn-warning" style="flex: 2; height: 50px; font-size: 1.1rem;">
                            XÁC NHẬN THANH TOÁN & TRẢ PHÒNG
                        </button>
                        <a href="rooms" class="btn" style="flex: 1; background: #eee; color: #333;">
                            Để sau
                        </a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
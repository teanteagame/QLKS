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

            <%-- Khung hóa đơn chuyên nghiệp sử dụng .card --%>
            <div class="card" style="max-width: 850px; margin: 0 auto; padding: 40px;">
                
                <%-- PHẦN ĐẦU HÓA ĐƠN: Thông tin khách sạn và Mã đơn --%>
                <div style="display: flex; justify-content: space-between; border-bottom: 2px solid var(--border-color); padding-bottom: 20px; margin-bottom: 30px;">
                    <div>
                        <h2 style="color: var(--primary); margin: 0;">HOTEL MANAGEMENT</h2>
                        <p style="color: var(--gray); font-size: 0.9rem; margin-top: 5px;">Số 123, Đường ABC, Quận XYZ</p>
                        <p style="color: var(--gray); font-size: 0.9rem;">Hotline: 0123.456.789</p>
                    </div>
                    <div style="text-align: right;">
                        <h3 style="color: var(--accent); margin: 0;">HÓA ĐƠN THANH TOÁN</h3>
                        <p style="margin-top: 5px;">Mã đơn: <strong>#${detail.bookingId}</strong></p>
                        <p style="font-size: 0.85rem; color: var(--gray);">
                            Ngày lập: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/>
                        </p>
                    </div>
                </div>

                <%-- THÔNG TIN KHÁCH HÀNG & PHÒNG --%>
                <div style="margin-bottom: 30px; background: var(--light); padding: 20px; border-radius: 8px; border-left: 5px solid var(--primary);">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; text-transform: uppercase; font-weight: 600;">Khách hàng</p>
                            <p style="font-size: 1.1rem; margin-top: 5px;"><strong>${detail.customerName}</strong></p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; text-transform: uppercase; font-weight: 600;">Thông tin phòng</p>
                            <p style="font-size: 1.1rem; margin-top: 5px;"><strong>Phòng ${detail.roomNumber}</strong> (${detail.roomType})</p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; text-transform: uppercase; font-weight: 600;">Thời gian nhận phòng</p>
                            <p style="margin-top: 5px;"><fmt:formatDate value="${detail.checkIn}" pattern="dd/MM/yyyy HH:mm"/></p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; text-transform: uppercase; font-weight: 600;">Hình thức thuê</p>
                            <p style="margin-top: 5px;">
                                <c:choose>
                                    <c:when test="${detail.rentalTypeId == 1}">Thuê theo giờ</c:when>
                                    <c:when test="${detail.rentalTypeId == 2}">Thuê qua đêm</c:when>
                                    <c:otherwise>Thuê theo ngày</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <%-- BẢNG CHI TIẾT CÁC KHOẢN MỤC (Minh bạch dịch vụ) --%>
                <table class="custom-table" style="margin-bottom: 30px;">
                    <thead>
                        <tr>
                            <th style="width: 50%;">Mô tả khoản mục</th>
                            <th style="text-align: center;">Số lượng</th>
                            <th style="text-align: right;">Thành tiền (VNĐ)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- 1. Tiền phòng --%>
                        <tr>
                            <td><strong>Tiền phòng (${detail.roomType})</strong></td>
                            <td style="text-align: center;">1</td>
                            <td style="text-align: right; font-weight: 600;">
                                <fmt:formatNumber value="${calculatedRoomTotal}" type="number" groupingUsed="true"/>
                            </td>
                        </tr>

                        <%-- 2. Liệt kê chi tiết từng dịch vụ --%>
                        <c:if test="${not empty serviceUsageList}">
                            <c:forEach items="${serviceUsageList}" var="item">
                                <tr>
                                    <td style="padding-left: 30px; color: var(--secondary);">
                                        <span style="color: var(--gray); margin-right: 5px;">•</span> ${item.name}
                                    </td>
                                    <td style="text-align: center;">x${item.quantity}</td>
                                    <td style="text-align: right;">
                                        <fmt:formatNumber value="${item.subTotal}" type="number" groupingUsed="true"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>

                        <%-- Thông báo nếu không dùng dịch vụ --%>
                        <c:if test="${empty serviceUsageList}">
                            <tr>
                                <td colspan="3" style="text-align: center; color: var(--gray); font-style: italic; padding: 15px;">
                                    Không có dịch vụ phát sinh
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <%-- PHẦN TỔNG KẾT TÀI CHÍNH --%>
                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 12px; border-top: 1px solid var(--border-color); padding-top: 25px;">
                    <div style="width: 320px; display: flex; justify-content: space-between;">
                        <span style="color: var(--gray);">Tổng tiền phòng:</span>
                        <span style="font-weight: 600;"><fmt:formatNumber value="${calculatedRoomTotal}" type="number"/></span>
                    </div>
                    <div style="width: 320px; display: flex; justify-content: space-between;">
                        <span style="color: var(--gray);">Tổng tiền dịch vụ:</span>
                        <span style="font-weight: 600;"><fmt:formatNumber value="${serviceTotal}" type="number"/></span>
                    </div>
                    <div style="width: 400px; display: flex; justify-content: space-between; margin-top: 10px; padding: 15px; background: #fff5f5; border-radius: 8px; color: var(--danger);">
                        <strong style="font-size: 1.1rem;">TỔNG CỘNG THANH TOÁN:</strong>
                        <strong style="font-size: 1.4rem;"><fmt:formatNumber value="${calculatedRoomTotal + serviceTotal}" type="number"/> VNĐ</strong>
                    </div>
                </div>

                <%-- FORM XÁC NHẬN THANH TOÁN --%>
                <form method="post" action="invoice" style="margin-top: 45px; padding-top: 30px; border-top: 1px dashed var(--border-color);">
                    <input type="hidden" name="bookingId" value="${detail.bookingId}"> 
                    <input type="hidden" name="roomId" value="${detail.roomId}"> 
                    <input type="hidden" name="roomTotal" value="${calculatedRoomTotal}"> 
                    <input type="hidden" name="serviceTotal" value="${serviceTotal}"> 

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: flex-end;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Phương thức thanh toán</label>
                            <select name="paymentMethod" class="input-field">
                                <option value="CASH">💵 Tiền mặt (Cash)</option>
                                <option value="BANK_TRANSFER">🏦 Chuyển khoản (Bank)</option>
                                <option value="CARD">💳 Quẹt thẻ (Card)</option>
                            </select>
                        </div>
                        
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-warning" style="flex: 2; height: 50px; font-weight: 700; font-size: 1rem; letter-spacing: 0.5px;">
                                XÁC NHẬN & XUẤT HĐ
                            </button>
                            <a href="rooms" class="btn btn-outline" style="flex: 1; height: 50px; line-height: 38px; text-align: center;">
                                Quay lại
                            </a>
                        </div>
                    </div>
                </form>

                <div style="margin-top: 40px; text-align: center; color: var(--gray); font-size: 0.85rem; border-top: 1px solid #eee; padding-top: 20px;">
                    <p>Cảm ơn quý khách đã sử dụng dịch vụ tại Hotel Management!</p>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
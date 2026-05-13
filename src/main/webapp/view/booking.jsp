<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt phòng P.${room.roomNumber} - Hotel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="common/navbar.jsp"/>

        <main class="main-content">
            <%-- Căn giữa form bằng inline style đơn giản kết hợp với .card --%>
            <div style="max-width: 650px; margin: 0 auto;">
                
                <div class="card border-accent">
                    <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 15px; margin-bottom: 20px;">
                        <h2 style="margin: 0;">📝 Phiếu Đặt Phòng</h2>
                    </div>

                    <%-- Thông báo lỗi sử dụng badge danger có sẵn --%>
                    <c:if test="${not empty error}">
                        <div class="badge status-danger" style="display: block; margin-bottom: 20px; padding: 12px; text-transform: none;">
                            ⚠️ ${error}
                        </div>
                    </c:if>

                    <%-- Thông tin phòng đang chọn --%>
                    <div style="background: var(--light); padding: 15px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid var(--accent);">
                        <p style="margin: 0;">Đang thực hiện cho: <strong>Phòng ${room.roomNumber}</strong></p>
                        <p style="margin: 5px 0 0 0; font-size: 0.9rem; color: var(--gray);">
                            Loại phòng: ${room.roomType.typeName}
                        </p>
                    </div>

                    <form method="post" action="booking">
                        <input type="hidden" name="roomId" value="${room.roomId}">

                        <%-- Sử dụng grid layout trực tiếp để chia cột form --%>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label class="form-label">Họ và tên khách hàng</label>
                                <input type="text" name="fullName" class="input-field" 
                                       placeholder="Ví dụ: Nguyễn Văn A" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Số CCCD / Passport</label>
                                <input type="text" name="citizenId" class="input-field" 
                                       placeholder="Số định danh" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" name="phone" class="input-field" 
                                       placeholder="Số liên lạc" required>
                            </div>

                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label class="form-label">Địa chỉ Email</label>
                                <input type="email" name="email" class="input-field" 
                                       placeholder="khachhang@example.com">
                            </div>

                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label class="form-label">Hình thức thuê phòng</label>
                                <select name="rentalTypeId" class="input-field">
                                    <option value="1">Thuê theo giờ (Hourly)</option>
                                    <option value="2">Thuê qua đêm (Overnight)</option>
                                    <option value="3">Thuê theo ngày (Daily)</option>
                                </select>
                            </div>
                        </div>

                        <%-- Hệ thống nút bấm thống nhất --%>
                        <div style="margin-top: 35px; display: flex; gap: 15px;">
                            <button type="submit" class="btn btn-success" style="flex: 2; height: 48px;">
                                ✅ XÁC NHẬN ĐẶT PHÒNG
                            </button>
                            <a href="rooms" class="btn btn-outline" style="flex: 1; height: 48px;">
                                Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
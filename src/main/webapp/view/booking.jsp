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
            <div class="form-container-centered">
                <div class="form-card">
                    <div class="form-header">
                        <h2>📝 Phiếu Đặt Phòng</h2>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert-error" style="margin-bottom: 20px;">
                            ⚠️ ${error}
                        </div>
                    </c:if>

                    <%-- Thông tin phòng đang chọn --%>
                    <div class="info-section">
                        <p style="margin: 0;">Đang thực hiện cho: <strong>Phòng ${room.roomNumber}</strong></p>
                        <p style="margin: 5px 0 0 0; font-size: 0.9rem; color: #666;">
                            Loại phòng: ${room.roomType.typeName}
                        </p>
                    </div>

                    <form method="post" action="booking">
                        <input type="hidden" name="roomId" value="${room.roomId}">

                        <div class="grid-form">
                            <div class="form-group full-width">
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

                            <div class="form-group full-width">
                                <label class="form-label">Địa chỉ Email</label>
                                <input type="email" name="email" class="input-field" 
                                       placeholder="khachhang@example.com">
                            </div>

                            <div class="form-group full-width">
                                <label class="form-label">Hình thức thuê phòng</label>
                                <select name="rentalTypeId" class="input-field">
                                    <option value="1">Thuê theo giờ (Hourly)</option>
                                    <option value="2">Thuê qua đêm (Overnight)</option>
                                    <option value="3">Thuê theo ngày (Daily)</option>
                                </select>
                            </div>
                        </div>

                        <div style="margin-top: 30px; display: flex; gap: 15px;">
                            <button type="submit" class="btn btn-success" style="flex: 2;">
                                ✅ XÁC NHẬN ĐẶT PHÒNG
                            </button>
                            <a href="rooms" class="btn" style="flex: 1; background: #eee; color: #333;">
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
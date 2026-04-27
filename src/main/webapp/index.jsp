<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Trang chủ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="d-flex flex-column min-vh-100">
        <jsp:include page="includes/header.jsp" />
        <main class="flex-grow-1">
            <div class="container mt-5 text-center">
                <h1 class="display-4">Chào mừng bạn đến với Khách sạn của chúng tôi</h1>
                <p class="lead">Trải nghiệm kỳ nghỉ tuyệt vời với dịch vụ đẳng cấp.</p>
                <hr class="my-4">
                <a href="#" class="btn btn-primary btn-lg">Xem danh sách phòng</a>
            </div>
        </main>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng ký tài khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex flex-column min-vh-100">
        <jsp:include page="includes/header.jsp" />
        <main class="flex-grow-1">
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow">
                            <div class="card-body">
                                <h3 class="text-center mb-4">Đăng ký thành viên</h3>
                                <form action="RegisterServlet" method="POST">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label>Tài khoản</label>
                                            <input type="text" name="username" class="form-control" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Họ và tên</label>
                                            <input type="text" name="fullname" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label>Mật khẩu</label>
                                        <input type="password" name="password" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn btn-success w-100">Hoàn tất đăng ký</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
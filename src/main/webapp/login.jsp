<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng nhập</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex flex-column min-vh-100">
        <jsp:include page="includes/header.jsp" />
        <main class="flex-grow-1">
            <div class="container mt-5">
                <div class="row justify-content-center">
                    <div class="col-md-4">
                        <div class="card shadow">
                            <div class="card-body">
                                <h3 class="text-center mb-4">Đăng nhập</h3>
                                <form action="LoginServlet" method="POST">
                                    <div class="mb-3">
                                        <label>Tài khoản</label>
                                        <input type="text" name="username" class="form-control" required>
                                    </div>
                                    <div class="mb-3">
                                        <label>Mật khẩu</label>
                                        <input type="password" name="password" class="form-control" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                                </form>
                                <p class="text-center mt-3">Chưa có tài khoản? <a href="register.jsp">Đăng ký tại đây</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
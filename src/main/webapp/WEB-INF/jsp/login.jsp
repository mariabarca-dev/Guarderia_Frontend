<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Guardería</title>
    <!-- Inclusión centralizada del head (Favicon, Bootstrap y CSS personalizado) -->
    <jsp:include page="head.jsp" />
</head>
<body class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <h3 class="text-center mb-4">Iniciar Sesión</h3>

            <!-- Tu formulario va aquí -->
            <form action="/do-login" method="POST">
                <div class="mb-3">
                    <label>Usuario:</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Contraseña:</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Ingresar</button>
            </form>

        </div>
    </div>
</body>
</html>
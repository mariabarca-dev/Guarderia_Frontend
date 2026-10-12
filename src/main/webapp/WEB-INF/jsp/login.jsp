<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Guardería Central</title>
    <!-- Inclusión centralizada del head (Favicon, Bootstrap y CSS personalizado) -->
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light d-flex align-items-center justify-content-center vh-100">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">

                <!-- Tarjeta contenedora de Bootstrap -->
                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">

                        <!-- Bloque de la Imagen (que ya incluye el logo, título y subtítulo) -->
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/images/logo.jpg"
                                 alt="Guardería Central - Sistema de Gestión"
                                 class="img-fluid rounded shadow-sm"
                                 style="width: 100%; object-fit: contain;">
                        </div>

                        <!-- Alerta por si existen errores de autenticación -->
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show py-2 small" role="alert">
                                Usuario o contraseña incorrectos.
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Formulario de Login -->
                        <form action="${pageContext.request.contextPath}/do-login" method="POST">

                            <!-- Token CSRF obligatorio para peticiones POST con Spring Security -->
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="mb-3">
                                <label for="username" class="form-label">Usuario:</label>
                                <input type="text" id="username" name="username" class="form-control" required autofocus>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña:</label>
                                <input type="password" id="password" name="password" class="form-control" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm">Ingresar</button>
                        </form>

                    </div>
                </div>

            </div>
        </div>
    </div>

</body>
</html>
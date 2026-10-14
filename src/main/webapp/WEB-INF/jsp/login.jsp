<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp" />
    <title>Login - Guardería Central</title>
</head>
<body class="bg-light d-flex align-items-center vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <img src="<c:url value='/images/logo.jpg'/>" alt="Logo" class="img-fluid mb-3" style="max-height: 100px;">
                    <h4 class="card-title mb-4">Guardería Central</h4>

                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger" role="alert">
                            Usuario o contraseña incorrectos.
                        </div>
                    </c:if>
                    <c:if test="${param.expired != null}">
                        <div class="alert alert-warning" role="alert">
                            Su sesión expiró, ingrese nuevamente.
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success" role="alert">
                            Ha cerrado sesión correctamente.
                        </div>
                    </c:if>

                    <form action="<c:url value='/login'/>" method="post" autocomplete="off">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3 text-start">
                            <label for="username" class="form-label">Usuario</label>
                            <input type="text" class="form-control" id="username" name="username" required autocomplete="off">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="password" class="form-label">Contraseña</label>
                            <input type="password" class="form-control" id="password" name="password" required autocomplete="off">
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Ingresar</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
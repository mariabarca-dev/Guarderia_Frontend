<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Login: no usa el layout ni el menú. Los campos nunca se precargan y los mensajes salen solo
     de los códigos de la URL (?error, ?error=servidor, ?logout, ?expired): nunca repiten lo escrito. --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp"/>
    <title>Ingresar - Guardería Central</title>
</head>
<body class="bg-light d-flex align-items-center min-vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="Logo"
                         class="img-fluid mb-3" style="max-height: 100px;">
                    <h4 class="card-title mb-4">Guardería Central</h4>

                    <c:choose>
                        <c:when test="${param.error == 'servidor'}">
                            <div class="alert alert-danger" role="alert">
                                <c:out value="No se pudo conectar con el servidor. Intentá de nuevo en unos minutos."/>
                            </div>
                        </c:when>
                        <c:when test="${param.error != null}">
                            <div class="alert alert-danger" role="alert">
                                <c:out value="Usuario o clave incorrectos."/>
                            </div>
                        </c:when>
                        <c:when test="${param.expired != null}">
                            <div class="alert alert-warning" role="alert">
                                <c:out value="Tu sesión venció. Ingresá nuevamente."/>
                            </div>
                        </c:when>
                        <c:when test="${param.logout != null}">
                            <div class="alert alert-success" role="alert">
                                <c:out value="Cerraste sesión correctamente."/>
                            </div>
                        </c:when>
                    </c:choose>

                    <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="off">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="mb-3 text-start">
                            <label for="username" class="form-label">Usuario</label>
                            <input type="text" class="form-control" id="username" name="username"
                                   required maxlength="50" pattern="[a-zA-Z0-9_.\-]+" autocomplete="off"
                                   title="Solo letras, números, punto, guion y guion bajo">
                        </div>
                        <div class="mb-3 text-start">
                            <label for="password" class="form-label">Clave</label>
                            <input type="password" class="form-control" id="password" name="password"
                                   required maxlength="100" autocomplete="off">
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

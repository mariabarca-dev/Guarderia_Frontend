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
<%-- --q es el tamaño del logo. El fondo repite el degradé del borde del logo para que se una sin cortes. --%>
<body class="d-flex flex-column align-items-center justify-content-center min-vh-100 py-3"
      style="--q: min(95vw, 125vh);
             background: linear-gradient(90deg, #030208 calc(50% - var(--q) / 2), #3431c6 calc(50% + var(--q) / 2));">

    <%-- Logo original (camioneta, título y subtítulo), recortado a su franja central --%>
    <div style="width: var(--q); height: calc(var(--q) * 0.40);
                background: url('${pageContext.request.contextPath}/images/logo.jpg') center 45% / 100% auto no-repeat;"
         role="img" aria-label="Guardería Central - Sistema de gestión de motorhomes, casas rodantes y trailers">
    </div>

    <%-- Recuadro blanco con el formulario, centrado abajo --%>
    <div class="container mt-3">
        <div class="row justify-content-center">
            <div class="col-11 col-sm-8 col-md-6 col-lg-4">
                <div class="card shadow card-login">
                    <div class="card-body text-center">

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
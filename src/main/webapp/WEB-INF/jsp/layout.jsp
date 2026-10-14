<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp" />
    <title>Guardería Central</title>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Header Central -->
    <header class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <img src="<c:url value='/images/logo.jpg'/>" alt="Logo" width="30" height="30" class="d-inline-block align-text-top me-2">
                Guardería Central
            </a>
            <div class="d-flex align-items-center text-white">
                <span class="me-3">Usuario: <strong><c:out value="${nombreUsuario}"/></strong></span>
                <form action="<c:url value='/logout'/>" method="post" class="d-inline">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-light btn-sm">Cerrar Sesión</button>
                </form>
            </div>
        </div>
    </header>

    <!-- Menú Dinámico según ROL -->
    <nav class="bg-secondary p-2 mb-3">
        <div class="container">
            <jsp:include page="/WEB-INF/jsp/${rol}/menu.jsp" />
        </div>
    </nav>

    <!-- Contenido Dinámico -->
    <main class="container flex-grow-1">
        <c:if test="${not empty mensajeError}">
            <div class="alert alert-danger" role="alert">
                <c:out value="${mensajeError}"/>
            </div>
        </c:if>
        <c:if test="${not empty mensajeExito}">
            <div class="alert alert-success" role="alert">
                <c:out value="${mensajeExito}"/>
            </div>
        </c:if>

        <jsp:include page="/WEB-INF/jsp/${contenido}.jsp" />
    </main>

    <!-- Footer Central -->
    <footer class="bg-light text-center text-muted py-3 mt-auto border-top">
        <div class="container">
            <small>&copy; Guardería Central - Todos los derechos reservados</small>
        </div>
    </footer>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- VISTA BASE ÚNICA para todos los roles.
     - El menú se incluye por convención de nombre: menu/<rol>.jsp (rol lo carga ModeloGlobalAdvice).
     - El contenido se incluye con el atributo "vista", que fija SIEMPRE el controller. --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp"/>
    <title>Guardería Central<c:if test="${not empty titulo}"> - <c:out value="${titulo}"/></c:if></title>
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

<header class="navbar navbar-dark bg-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="Logo" width="30" height="30"
                 class="d-inline-block align-text-top me-2">
            Guardería Central
        </span>
        <span class="text-white">
            Usuario: <strong><c:out value="${nombreUsuario}"/></strong>
            <span class="badge bg-secondary ms-1 text-uppercase"><c:out value="${rol}"/></span>
        </span>
    </div>
</header>

<nav class="bg-secondary py-2 mb-4">
    <div class="container">
        <jsp:include page="/WEB-INF/jsp/menu/${rol}.jsp"/>
    </div>
</nav>

<main class="container flex-grow-1">
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger" role="alert"><c:out value="${mensajeError}"/></div>
    </c:if>
    <c:if test="${not empty mensajeExito}">
        <div class="alert alert-success" role="alert"><c:out value="${mensajeExito}"/></div>
    </c:if>

    <jsp:include page="/WEB-INF/jsp/${vista}.jsp"/>
</main>

<footer class="bg-light text-center text-muted py-3 mt-4 border-top">
    <div class="container">
        <small>&copy; Guardería Central - Todos los derechos reservados</small>
    </div>
</footer>

</body>
</html>

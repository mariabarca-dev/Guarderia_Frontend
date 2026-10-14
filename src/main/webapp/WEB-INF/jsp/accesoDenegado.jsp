<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp" />
    <title>Acceso Denegado</title>
</head>
<body class="bg-light d-flex align-items-center vh-100 text-center">
<div class="container">
    <h1 class="display-1 fw-bold text-danger">403</h1>
    <h2 class="mb-3">Acceso Denegado</h2>
    <p class="lead">No tienes permisos para acceder a este recurso.</p>
    <a href="<c:url value='/login'/>" class="btn btn-primary">Volver al Inicio</a>
</div>
</body>
</html>
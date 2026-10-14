<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Error del Sistema - Guardería Central</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">

<div class="container d-flex flex-column justify-content-center align-items-center min-vh-100">
    <div class="card border-danger shadow text-center" style="max-width: 550px; width: 100%;">
        <div class="card-header bg-danger text-white fw-bold py-3">
            <h4 class="mb-0">¡Vaya! Ocurrió un error inesperado</h4>
        </div>
        <div class="card-body p-4">
            <div class="mb-3">
                <span class="badge bg-danger fs-6 px-3 py-2">Error del Servidor</span>
            </div>

            <p class="text-muted mb-3">
                Lo sentimos, ha ocurrido un inconveniente al procesar su solicitud en el sistema.
            </p>

            <c:if test="${not empty mensajeError}">
                <div class="alert alert-danger text-start small mb-3">
                    <c:out value="${mensajeError}"/>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-secondary text-start small mb-3">
                    <c:if test="${not empty errorCode}">
                        <strong><c:out value="${errorCode}"/></strong> -
                    </c:if>
                    <c:out value="${errorMessage}"/>
                </div>
            </c:if>

            <div class="d-grid gap-2">
                <a href="<c:url value='/'/>" class="btn btn-primary fw-bold">
                    Volver al Inicio
                </a>
            </div>
        </div>
        <div class="card-footer text-muted small py-2">
            Guardería Central &copy; 2026
        </div>
    </div>
</div>

</body>
</html>
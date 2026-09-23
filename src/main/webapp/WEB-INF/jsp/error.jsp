<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Error del Sistema - Guardería Central</title>
    <!-- Inclusión centralizada del head -->
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

            <%-- Opcional: Mostrar detalles técnicos solo si la excepción está presente --%>
            <c:if test="${not empty pageContext.exception}">
                <div class="alert alert-secondary text-start small mb-4" style="max-height: 150px; overflow-y: auto;">
                    <strong>Detalle técnico:</strong>
                    <code>${pageContext.exception}</code>
                </div>
            </c:if>

            <div class="d-grid gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary fw-bold">
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
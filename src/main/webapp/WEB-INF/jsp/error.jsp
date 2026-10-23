<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Página de error. La usan:
     - BackendExceptionAdvice, con "mensajeError" (error del back sin pantalla anterior a la que volver);
     - Spring Boot para errores del contenedor (404, 500...), con "status" y "error". Nunca muestra stacktrace. --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp"/>
    <title>Error - Guardería Central</title>
</head>
<body class="bg-light d-flex align-items-center min-vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-warning">
                <div class="card-body text-center">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="Logo"
                         class="img-fluid mb-3" style="max-height: 80px;">
                    <h4>Ocurrió un problema</h4>
                    <c:choose>
                        <c:when test="${not empty mensajeError}">
                            <div class="alert alert-danger"><c:out value="${mensajeError}"/></div>
                        </c:when>
                        <c:when test="${status == 404}">
                            <div class="alert alert-warning"><c:out value="La página solicitada no existe."/></div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger">
                                <c:out value="Ocurrió un error inesperado"/>
                                <c:if test="${not empty status}"> (<c:out value="${status}"/>)</c:if>.
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Volver al inicio</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

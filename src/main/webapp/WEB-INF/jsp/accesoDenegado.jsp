<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <jsp:include page="/WEB-INF/jsp/head.jsp"/>
    <title>Acceso denegado - Guardería Central</title>
</head>
<body class="bg-light d-flex align-items-center min-vh-100">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-danger">
                <div class="card-body text-center">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="Logo"
                         class="img-fluid mb-3" style="max-height: 80px;">
                    <h4 class="text-danger">Acceso denegado</h4>
                    <p class="text-muted"><c:out value="No tenés permisos para ver esta pantalla."/></p>
                    <%-- "/" lleva al login, que redirige al panel del rol si la sesión sigue abierta --%>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Volver a mi panel</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

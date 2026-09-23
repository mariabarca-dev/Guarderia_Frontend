<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Panel Principal - Guardería Central</title>
    <!-- Inclusión centralizada del head (Favicon, Bootstrap y CSS personalizado) -->
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">

    <!-- Navbar común para todos -->
    <nav class="navbar navbar-dark bg-dark px-4">
        <span class="navbar-brand">Guardería Central - Rol: ${sessionScope.userRole}</span>
        <a href="/logout" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
    </nav>

    <div class="container mt-4">
        <c:choose>
            <c:when test="${sessionScope.userRole == 'SYSADMIN'}">
                <jsp:include page="dash/sysadmin-panel.jsp" />
            </c:when>
            <c:when test="${sessionScope.userRole == 'ADMIN'}">
                <jsp:include page="dash/admin-panel.jsp" />
            </c:when>
            <c:when test="${sessionScope.userRole == 'EMPLEADO'}">
                <jsp:include page="dash/empleado-panel.jsp" />
            </c:when>
            <c:otherwise>
                <jsp:include page="dash/socio-panel.jsp" />
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>
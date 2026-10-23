<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- userName y userRole los carga SysadminController en el modelo (desde Spring Security) --%>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Guardería Central - Panel de Administración General (SysAdmin)</title>
    <!-- Inclusión centralizada del head (Favicon, Bootstrap y CSS personalizado) -->
    <jsp:include page="/WEB-INF/jsp/head.jsp" />
</head>
<body class="bg-light">

<!-- VALIDACIÓN VISUAL DE ROL (la protección real está en SecurityConfig) -->
<c:choose>
    <c:when test="${userRole == 'SYSADMIN'}">

        <!-- 1. BARRA DE NAVEGACIÓN SUPERIOR / HEADER -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
            <div class="container-fluid">
                <a class="navbar-brand fw-bold text-danger" href="${pageContext.request.contextPath}/sysadmin/dash">
                    Guardería Central | <span class="text-white fs-6">Panel SysAdmin</span>
                </a>
                <div class="d-flex align-items-center">
                    <span class="navbar-text me-3 text-light">
                        Superusuario: <strong><c:out value="${not empty userName ? userName : userRole}" /></strong>
                        (<span class="badge bg-danger"><c:out value="${userRole}" /></span>)
                    </span>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-outline-danger btn-sm">Cerrar Sesión</button>
                    </form>
                </div>
            </div>
        </nav>

        <div class="container-fluid px-4">

            <!-- ALERTAS Y MENSAJES INFORMATIVOS DEL SERVIDOR -->
            <c:if test="${not empty mensajeExito}">
                <div class="alert alert-success fade show mb-4" role="alert">
                    <strong>¡Éxito!</strong> <c:out value="${mensajeExito}" />
                </div>
            </c:if>
            <c:if test="${not empty mensajeError}">
                <div class="alert alert-danger fade show mb-4" role="alert">
                    <strong>Error:</strong> <c:out value="${mensajeError}" />
                </div>
            </c:if>

            <!-- 2. TARJETAS DE MÉTRICAS GLOBALES (CARDS) -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="card bg-primary text-white shadow-sm h-100">
                        <div class="card-body">
                            <h6 class="card-title text-uppercase fw-bold opacity-75">Administradores</h6>
                            <h2 class="display-6 fw-bold mb-0">
                                <c:out value="${not empty totalAdmins ? totalAdmins : 0}" />
                            </h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-info text-white shadow-sm h-100">
                        <div class="card-body">
                            <h6 class="card-title text-uppercase fw-bold opacity-75">Empleados</h6>
                            <h2 class="display-6 fw-bold mb-0">
                                <c:out value="${not empty totalEmpleados ? totalEmpleados : 0}" />
                            </h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-success text-white shadow-sm h-100">
                        <div class="card-body">
                            <h6 class="card-title text-uppercase fw-bold opacity-75">Socios Activos</h6>
                            <h2 class="display-6 fw-bold mb-0">
                                <c:out value="${not empty totalSocios ? totalSocios : 0}" />
                            </h2>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card bg-warning text-dark shadow-sm h-100">
                        <div class="card-body">
                            <h6 class="card-title text-uppercase fw-bold opacity-75">Alertas de Ocupación</h6>
                            <h2 class="display-6 fw-bold mb-0">
                                <c:out value="${not empty alertasOcupacion ? alertasOcupacion : 0}" />
                            </h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 3. PANEL DE ACCESOS RÁPIDOS (ACCIONES ADMINISTRATIVAS) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-secondary text-white fw-bold">
                    Acciones y Controles Avanzados del Sistema
                </div>
                <div class="card-body">
                    <div class="row g-2">
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/admin/crear" class="btn btn-primary w-100 fw-bold">
                                + Crear Nuevo Administrador
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/reportes/globales" class="btn btn-dark w-100 fw-bold">
                                Generar Reportes Globales
                            </a>
                        </div>
                        <div class="col-md-4">
                            <a href="${pageContext.request.contextPath}/auditoria" class="btn btn-danger w-100 fw-bold">
                                Ver Logs de Auditoría
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. TABLA DE LISTADO Y CONTROL DE ADMINISTRADORES -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span>Listado de Administradores Registrados</span>
                    <span class="badge bg-danger">Modo Administrador Maestro</span>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty administradores}">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre Completo</th>
                                        <th>Usuario</th>
                                        <th>Dirección</th>
                                        <th>Teléfono</th>
                                        <th>Rol</th>
                                        <th class="text-end">Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="admin" items="${administradores}">
                                        <tr>
                                            <td><strong>#<c:out value="${admin.id}" /></strong></td>
                                            <td>
                                                <c:out value="${admin.nombre}" /> <c:out value="${admin.apellido}" />
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary"><c:out value="${admin.nombreUsuario}" /></span>
                                            </td>
                                            <td><c:out value="${admin.direccion}" /></td>
                                            <td><c:out value="${admin.telefono}" /></td>
                                            <td>
                                                <span class="badge bg-primary"><c:out value="${admin.rol}" /></span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/admin/editar?id=${admin.id}"
                                                   class="btn btn-warning btn-sm fw-bold">Modificar</a>
                                                <form action="${pageContext.request.contextPath}/admin/baja" method="POST" class="d-inline"
                                                      onsubmit="return confirm('¿Seguro que querés dar de baja a este administrador?');">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="id" value="${admin.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm fw-bold">Dar de Baja</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-4 text-center text-muted">
                                <p class="mb-0">No se encontraron administradores registrados en el sistema.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>

    </c:when>

    <%-- CASO DE DENEGACIÓN DE ACCESO: SI NO ES SYSADMIN --%>
    <c:otherwise>
        <div class="container d-flex flex-column justify-content-center align-items-center min-vh-100">
            <div class="card border-danger shadow text-center" style="max-width: 500px; width: 100%;">
                <div class="card-header bg-danger text-white fw-bold py-3">
                    <h4 class="mb-0">Acceso Denegado</h4>
                </div>
                <div class="card-body p-4">
                    <p class="card-text text-danger fs-5 fw-semibold mb-3">
                        Permisos Insuficientes
                    </p>
                    <p class="text-muted mb-4">
                        Su rol actual (<strong><c:out value="${not empty userRole ? userRole : 'SIN ROL'}" /></strong>) no le otorga autorización para acceder a esta área. Este panel es de uso exclusivo para el Superusuario del Sistema (SYSADMIN).
                    </p>
                    <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-outline-danger w-100 fw-bold">
                            Volver al Inicio de Sesión
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

</body>
</html>

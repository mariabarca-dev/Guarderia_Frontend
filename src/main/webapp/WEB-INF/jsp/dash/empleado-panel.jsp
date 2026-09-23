<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Obtención de atributos de sesión --%>
<c:set var="userRole" value="${sessionScope.userRole}" />
<c:set var="usuario" value="${sessionScope.usuarioSesion}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Empleado - Estacionamiento</title>
    <!-- Bootstrap CDN Clásico -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN -->
<nav class="navbar navbar-expand-lg navbar-dark bg-secondary mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Empleado</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Empleado: <strong>${usuario.nombre} ${usuario.apellido}</strong>
                (<span class="badge bg-light text-dark">${userRole}</span>)
            </span>
            <!-- Logout puramente por POST Servidor -->
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-outline-light btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container px-4">

    <!-- ALERTAS Y MENSAJES -->
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> ${mensajeError}
        </div>
    </c:if>

    <!-- EVALUACIÓN DE ROL: EMPLEADO -->
    <c:choose>
        <c:when test="${userRole == 'EMPLEADO'}">

            <!-- ENCABEZADO DE BIENVENIDA -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h4 class="card-title mb-1">Bienvenido, ${usuario.nombre} ${usuario.apellido}</h4>
                    <p class="card-text text-muted mb-0">Consulte sus zonas asignadas y los vehículos bajo su responsabilidad.</p>
                </div>
            </div>

            <div class="row">
                <!-- SECCIÓN 1: ZONAS ASIGNADAS -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white fw-bold">
                            Zonas Asignadas
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Letra / Identificador</th>
                                        <th>Tipo Vehículo Permitido</th>
                                        <th>Capacidad Máxima</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="zona" items="${zonasAsignadas}">
                                        <tr>
                                            <td><span class="badge bg-primary">Zona ${zona.letra}</span></td>
                                            <td>${zona.tipoVehiculo}</td>
                                            <td>${zona.capacidadVehiculos} vehículos</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty zonasAsignadas}">
                                        <tr>
                                            <td colspan="3" class="text-center text-muted p-3">No tiene zonas asignadas actualmente.</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 2: VEHÍCULOS A CARGO -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-info text-dark fw-bold">
                            Vehículos a Su Cargo
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Matrícula</th>
                                        <th>Marca / Nombre</th>
                                        <th>Tipo / Modelo</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="vehiculo" items="${vehiculosACargo}">
                                        <tr>
                                            <td>${vehiculo.id}</td>
                                            <td><span class="badge bg-secondary">${vehiculo.matricula}</span></td>
                                            <td>${vehiculo.nombre}</td>
                                            <td>${vehiculo.tipo}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty vehiculosACargo}">
                                        <tr>
                                            <td colspan="4" class="text-center text-muted p-3">No tiene vehículos asignados bajo su cargo.</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </c:when>

        <c:otherwise>
            <!-- MENSAJE DE RESTRICCIÓN DE ACCESO -->
            <div class="alert alert-danger shadow-sm mt-4" role="alert">
                <h4 class="alert-heading">Acceso Denegado</h4>
                <p class="mb-0">
                    Usted no posee los permisos de <strong>EMPLEADO</strong> para consultar esta información.
                    Su rol actual es: <strong>${userRole}</strong>.
                </p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
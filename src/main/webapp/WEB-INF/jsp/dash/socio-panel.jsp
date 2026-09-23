
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
    <title>Panel de Socio - Estacionamiento</title>
    <!-- Bootstrap CDN Clásico -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Socio</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Socio: <strong>${usuario.nombre} ${usuario.apellido}</strong>
                (<span class="badge bg-light text-primary">${userRole}</span>)
            </span>
            <!-- Logout mediante POST Servidor (Regla F & G) -->
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

    <!-- EVALUACIÓN DE ROL EXACTO: SOCIO (Regla C) -->
    <c:choose>
        <c:when test="${userRole == 'SOCIO'}">

            <!-- ENCABEZADO DE BIENVENIDA -->
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h4 class="card-title mb-1">Bienvenido/a, ${usuario.nombre} ${usuario.apellido}</h4>
                    <p class="card-text text-muted mb-0">Consulte el estado de sus vehículos registrados y garages en propiedad.</p>
                </div>
            </div>

            <div class="row">
                <!-- SECCIÓN 1: MIS VEHÍCULOS (Cardinalidad Socio-Vehiculo 1 -> N) -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white fw-bold">
                            Mis Vehículos Registrados
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
                                        <th>Dimensiones (An x Prof)</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="vehiculo" items="${misVehiculos}">
                                        <tr>
                                            <td>${vehiculo.id}</td>
                                            <td><span class="badge bg-secondary">${vehiculo.matricula}</span></td>
                                            <td>${vehiculo.nombre}</td>
                                            <td>${vehiculo.tipo}</td>
                                            <td>${vehiculo.ancho}m x ${vehiculo.profundidad}m</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty misVehiculos}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted p-3">No posee vehículos registrados actualmente.</td>
                                        </tr>
                                    </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECCIÓN 2: MIS GARAGES EN PROPIEDAD (PropiedadGarageDTO - Reglas D y E) -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-primary text-white fw-bold">
                            Mis Garages en Propiedad
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>N° Garage</th>
                                        <th>Piso / Ubicación</th>
                                        <th>Fecha Adquisición</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="propiedad" items="${misGarages}">
                                        <tr>
                                            <td><span class="badge bg-success">Garage #${propiedad.garage.id}</span></td>
                                            <td>${propiedad.garage.ubicacion}</td>
                                            <td>${propiedad.fechaCompraGarage}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty misGarages}">
                                        <tr>
                                            <td colspan="3" class="text-center text-muted p-3">No posee garages registrados a su nombre.</td>
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
            <!-- MENSAJE DE RESTRICCIÓN DE ACCESO (Regla C) -->
            <div class="alert alert-danger shadow-sm mt-4" role="alert">
                <h4 class="alert-heading">Acceso Denegado</h4>
                <p class="mb-0">
                    Usted no posee los permisos de <strong>SOCIO</strong> para consultar este panel.
                    Su rol actual es: <strong>${userRole}</strong>.
                </p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
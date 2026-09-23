<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- DECLARACIÓN DE BEANS Y VARIABLES DE SESIÓN --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%--noinspection ElSpecValidation--%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Asignaciones de Vehículos a Garages</title>
    <!-- Bootstrap 5 CDN Clásico (Cero JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Gestión de Asignaciones (Vehículo - Garage)</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Usuario: <strong><c:out value="${usuarioSesion.nombre}" /></strong>
                (<span class="badge bg-secondary"><c:out value="${userRole}" /></span>)
            </span>
            <!-- Cierre de sesión por formulario POST con token CSRF -->
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
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> <c:out value="${mensajeExito}" />
        </div>
    </c:if>
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> <c:out value="${mensajeError}" />
        </div>
    </c:if>

    <!-- EVALUACIÓN DE ROLES CON JSTL: ACCESO A VISTA DE NEGOCIO (SOCIO, EMPLEADO, ADMINISTRADOR) -->
    <c:choose>
        <c:when test="${userRole == 'ADMINISTRADOR' || userRole == 'EMPLEADO' || userRole == 'SOCIO'}">

            <!-- TARJETA PRINCIPAL: LISTADO Y REGISTRO DE ASIGNACIONES A GARAGE -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span>Listado de Asignaciones de Vehículos a Garages</span>

                        <%-- BOTÓN DE CREACIÓN: VISIBLE EXCLUSIVAMENTE PARA ADMINISTRADORES DE NEGOCIO --%>
                    <c:if test="${userRole == 'ADMINISTRADOR'}">
                        <form action="${pageContext.request.contextPath}/asignaciones-garage/nueva" method="GET" class="m-0">
                            <button type="submit" class="btn btn-success btn-sm">+ Asignar Vehículo a Garage</button>
                        </form>
                    </c:if>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty listaAsignacionesGarage}">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID Vehículo</th>
                                        <th>Vehículo / Marca</th>
                                        <th>Matrícula</th>
                                        <th>Tipo</th>
                                        <th>Garage Asignado (ID / Num)</th>
                                        <th>Fecha de Asignación</th>

                                            <%-- COLUMNA DE ACCIONES SOLAMENTE PARA ADMINISTRADORES DE NEGOCIO --%>
                                        <c:if test="${userRole == 'ADMINISTRADOR'}">
                                            <th class="text-end">Acciones</th>
                                        </c:if>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="asig" items="${listaAsignacionesGarage}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-secondary">
                                                    <c:out value="${asig.vehiculo.id != null ? asig.vehiculo.id : 'N/A'}" />
                                                </span>
                                            </td>
                                            <td>
                                                <strong>
                                                    <c:out value="${asig.vehiculo.nombre != null ? asig.vehiculo.nombre : 'Sin Vehículo'}" />
                                                </strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">
                                                    <c:out value="${asig.vehiculo.matricula != null ? asig.vehiculo.matricula : 'N/A'}" />
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-info text-dark">
                                                    <c:out value="${asig.vehiculo.tipo != null ? asig.vehiculo.tipo : 'N/A'}" />
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-dark fs-6">
                                                    Garage #<c:out value="${asig.garage.id != null ? asig.garage.id : (asig.garage.numero != null ? asig.garage.numero : 'N/A')}" />
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty asig.fechaAsignacionGarage}">
                                                        <span class="badge bg-light text-dark border">
                                                            <c:out value="${asig.fechaAsignacionGarage}" />
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Sin Fecha Registrada</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                                <%-- BOTONES DE ACCIÓN EXCLUSIVOS PARA ADMINISTRADORES DE NEGOCIO --%>
                                            <c:if test="${userRole == 'ADMINISTRADOR'}">
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/asignaciones-garage/editar" method="GET" class="d-inline">
                                                        <input type="hidden" name="vehiculoId" value="${asig.vehiculo.id}">
                                                        <input type="hidden" name="garageId" value="${asig.garage.id}">
                                                        <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/asignaciones-garage/eliminar" method="POST" class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <input type="hidden" name="vehiculoId" value="${asig.vehiculo.id}">
                                                        <input type="hidden" name="garageId" value="${asig.garage.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm">Desasignar</button>
                                                    </form>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-4 text-center text-muted">
                                <p class="mb-0">No hay asignaciones de vehículos a garages registradas en el sistema.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- FORMULARIO DE FILTRADO / BÚSQUEDA TRADICIONAL (GET, CERO JAVASCRIPT) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    Filtrar Asignaciones
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/asignaciones-garage/buscar" method="GET" class="row g-3">
                        <div class="col-md-3">
                            <label for="vehiculoMatricula" class="form-label">Matrícula Vehículo</label>
                            <input type="text" class="form-control" id="vehiculoMatricula" name="vehiculo.matricula" value="${param['vehiculo.matricula']}" placeholder="Ej. ABC-1234">
                        </div>
                        <div class="col-md-3">
                            <label for="garageId" class="form-label">ID / N° Garage</label>
                            <input type="number" class="form-control" id="garageId" name="garage.id" value="${param['garage.id']}" placeholder="Ej. 101">
                        </div>
                        <div class="col-md-3">
                            <label for="fechaAsignacionGarage" class="form-label">Fecha Asignación</label>
                            <input type="date" class="form-control" id="fechaAsignacionGarage" name="fechaAsignacionGarage" value="${param.fechaAsignacionGarage}">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary me-2">Buscar</button>
                            <a href="${pageContext.request.contextPath}/asignaciones-garage/dashboard" class="btn btn-secondary">Limpiar</a>
                        </div>
                    </form>
                </div>
            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO EN CASO DE ROL NO AUTORIZADO (INCLUYE SYSADMIN AL SER PANTALLA DE NEGOCIO) --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong><c:out value="${userRole}" /></strong>) no tiene los permisos necesarios para visualizar la gestión de asignaciones de vehículos a garages.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
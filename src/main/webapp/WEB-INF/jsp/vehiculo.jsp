<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- DECLARACIÓN DE BEANS Y VARIABLES DE SESIÓN (PREVIENE ADVERTENCIAS Y ERRORES DE LINTER EN INTELLIJ) --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%-- Supresión de inspección de IntelliJ para la propiedad dinámica de sesión --%>
<%--noinspection ElSpecValidation--%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Gestión de Vehículos</title>
    <!-- Bootstrap 5 CDN Clásico (Cero JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Gestión de Vehículos</a>
        <div class="d-flex align-items-center">
                <span class="navbar-text me-3 text-light">
                    <%-- Resolución dinámica del objeto de sesión --%>
                    Usuario: <strong>${usuarioSesion.nombre}</strong>
                    (<span class="badge bg-secondary">${userRole}</span>)
                </span>
            <!-- Cierre de sesión por formulario POST tradicional -->
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <button type="submit" class="btn btn-outline-danger btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">

    <!-- ALERTAS Y MENSAJES INFORMATIVOS DEL SERVIDOR -->
    <c:if test="${not empty mensajeExito}">
        <div class="alert alert-success fade show" role="alert">
            <strong>¡Éxito!</strong> ${mensajeExito}
        </div>
    </c:if>
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger fade show" role="alert">
            <strong>Error:</strong> ${mensajeError}
        </div>
    </c:if>

    <!-- EVALUACIÓN DE ROLES CON JSTL: ACCESO GENERAL AL DASHBOARD -->
    <c:choose>
        <c:when test="${userRole == 'ADMIN' || userRole == 'SYSADMIN' || userRole == 'EMPLEADO' || userRole == 'SOCIO'}">

            <!-- TARJETA PRINCIPAL: LISTADO Y REGISTRO DE VEHÍCULOS -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span>Listado General de Vehículos</span>

                        <%-- BOTÓN DE CREACIÓN: VISIBLE EXCLUSIVAMENTE PARA ADMINISTRADORES --%>
                    <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                        <form action="${pageContext.request.contextPath}/vehiculos/nuevo" method="GET" class="m-0">
                            <button type="submit" class="btn btn-success btn-sm">+ Registrar Nuevo Vehículo</button>
                        </form>
                    </c:if>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty listaVehiculos}">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Nombre / Marca</th>
                                        <th>Matrícula</th>
                                        <th>Tipo / Modelo</th>
                                        <th>Dimensiones (Ancho x Prof.)</th>
                                        <th>ID Socio</th>
                                        <th>ID Empleado Cargo</th>

                                            <%-- COLUMNA DE ACCIONES SOLAMENTE PARA ADMINS --%>
                                        <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                            <th class="text-end">Acciones</th>
                                        </c:if>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="v" items="${listaVehiculos}">
                                        <tr>
                                            <td>${v.id}</td>
                                            <td><strong>${v.nombre}</strong></td>
                                            <td><span class="badge bg-secondary">${v.matricula}</span></td>
                                            <td><span class="badge bg-info text-dark">${v.tipo}</span></td>
                                            <td>${v.ancho} m x ${v.profundidad} m</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.socioId > 0}">
                                                        <span class="badge bg-light text-dark border">Socio #${v.socioId}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Sin Asignar</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${v.empleadoId > 0}">
                                                        <span class="badge bg-light text-dark border">Empleado #${v.empleadoId}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Sin Asignar</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                                <%-- BOTONES DE ACCIÓN EXCLUSIVOS PARA ADMINISTRADORES --%>
                                            <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                                <td class="text-end">
                                                    <form action="${pageContext.request.contextPath}/vehiculos/editar" method="GET" class="d-inline">
                                                        <input type="hidden" name="id" value="${v.id}">
                                                        <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/vehiculos/eliminar" method="POST" class="d-inline">
                                                        <input type="hidden" name="id" value="${v.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm">Borrar</button>
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
                                <p class="mb-0">No hay vehículos registrados en el sistema.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- FORMULARIO DE FILTRADO / BÚSQUEDA TRADICIONAL (CERO JAVASCRIPT) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    Filtrar Vehículos
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/vehiculos/buscar" method="GET" class="row g-3">
                        <div class="col-md-3">
                            <label for="matricula" class="form-label">Matrícula</label>
                            <input type="text" class="form-control" id="matricula" name="matricula" value="${param.matricula}" placeholder="Ej. ABC-1234">
                        </div>
                        <div class="col-md-3">
                            <label for="nombre" class="form-label">Nombre / Marca</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" value="${param.nombre}" placeholder="Ej. Toyota">
                        </div>
                        <div class="col-md-3">
                            <label for="tipo" class="form-label">Tipo / Modelo</label>
                            <input type="text" class="form-control" id="tipo" name="tipo" value="${param.tipo}" placeholder="Ej. SUV">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary me-2">Buscar</button>
                            <a href="${pageContext.request.contextPath}/vehiculos/dashboard" class="btn btn-secondary">Limpiar</a>
                        </div>
                    </form>
                </div>
            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO EN CASO DE ROL NO AUTORIZADO --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong>${userRole}</strong>) no tiene los permisos necesarios para visualizar la gestión de vehículos.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
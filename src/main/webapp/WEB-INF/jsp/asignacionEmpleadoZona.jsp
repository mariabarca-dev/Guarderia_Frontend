<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- DECLARACIÓN DE BEANS Y VARIABLES DE SESIÓN PARA PREVENIR ADVERTENCIAS EN INTELLIJ --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%-- Carga explícita del rol exacto del usuario desde la sesión --%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Asignaciones de Empleados a Zonas</title>
    <!-- Bootstrap 5 CDN Clásico (Cero JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Gestión de Asignaciones (Empleado - Zona)</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Usuario: <strong><c:out value="${usuarioSesion.nombre}" /></strong>
                (<span class="badge bg-secondary"><c:out value="${userRole}" /></span>)
            </span>

            <!-- Cierre de sesión seguro vía POST con token CSRF -->
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

    <!-- EVALUACIÓN DE ROLES CON JSTL: MATRIZ DE ACCESO A ENTIDADES DE NEGOCIO -->
    <c:choose>
        <%-- Acceso permitido únicamente a roles con lectura o gestión de Negocio --%>
        <c:when test="${userRole == 'ADMINISTRADOR' || userRole == 'EMPLEADO' || userRole == 'SOCIO'}">

            <!-- TARJETA PRINCIPAL: LISTADO Y REGISTRO DE ASIGNACIONES -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span>Listado de Asignaciones de Empleados por Zona</span>

                        <%-- BOTÓN DE CREACIÓN: VISIBLE EXCLUSIVAMENTE PARA ADMINISTRADORES DE NEGOCIO --%>
                    <c:if test="${userRole == 'ADMINISTRADOR'}">
                        <form action="${pageContext.request.contextPath}/asignaciones/nueva" method="GET" class="m-0">
                            <button type="submit" class="btn btn-success btn-sm">+ Asignar Empleado a Zona</button>
                        </form>
                    </c:if>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty listaAsignaciones}">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID Empleado</th>
                                        <th>Empleado</th>
                                        <th>Zona Asignada</th>
                                        <th>Tipo de Vehículo de Zona</th>
                                        <th>Capacidad de Zona</th>
                                        <th>Vehículos a Cargo</th>

                                            <%-- COLUMNA DE ACCIONES SOLAMENTE PARA ADMINISTRADOR --%>
                                        <c:if test="${userRole == 'ADMINISTRADOR'}">
                                            <th class="text-end">Acciones</th>
                                        </c:if>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="asig" items="${listaAsignaciones}">
                                        <tr>
                                            <td>
                                                    <span class="badge bg-secondary">
                                                        <c:out value="${asig.empleado.id != null ? asig.empleado.id : 'N/A'}" />
                                                    </span>
                                            </td>
                                            <td>
                                                <strong>
                                                    <c:out value="${asig.empleado.nombre != null ? asig.empleado.nombre : 'Sin Empleado'}" />
                                                </strong>
                                            </td>
                                            <td>
                                                    <span class="badge bg-dark fs-6">
                                                        Zona <c:out value="${asig.zona.letra != null ? asig.zona.letra : 'N/A'}" />
                                                    </span>
                                            </td>
                                            <td>
                                                    <span class="badge bg-info text-dark">
                                                        <c:out value="${asig.zona.tipoVehiculo != null ? asig.zona.tipoVehiculo : 'N/A'}" />
                                                    </span>
                                            </td>
                                            <td>
                                                <c:out value="${asig.zona.capacidadVehiculos}" /> lugares
                                            </td>
                                            <td>
                                                    <span class="badge bg-primary fs-6">
                                                        <c:out value="${asig.cantVehiculosACargo}" /> vehículos
                                                    </span>
                                            </td>

                                                <%-- BOTONES DE EDICIÓN Y ELIMINACIÓN EXCLUSIVOS PARA ADMINISTRADOR --%>
                                            <c:if test="${userRole == 'ADMINISTRADOR'}">
                                                <td class="text-end">
                                                    <!-- Formulario GET para pantalla de edición -->
                                                    <form action="${pageContext.request.contextPath}/asignaciones/editar" method="GET" class="d-inline">
                                                        <input type="hidden" name="empleadoId" value="${asig.empleado.id}">
                                                        <input type="hidden" name="zonaId" value="${asig.zona.id}">
                                                        <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                    </form>

                                                    <!-- Formulario POST para eliminación con CSRF obligatorio -->
                                                    <form action="${pageContext.request.contextPath}/asignaciones/eliminar" method="POST" class="d-inline">
                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                        <input type="hidden" name="empleadoId" value="${asig.empleado.id}">
                                                        <input type="hidden" name="zonaId" value="${asig.zona.id}">
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
                                <p class="mb-0">No hay asignaciones de empleados a zonas registradas en el sistema.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- FORMULARIO DE FILTRADO TRADICIONAL (CERO JAVASCRIPT) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    Filtrar Asignaciones
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/asignaciones/buscar" method="GET" class="row g-3">
                        <div class="col-md-4">
                            <label for="empleadoNombre" class="form-label">Nombre de Empleado</label>
                            <input type="text" class="form-control" id="empleadoNombre" name="empleado.nombre" value="${param['empleado.nombre']}" placeholder="Ej. Juan Pérez">
                        </div>
                        <div class="col-md-4">
                            <label for="zonaLetra" class="form-label">Letra de Zona</label>
                            <input type="text" class="form-control" id="zonaLetra" name="zona.letra" value="${param['zona.letra']}" placeholder="Ej. A">
                        </div>
                        <div class="col-md-4 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary me-2">Buscar</button>
                            <a href="${pageContext.request.contextPath}/asignaciones/dashboard" class="btn btn-secondary">Limpiar</a>
                        </div>
                    </form>
                </div>
            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO EN CASO DE SYSADMIN O ROL NO AUTORIZADO EN NEGOCIO --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong><c:out value="${userRole}" /></strong>) no posee permisos sobre las pantallas de gestión de negocio.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
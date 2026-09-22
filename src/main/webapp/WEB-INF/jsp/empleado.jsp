<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- DECLARACIÓN DE BEANS Y VARIABLES DE SESIÓN (EVITA ALERTAS Y MARCAS ROJAS EN INTELLIJ) --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%-- Supresión de inspección de IntelliJ para la propiedad dinámica de sesión --%>
<%--noinspection ElSpecValidation--%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Empleado</title>
    <!-- Bootstrap 5 CDN Clásico (Sin dependencias ni ejecuciones de JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel General del Empleado</a>
        <div class="d-flex align-items-center">
                <span class="navbar-text me-3 text-light">
                    <%-- Resolución dinámica del objeto de sesión --%>
                    Empleado: <strong>${usuarioSesion.nombre}</strong>
                    (<span class="badge bg-secondary">${userRole}</span>)
                </span>
            <!-- Cierre de sesión por formulario tradicional POST (Cero JS) -->
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

    <!-- EVALUACIÓN DE ROLES CON JSTL: VERIFICACIÓN DE ACCESO PARA EMPLEADO O ADMINS -->
    <c:choose>
        <c:when test="${userRole == 'EMPLEADO' || userRole == 'ADMIN' || userRole == 'SYSADMIN'}">

            <!-- 1. SECCIÓN: DATOS PERSONALES DEL EMPLEADO LOGUEADO -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-dark shadow-sm">
                        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>Información del Empleado</span>
                            <span class="badge bg-info text-dark">Código: ${datosEmpleado.codigo}</span>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty datosEmpleado}">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label class="form-label text-muted mb-0">Nombre Completo</label>
                                            <p class="fw-bold mb-0">${datosEmpleado.nombre} ${datosEmpleado.apellido}</p>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label text-muted mb-0">Usuario</label>
                                            <p class="fw-bold mb-0">${datosEmpleado.nombreUsuario}</p>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label text-muted mb-0">Código Empleado</label>
                                            <p class="fw-bold mb-0">${datosEmpleado.codigo}</p>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label text-muted mb-0">Especialidad</label>
                                            <p class="fw-bold mb-0"><span class="badge bg-primary">${datosEmpleado.especialidad}</span></p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Dirección</label>
                                            <p class="fw-bold mb-0">${datosEmpleado.direccion}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Teléfono</label>
                                            <p class="fw-bold mb-0">${datosEmpleado.telefono}</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-danger mb-0">No se pudieron cargar los datos del empleado.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- BOTONES DE EDICIÓN EXCLUSIVOS PARA ADMINISTRADORES -->
                        <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                            <div class="card-footer bg-light text-end">
                                <form action="${pageContext.request.contextPath}/admin/empleados/editar" method="GET" class="d-inline">
                                    <input type="hidden" name="id" value="${datosEmpleado.id}">
                                    <button type="submit" class="btn btn-warning btn-sm">Editar Ficha Empleado (Modo Admin)</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 2. SECCIÓN: TABLAS DE GESTIÓN (ZONAS Y VEHÍCULOS A CARGO) -->
            <div class="row">

                <!-- TABLA 1: ZONAS ASIGNADAS -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-secondary text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>1. Mis Zonas Asignadas</span>
                                <%-- Control de botón Crear/Asignar para Admins --%>
                            <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                <form action="${pageContext.request.contextPath}/admin/zonas/asignar" method="GET" class="m-0">
                                    <button type="submit" class="btn btn-success btn-sm">+ Asignar Zona</button>
                                </form>
                            </c:if>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty listaZonas}">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped mb-0 align-middle">
                                            <thead class="table-light">
                                            <tr>
                                                <th>Zona</th>
                                                <th>Capacidad Vehículos</th>
                                                <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                                    <th class="text-end">Acciones</th>
                                                </c:if>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="z" items="${listaZonas}">
                                                <tr>
                                                    <td><span class="badge bg-dark">Zona ${z.letra}</span></td>
                                                    <td>${z.capacidadVehiculos} lugares</td>

                                                        <%-- Acciones solo visibles para roles administrativos --%>
                                                    <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                                        <td class="text-end">
                                                            <form action="${pageContext.request.contextPath}/admin/zonas/editar" method="GET" class="d-inline">
                                                                <input type="hidden" name="letra" value="${z.letra}">
                                                                <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/zonas/desasignar" method="POST" class="d-inline">
                                                                <input type="hidden" name="letra" value="${z.letra}">
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
                                        <p class="mb-0">No tiene zonas asignadas actualmente.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- TABLA 2: VEHÍCULOS A CARGO -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-secondary text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>2. Vehículos Bajo mi Responsabilidad</span>
                                <%-- Control de botón Asignar Responsabilidad para Admins --%>
                            <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                <form action="${pageContext.request.contextPath}/admin/vehiculos/asignar-empleado" method="GET" class="m-0">
                                    <button type="submit" class="btn btn-success btn-sm">+ Asignar Vehículo</button>
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
                                                <th>Matrícula</th>
                                                <th>Tipo</th>
                                                <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                                    <th class="text-end">Acciones</th>
                                                </c:if>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="v" items="${listaVehiculos}">
                                                <tr>
                                                    <td>${v.id}</td>
                                                    <td><span class="badge bg-secondary">${v.matricula}</span></td>
                                                    <td>${v.tipo}</td>

                                                        <%-- Acciones solo visibles para roles administrativos --%>
                                                    <c:if test="${userRole == 'ADMIN' || userRole == 'SYSADMIN'}">
                                                        <td class="text-end">
                                                            <form action="${pageContext.request.contextPath}/admin/vehiculos/editar" method="GET" class="d-inline">
                                                                <input type="hidden" name="id" value="${v.id}">
                                                                <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/vehiculos/remover-responsable" method="POST" class="d-inline">
                                                                <input type="hidden" name="id" value="${v.id}">
                                                                <button type="submit" class="btn btn-danger btn-sm">Quitar</button>
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
                                        <p class="mb-0">No tiene vehículos asignados a su cargo.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO EN CASO DE INTENTO NO AUTORIZADO --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong>${userRole}</strong>) no posee los permisos requeridos para acceder a este panel de empleados.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Declaración de beans para compatibilidad en IDEs --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%-- Definición simplificada del rol desde la sesión --%>
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
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">Panel General de Empleado</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Empleado: <strong><c:out value="${usuarioSesion.nombre}" /></strong>
                (<span class="badge bg-secondary"><c:out value="${userRole}" /></span>)
            </span>
            <!-- Cierre de sesión por formulario POST (Cero JS + Token CSRF) -->
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-outline-danger btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">

    <!-- MENSAJES DE ERROR Y ÉXITO ENVIADOS POR EL CONTROLADOR -->
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

    <!-- EVALUACIÓN DE ROLES CON C:CHOOSE SEGÚN LA MATRIZ DE PERMISOS -->
    <c:choose>
        <%-- VISTA PARA EMPLEADO O SOCIO (Solo lectura) --%>
        <c:when test="${userRole == 'EMPLEADO' || userRole == 'SOCIO'}">

            <!-- 1. SECCIÓN: DATOS PERSONALES DEL EMPLEADO LOGUEADO -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-dark shadow-sm">
                        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>Información Personal de Empleado</span>
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
                    </div>
                </div>
            </div>

            <!-- 2. SECCIÓN: TABLA DE ASIGNACIONES EMPLEADO-ZONA (N a N) -->
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="card shadow-sm">
                        <div class="card-header bg-secondary text-white fw-bold">
                            <span>Mis Zonas y Vehículos Asignados</span>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty listaAsignacionesZona}">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped mb-0 align-middle">
                                            <thead class="table-light">
                                            <tr>
                                                <th>Zona (Letra)</th>
                                                <th>Vehículos a Cargo</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="asig" items="${listaAsignacionesZona}">
                                                <tr>
                                                    <td><span class="badge bg-dark">Zona ${asig.zonaLetra}</span></td>
                                                    <td><strong>${asig.cantVehiculosACargo}</strong> vehículo(s)</td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-4 text-center text-muted">
                                        <p class="mb-0">No tiene asignaciones de zona registradas actualmente.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

        </c:when>

        <%-- VISTA PARA ADMINISTRADOR (Entidades de Negocio) --%>
        <c:when test="${userRole == 'ADMINISTRADOR'}">

            <!-- INFORMACIÓN DEL EMPLEADO CON CONSULTA Y EDICIÓN DE NEGOCIO -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-dark shadow-sm">
                        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>Gestión de Datos del Empleado (Vista Administrador)</span>
                            <span class="badge bg-info text-dark">Código: ${datosEmpleado.codigo}</span>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label text-muted mb-0">Nombre Completo</label>
                                    <p class="fw-bold mb-0">${datosEmpleado.nombre} ${datosEmpleado.apellido}</p>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label text-muted mb-0">Especialidad</label>
                                    <p class="fw-bold mb-0"><span class="badge bg-primary">${datosEmpleado.especialidad}</span></p>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label text-muted mb-0">Teléfono</label>
                                    <p class="fw-bold mb-0">${datosEmpleado.telefono}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- GRILLA DE GESTIÓN DE ASIGNACIONES EMPLEADO-ZONA (ADMINISTRADOR) -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>Asignaciones de Zonas y Cargas de Vehículos (Empleado - Zona)</span>
                            <a href="${pageContext.request.contextPath}/asignacion-zona/nueva" class="btn btn-light btn-sm">+ Nueva Asignación</a>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty listaAsignacionesZona}">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped mb-0 align-middle">
                                            <thead class="table-light">
                                            <tr>
                                                <th>ID Asignación</th>
                                                <th>Zona</th>
                                                <th>Cant. Vehículos a Cargo</th>
                                                <th class="text-end">Acciones</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="asig" items="${listaAsignacionesZona}">
                                                <tr>
                                                    <td>${asig.id}</td>
                                                    <td><span class="badge bg-dark">Zona ${asig.zonaLetra}</span></td>
                                                    <td>${asig.cantVehiculosACargo}</td>
                                                    <td class="text-end">
                                                        <form action="${pageContext.request.contextPath}/asignacion-zona/eliminar" method="POST" class="d-inline">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                            <input type="hidden" name="id" value="${asig.id}">
                                                            <button type="submit" class="btn btn-danger btn-sm">Dar de Baja</button>
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
                                        <p class="mb-0">No existen asignaciones de zonas registradas para este empleado.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

        </c:when>

        <%-- VISTA PARA SYSADMIN (Gestión Exclusiva de Usuarios) --%>
        <c:when test="${userRole == 'SYSADMIN'}">

            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-warning shadow-sm">
                        <div class="card-header bg-warning text-dark fw-bold d-flex justify-content-between align-items-center">
                            <span>Administración de Cuenta de Usuario Empleado</span>
                            <span class="badge bg-dark text-white">SYSADMIN Modo</span>
                        </div>
                        <div class="card-body">
                            <p class="card-text">Gestión del usuario de sistema asociado al empleado: <strong>${datosEmpleado.nombreUsuario}</strong></p>
                            <form action="${pageContext.request.contextPath}/usuarios/editar" method="GET" class="d-inline">
                                <input type="hidden" name="id" value="${datosEmpleado.usuarioId}">
                                <button type="submit" class="btn btn-primary btn-sm">Editar Cuenta de Usuario</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/usuarios/eliminar" method="POST" class="d-inline">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="id" value="${datosEmpleado.usuarioId}">
                                <button type="submit" class="btn btn-danger btn-sm">Dar de Baja Usuario</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO SI OCURRE UN ROL NO CONTEMPLADO --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong><c:out value="${userRole}" /></strong>) no tiene un perfil configurado en este dashboard.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
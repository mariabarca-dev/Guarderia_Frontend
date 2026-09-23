<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración Central</title>
    <!-- CDN de Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />
<c:set var="userRole" value="${sessionScope.userRole}" />

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">Panel de Administración Central</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Usuario: <strong>${usuarioSesion.nombreUsuario}</strong>
                (<span class="badge bg-info text-dark">${userRole}</span>)
            </span>
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-outline-danger btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">

    <!-- ALERTAS Y MENSAJES DEL SERVIDOR -->
    <c:set var="mensajeExito" value="${requestScope.mensajeExito}" />
    <c:set var="mensajeError" value="${requestScope.mensajeError}" />
    <c:if test="${not empty mensajeExito}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>¡Éxito!</strong> ${mensajeExito}
        </div>
    </c:if>
    <c:if test="${not empty mensajeError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>Error:</strong> ${mensajeError}
        </div>
    </c:if>

    <!-- EVALUACIÓN PRINCIPAL DE ROLES -->
    <c:choose>
        <%-- ROLES CON PERMISO DE ESCRITURA EN NEGOCIO: ADMINISTRADOR --%>
        <c:when test="${sessionScope.userRole == 'ADMINISTRADOR'}">

            <!-- 1. FORMULARIOS DE REGISTRO DE ENTIDADES DE NEGOCIO -->
            <div class="row mb-4">
                <!-- ALTA VEHÍCULO (Con dropdown de Socio - Relación 1->N) -->
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card h-100 border-warning">
                        <div class="card-header bg-warning text-dark font-weight-bold">Alta Vehículo</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/vehiculos/crear" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="mb-2">
                                    <label class="form-label small">Socio Propietario</label>
                                    <select name="socioId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione un socio...</option>
                                        <c:forEach var="socio" items="${listaSocios}">
                                            <option value="${socio.id}">${socio.apellido}, ${socio.nombre} (DNI: ${socio.dni})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <input type="text" name="matricula" class="form-control form-control-sm" placeholder="Matrícula" required>
                                </div>
                                <div class="mb-2">
                                    <input type="text" name="nombre" class="form-control form-control-sm" placeholder="Nombre / Marca" required>
                                </div>
                                <div class="mb-2">
                                    <input type="text" name="tipo" class="form-control form-control-sm" placeholder="Tipo / Modelo" required>
                                </div>
                                <div class="mb-2">
                                    <input type="number" step="0.01" name="profundidad" class="form-control form-control-sm" placeholder="Profundidad" required>
                                </div>
                                <div class="mb-2">
                                    <input type="number" step="0.01" name="ancho" class="form-control form-control-sm" placeholder="Ancho" required>
                                </div>
                                <button type="submit" class="btn btn-warning btn-sm w-100">Registrar Vehículo</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ALTA GARAJE Y ZONA -->
                <div class="col-md-6 col-lg-4 mb-3">
                    <div class="card h-100 border-info">
                        <div class="card-header bg-info text-dark font-weight-bold">Infraestructura</div>
                        <div class="card-body">
                            <!-- Formulario Garaje -->
                            <form action="${pageContext.request.contextPath}/admin/garajes/crear" method="POST" class="mb-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <h6>Nuevo Garaje</h6>
                                <div class="mb-1"><input type="number" name="numeroGarage" class="form-control form-control-sm" placeholder="N° Garaje" required></div>
                                <div class="mb-1"><input type="number" step="0.1" name="lecturaInicialLuz" class="form-control form-control-sm" placeholder="Lectura Luz" required></div>
                                <div class="mb-1">
                                    <select name="zonaId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione Zona...</option>
                                        <c:forEach var="zona" items="${listaZonas}">
                                            <option value="${zona.id}">Zona ${zona.letra}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-info btn-sm w-100">Alta Garaje</button>
                            </form>
                            <hr>
                            <!-- Formulario Zona -->
                            <form action="${pageContext.request.contextPath}/admin/zonas/crear" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <h6>Nueva Zona</h6>
                                <div class="row g-1 mb-1">
                                    <div class="col"><input type="text" name="letra" class="form-control form-control-sm" placeholder="Letra" required></div>
                                    <div class="col"><input type="number" name="capacidadVehiculos" class="form-control form-control-sm" placeholder="Capacidad" required></div>
                                </div>
                                <div class="mb-1"><input type="text" name="tipoVehiculo" class="form-control form-control-sm" placeholder="Tipo Permitido" required></div>
                                <div class="row g-1 mb-1">
                                    <div class="col"><input type="number" step="0.01" name="ancho" class="form-control form-control-sm" placeholder="Ancho" required></div>
                                    <div class="col"><input type="number" step="0.01" name="largo" class="form-control form-control-sm" placeholder="Largo" required></div>
                                </div>
                                <button type="submit" class="btn btn-secondary btn-sm w-100">Alta Zona</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- OPERACIONES: PROPIEDAD GARAJE Y ASIGNACIÓN VEHÍCULO-GARAJE -->
                <div class="col-md-12 col-lg-4 mb-3">
                    <div class="card h-100 border-dark">
                        <div class="card-header bg-dark text-white font-weight-bold">Operaciones de Negocio</div>
                        <div class="card-body">
                            <!-- Venta Garaje a Socio (PropiedadGarageDTO) -->
                            <form action="${pageContext.request.contextPath}/admin/operaciones/venta-garage" method="POST" class="mb-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <h6>Venta de Garaje a Socio</h6>
                                <div class="mb-2">
                                    <select name="socioId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione Socio...</option>
                                        <c:forEach var="socio" items="${listaSocios}">
                                            <option value="${socio.id}">${socio.apellido}, ${socio.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <select name="garageId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione Garaje Libre...</option>
                                        <c:forEach var="garaje" items="${listaGarajesLibres}">
                                            <option value="${garaje.id}">Garaje N° ${garaje.numeroGarage}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2"><input type="date" name="fechaCompra" class="form-control form-control-sm" required></div>
                                <button type="submit" class="btn btn-outline-dark btn-sm w-100">Registrar Propiedad</button>
                            </form>
                            <hr>
                            <!-- Asignar Vehículo a Garaje (1 a 1, dropdowns de selección única) -->
                            <form action="${pageContext.request.contextPath}/admin/operaciones/asignar-vehiculo" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <h6>Asignar Vehículo a Garaje</h6>
                                <div class="mb-2">
                                    <select name="vehiculoId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione Vehículo...</option>
                                        <c:forEach var="vehiculo" items="${listaVehiculosSinGarage}">
                                            <option value="${vehiculo.id}">${vehiculo.matricula} - ${vehiculo.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <select name="garageId" class="form-select form-select-sm" required>
                                        <option value="">Seleccione Garaje...</option>
                                        <c:forEach var="garaje" items="${listaGarajes}">
                                            <option value="${garaje.id}">Garaje N° ${garaje.numeroGarage}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-2"><input type="date" name="fechaAsignacion" class="form-control form-control-sm" required></div>
                                <button type="submit" class="btn btn-outline-dark btn-sm w-100">Asignar Vehículo</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- ROLES CON PERMISO DE ESCRITURA EN USUARIOS: SYSADMIN --%>
        <c:when test="${sessionScope.userRole == 'SYSADMIN'}">
            <div class="row mb-4">
                <!-- ALTA SOCIO (CUENTA) -->
                <div class="col-md-6 mb-3">
                    <div class="card border-primary">
                        <div class="card-header bg-primary text-white font-weight-bold">Alta Usuario Socio</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/sysadmin/socios/crear" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="dni" maxlength="8" class="form-control form-control-sm" placeholder="DNI (máx 8)" required></div>
                                    <div class="col"><input type="text" name="nombre" class="form-control form-control-sm" placeholder="Nombre" required></div>
                                    <div class="col"><input type="text" name="apellido" class="form-control form-control-sm" placeholder="Apellido" required></div>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="direccion" class="form-control form-control-sm" placeholder="Dirección" required></div>
                                    <div class="col"><input type="text" name="telefono" maxlength="10" class="form-control form-control-sm" placeholder="Teléfono" required></div>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="nombreUsuario" class="form-control form-control-sm" placeholder="Usuario" required></div>
                                    <div class="col"><input type="password" name="clave" class="form-control form-control-sm" placeholder="Contraseña" required></div>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm w-100">Registrar Socio</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ALTA EMPLEADO (CUENTA) -->
                <div class="col-md-6 mb-3">
                    <div class="card border-success">
                        <div class="card-header bg-success text-white font-weight-bold">Alta Usuario Empleado</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/sysadmin/empleados/crear" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="nombre" class="form-control form-control-sm" placeholder="Nombre" required></div>
                                    <div class="col"><input type="text" name="apellido" class="form-control form-control-sm" placeholder="Apellido" required></div>
                                    <div class="col"><input type="text" name="codigoEmpleado" maxlength="3" class="form-control form-control-sm" placeholder="Código (3 car.)" required></div>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="especialidad" class="form-control form-control-sm" placeholder="Especialidad" required></div>
                                    <div class="col"><input type="text" name="direccion" class="form-control form-control-sm" placeholder="Dirección" required></div>
                                    <div class="col"><input type="text" name="telefono" maxlength="10" class="form-control form-control-sm" placeholder="Teléfono" required></div>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col"><input type="text" name="nombreUsuario" class="form-control form-control-sm" placeholder="Usuario" required></div>
                                    <div class="col"><input type="password" name="clave" class="form-control form-control-sm" placeholder="Contraseña" required></div>
                                </div>
                                <button type="submit" class="btn btn-success btn-sm w-100">Registrar Empleado</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- MODO SOLO LECTURA: SOCIO O EMPLEADO --%>
        <c:otherwise>
            <div class="alert alert-info">
                <strong>Modo Consulta:</strong> Su rol actual (<strong>${sessionScope.userRole}</strong>) sólo le permite visualizar la información del sistema.
            </div>
        </c:otherwise>
    </c:choose>

    <!-- 2. REPORTES DE DISPONIBILIDAD (ACCESIBLE PARA TODOS) -->
    <c:if test="${not empty reporteDisponibilidad}">
        <div class="card mb-4">
            <div class="card-header bg-secondary text-white font-weight-bold">Reporte de Disponibilidad y Ocupación General</div>
            <div class="card-body">
                <ul class="list-group">
                    <c:forEach var="lineaReporte" items="${reporteDisponibilidad}">
                        <li class="list-group-item">${lineaReporte}</li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>

    <!-- 3. TABLA DE ASIGNACIÓN EMPLEADO - ZONA (GRILLA N a N CON ALTA Y BAJA POR FILA) -->
    <div class="card mb-4 border-secondary">
        <div class="card-header bg-secondary text-white font-weight-bold">Asignaciones Empleado - Zona (N a N)</div>
        <div class="card-body">
            <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                <form action="${pageContext.request.contextPath}/admin/asignaciones-zona/crear" method="POST" class="row g-2 mb-3">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="col-md-4">
                        <select name="empleadoId" class="form-select form-select-sm" required>
                            <option value="">Seleccione Empleado...</option>
                            <c:forEach var="emp" items="${listaEmpleados}">
                                <option value="${emp.id}">${emp.apellido}, ${emp.nombre} (${emp.codigoEmpleado})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <select name="zonaId" class="form-select form-select-sm" required>
                            <option value="">Seleccione Zona...</option>
                            <c:forEach var="zona" items="${listaZonas}">
                                <option value="${zona.id}">Zona ${zona.letra}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="number" name="cantVehiculosACargo" class="form-control form-control-sm" placeholder="Cant. Vehículos" required min="1">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-success btn-sm w-100">Asignar Zona</button>
                    </div>
                </form>
            </c:if>

            <div class="table-responsive">
                <table class="table table-hover table-striped mb-0 align-middle">
                    <thead>
                    <tr>
                        <th>Empleado</th>
                        <th>Zona</th>
                        <th>Vehículos a Cargo</th>
                        <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                            <th class="text-end">Acciones</th>
                        </c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="asig" items="${listaAsignacionesZona}">
                        <tr>
                            <td>${asig.nombreEmpleado}</td>
                            <td>Zona ${asig.letraZona}</td>
                            <td>${asig.cantVehiculosACargo}</td>
                            <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                <td class="text-end">
                                    <form action="${pageContext.request.contextPath}/admin/asignaciones-zona/eliminar" method="POST" class="d-inline">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <input type="hidden" name="id" value="${asig.id}">
                                        <button type="submit" class="btn btn-danger btn-sm">Dar de Baja</button>
                                    </form>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- 4. TABLAS DE CONSULTA Y GESTIÓN GENERAL -->
    <div class="row">
        <!-- TABLA DE SOCIOS -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-white font-weight-bold">Socios Registrados</div>
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>DNI</th>
                            <th>Nombre</th>
                            <th>Teléfono</th>
                            <c:if test="${sessionScope.userRole == 'SYSADMIN'}">
                                <th class="text-end">Acciones</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="socio" items="${listaSocios}">
                            <tr>
                                <td>${socio.id}</td>
                                <td>${socio.dni}</td>
                                <td>${socio.nombre} ${socio.apellido}</td>
                                <td>${socio.telefono}</td>
                                <c:if test="${sessionScope.userRole == 'SYSADMIN'}">
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/sysadmin/socios/editar" method="GET" class="d-inline">
                                            <input type="hidden" name="id" value="${socio.id}">
                                            <button type="submit" class="btn btn-warning btn-sm">Modificar</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/sysadmin/socios/eliminar" method="POST" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="id" value="${socio.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TABLA DE VEHÍCULOS -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-white font-weight-bold">Vehículos Registrados</div>
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Matrícula</th>
                            <th>Nombre/Marca</th>
                            <th>Tipo</th>
                            <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                <th class="text-end">Acciones</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="vehiculo" items="${listaVehiculos}">
                            <tr>
                                <td>${vehiculo.id}</td>
                                <td>${vehiculo.matricula}</td>
                                <td>${vehiculo.nombre}</td>
                                <td>${vehiculo.tipo}</td>
                                <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/vehiculos/editar" method="GET" class="d-inline">
                                            <input type="hidden" name="id" value="${vehiculo.id}">
                                            <button type="submit" class="btn btn-warning btn-sm">Modificar</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/vehiculos/eliminar" method="POST" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="id" value="${vehiculo.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- TABLA DE GARAJES -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-white font-weight-bold">Garajes</div>
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead>
                        <tr>
                            <th>N° Garaje</th>
                            <th>Zona</th>
                            <th>Lectura Luz</th>
                            <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                <th class="text-end">Acciones</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="garaje" items="${listaGarajes}">
                            <tr>
                                <td>${garaje.numeroGarage}</td>
                                <td>${garaje.letraZona}</td>
                                <td>${garaje.lecturaInicialLuz}</td>
                                <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/garajes/editar" method="GET" class="d-inline">
                                            <input type="hidden" name="numeroGarage" value="${garaje.numeroGarage}">
                                            <button type="submit" class="btn btn-warning btn-sm">Modificar</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/garajes/eliminar" method="POST" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="numeroGarage" value="${garaje.numeroGarage}">
                                            <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TABLA DE ZONAS -->
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-header bg-white font-weight-bold">Zonas</div>
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead>
                        <tr>
                            <th>Letra</th>
                            <th>Tipo Permitido</th>
                            <th>Capacidad</th>
                            <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                <th class="text-end">Acciones</th>
                            </c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="zona" items="${listaZonas}">
                            <tr>
                                <td>${zona.letra}</td>
                                <td>${zona.tipoVehiculo}</td>
                                <td>${zona.capacidadVehiculos}</td>
                                <c:if test="${sessionScope.userRole == 'ADMINISTRADOR'}">
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/admin/zonas/editar" method="GET" class="d-inline">
                                            <input type="hidden" name="id" value="${zona.id}">
                                            <button type="submit" class="btn btn-warning btn-sm">Modificar</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/zonas/eliminar" method="POST" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="id" value="${zona.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />
<%--noinspection ElSpecValidation--%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - Operaciones Centrales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel de Administración Operativa</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Usuario: <strong>${usuarioSesion.nombre}</strong>
                (<span class="badge bg-warning text-dark">${userRole}</span>)
            </span>
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-outline-danger btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">

    <!-- ALERTAS -->
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

    <!-- EVALUACIÓN DE ROL: ADMINISTRADOR -->
    <c:choose>
        <c:when test="${userRole == 'ADMINISTRADOR'}">

            <!-- SECCIÓN 1: FORMULARIOS TRANSACCIONALES -->
            <div class="row">
                <!-- VENTA DE GARAJE -->
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-primary text-white fw-bold">Registrar Venta de Garaje</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin-panel/venta-garage" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="mb-3">
                                    <label for="socioId" class="form-label">Socio Comprador</label>
                                    <select class="form-select" id="socioId" name="socioId" required>
                                        <option value="">Seleccione Socio...</option>
                                        <c:forEach var="s" items="${listaSocios}">
                                            <option value="${s.id}">${s.apellido}, ${s.nombre} (DNI: ${s.dni})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="garageId" class="form-label">Garaje Libre</label>
                                    <select class="form-select" id="garageId" name="garageId" required>
                                        <option value="">Seleccione Garaje...</option>
                                        <c:forEach var="g" items="${listaGaragesLibres}">
                                            <option value="${g.id}">Garaje N° ${g.numeroGarage} (Zona ${g.zona})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="fechaCompraGarage" class="form-label">Fecha de Compra</label>
                                    <input type="date" class="form-control" id="fechaCompraGarage" name="fechaCompraGarage" required>
                                </div>

                                <button type="submit" class="btn btn-primary w-100">Registrar Venta</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ASIGNAR VEHÍCULO A GARAJE -->
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-success text-white fw-bold">Asignar Vehículo a Garaje</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin-panel/asignar-vehiculo" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="mb-3">
                                    <label for="vehiculoId" class="form-label">Vehículo</label>
                                    <select class="form-select" id="vehiculoId" name="vehiculoId" required>
                                        <option value="">Seleccione Vehículo...</option>
                                        <c:forEach var="v" items="${listaVehiculos}">
                                            <option value="${v.id}">${v.matricula} - ${v.nombre} (${v.tipo})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="garageIdAsig" class="form-label">Garaje</label>
                                    <select class="form-select" id="garageIdAsig" name="garageId" required>
                                        <option value="">Seleccione Garaje...</option>
                                        <c:forEach var="g" items="${listaGarages}">
                                            <option value="${g.id}">Garaje N° ${g.numeroGarage} (Zona ${g.zona})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="fechaAsignacionGarage" class="form-label">Fecha de Ocupación</label>
                                    <input type="date" class="form-control" id="fechaAsignacionGarage" name="fechaAsignacionGarage" required>
                                </div>

                                <button type="submit" class="btn btn-success w-100">Asignar Garaje</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ASIGNAR EMPLEADO A ZONA -->
                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white fw-bold">Carga de Personal en Zona</div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin-panel/asignar-empleado-zona" method="POST">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                                <div class="mb-3">
                                    <label for="empleadoId" class="form-label">Empleado</label>
                                    <select class="form-select" id="empleadoId" name="empleadoId" required>
                                        <option value="">Seleccione Empleado...</option>
                                        <c:forEach var="e" items="${listaEmpleados}">
                                            <option value="${e.id}">${e.apellido}, ${e.nombre} (${e.codigo})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="zonaId" class="form-label">Zona</label>
                                    <select class="form-select" id="zonaId" name="zonaId" required>
                                        <option value="">Seleccione Zona...</option>
                                        <c:forEach var="z" items="${listaZonas}">
                                            <option value="${z.id}">Zona ${z.letra} (${z.tipoVehiculo})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="cantVehiculosACargo" class="form-label">Vehículos a Cargo</label>
                                    <input type="number" class="form-control" id="cantVehiculosACargo" name="cantVehiculosACargo" min="1" required>
                                </div>

                                <button type="submit" class="btn btn-dark w-100">Asignar a Zona</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2: GRILLA N A N (ASIGNACIONES DE EMPLEADOS A ZONAS) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-secondary text-white fw-bold">
                    Grilla de Personal Asignado a Zonas
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Empleado</th>
                                <th>Código</th>
                                <th>Zona Asignada</th>
                                <th>Tipo Vehículo Zona</th>
                                <th>Vehículos a Cargo</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="asig" items="${listaAsignacionesEmp}">
                                <tr>
                                    <td>${asig.empleado.apellido}, ${asig.empleado.nombre}</td>
                                    <td><span class="badge bg-secondary">${asig.empleado.codigo}</span></td>
                                    <td><strong>Zona ${asig.zona.letra}</strong></td>
                                    <td>${asig.zona.tipoVehiculo}</td>
                                    <td><span class="badge bg-info text-dark">${asig.cantVehiculosACargo} vehículos</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaAsignacionesEmp}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted p-3">No hay asignaciones registradas actualmente.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 3: REPORTES Y DISPONIBILIDAD DE GARAJES -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-info text-dark fw-bold">
                    Reporte de Ocupación y Disponibilidad General
                </div>
                <div class="card-body">
                    <ul class="list-group">
                        <c:forEach var="linea" items="${reporteDisponibilidad}">
                            <li class="list-group-item">${linea}</li>
                        </c:forEach>
                        <c:if test="${empty reporteDisponibilidad}">
                            <li class="list-group-item text-muted">No hay información de disponibilidad disponible.</li>
                        </c:if>
                    </ul>
                </div>
            </div>

        </c:when>

        <c:otherwise>
            <div class="alert alert-danger shadow-sm mt-4" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Esta pantalla de gestión operativa requiere el rol <strong>ADMINISTRADOR</strong>. Su rol actual es <strong>${userRole}</strong>.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- DECLARACIÓN DE BEANS Y VARIABLES DE SESIÓN --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard de Socio</title>
    <!-- Bootstrap 5 CDN Clásico (Cero JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Panel General del Socio</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Socio: <strong>${usuarioSesion.nombre}</strong>
                (<span class="badge bg-light text-primary">${userRole}</span>)
            </span>
            <!-- Cierre de sesión por formulario tradicional POST con token CSRF -->
            <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-outline-light btn-sm">Cerrar Sesión</button>
            </form>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">

    <!-- ALERTAS Y MENSAJES DEL SERVIDOR -->
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

    <!-- EVALUACIÓN DE ROLES CON JSTL: VERIFICACIÓN DE ACCESO DE SOCIO Y ADMINISTRATIVO DE NEGOCIO -->
    <c:choose>
        <c:when test="${userRole == 'SOCIO' || userRole == 'EMPLEADO' || userRole == 'ADMINISTRADOR'}">

            <!-- 1. SECCIÓN: MIS DATOS PERSONALES -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card border-primary shadow-sm">
                        <div class="card-header bg-primary text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>1. Mis Datos Personales</span>
                            <span class="badge bg-light text-dark">DNI: ${datosSocio.dni}</span>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty datosSocio}">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Nombre Completo</label>
                                            <p class="fw-bold mb-0">${datosSocio.nombre} ${datosSocio.apellido}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Nombre de Usuario</label>
                                            <p class="fw-bold mb-0">${datosSocio.nombreUsuario}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">DNI</label>
                                            <p class="fw-bold mb-0">${datosSocio.dni}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Dirección</label>
                                            <p class="fw-bold mb-0">${datosSocio.direccion}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Teléfono</label>
                                            <p class="fw-bold mb-0">${datosSocio.telefono}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label text-muted mb-0">Fecha de Ingreso</label>
                                            <p class="fw-bold mb-0">${datosSocio.fechaIngreso}</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-danger mb-0">Error: No se pudieron cargar los datos personales del socio.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- ACCIONES ADMINISTRATIVAS EXCLUSIVAS PARA ADMINISTRADOR (ENTIDAD DE NEGOCIO) -->
                        <c:if test="${userRole == 'ADMINISTRADOR'}">
                            <div class="card-footer bg-light text-end">
                                <form action="${pageContext.request.contextPath}/admin/socios/editar" method="GET" class="d-inline">
                                    <input type="hidden" name="id" value="${datosSocio.id}">
                                    <button type="submit" class="btn btn-warning btn-sm">Editar Datos de Socio</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 2. SECCIÓN: TABLAS DE INFORMACIÓN RELACIONADA -->
            <div class="row">

                <!-- TABLA: VEHÍCULOS (RELACIÓN 1->N CON SOCIO) -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>2. Vehículos Registrados</span>
                            <c:if test="${userRole == 'ADMINISTRADOR'}">
                                <form action="${pageContext.request.contextPath}/admin/vehiculos/nuevo" method="GET" class="m-0">
                                    <input type="hidden" name="socioId" value="${datosSocio.id}">
                                    <button type="submit" class="btn btn-success btn-sm">+ Registrar Vehículo</button>
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
                                                <c:if test="${userRole == 'ADMINISTRADOR'}">
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
                                                    <c:if test="${userRole == 'ADMINISTRADOR'}">
                                                        <td class="text-end">
                                                            <form action="${pageContext.request.contextPath}/admin/vehiculos/editar" method="GET" class="d-inline">
                                                                <input type="hidden" name="id" value="${v.id}">
                                                                <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                            </form>
                                                            <form action="${pageContext.request.contextPath}/admin/vehiculos/eliminar" method="POST" class="d-inline">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
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
                                        <p class="mb-0">No se encuentran vehículos registrados.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- TABLA: GARAJES COMPRADOS / PROPIEDAD (PROPIEDADGARAGEDTO) -->
                <div class="col-lg-6 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                            <span>3. Garajes en Propiedad</span>
                            <c:if test="${userRole == 'ADMINISTRADOR'}">
                                <form action="${pageContext.request.contextPath}/admin/propiedad-garage/nuevo" method="GET" class="m-0">
                                    <input type="hidden" name="socioId" value="${datosSocio.id}">
                                    <button type="submit" class="btn btn-info btn-sm text-white">+ Asignar Garaje Libre</button>
                                </form>
                            </c:if>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty listaPropiedadesGarage}">
                                    <div class="table-responsive">
                                        <table class="table table-hover table-striped mb-0 align-middle">
                                            <thead class="table-light">
                                            <tr>
                                                <th>ID Garaje</th>
                                                <th>Zona</th>
                                                <th>Fecha Compra</th>
                                                <c:if test="${userRole == 'ADMINISTRADOR'}">
                                                    <th class="text-end">Acciones</th>
                                                </c:if>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <!-- Itera la lista de PropiedadGarageDTO (no GarageDTO directamente) -->
                                            <c:forEach var="pg" items="${listaPropiedadesGarage}">
                                                <tr>
                                                    <td>${pg.garageId}</td>
                                                    <td><span class="badge bg-info text-dark">Zona ${pg.zonaNombre}</span></td>
                                                    <td>${pg.fechaCompra}</td>
                                                    <c:if test="${userRole == 'ADMINISTRADOR'}">
                                                        <td class="text-end">
                                                            <form action="${pageContext.request.contextPath}/admin/propiedad-garage/desvincular" method="POST" class="d-inline">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                                <input type="hidden" name="id" value="${pg.id}">
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
                                        <p class="mb-0">No posee garajes registrados actualmente.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO PARA ROLES NO PERMITIDOS (POR EJEMPLO SYSADMIN TRATANDO DE ACCEDER A VISTA DE NEGOCIO) --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong>${userRole}</strong>) no está autorizado para visualizar o gestionar este panel de entidades de negocio.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
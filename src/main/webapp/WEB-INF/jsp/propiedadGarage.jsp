<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Declaración de beans para compatibilidad en IDEs --%>
<jsp:useBean id="usuarioSesion" type="java.lang.Object" scope="session" />

<%-- Definición del rol de usuario desde la sesión --%>
<c:set var="userRole" value="${sessionScope.userRole}" />

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Propiedades de Garages (Socio - Garage)</title>
    <!-- Bootstrap 5 CDN Clásico (Cero JavaScript) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<!-- BARRA DE NAVEGACIÓN SUPERIOR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">Panel de Propiedades de Garages</a>
        <div class="d-flex align-items-center">
            <span class="navbar-text me-3 text-light">
                Usuario: <strong><c:out value="${usuarioSesion.nombre}" /></strong>
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

    <!-- EVALUACIÓN DE ROLES PARA ENTIDAD DE NEGOCIO -->
    <c:choose>
        <%-- ROLES AUTORIZADOS A VER LA PANTALLA DE NEGOCIO (ADMINISTRADOR, SOCIO, EMPLEADO) --%>
        <c:when test="${userRole == 'ADMINISTRADOR' || userRole == 'SOCIO' || userRole == 'EMPLEADO'}">

            <!-- TARJETA PRINCIPAL: LISTADO Y REGISTRO DE PROPIEDADES DE GARAGE -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
                    <span>Listado de Propiedades de Garages por Socio</span>

                        <%-- BOTÓN DE REGISTRO: VISIBLE EXCLUSIVAMENTE PARA ADMINISTRADORES --%>
                    <c:if test="${userRole == 'ADMINISTRADOR'}">
                        <a href="${pageContext.request.contextPath}/propiedades-garage/nueva" class="btn btn-success btn-sm">+ Registrar Nueva Propiedad</a>
                    </c:if>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty listaPropiedadesGarage}">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0 align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>ID Socio</th>
                                        <th>Socio Propietario</th>
                                        <th>Garage (ID / N°)</th>
                                        <th>Zona</th>
                                        <th>Fecha de Compra</th>
                                            <%-- COLUMNA DE ACCIONES SOLAMENTE PARA ADMINISTRADOR --%>
                                        <c:if test="${userRole == 'ADMINISTRADOR'}">
                                            <th class="text-end">Acciones</th>
                                        </c:if>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="prop" items="${listaPropiedadesGarage}">
                                        <tr>
                                            <td>
                                                    <span class="badge bg-secondary">
                                                        <c:out value="${prop.socioId}" />
                                                    </span>
                                            </td>
                                            <td>
                                                <strong><c:out value="${prop.socioNombre}" /></strong>
                                            </td>
                                            <td>
                                                    <span class="badge bg-dark fs-6">
                                                        Garage #<c:out value="${prop.garageNumero != null ? prop.garageNumero : prop.garageId}" />
                                                    </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty prop.zonaLetra}">
                                                            <span class="badge bg-info text-dark">
                                                                Zona <c:out value="${prop.zonaLetra}" />
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Sin Zona</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty prop.fechaCompra}">
                                                            <span class="badge bg-light text-dark border">
                                                                <c:out value="${prop.fechaCompra}" />
                                                            </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <em class="text-muted">Sin Fecha</em>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                                <%-- ACCIONES EXCLUSIVAS PARA EL ROL ADMINISTRADOR --%>
                                            <c:if test="${userRole == 'ADMINISTRADOR'}">
                                            <td class="text-end">
                                                <form action="${pageContext.request.contextPath}/propiedades-garage/editar" method="GET" class="d-inline">
                                                    <input type="hidden" name="id" value="${prop.id}">
                                                    <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/propiedades-garage/eliminar" method="POST" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="id" value="${prop.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
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
                                <p class="mb-0">No hay registros de propiedades de garages en el sistema.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- FORMULARIO DE FILTRADO / BÚSQUEDA TRADICIONAL (CERO JAVASCRIPT) -->
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-light fw-bold">
                    Filtrar Propiedades
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/propiedades-garage/buscar" method="GET" class="row g-3">
                        <div class="col-md-3">
                            <label for="socioNombre" class="form-label">Nombre del Socio</label>
                            <input type="text" class="form-control" id="socioNombre" name="socioNombre" value="${param.socioNombre}" placeholder="Ej. Carlos Pérez">
                        </div>
                        <div class="col-md-3">
                            <label for="garageId" class="form-label">ID / N° Garage</label>
                            <input type="number" class="form-control" id="garageId" name="garageId" value="${param.garageId}" placeholder="Ej. 101">
                        </div>
                        <div class="col-md-3">
                            <label for="fechaCompra" class="form-label">Fecha de Compra</label>
                            <input type="date" class="form-control" id="fechaCompra" name="fechaCompra" value="${param.fechaCompra}">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary me-2">Buscar</button>
                            <a href="${pageContext.request.contextPath}/propiedades-garage" class="btn btn-secondary">Limpiar</a>
                        </div>
                    </form>
                </div>
            </div>

        </c:when>

        <%-- DENEGACIÓN DE ACCESO SI ES SYSADMIN U OTRO ROL NO PERMITIDO EN NEGOCIO --%>
        <c:otherwise>
            <div class="alert alert-danger shadow-sm" role="alert">
                <h4 class="alert-heading">Acceso Restringido</h4>
                <p class="mb-0">Su rol actual (<strong><c:out value="${userRole}" /></strong>) no está autorizado para acceder a las pantallas de gestión de entidades de negocio.</p>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
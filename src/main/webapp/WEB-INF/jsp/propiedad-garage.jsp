<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Vista compartida: ADMINISTRADOR (gestion-compras) y SOCIO (mis-compras, solo lectura).
     Campos del back (PropiedadGarageResponse): id, socioId, garageId, fechaCompraGarage, activo.
     OJO: GET /propiedades-garage/socio/{id} devuelve GarageResponse (id, numeroGarage, zonaId, ...),
     por eso la columna Garage tambien contempla numeroGarage. --%>

<%-- FORMULARIO CREAR / EDITAR --%>
<c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
    <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
        <summary class="card-header bg-dark text-white fw-bold">
            <c:choose>
                <c:when test="${not empty registro}">Editar compra de garage</c:when>
                <c:otherwise>Registrar compra de garage</c:otherwise>
            </c:choose>
        </summary>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty registro}"><c:set var="accionForm" value="${rutaBase}/editar"/></c:when>
                <c:otherwise><c:set var="accionForm" value="${rutaBase}/crear"/></c:otherwise>
            </c:choose>
            <form action="${pageContext.request.contextPath}${accionForm}" method="POST" class="row g-3" autocomplete="off">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <c:if test="${not empty registro}">
                    <input type="hidden" name="id" value="<c:out value='${registro.id}'/>"/>
                </c:if>

                <div class="col-md-4">
                    <label for="socioId" class="form-label">ID del socio</label>
                    <input type="number" min="1" class="form-control" id="socioId" name="socioId" required
                           value="<c:out value='${registro.socioId}'/>">
                </div>
                <div class="col-md-4">
                    <label for="garageId" class="form-label">ID del garage</label>
                    <input type="number" min="1" class="form-control" id="garageId" name="garageId" required
                           value="<c:out value='${registro.garageId}'/>">
                </div>
                <div class="col-md-4">
                    <label for="fechaCompraGarage" class="form-label">Fecha de compra</label>
                    <input type="date" class="form-control" id="fechaCompraGarage" name="fechaCompraGarage" required
                           value="<c:out value='${registro.fechaCompraGarage}'/>">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${not empty registro}">Guardar cambios</c:when>
                            <c:otherwise>Registrar</c:otherwise>
                        </c:choose>
                    </button>
                    <c:if test="${not empty registro}">
                        <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-secondary">Cancelar</a>
                    </c:if>
                </div>
            </form>
        </div>
    </details>
</c:if>

<%-- LISTADO --%>
<div class="card shadow-sm mb-4">
    <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
        <span>
            <c:out value="${empty titulo ? 'Compras de garages' : titulo}"/>
            <c:if test="${modoBajas}"> (dadas de baja)</c:if>
        </span>
        <c:if test="${not empty rutaBase}">
            <c:choose>
                <c:when test="${modoBajas}">
                    <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-light btn-sm">Ver activas</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}${rutaBase}/bajas" class="btn btn-light btn-sm">Ver bajas</a>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty registros}">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Socio</th>
                            <th>Garage</th>
                            <th>Fecha de compra</th>
                            <c:if test="${modoBajas}"><th>Estado</th></c:if>
                            <c:if test="${not modoBajas and (puedeEditar or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" items="${registros}">
                            <tr>
                                <td><c:out value="${p.id}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.socioId}">Socio #<c:out value="${p.socioId}"/></c:when>
                                        <c:otherwise><em class="text-muted">-</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-dark">
                                        <c:choose>
                                            <c:when test="${not empty p.garageId}">Garage #<c:out value="${p.garageId}"/></c:when>
                                            <c:otherwise>Garage N° <c:out value="${p.numeroGarage}"/></c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.fechaCompraGarage}"><c:out value="${p.fechaCompraGarage}"/></c:when>
                                        <c:otherwise><em class="text-muted">Sin fecha</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${modoBajas}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:if>
                                <c:if test="${not modoBajas and (puedeEditar or puedeEliminar)}">
                                    <td class="text-end">
                                        <c:if test="${puedeEditar}">
                                            <a href="${pageContext.request.contextPath}${rutaBase}/ver/${p.id}" class="btn btn-warning btn-sm">Editar</a>
                                        </c:if>
                                        <c:if test="${puedeEliminar}">
                                            <form action="${pageContext.request.contextPath}${rutaBase}/eliminar" method="POST" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="id" value="<c:out value='${p.id}'/>"/>
                                                <button type="submit" class="btn btn-danger btn-sm">Dar de baja</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="p-4 text-center text-muted">No hay compras de garages para mostrar.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- BUSQUEDA POR SOCIO (solo gestion del ADMINISTRADOR) --%>
<c:if test="${not empty rutaBase and not modoBajas}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light fw-bold">Buscar garages de un socio</div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}${rutaBase}/de-socio" method="GET" class="row g-3">
                <div class="col-md-4">
                    <label for="busSocio" class="form-label">ID del socio</label>
                    <input type="number" min="1" class="form-control" id="busSocio" name="socioId" required>
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary me-2">Buscar</button>
                    <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-secondary">Limpiar</a>
                </div>
            </form>
        </div>
    </div>
</c:if>
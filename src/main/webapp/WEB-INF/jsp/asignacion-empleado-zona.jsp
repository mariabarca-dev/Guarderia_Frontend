<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Vista compartida: ADMINISTRADOR (gestion-sectores) y EMPLEADO (mis-sectores, solo lectura, sin formulario).
     Campos del back (AsignacionEmpleadoZonaResponse, PLANA): id, empleadoId, zonaId, cantVehiculosACargo, activo.
     No trae la zona anidada. Si el controller quiere mostrar la letra, puede poner "zonaLetra" en cada fila. --%>

<%-- FORMULARIO CREAR / EDITAR (solo ADMINISTRADOR) --%>
<c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
    <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
        <summary class="card-header bg-dark text-white fw-bold">
            <c:choose>
                <c:when test="${not empty registro}">Editar asignación</c:when>
                <c:otherwise>Asignar empleado a zona</c:otherwise>
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
                    <label for="empleadoId" class="form-label">ID del empleado</label>
                    <input type="number" min="1" class="form-control" id="empleadoId" name="empleadoId" required
                           value="<c:out value='${registro.empleadoId}'/>">
                </div>
                <div class="col-md-4">
                    <label for="zonaId" class="form-label">ID de la zona</label>
                    <input type="number" min="1" class="form-control" id="zonaId" name="zonaId" required
                           value="<c:out value='${registro.zonaId}'/>">
                </div>
                <div class="col-md-4">
                    <label for="cantVehiculosACargo" class="form-label">Vehículos a cargo</label>
                    <input type="number" min="0" class="form-control" id="cantVehiculosACargo" name="cantVehiculosACargo" required
                           value="<c:out value='${empty registro ? 0 : registro.cantVehiculosACargo}'/>">
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${not empty registro}">Guardar cambios</c:when>
                            <c:otherwise>Asignar</c:otherwise>
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
            <c:out value="${empty titulo ? 'Asignaciones empleado-zona' : titulo}"/>
            <c:if test="${modoBajas}"> (historial)</c:if>
        </span>
        <c:if test="${not empty rutaBase}">
            <c:choose>
                <c:when test="${modoBajas}">
                    <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-light btn-sm">Ver vigentes</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}${rutaBase}/historial" class="btn btn-light btn-sm">Ver historial</a>
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
                            <th>Empleado</th>
                            <th>Zona</th>
                            <th>Vehículos a cargo</th>
                            <c:if test="${modoBajas}"><th>Estado</th></c:if>
                            <c:if test="${not modoBajas and (puedeEditar or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${registros}">
                            <tr>
                                <td><c:out value="${a.id}"/></td>
                                <td>Empleado #<c:out value="${a.empleadoId}"/></td>
                                <td>
                                    <span class="badge bg-dark">
                                        <c:choose>
                                            <c:when test="${not empty a.zonaLetra}">Zona <c:out value="${a.zonaLetra}"/></c:when>
                                            <c:otherwise>Zona #<c:out value="${a.zonaId}"/></c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td><span class="badge bg-primary"><c:out value="${a.cantVehiculosACargo}"/> vehículos</span></td>
                                <c:if test="${modoBajas}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:if>
                                <c:if test="${not modoBajas and (puedeEditar or puedeEliminar)}">
                                    <td class="text-end">
                                        <c:if test="${puedeEditar}">
                                            <a href="${pageContext.request.contextPath}${rutaBase}/ver/${a.id}" class="btn btn-warning btn-sm">Editar</a>
                                        </c:if>
                                        <c:if test="${puedeEliminar}">
                                            <form action="${pageContext.request.contextPath}${rutaBase}/eliminar" method="POST" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="id" value="<c:out value='${a.id}'/>"/>
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
                <div class="p-4 text-center text-muted">No hay asignaciones para mostrar.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
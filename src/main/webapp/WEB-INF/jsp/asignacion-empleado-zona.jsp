<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
  SECTORES (asignaciones empleado-zona).
  Fragmento incluido por layout.jsp (sin html/head/body). Toda salida con c:out o fn:escapeXml. Sin JavaScript.
  Lo usan: AsignacionEmpleadoZonaController (ADMINISTRADOR) y UsuarioController
  (EMPLEADO /empleado/mis-sectores: solo las propias, sin formulario ni botones).

  Model que arma el controller:
    titulo, base (ruta web de la tabla), lista (List<Map>), registro (Map a ver/editar, puede ser null),
    esBajas (muestra Estado y oculta acciones), puedeVer, puedeCrear, puedeEditar, puedeEliminar,
    puedeConsultar (muestra la tarjeta de consultas; solo ADMINISTRADOR).
--%>
<c:set var="raiz" value="${pageContext.request.contextPath}${base}"/>
<c:set var="editando" value="${not empty registro and puedeEditar}"/>

<c:if test="${puedeConsultar}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light fw-bold">Consultas</div>
        <div class="card-body">
            <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}">Listado</a>
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}/historial">Historial (activas y dadas de baja)</a>
            </div>

        </div>
    </div>
</c:if>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-dark text-white fw-bold"><c:out value="${titulo}"/></div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty lista}">
                <div class="table-responsive">
                <table class="table table-hover table-striped mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                    <th>ID</th>
                    <th>Empleado (ID)</th>
                    <th>Zona (ID)</th>
                    <th>Vehículos a cargo</th>
                    <c:if test="${esBajas}"><th>Estado</th></c:if>
                    <c:if test="${not esBajas and (puedeVer or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${lista}">
                    <tr>
                    <td><c:out value="${r.id}"/></td>
                    <td><c:out value="${r.empleadoId}"/></td>
                    <td><c:out value="${r.zonaId}"/></td>
                    <td><c:out value="${r.cantVehiculosACargo}"/></td>
                    <c:if test="${esBajas}">
                        <td>
                            <c:choose>
                                <c:when test="${r.activo}"><span class="badge bg-success">Activo</span></c:when>
                                <c:otherwise><span class="badge bg-danger">Baja</span></c:otherwise>
                            </c:choose>
                        </td>
                    </c:if>
                    <c:if test="${not esBajas and (puedeVer or puedeEliminar)}">
                        <td class="text-end">
                            <c:if test="${puedeVer}">
                                <a class="btn btn-warning btn-sm" href="${fn:escapeXml(raiz)}/ver/${fn:escapeXml(r.id)}">
                                    <c:out value="${puedeEditar ? 'Editar' : 'Ver'}"/>
                                </a>
                            </c:if>
                            <c:if test="${puedeEliminar}">
                                <form action="${fn:escapeXml(raiz)}/eliminar" method="post" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="hidden" name="id" value="${fn:escapeXml(r.id)}"/>
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
                <div class="p-4 text-center text-muted"><p class="mb-0">No hay registros para mostrar.</p></div>
            </c:otherwise>
        </c:choose>
    </div>
    <c:if test="${puedeEliminar and not esBajas}">
        <div class="card-footer text-muted small">"Dar de baja" es una baja lógica: el registro queda inactivo y se ve en el listado de bajas o en el historial.</div>
    </c:if>
</div>

<c:if test="${editando or (puedeCrear and empty registro)}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold">
            <c:out value="${editando ? 'Editar sector' : 'Nuevo registro: sector'}"/>
        </div>
        <div class="card-body">
            <form action="${fn:escapeXml(raiz)}/${editando ? 'editar' : 'crear'}" method="post" class="row g-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <c:if test="${editando}"><input type="hidden" name="id" value="${fn:escapeXml(registro.id)}"/></c:if>
            <div class="col-md-4">
                <label class="form-label" for="empleadoId">Empleado (ID)</label>
                <input type="number" class="form-control" id="empleadoId" name="empleadoId" value="${fn:escapeXml(registro.empleadoId)}" required min="1">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="zonaId">Zona (ID)</label>
                <input type="number" class="form-control" id="zonaId" name="zonaId" value="${fn:escapeXml(registro.zonaId)}" required min="1">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="cantVehiculosACargo">Vehículos a cargo</label>
                <input type="number" class="form-control" id="cantVehiculosACargo" name="cantVehiculosACargo" value="${fn:escapeXml(registro.cantVehiculosACargo)}" required min="0">
            </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary"><c:out value="${editando ? 'Guardar cambios' : 'Registrar'}"/></button>
                    <c:if test="${editando}"><a class="btn btn-secondary" href="${fn:escapeXml(raiz)}">Cancelar</a></c:if>
                </div>
            </form>
        </div>
    </div>
</c:if>

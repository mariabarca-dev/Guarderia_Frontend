<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
  COCHERAS / GARAGES (solo ADMINISTRADOR).
  Fragmento incluido por layout.jsp (sin html/head/body). Toda salida con c:out o fn:escapeXml. Sin JavaScript.
  Lo usan: GarageController (/administrador/gestion-cocheras).

  Model que arma el controller:
    titulo, base (ruta web de la tabla), lista (List<Map>), registro (Map a ver/editar, puede ser null),
    esBajas (muestra Estado y oculta acciones), puedeVer, puedeCrear, puedeEditar, puedeEliminar,
    puedeConsultar (muestra la tarjeta de consultas; solo ADMINISTRADOR).
    ocupacion (opcional): List<ZonaResponse> de GET /garages/disponibilidad (espacios por zona).
--%>
<c:set var="raiz" value="${pageContext.request.contextPath}${base}"/>
<c:set var="editando" value="${not empty registro and puedeEditar}"/>

<c:if test="${puedeConsultar}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light fw-bold">Consultas</div>
        <div class="card-body">
            <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}">Listado</a>
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}/bajas">Activas y dadas de baja</a>
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}/ocupacion">Ocupación por zona</a>
            </div>

        </div>
    </div>
</c:if>

<c:if test="${not empty ocupacion}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-secondary text-white fw-bold">Ocupación por zona</div>
        <div class="card-body p-0">
            <div class="table-responsive">
            <table class="table table-striped mb-0 align-middle">
                <thead class="table-light">
                <tr><th>Zona</th><th>Tipo de vehículo</th><th>Capacidad</th><th>Ocupados</th><th>Disponibles</th></tr>
                </thead>
                <tbody>
                <c:forEach var="z" items="${ocupacion}">
                    <tr>
                        <td><span class="badge bg-dark">Zona <c:out value="${z.letra}"/></span></td>
                        <td><c:out value="${fn:replace(z.tipoVehiculo, '_', ' ')}"/></td>
                        <td><c:out value="${z.capacidadVehiculos}"/></td>
                        <td><c:out value="${z.espaciosOcupados}"/></td>
                        <td><strong><c:out value="${z.espaciosDisponibles}"/></strong></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
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
                    <th>N° de cochera</th>
                    <th>Lectura de luz</th>
                    <th>Mantenimiento</th>
                    <th>Zona (ID)</th>
                    <c:if test="${esBajas}"><th>Estado</th></c:if>
                    <c:if test="${not esBajas and (puedeVer or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${lista}">
                    <tr>
                    <td><c:out value="${r.id}"/></td>
                    <td><c:out value="${r.numeroGarage}"/></td>
                    <td><fmt:formatNumber value="${r.lecturaLuz}" maxFractionDigits="2"/></td>
                    <td><c:out value="${r.servicioMantenimiento ? 'Sí' : 'No'}"/></td>
                    <td><c:out value="${r.zonaId}"/></td>
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
            <c:out value="${editando ? 'Editar cochera' : 'Nuevo registro: cochera'}"/>
        </div>
        <div class="card-body">
            <form action="${fn:escapeXml(raiz)}/${editando ? 'editar' : 'crear'}" method="post" class="row g-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <c:if test="${editando}"><input type="hidden" name="id" value="${fn:escapeXml(registro.id)}"/></c:if>
            <div class="col-md-4">
                <label class="form-label" for="numeroGarage">N° de cochera</label>
                <input type="number" class="form-control" id="numeroGarage" name="numeroGarage" value="${fn:escapeXml(registro.numeroGarage)}" required min="1">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="lecturaLuz">Lectura del contador de luz</label>
                <input type="number" class="form-control" id="lecturaLuz" name="lecturaLuz" value="${fn:escapeXml(registro.lecturaLuz)}" required min="0" step="0.01">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="servicioMantenimiento">Servicio de mantenimiento</label>
                <select class="form-select" id="servicioMantenimiento" name="servicioMantenimiento" required>
                    <option value="">Elegí una opción</option>
                    <option value="true" <c:if test="${not empty registro and registro.servicioMantenimiento}">selected</c:if>>Sí</option>
                    <option value="false" <c:if test="${not empty registro and not registro.servicioMantenimiento}">selected</c:if>>No</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="zonaId">Zona (ID)</label>
                <input type="number" class="form-control" id="zonaId" name="zonaId" value="${fn:escapeXml(registro.zonaId)}" required min="1">
            </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary"><c:out value="${editando ? 'Guardar cambios' : 'Registrar'}"/></button>
                    <c:if test="${editando}"><a class="btn btn-secondary" href="${fn:escapeXml(raiz)}">Cancelar</a></c:if>
                </div>
            </form>
        </div>
    </div>
</c:if>

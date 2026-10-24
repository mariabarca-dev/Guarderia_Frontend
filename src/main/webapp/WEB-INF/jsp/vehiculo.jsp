<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%--
  RODADOS / VEHÍCULOS.
  Fragmento incluido por layout.jsp (sin html/head/body). Toda salida con c:out o fn:escapeXml. Sin JavaScript.
  Lo usan: VehiculoController (ADMINISTRADOR: todos, con alta/edición/baja) y UsuarioController
  (SOCIO /socio/mis-vehiculos y /ver/{id}: solo lectura, con detalle; EMPLEADO /empleado/mis-encargos: solo lectura).

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
            <a class="btn btn-outline-dark btn-sm" href="${fn:escapeXml(raiz)}/bajas">Activos y dados de baja</a>
            </div>
            <form action="${fn:escapeXml(raiz)}/buscar-patente" method="get" class="row g-2 align-items-end mt-2">
                <div class="col-sm-6 col-md-4">
                    <label class="form-label">Buscar por patente</label>
                    <input type="text" class="form-control" name="patente" required maxlength="50">
                </div>
                <div class="col-auto"><button type="submit" class="btn btn-primary">Buscar</button></div>
            </form>
            <form action="${fn:escapeXml(raiz)}/buscar-categoria" method="get" class="row g-2 align-items-end mt-2">
                <div class="col-sm-6 col-md-4">
                    <label class="form-label">Buscar por categoría</label>
                    <select class="form-select" name="categoria" required><option value="">Elegí una categoría</option><c:forEach var="t" items="MOTORHOME,CASA_RODANTE_DE_ARRASTRE,CARAVANA,TRAILER"><option value="${fn:escapeXml(t)}"><c:out value="${fn:replace(t, '_', ' ')}"/></option></c:forEach></select>
                </div>
                <div class="col-auto"><button type="submit" class="btn btn-primary">Buscar</button></div>
            </form>
            <form action="${fn:escapeXml(raiz)}/de-socio" method="get" class="row g-2 align-items-end mt-2">
                <div class="col-sm-6 col-md-4">
                    <label class="form-label">Rodados de un socio (ID del socio)</label>
                    <input type="number" class="form-control" name="nroSocio" required min="1">
                </div>
                <div class="col-auto"><button type="submit" class="btn btn-primary">Buscar</button></div>
            </form>
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
                    <th>Nombre</th>
                    <th>Patente</th>
                    <th>Tipo</th>
                    <th>Profundidad (m)</th>
                    <th>Ancho (m)</th>
                    <th>Socio (ID)</th>
                    <c:if test="${esBajas}"><th>Estado</th></c:if>
                    <c:if test="${not esBajas and (puedeVer or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${lista}">
                    <tr>
                    <td><c:out value="${r.id}"/></td>
                    <td><c:out value="${r.nombre}"/></td>
                    <td><c:out value="${r.matricula}"/></td>
                    <td><span class="badge bg-info text-dark"><c:out value="${fn:replace(r.tipo, '_', ' ')}"/></span></td>
                    <td><fmt:formatNumber value="${r.profundidad}" maxFractionDigits="2"/></td>
                    <td><fmt:formatNumber value="${r.ancho}" maxFractionDigits="2"/></td>
                    <td><c:out value="${r.socioId}"/></td>
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

<c:if test="${not empty registro and not puedeEditar}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-secondary text-white fw-bold">Detalle: rodado</div>
        <div class="card-body p-0">
            <table class="table table-striped mb-0">
                <tbody>
                <tr><th class="w-25">Nombre</th><td><c:out value="${registro.nombre}"/></td></tr>
                <tr><th class="w-25">Patente</th><td><c:out value="${registro.matricula}"/></td></tr>
                <tr><th class="w-25">Tipo</th><td><span class="badge bg-info text-dark"><c:out value="${fn:replace(registro.tipo, '_', ' ')}"/></span></td></tr>
                <tr><th class="w-25">Profundidad (m)</th><td><fmt:formatNumber value="${registro.profundidad}" maxFractionDigits="2"/></td></tr>
                <tr><th class="w-25">Ancho (m)</th><td><fmt:formatNumber value="${registro.ancho}" maxFractionDigits="2"/></td></tr>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<c:if test="${editando or (puedeCrear and empty registro)}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold">
            <c:out value="${editando ? 'Editar rodado' : 'Nuevo registro: rodado'}"/>
        </div>
        <div class="card-body">
            <form action="${fn:escapeXml(raiz)}/${editando ? 'editar' : 'crear'}" method="post" class="row g-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <c:if test="${editando}"><input type="hidden" name="id" value="${fn:escapeXml(registro.id)}"/></c:if>
            <div class="col-md-4">
                <label class="form-label" for="socioId">Socio (ID)</label>
                <input type="number" class="form-control" id="socioId" name="socioId" value="${fn:escapeXml(registro.socioId)}" required min="1">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="nombre">Nombre o descripción</label>
                <input type="text" class="form-control" id="nombre" name="nombre" value="${fn:escapeXml(registro.nombre)}" maxlength="100">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="matricula">Patente</label>
                <input type="text" class="form-control" id="matricula" name="matricula" value="${fn:escapeXml(registro.matricula)}" required maxlength="50">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="tipo">Tipo de vehículo</label>
                <select class="form-select" id="tipo" name="tipo" required>
                    <option value="">Elegí una opción</option>
                    <c:forEach var="t" items="MOTORHOME,CASA_RODANTE_DE_ARRASTRE,CARAVANA,TRAILER">
                        <option value="${fn:escapeXml(t)}" <c:if test="${registro.tipo == t}">selected</c:if>><c:out value="${fn:replace(t, '_', ' ')}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label" for="profundidad">Profundidad (m)</label>
                <input type="number" class="form-control" id="profundidad" name="profundidad" value="${fn:escapeXml(registro.profundidad)}" required min="0" step="0.01">
            </div>
            <div class="col-md-4">
                <label class="form-label" for="ancho">Ancho (m)</label>
                <input type="number" class="form-control" id="ancho" name="ancho" value="${fn:escapeXml(registro.ancho)}" required min="0" step="0.01">
            </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-primary"><c:out value="${editando ? 'Guardar cambios' : 'Registrar'}"/></button>
                    <c:if test="${editando}"><a class="btn btn-secondary" href="${fn:escapeXml(raiz)}">Cancelar</a></c:if>
                </div>
            </form>
        </div>
    </div>
</c:if>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Vista compartida: ADMINISTRADOR (gestion-rodados), SOCIO (mis-vehiculos), EMPLEADO (mis-encargos).
     Campos del back (VehiculoResponse): id, socioId, nombre, matricula, tipo, profundidad, ancho, activo. --%>

<%-- DETALLE DE SOLO LECTURA (por ejemplo /socio/mis-vehiculos/ver/{id}) --%>
<c:if test="${not empty registro and not puedeEditar}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-secondary text-white fw-bold">Detalle del vehículo</div>
        <div class="card-body">
            <dl class="row mb-0">
                <dt class="col-sm-3">Matrícula</dt><dd class="col-sm-9"><c:out value="${registro.matricula}"/></dd>
                <dt class="col-sm-3">Nombre</dt><dd class="col-sm-9"><c:out value="${registro.nombre}"/></dd>
                <dt class="col-sm-3">Tipo</dt><dd class="col-sm-9"><c:out value="${registro.tipo}"/></dd>
                <dt class="col-sm-3">Ancho</dt><dd class="col-sm-9"><c:out value="${registro.ancho}"/> m</dd>
                <dt class="col-sm-3">Profundidad</dt><dd class="col-sm-9"><c:out value="${registro.profundidad}"/> m</dd>
            </dl>
        </div>
    </div>
</c:if>

<%-- FORMULARIO CREAR / EDITAR (solo si el rol puede) --%>
<c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
    <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
        <summary class="card-header bg-dark text-white fw-bold">
            <c:choose>
                <c:when test="${not empty registro}">Editar vehículo</c:when>
                <c:otherwise>Registrar nuevo vehículo</c:otherwise>
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

                <div class="col-md-3">
                    <label for="socioId" class="form-label">ID del socio</label>
                    <input type="number" min="1" class="form-control" id="socioId" name="socioId" required
                           value="<c:out value='${registro.socioId}'/>">
                </div>
                <div class="col-md-3">
                    <label for="matricula" class="form-label">Matrícula</label>
                    <input type="text" class="form-control" id="matricula" name="matricula" maxlength="50" required
                           value="<c:out value='${registro.matricula}'/>">
                </div>
                <div class="col-md-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" maxlength="100"
                           value="<c:out value='${registro.nombre}'/>">
                </div>
                <div class="col-md-3">
                    <label for="tipo" class="form-label">Tipo</label>
                    <select class="form-select" id="tipo" name="tipo" required>
                        <option value="">Seleccione...</option>
                        <option value="MOTORHOME" <c:if test="${registro.tipo == 'MOTORHOME'}">selected</c:if>>Motorhome</option>
                        <option value="CASA_RODANTE_DE_ARRASTRE" <c:if test="${registro.tipo == 'CASA_RODANTE_DE_ARRASTRE'}">selected</c:if>>Casa rodante de arrastre</option>
                        <option value="CARAVANA" <c:if test="${registro.tipo == 'CARAVANA'}">selected</c:if>>Caravana</option>
                        <option value="TRAILER" <c:if test="${registro.tipo == 'TRAILER'}">selected</c:if>>Trailer</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="ancho" class="form-label">Ancho (m)</label>
                    <input type="number" step="0.01" min="0" class="form-control" id="ancho" name="ancho" required
                           value="<c:out value='${registro.ancho}'/>">
                </div>
                <div class="col-md-3">
                    <label for="profundidad" class="form-label">Profundidad (m)</label>
                    <input type="number" step="0.01" min="0" class="form-control" id="profundidad" name="profundidad" required
                           value="<c:out value='${registro.profundidad}'/>">
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
            <c:out value="${empty titulo ? 'Vehículos' : titulo}"/>
            <c:if test="${modoBajas}"> (dados de baja)</c:if>
        </span>
        <c:if test="${not empty rutaBase}">
            <c:choose>
                <c:when test="${modoBajas}">
                    <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-light btn-sm">Ver activos</a>
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
                            <th>Matrícula</th>
                            <th>Nombre</th>
                            <th>Tipo</th>
                            <th>Ancho x Prof.</th>
                            <th>Socio</th>
                            <c:if test="${modoBajas}"><th>Estado</th></c:if>
                            <c:if test="${not modoBajas and (not empty rutaBase or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="v" items="${registros}">
                            <tr>
                                <td><c:out value="${v.id}"/></td>
                                <td><span class="badge bg-secondary"><c:out value="${v.matricula}"/></span></td>
                                <td><strong><c:out value="${v.nombre}"/></strong></td>
                                <td><span class="badge bg-info text-dark"><c:out value="${v.tipo}"/></span></td>
                                <td><c:out value="${v.ancho}"/> m x <c:out value="${v.profundidad}"/> m</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty v.socioId}">Socio #<c:out value="${v.socioId}"/></c:when>
                                        <c:otherwise><em class="text-muted">Sin asignar</em></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${modoBajas}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:if>
                                <c:if test="${not modoBajas and (not empty rutaBase or puedeEliminar)}">
                                    <td class="text-end">
                                        <c:if test="${not empty rutaBase}">
                                            <a href="${pageContext.request.contextPath}${rutaBase}/ver/${v.id}" class="btn btn-warning btn-sm">
                                                <c:choose><c:when test="${puedeEditar}">Editar</c:when><c:otherwise>Ver</c:otherwise></c:choose>
                                            </a>
                                        </c:if>
                                        <c:if test="${puedeEliminar}">
                                            <form action="${pageContext.request.contextPath}${rutaBase}/eliminar" method="POST" class="d-inline">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="id" value="<c:out value='${v.id}'/>"/>
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
                <div class="p-4 text-center text-muted">No hay vehículos para mostrar.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- BUSQUEDAS EXTRA (solo pantalla de gestion del ADMINISTRADOR) --%>
<c:if test="${not empty rutaBase and not modoBajas}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-light fw-bold">Buscar vehículos</div>
        <div class="card-body">
            <div class="row g-3">
                <form action="${pageContext.request.contextPath}${rutaBase}/buscar-patente" method="GET" class="col-md-4">
                    <label for="busMatricula" class="form-label">Por matrícula</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="busMatricula" name="matricula" maxlength="50" required>
                        <button type="submit" class="btn btn-primary">Buscar</button>
                    </div>
                </form>
                <form action="${pageContext.request.contextPath}${rutaBase}/buscar-categoria" method="GET" class="col-md-4">
                    <label for="busTipo" class="form-label">Por tipo</label>
                    <select class="form-select" id="busTipo" name="tipo" required>
                        <option value="">Seleccione...</option>
                        <option value="MOTORHOME">Motorhome</option>
                        <option value="CASA_RODANTE_DE_ARRASTRE">Casa rodante de arrastre</option>
                        <option value="CARAVANA">Caravana</option>
                        <option value="TRAILER">Trailer</option>
                    </select>
                    <button type="submit" class="btn btn-primary mt-2">Buscar</button>
                </form>
                <form action="${pageContext.request.contextPath}${rutaBase}/de-socio" method="GET" class="col-md-4">
                    <label for="busSocio" class="form-label">Por ID de socio</label>
                    <div class="input-group">
                        <input type="number" min="1" class="form-control" id="busSocio" name="socioId" required>
                        <button type="submit" class="btn btn-primary">Buscar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>
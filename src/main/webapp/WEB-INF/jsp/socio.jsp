<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
  socio.jsp - Fragmento (se incluye dentro de layout.jsp). Dos usos:
  1) PERFIL DEL SOCIO (/socio/mi-perfil y /socio/mis-cocheras): llega "datosSocio".
     En mis-cocheras llega ademas "listaCocherasOcupadas" (GarageOcupadoResponse).
  2) CUENTAS DE SOCIOS (/administrador|sysadmin/cuentas-socios): llegan "registros", "rutaBase",
     "puedeCrear", "puedeEditar", "puedeEliminar", "modoBajas" y, en ver, "registro".
     Consultas extra del ADMINISTRADOR: "resultado" y "tituloResultado".
--%>
<c:choose>

<%-- ================= 1) PERFIL DEL SOCIO LOGUEADO (solo lectura) ================= --%>
<c:when test="${not empty datosSocio}">
    <div class="card border-primary shadow-sm mb-4">
        <div class="card-header bg-primary text-white fw-bold d-flex justify-content-between align-items-center">
            <span>Mis datos personales</span>
            <span class="badge bg-light text-dark">DNI: <c:out value="${datosSocio.dni}"/></span>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Nombre completo</label>
                    <p class="fw-bold mb-0"><c:out value="${datosSocio.nombre}"/> <c:out value="${datosSocio.apellido}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Usuario</label>
                    <p class="fw-bold mb-0"><c:out value="${datosSocio.nombreUsuario}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Fecha de ingreso</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosSocio.fechaIngreso ? '-' : datosSocio.fechaIngreso}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Dirección</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosSocio.direccion ? '-' : datosSocio.direccion}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Teléfono</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosSocio.telefono ? '-' : datosSocio.telefono}"/></p>
                </div>
                    <div class="col-md-4">
                        <label for="fechaIngreso" class="form-label">Fecha de ingreso</label>
                        <input type="date" class="form-control" id="fechaIngreso" name="fechaIngreso" required
                               value="<c:out value='${registro.fechaIngreso}'/>">
                    </div>


            </div>
        </div>
    </div>

    <%-- Garages que ocupa el socio (GarageOcupadoResponse). Solo llega en /socio/mis-cocheras. --%>
    <c:if test="${listaCocherasOcupadas != null}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-dark text-white fw-bold">Mis cocheras ocupadas</div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty listaCocherasOcupadas}">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped mb-0 align-middle">
                                <thead class="table-light">
                                <tr>
                                    <c:forEach var="col" items="${listaCocherasOcupadas[0]}">
                                        <th><c:out value="${col.key}"/></th>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="fila" items="${listaCocherasOcupadas}">
                                    <tr>
                                        <c:forEach var="celda" items="${fila}">
                                            <td><c:out value="${celda.value}"/></td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-4 text-center text-muted">No tenés cocheras ocupadas actualmente.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
</c:when>

<%-- ================= 2) CUENTAS DE SOCIOS (ADMINISTRADOR y SYSADMIN) ================= --%>
<c:otherwise>
    <c:set var="esAdmin" value="${fn:startsWith(rutaBase, '/administrador')}"/>

    <%-- FORMULARIO CREAR / EDITAR --%>
    <c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
        <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
            <summary class="card-header bg-dark text-white fw-bold">
                <c:choose>
                    <c:when test="${not empty registro}">Editar socio</c:when>
                    <c:otherwise>Registrar nuevo socio</c:otherwise>
                </c:choose>
            </summary>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty registro}"><c:set var="accionForm" value="${rutaBase}/editar"/></c:when>
                    <c:otherwise><c:set var="accionForm" value="${rutaBase}/crear"/></c:otherwise>
                </c:choose>
                <form action="${pageContext.request.contextPath}<c:out value='${accionForm}'/>" method="POST" class="row g-3" autocomplete="off">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <c:if test="${not empty registro}">
                        <input type="hidden" name="id" value="<c:out value='${registro.id}'/>"/>
                    </c:if>
                    <div class="col-md-4">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" maxlength="100" required
                               value="<c:out value='${registro.nombre}'/>">
                    </div>
                    <div class="col-md-4">
                        <label for="apellido" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="apellido" name="apellido" maxlength="100" required
                               value="<c:out value='${registro.apellido}'/>">
                    </div>
                    <div class="col-md-4">
                        <label for="dni" class="form-label">DNI</label>
                        <input type="text" class="form-control" id="dni" name="dni" maxlength="15" required
                               value="<c:out value='${registro.dni}'/>">
                    </div>
                    <div class="col-md-4">
                        <label for="nombreUsuario" class="form-label">Nombre de usuario</label>
                        <input type="text" class="form-control" id="nombreUsuario" name="nombreUsuario" maxlength="50" required
                               value="<c:out value='${registro.nombreUsuario}'/>">
                    </div>
                    <c:if test="${empty registro}">
                        <div class="col-md-4">
                            <label for="clave" class="form-label">Contraseña</label>
                            <input type="password" class="form-control" id="clave" name="clave" maxlength="100" required>
                        </div>
                    </c:if>
                    <div class="col-md-4">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" class="form-control" id="direccion" name="direccion" maxlength="150"
                               value="<c:out value='${registro.direccion}'/>">
                    </div>
                    <div class="col-md-4">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="telefono" name="telefono" maxlength="20"
                               value="<c:out value='${registro.telefono}'/>">
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <c:choose>
                                <c:when test="${not empty registro}">Guardar cambios</c:when>
                                <c:otherwise>Registrar</c:otherwise>
                            </c:choose>
                        </button>
                        <c:if test="${not empty registro}">
                            <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>" class="btn btn-secondary">Cancelar</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </details>
    </c:if>

    <%-- BUSCAR POR DNI (consulta extra, solo ADMINISTRADOR) --%>
    <c:if test="${esAdmin and not modoBajas}">
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/buscar-documento" method="GET" class="row g-2 align-items-end">
                    <div class="col-md-4">
                        <label for="buscarDni" class="form-label">Buscar socio por DNI</label>
                        <input type="text" class="form-control" id="buscarDni" name="dni" maxlength="15" required>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-secondary">Buscar</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <%-- RESULTADO DE UNA CONSULTA EXTRA (rodados o cocheras de un socio) --%>
    <c:if test="${resultado != null}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-secondary text-white fw-bold d-flex justify-content-between align-items-center">
                <span><c:out value="${tituloResultado}"/></span>
                <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>" class="btn btn-light btn-sm">Cerrar</a>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty resultado}">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped mb-0 align-middle">
                                <thead class="table-light">
                                <tr>
                                    <c:forEach var="col" items="${resultado[0]}">
                                        <th><c:out value="${col.key}"/></th>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="fila" items="${resultado}">
                                    <tr>
                                        <c:forEach var="celda" items="${fila}">
                                            <td><c:out value="${celda.value}"/></td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="p-4 text-center text-muted">No hay registros para mostrar.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

    <%-- LISTADO DE SOCIOS --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
            <span>
                Socios
                <c:if test="${modoBajas}"> (dados de baja)</c:if>
            </span>
            <c:choose>
                <c:when test="${modoBajas}">
                    <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>" class="btn btn-light btn-sm">Ver activos</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/bajas" class="btn btn-light btn-sm">Ver bajas</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${not empty registros}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Nombre y apellido</th>
                                <th>DNI</th>
                                <th>Usuario</th>
                                <th>Teléfono</th>
                                <th>Ingreso</th>
                                <c:if test="${modoBajas}"><th>Estado</th></c:if>
                                <c:if test="${not modoBajas}"><th class="text-end">Acciones</th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="s" items="${registros}">
                                <tr>
                                    <td><c:out value="${s.id}"/></td>
                                    <td><strong><c:out value="${s.nombre}"/> <c:out value="${s.apellido}"/></strong></td>
                                    <td><c:out value="${s.dni}"/></td>
                                    <td><span class="badge rol-SOCIO"><c:out value="${s.nombreUsuario}"/></span></td>
                                    <td><c:out value="${empty s.telefono ? '-' : s.telefono}"/></td>
                                    <td><c:out value="${empty s.fechaIngreso ? '-' : s.fechaIngreso}"/></td>
                                    <c:if test="${modoBajas}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${s.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                                <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:if>
                                    <c:if test="${not modoBajas}">
                                        <td class="text-end">
                                            <c:if test="${esAdmin}">
                                                <a href="${pageContext.request.contextPath}/administrador/cuentas-socios/<c:out value='${s.id}'/>/sus-rodados"
                                                   class="btn btn-outline-secondary btn-sm">Rodados</a>
                                                <a href="${pageContext.request.contextPath}/administrador/cuentas-socios/<c:out value='${s.id}'/>/sus-cocheras"
                                                   class="btn btn-outline-secondary btn-sm">Cocheras</a>
                                            </c:if>
                                            <c:if test="${puedeEditar}">
                                                <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/ver/<c:out value='${s.id}'/>"
                                                   class="btn btn-warning btn-sm">Editar</a>
                                            </c:if>
                                            <c:if test="${puedeEliminar}">
                                                <form action="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/eliminar" method="POST" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="id" value="<c:out value='${s.id}'/>"/>
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
                    <div class="p-4 text-center text-muted">No hay socios para mostrar.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:otherwise>
</c:choose>

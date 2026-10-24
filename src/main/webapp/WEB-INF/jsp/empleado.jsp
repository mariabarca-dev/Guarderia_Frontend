<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%--
  empleado.jsp - Fragmento (se incluye dentro de layout.jsp). Dos usos:
  1) LEGAJO DEL EMPLEADO (/empleado/mi-legajo): llega "datosEmpleado" (solo lectura).
  2) CUENTAS DE EMPLEADOS (/administrador|sysadmin/cuentas-empleados): llegan "registros", "rutaBase",
     "puedeCrear", "puedeEditar", "puedeEliminar", "modoBajas" y, en ver, "registro".
     Consultas extra del ADMINISTRADOR: "resultado", "tituloResultado" y, solo en sus-encargos,
     "resultadoEncargosDe" (id del empleado) para mostrar encargar / desencargar.
  El codigo del empleado se lee de "codigoEmpleado" o de "codigo" (el que traiga la respuesta del back).
--%>
<c:choose>

<%-- ================= 1) LEGAJO DEL EMPLEADO LOGUEADO (solo lectura) ================= --%>
<c:when test="${not empty datosEmpleado}">
    <c:set var="codigoLegajo" value="${not empty datosEmpleado.codigoEmpleado ? datosEmpleado.codigoEmpleado : datosEmpleado.codigo}"/>
    <div class="card border-dark shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
            <span>Mi legajo</span>
            <span class="badge bg-info text-dark">Código: <c:out value="${codigoLegajo}"/></span>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Nombre completo</label>
                    <p class="fw-bold mb-0"><c:out value="${datosEmpleado.nombre}"/> <c:out value="${datosEmpleado.apellido}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Usuario</label>
                    <p class="fw-bold mb-0"><c:out value="${datosEmpleado.nombreUsuario}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Especialidad</label>
                    <p class="mb-0"><span class="badge bg-primary"><c:out value="${datosEmpleado.especialidad}"/></span></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">DNI</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosEmpleado.dni ? '-' : datosEmpleado.dni}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Dirección</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosEmpleado.direccion ? '-' : datosEmpleado.direccion}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Teléfono</label>
                    <p class="fw-bold mb-0"><c:out value="${empty datosEmpleado.telefono ? '-' : datosEmpleado.telefono}"/></p>
                </div>
            </div>
        </div>
    </div>
</c:when>

<%-- ================= 2) CUENTAS DE EMPLEADOS (ADMINISTRADOR y SYSADMIN) ================= --%>
<c:otherwise>
    <c:set var="esAdmin" value="${fn:startsWith(rutaBase, '/administrador')}"/>

    <%-- FORMULARIO CREAR / EDITAR --%>
    <c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
        <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
            <summary class="card-header bg-dark text-white fw-bold">
                <c:choose>
                    <c:when test="${not empty registro}">Editar empleado</c:when>
                    <c:otherwise>Registrar nuevo empleado</c:otherwise>
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
                        <label for="codigoEmpleado" class="form-label">Código de empleado</label>
                        <input type="text" class="form-control" id="codigoEmpleado" name="codigoEmpleado" maxlength="30" required
                               value="<c:out value='${not empty registro.codigoEmpleado ? registro.codigoEmpleado : registro.codigo}'/>">
                    </div>
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
                        <label for="especialidad" class="form-label">Especialidad</label>
                        <input type="text" class="form-control" id="especialidad" name="especialidad" maxlength="100" required
                               value="<c:out value='${registro.especialidad}'/>">
                    </div>
                    <div class="col-md-4">
                        <label for="dni" class="form-label">DNI (opcional)</label>
                        <input type="text" class="form-control" id="dni" name="dni" maxlength="15"
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

    <%-- RESULTADO DE UNA CONSULTA EXTRA (sectores o encargos de un empleado) --%>
    <c:if test="${resultado != null}">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-secondary text-white fw-bold d-flex justify-content-between align-items-center">
                <span><c:out value="${tituloResultado}"/></span>
                <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>" class="btn btn-light btn-sm">Cerrar</a>
            </div>

            <%-- Encargar un vehiculo (solo en sus-encargos): el formulario envia el id del vehiculo --%>
            <c:if test="${not empty resultadoEncargosDe}">
                <div class="card-body border-bottom">
                    <form action="${pageContext.request.contextPath}/administrador/cuentas-empleados/<c:out value='${resultadoEncargosDe}'/>/encargar"
                          method="POST" class="row g-2 align-items-end">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="col-md-3">
                            <label for="vehiculoId" class="form-label">ID del vehículo a encargar</label>
                            <input type="number" class="form-control" id="vehiculoId" name="vehiculoId" min="1" required>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Encargar vehículo</button>
                        </div>
                    </form>
                </div>
            </c:if>

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
                                    <c:if test="${not empty resultadoEncargosDe}"><th class="text-end">Acción</th></c:if>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="fila" items="${resultado}">
                                    <tr>
                                        <c:forEach var="celda" items="${fila}">
                                            <td><c:out value="${celda.value}"/></td>
                                        </c:forEach>
                                        <c:if test="${not empty resultadoEncargosDe}">
                                            <td class="text-end">
                                                <form action="${pageContext.request.contextPath}/administrador/cuentas-empleados/<c:out value='${resultadoEncargosDe}'/>/desencargar/<c:out value='${fila.id}'/>"
                                                      method="POST" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm">Quitar encargo</button>
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
                        <div class="p-4 text-center text-muted">No hay registros para mostrar.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>

    <%-- LISTADO DE EMPLEADOS --%>
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
            <span>
                Empleados
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
                                <th>Código</th>
                                <th>Nombre y apellido</th>
                                <th>Especialidad</th>
                                <th>Usuario</th>
                                <th>Teléfono</th>
                                <c:if test="${modoBajas}"><th>Estado</th></c:if>
                                <c:if test="${not modoBajas}"><th class="text-end">Acciones</th></c:if>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="e" items="${registros}">
                                <tr>
                                    <td><c:out value="${e.id}"/></td>
                                    <td><c:out value="${not empty e.codigoEmpleado ? e.codigoEmpleado : e.codigo}"/></td>
                                    <td><strong><c:out value="${e.nombre}"/> <c:out value="${e.apellido}"/></strong></td>
                                    <td><span class="badge bg-primary"><c:out value="${e.especialidad}"/></span></td>
                                    <td><span class="badge bg-secondary"><c:out value="${e.nombreUsuario}"/></span></td>
                                    <td><c:out value="${empty e.telefono ? '-' : e.telefono}"/></td>
                                    <c:if test="${modoBajas}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${e.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                                <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </c:if>
                                    <c:if test="${not modoBajas}">
                                        <td class="text-end">
                                            <c:if test="${esAdmin}">
                                                <a href="${pageContext.request.contextPath}/administrador/cuentas-empleados/<c:out value='${e.id}'/>/sus-sectores"
                                                   class="btn btn-outline-secondary btn-sm">Sectores</a>
                                                <a href="${pageContext.request.contextPath}/administrador/cuentas-empleados/<c:out value='${e.id}'/>/sus-encargos"
                                                   class="btn btn-outline-secondary btn-sm">Encargos</a>
                                            </c:if>
                                            <c:if test="${puedeEditar}">
                                                <a href="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/ver/<c:out value='${e.id}'/>"
                                                   class="btn btn-warning btn-sm">Editar</a>
                                            </c:if>
                                            <c:if test="${puedeEliminar}">
                                                <form action="${pageContext.request.contextPath}<c:out value='${rutaBase}'/>/eliminar" method="POST" class="d-inline">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <input type="hidden" name="id" value="<c:out value='${e.id}'/>"/>
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
                    <div class="p-4 text-center text-muted">No hay empleados para mostrar.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:otherwise>
</c:choose>
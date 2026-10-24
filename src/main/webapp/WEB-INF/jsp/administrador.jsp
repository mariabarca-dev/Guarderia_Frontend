<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- FORMULARIO CREAR / EDITAR ADMINISTRADOR --%>
<c:if test="${(puedeCrear or puedeEditar) and not modoBajas}">
    <details class="card shadow-sm mb-4" <c:if test="${not empty registro}">open</c:if>>
        <summary class="card-header bg-dark text-white fw-bold">
            <c:choose>
                <c:when test="${not empty registro}">Editar administrador</c:when>
                <c:otherwise>Registrar nuevo administrador</c:otherwise>
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
                    <label for="nombreUsuario" class="form-label">Nombre de Usuario</label>
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
                        <a href="${pageContext.request.contextPath}${rutaBase}" class="btn btn-secondary">Cancelar</a>
                    </c:if>
                </div>
            </form>
        </div>
    </details>
</c:if>

<%-- LISTADO DE ADMINISTRADORES --%>
<div class="card shadow-sm mb-4">
    <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
        <span>
            <c:out value="${empty titulo ? 'Administradores' : titulo}"/>
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
                            <th>Nombre y Apellido</th>
                            <th>Usuario</th>
                            <th>Teléfono</th>
                            <th>Dirección</th>
                            <c:if test="${modoBajas}"><th>Estado</th></c:if>
                            <c:if test="${not modoBajas and (not empty rutaBase or puedeEliminar)}"><th class="text-end">Acciones</th></c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${registros}">
                            <tr>
                                <td><c:out value="${a.id}"/></td>
                                <td><strong><c:out value="${a.nombre}"/> <c:out value="${a.apellido}"/></strong></td>
                                <td><span class="badge bg-secondary"><c:out value="${a.nombreUsuario}"/></span></td>
                                <td><c:out value="${empty a.telefono ? '-' : a.telefono}"/></td>
                                <td><c:out value="${empty a.direccion ? '-' : a.direccion}"/></td>
                                <c:if test="${modoBajas}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${a.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </c:if>
                                <c:if test="${not modoBajas and (not empty rutaBase or puedeEliminar)}">
                                    <td class="text-end">
                                        <c:if test="${not empty rutaBase}">
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
                <div class="p-4 text-center text-muted">No hay administradores para mostrar.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
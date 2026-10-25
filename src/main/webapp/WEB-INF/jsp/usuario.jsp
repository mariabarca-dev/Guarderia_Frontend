<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  usuario.jsp - Listado general de cuentas (solo SYSADMIN). Fragmento: se incluye dentro de layout.jsp.
  Modelo (lo carga UsuarioController):
    - registros  : lista de cuentas (GET /usuarios o /usuarios/inactivos)
    - registro   : una cuenta (GET /usuarios/{id}); si existe se muestra el detalle
    - rutaBase   : /sysadmin/todas-las-cuentas
    - modoBajas  : true cuando se listan las cuentas dadas de baja
--%>
<c:set var="base" value="${empty rutaBase ? '/sysadmin/todas-las-cuentas' : rutaBase}"/>

<%-- DETALLE DE UNA CUENTA --%>
<c:if test="${not empty registro}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
            <span>Detalle de la cuenta</span>
            <a href="${pageContext.request.contextPath}<c:out value='${base}'/>" class="btn btn-light btn-sm">Volver al listado</a>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Nombre completo</label>
                    <p class="fw-bold mb-0"><c:out value="${registro.nombre}"/> <c:out value="${registro.apellido}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Usuario</label>
                    <p class="fw-bold mb-0"><c:out value="${registro.nombreUsuario}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Rol</label>
                    <p class="mb-0"><span class="badge rol-${registro.rol}"><c:out value="${registro.rol}"/></span></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">DNI</label>
                    <p class="fw-bold mb-0"><c:out value="${empty registro.dni ? '-' : registro.dni}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Dirección</label>
                    <p class="fw-bold mb-0"><c:out value="${empty registro.direccion ? '-' : registro.direccion}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Teléfono</label>
                    <p class="fw-bold mb-0"><c:out value="${empty registro.telefono ? '-' : registro.telefono}"/></p>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted mb-0">Estado</label>
                    <p class="mb-0">
                        <c:choose>
                            <c:when test="${registro.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>
</c:if>

<%-- LISTADO GENERAL DE CUENTAS --%>
<c:if test="${empty registro}">
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-dark text-white fw-bold d-flex justify-content-between align-items-center">
            <span>
                Todas las cuentas
                <c:if test="${modoBajas}"> (dadas de baja)</c:if>
            </span>
            <c:choose>
                <c:when test="${modoBajas}">
                    <a href="${pageContext.request.contextPath}<c:out value='${base}'/>" class="btn btn-light btn-sm">Ver activas</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}<c:out value='${base}'/>/bajas" class="btn btn-light btn-sm">Ver bajas</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="card-body p-0">
            <%-- En la vista de bajas solo se muestran las cuentas dadas de baja (el back devuelve todas) --%>
            <c:set var="hayFilas" value="${not modoBajas}"/>
            <c:if test="${modoBajas}">
                <c:forEach var="x" items="${registros}">
                    <c:if test="${x.activo == false}"><c:set var="hayFilas" value="true"/></c:if>
                </c:forEach>
            </c:if>
            <c:choose>
                <c:when test="${not empty registros and hayFilas}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Nombre y apellido</th>
                                <th>Usuario</th>
                                <th>DNI</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th class="text-end">Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${registros}">
                            <c:if test="${not modoBajas or u.activo == false}">
                                <tr>
                                    <td><c:out value="${u.id}"/></td>
                                    <td><strong><c:out value="${u.nombre}"/> <c:out value="${u.apellido}"/></strong></td>
                                    <td><c:out value="${u.nombreUsuario}"/></td>
                                    <td><c:out value="${empty u.dni ? '-' : u.dni}"/></td>
                                    <td><span class="badge rol-${u.rol}"><c:out value="${u.rol}"/></span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.activo == false}"><span class="badge bg-danger">Baja</span></c:when>
                                            <c:otherwise><span class="badge bg-success">Activo</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}<c:out value='${base}'/>/ver/<c:out value='${u.id}'/>"
                                           class="btn btn-secondary btn-sm">Ver detalle</a>
                                    </td>
                                </tr>
                            </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-4 text-center text-muted">No hay cuentas para mostrar.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:if>

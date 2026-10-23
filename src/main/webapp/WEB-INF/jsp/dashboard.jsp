<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Panel de inicio, igual para todos los roles. "registro" = GET /usuarios/me (UsuarioResponse). --%>
<div class="row">
    <div class="col-lg-8">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-dark text-white fw-bold">
                Bienvenido/a, <c:out value="${registro.nombre}"/> <c:out value="${registro.apellido}"/>
            </div>
            <div class="card-body">
                <h6 class="text-muted mb-3">Datos de tu cuenta</h6>
                <table class="table table-striped mb-0">
                    <tbody>
                    <tr><th class="w-25">Usuario</th><td><c:out value="${registro.nombreUsuario}"/></td></tr>
                    <tr><th>Nombre</th><td><c:out value="${registro.nombre}"/> <c:out value="${registro.apellido}"/></td></tr>
                    <tr><th>DNI</th><td><c:out value="${empty registro.dni ? '-' : registro.dni}"/></td></tr>
                    <tr><th>Rol</th><td><span class="badge bg-secondary"><c:out value="${registro.rol}"/></span></td></tr>
                    <tr>
                        <th>Estado</th>
                        <td>
                            <c:choose>
                                <c:when test="${registro.activo}"><span class="badge bg-success">Activo</span></c:when>
                                <c:otherwise><span class="badge bg-danger">Baja</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-secondary text-white fw-bold">Accesos</div>
            <div class="card-body">
                <p class="mb-0 text-muted">Elegí una opción del menú para empezar.</p>
            </div>
        </div>
    </div>
</div>

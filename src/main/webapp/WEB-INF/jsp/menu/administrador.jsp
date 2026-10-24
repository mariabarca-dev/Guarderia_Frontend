<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Menú del rol ADMINISTRADOR: lo único propio del rol (siempre visible, sin JavaScript). --%>
<div class="d-flex flex-wrap align-items-center gap-1">
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/dash">Inicio</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-zonas">Zonas</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-cocheras">Cocheras</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-rodados">Rodados</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-compras">Compras</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-sectores">Sectores</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/gestion-ocupaciones">Ocupaciones</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/cuentas-socios">Socios</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/cuentas-empleados">Empleados</a>
    <a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/cuentas-administradores">Administradores</a>
    <form action="${pageContext.request.contextPath}/logout" method="post" class="ms-auto">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-outline-light btn-sm">Cerrar sesión</button>
    </form>
</div>

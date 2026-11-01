<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Menú del rol ADMINISTRADOR: lo único propio del rol (siempre visible, sin JavaScript).
     La opción de la pantalla actual se marca con la clase "active". --%>
<%-- Ruta actual sin el contexto. El controller devuelve la vista "layout" con un forward, así que la ruta original
     que pidió el navegador está en el atributo jakarta.servlet.forward.request_uri. --%>
<c:set var="uriActual" value="${not empty requestScope['jakarta.servlet.forward.request_uri'] ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}"/>
<c:set var="ruta" value="${fn:substringAfter(uriActual, pageContext.request.contextPath)}"/>
<div class="d-flex flex-wrap align-items-center gap-1">
    <a class="nav-link text-white${ruta == '/administrador/dash' ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/dash">Inicio</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-zonas') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-zonas">Zonas</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-cocheras') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-cocheras">Cocheras</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-rodados') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-rodados">Rodados</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-compras') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-compras">Compras</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-sectores') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-sectores">Sectores</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/gestion-ocupaciones') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/gestion-ocupaciones">Ocupaciones</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/cuentas-socios') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/cuentas-socios">Socios</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/cuentas-empleados') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/cuentas-empleados">Empleados</a>
    <a class="nav-link text-white${fn:startsWith(ruta, '/administrador/cuentas-administradores') ? ' active' : ''}" href="${pageContext.request.contextPath}/administrador/cuentas-administradores">Administradores</a>
    <form action="${pageContext.request.contextPath}/logout" method="post" class="ms-auto">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button type="submit" class="btn btn-outline-light btn-sm">Cerrar sesión</button>
    </form>
</div>

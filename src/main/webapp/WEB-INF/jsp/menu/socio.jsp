<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Menú del rol SOCIO. La opción de la pantalla actual se marca con la clase "active". --%>
<%-- Ruta actual sin el contexto. El controller devuelve la vista "layout" con un forward, así que la ruta original
     que pidió el navegador está en el atributo jakarta.servlet.forward.request_uri. --%>
<c:set var="uriActual" value="${not empty requestScope['jakarta.servlet.forward.request_uri'] ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}"/>
<c:set var="ruta" value="${fn:substringAfter(uriActual, pageContext.request.contextPath)}"/>
<ul class="nav">
    <li class="nav-item"><a class="nav-link text-white${ruta == '/socio/dash' ? ' active' : ''}" href="${pageContext.request.contextPath}/socio/dash">Inicio</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/socio/mi-perfil') ? ' active' : ''}" href="${pageContext.request.contextPath}/socio/mi-perfil">Mi Perfil</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/socio/mis-vehiculos') ? ' active' : ''}" href="${pageContext.request.contextPath}/socio/mis-vehiculos">Mis Rodados</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/socio/mis-cocheras') ? ' active' : ''}" href="${pageContext.request.contextPath}/socio/mis-cocheras">Mis Cocheras</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/socio/mis-compras') ? ' active' : ''}" href="${pageContext.request.contextPath}/socio/mis-compras">Mis Compras</a></li>
    <li class="nav-item ms-auto">
        <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline-light btn-sm">Salir</button>
        </form>
    </li>
</ul>

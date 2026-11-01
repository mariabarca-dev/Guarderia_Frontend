<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Menú del rol SYSADMIN. La opción de la pantalla actual se marca con la clase "active". --%>
<%-- Ruta actual sin el contexto. El controller devuelve la vista "layout" con un forward, así que la ruta original
     que pidió el navegador está en el atributo jakarta.servlet.forward.request_uri. --%>
<c:set var="uriActual" value="${not empty requestScope['jakarta.servlet.forward.request_uri'] ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}"/>
<c:set var="ruta" value="${fn:substringAfter(uriActual, pageContext.request.contextPath)}"/>
<ul class="nav">
    <li class="nav-item"><a class="nav-link text-white${ruta == '/sysadmin/dash' ? ' active' : ''}" href="${pageContext.request.contextPath}/sysadmin/dash">Panel Principal</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/sysadmin/todas-las-cuentas') ? ' active' : ''}" href="${pageContext.request.contextPath}/sysadmin/todas-las-cuentas">Todas las Cuentas</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/sysadmin/cuentas-socios') ? ' active' : ''}" href="${pageContext.request.contextPath}/sysadmin/cuentas-socios">Gestionar Socios</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/sysadmin/cuentas-empleados') ? ' active' : ''}" href="${pageContext.request.contextPath}/sysadmin/cuentas-empleados">Gestionar Empleados</a></li>
    <li class="nav-item"><a class="nav-link text-white${fn:startsWith(ruta, '/sysadmin/cuentas-administradores') ? ' active' : ''}" href="${pageContext.request.contextPath}/sysadmin/cuentas-administradores">Gestionar Administradores</a></li>
    <li class="nav-item ms-auto">
        <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline-light btn-sm">Salir</button>
        </form>
    </li>
</ul>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<ul class="nav">
    <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/dash">Inicio</a></li>
    <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/cuentas-socios">Cuentas Socios</a></li>
    <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/administrador/cuentas-empleados">Cuentas Empleados</a></li>
    <li class="nav-item ms-auto">
        <form action="${pageContext.request.contextPath}/logout" method="POST" class="m-0">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-outline-light btn-sm">Salir</button>
        </form>
    </li>
</ul>
# GuarderíaCentral – Frontend (Spring MVC + JSP)

Trabajo práctico de **Programación 2** – Tecnicatura Universitaria en Informática Aplicada, UTN-INSPT.
**Grupo A – Tema 9.** Profesor: Miguel Silva.

**Integrantes:** Franco Buyatti, Daniela Forclaz, Héctor Machaca y María Eugenia Barca.

Este repositorio es el **frontend** del sistema de la cochera "Guardería Central": una aplicación web hecha con Spring MVC y JSP que consume la API REST del **backend** (`Guarderia_Backend`). No accede a la base de datos.

> Por consigna, **no se usa JavaScript**. Toda la interacción se resuelve con formularios HTML, enlaces y JSTL.

## Tecnologías

| Componente | Versión / detalle |
|---|---|
| Java | 21 |
| Spring Boot | Spring MVC (Maven, empaquetado WAR) |
| Vistas | JSP + JSTL (Tomcat Jasper) |
| Seguridad | Spring Security (login contra el backend, protección CSRF) |
| Estilos | Bootstrap 5 (por CDN, requiere internet) y `static/css/estilos.css` |
| Utilidades | Lombok |
| Puerto | `8081` |

## Arquitectura

```
Navegador → Frontend (:8081) → Backend REST (:8080) → MySQL
```

El frontend no usa DTO: los datos viajan como `Map` / `List<Map>`. El paquete base es `com.GuarderiaCentral.Guarderia_Frontend`:

| Paquete | Contenido |
|---|---|
| `controllers` | Un controller por entidad. Arman el modelo y devuelven la vista. |
| `services` | Un service por entidad. Llaman al backend con `BackendClientService`. |
| `client` | `BackendClientService`: cliente HTTP al backend (`get`, `post`, `put`, `delete`, `getLista`, `getMapa`) y manejo de la cookie de sesión. |
| `security` | Autenticación contra el backend, redirección por rol y cierre de sesión. |
| `config` | `SecurityConfig` (rutas por rol), `RestTemplateConfig`, `WebConfig`. |
| `advice` | Datos globales para las vistas y manejo de errores del backend. |

### Cómo se arma una pantalla

- Todos los controllers devuelven la vista `layout`.
- El controller fija el atributo `vista` (por ejemplo `zona`, `socio`) y `layout.jsp` incluye `WEB-INF/jsp/${vista}.jsp`.
- El menú se incluye por convención de nombre: `WEB-INF/jsp/menu/<rol>.jsp`.
- Los permisos de pantalla viajan como banderas del modelo (`puedeCrear`, `puedeEditar`, `puedeEliminar`, `modoBajas`).

## Roles y rutas

El login redirige a `/<rol>/dash`. Las rutas se protegen por prefijo en `config/SecurityConfig`:

| Prefijo | Rol | Pantallas |
|---|---|---|
| `/socio/**` | SOCIO | Mi perfil, mis rodados, mis cocheras, mis compras |
| `/empleado/**` | EMPLEADO | Mi legajo, mis sectores, mis rodados a cargo |
| `/administrador/**` | ADMINISTRADOR | Zonas, cocheras, rodados, compras, sectores, ocupaciones, y cuentas de socios, empleados y administradores |
| `/sysadmin/**` | SYSADMIN | Todas las cuentas y gestión de cuentas |

Cada listado tiene su historial de bajas (`.../bajas`).

## Requisitos previos

- JDK 21
- IntelliJ IDEA (Maven integrado) o Maven 3.9+
- **El backend en ejecución** (y su base de datos MySQL)

## Configuración

Todo está en `src/main/resources/application.properties`:

```properties
server.port=8081
backend.api.url=http://localhost:8080/api
server.servlet.session.timeout=30m
```

- `backend.api.url`: dirección del backend. Si el backend corre en otra PC, cambiá `localhost` por su IP (por ejemplo `http://192.168.0.10:8080/api`).
- En el backend, `app.cors.allowed-origin` debe coincidir con la dirección desde la que se abre este frontend.

## Cómo ejecutarlo

**Desde IntelliJ IDEA**

1. `File > Open` y elegí la carpeta del proyecto (la que contiene `pom.xml`).
2. Esperá a que Maven descargue las dependencias y confirmá el SDK 21.
3. Ejecutá `GuarderiaFrontendApplication`.
4. Si aparece un error de JSP o de Tomcat en IntelliJ, en la configuración de ejecución activá **"Add dependencies with 'provided' scope to classpath"**.

**Desde la terminal**

```bash
mvn spring-boot:run
```

Abrí `http://localhost:8081/login`. **Levantá primero el backend y después el frontend.**

## Acceso desde otras PC o celulares

Para que otros dispositivos de la misma red vean la web, abrí `http://<IP-de-la-PC-del-frontend>:8081/login` (con `http://`) y permití el puerto 8081 en el firewall de Windows.

## Estructura del proyecto

```
Guarderia_Frontend/
├── src/main/java/com/GuarderiaCentral/Guarderia_Frontend/
│   ├── advice/ client/ config/ controllers/ security/ services/
├── src/main/webapp/WEB-INF/jsp/      ← vistas (layout, menu/<rol>.jsp, una por entidad)
├── src/main/resources/
│   ├── application.properties
│   └── static/css/estilos.css
└── pom.xml
```

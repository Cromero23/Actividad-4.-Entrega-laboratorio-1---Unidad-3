# Unidad III — Laboratorio 01: Bitácoras y auditoría del dato en PostgreSQL

## Descripción

Este repositorio documenta las actividades del Laboratorio 01 de la Unidad III de la materia Gestión de Seguridad y Desempeño de Bases de Datos.

El laboratorio se desarrolló utilizando PostgreSQL 16 sobre Windows, con el objetivo de configurar mecanismos de registro, identificar eventos de seguridad y establecer una auditoría a nivel de dato mediante disparadores.

Se trabajó con la base de datos `comercial`, simulando situaciones relacionadas con modificaciones de información sensible, accesos fallidos, cambios de permisos y manipulación de mecanismos de auditoría.

## Objetivos

- Configurar las bitácoras del servidor PostgreSQL.
- Registrar conexiones, desconexiones y modificaciones.
- Identificar accesos fallidos y operaciones rechazadas.
- Auditar operaciones INSERT, UPDATE y DELETE.
- Conservar los valores anteriores y posteriores de los registros modificados.
- Verificar la seguridad de los registros de auditoría.
- Exportar y proteger evidencias mediante SHA-256.
- Reconstruir acontecimientos a partir de registros históricos.

## Entorno utilizado

| Componente | Descripción |
|---|---|
| Motor | PostgreSQL 16 |
| Sistema operativo | Windows |
| Despliegue | Instalación local |
| Base de datos | comercial |
| Administración | pgAdmin 4 |
| Consola | PowerShell y psql |
| Editor | Visual Studio Code |

## Actividades desarrolladas

### Parte A — Bitácora del servidor

Se realizaron las actividades 1 a 9, incluyendo la configuración del colector, análisis de accesos, modificaciones de privilegios, operaciones rechazadas y consultas de sesiones activas.

### Parte B — Auditoría del dato

Se realizaron las actividades 10 a 15, implementando el esquema `auditoria`, una tabla de registro, una función `SECURITY DEFINER` y un disparador de auditoría sobre `public.clientes`.

### Cierre

Las actividades 16 y 17 permitieron exportar la bitácora, verificar su integridad mediante SHA-256 y reconstruir una cronología de los acontecimientos.

## Resultados obtenidos

La verificación final confirmó que el registro del servidor estaba habilitado con `log_statement = mod`.

También se confirmó que el disparador `trg_auditoria_clientes` permanecía activo.

Se conservaron ocho eventos en la tabla de auditoría: una inserción, seis actualizaciones y una eliminación.

Los usuarios `app_ventas` y `soporte_ana` no disponían de acceso al esquema `auditoria` ni de los permisos comprobados sobre `auditoria.cambios_clientes`.

## Archivos del proyecto

- **[sql/](sql/):** Scripts SQL utilizados en la configuración y auditoría.
- **[evidencias/](evidencias/):** Capturas de pantalla y documentación de las actividades.
- **[informe.md](informe.md):** Informe final, análisis de resultados y preguntas de reflexión.
- **[Bitácora exportada](evidencias/bitacora-lab01.log):** Archivo de registros de la práctica.
- **[Hash SHA-256](evidencias/bitacora-lab01.sha256):** Control de integridad de la exportación.

## Consideraciones de seguridad

Los datos utilizados corresponden a un entorno de práctica.

Se deben evitar contraseñas reales, claves privadas y otros secretos en el repositorio.

Antes de publicar archivos de registro, se debe comprobar que no contengan credenciales, tokens ni información sensible que no deba difundirse.

La base de datos y los mecanismos de auditoría se conservarán para su utilización en las siguientes prácticas de la Unidad III.

## Autor

**Carlos Romero**

Facultad de Informática Culiacán  
Universidad Autónoma de Sinaloa

**Fecha:** 28 de octubre de 2026
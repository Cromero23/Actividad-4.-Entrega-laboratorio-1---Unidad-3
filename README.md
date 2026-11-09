# Unidad III — Laboratorio 01: Bitácoras y auditoría del dato en PostgreSQL

**Universidad Autónoma de Sinaloa**  
**Facultad de Informática Culiacán**  
**Licenciatura en Informática**  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Alumno:** Carlos Alberto Romero Corral  
**Grupo:** 4-4

## Descripción

Este repositorio contiene el desarrollo del **Laboratorio 01 de la Unidad III**, enfocado en la configuración de bitácoras, el seguimiento de operaciones y la auditoría de modificaciones de datos en PostgreSQL.

El laboratorio se realizó utilizando **PostgreSQL 16 en Windows**, con apoyo de pgAdmin 4, PowerShell, psql y Visual Studio Code.

Se utilizó la base de datos `comercial` para simular incidentes de seguridad, analizar operaciones ejecutadas por diferentes usuarios e implementar mecanismos que permitieran reconstruir los cambios realizados.

## Objetivo

Implementar y analizar mecanismos de registro y auditoría en PostgreSQL para identificar accesos, operaciones, errores y modificaciones sobre los datos, así como conservar evidencias que permitan investigar posibles incidentes de seguridad.

## Actividades realizadas

### 1. Preparación del entorno

Se configuró la base de datos `comercial` y la tabla `public.clientes`, utilizando registros ficticios para las pruebas.

También se crearon y configuraron los roles `app_ventas` y `soporte_ana`, asignándoles permisos específicos para simular diferentes niveles de acceso.

### 2. Configuración de las bitácoras de PostgreSQL

Se revisó la configuración inicial de los registros del servidor y se modificaron los parámetros necesarios para habilitar el seguimiento de actividades.

La configuración final fue:

| Parámetro | Valor |
|---|---|
| `logging_collector` | `on` |
| `log_connections` | `on` |
| `log_disconnections` | `on` |
| `log_statement` | `mod` |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h` |

Estos parámetros permitieron registrar conexiones, desconexiones, operaciones de modificación y datos de contexto de las sesiones.

### 3. Simulación y análisis de incidentes

Se realizaron pruebas para observar cómo PostgreSQL registra distintos acontecimientos:

- Modificaciones de información sin una auditoría de datos previamente habilitada.
- Conexiones exitosas e intentos de autenticación fallidos.
- Modificaciones de privilegios mediante `GRANT` y `REVOKE`.
- Cambios estructurales mediante `ALTER TABLE`.
- Actualizaciones de información mediante `UPDATE`.
- Errores por falta de permisos.
- Supervisión de sesiones activas mediante `pg_stat_activity`.

Estas actividades permitieron identificar la diferencia entre los registros generales del servidor y la información necesaria para conocer los cambios específicos realizados sobre los datos.

### 4. Implementación de auditoría mediante disparadores

Se creó el esquema `auditoria` y la tabla `auditoria.cambios_clientes` para conservar los cambios realizados sobre `public.clientes`.

También se implementaron:

- La función `auditoria.registrar_cambio_cliente`, utilizando `SECURITY DEFINER`.
- El disparador `trg_auditoria_clientes`.
- El registro de operaciones `INSERT`, `UPDATE` y `DELETE`.
- La conservación de los valores anteriores y posteriores de las modificaciones mediante JSONB.
- El registro del usuario de sesión, usuario efectivo, aplicación, dirección IP y fecha del evento.

De esta manera, fue posible identificar qué registro se modificó, cuándo ocurrió el cambio y cuáles eran los valores anteriores y posteriores.

### 5. Pruebas de seguridad y limitaciones

Se verificó que los usuarios `app_ventas` y `soporte_ana` no contaran con permisos directos para consultar o modificar la tabla de auditoría.

También se realizaron pruebas para analizar las limitaciones del mecanismo implementado, entre ellas:

- La ausencia de registros de lectura con `log_statement = mod`.
- La diferencia entre el registro de una sentencia masiva y los múltiples cambios individuales que puede generar.
- La posibilidad de que un administrador con privilegios suficientes desactive temporalmente un disparador.
- La importancia de proteger los registros frente a manipulaciones.

Al finalizar las pruebas se comprobó que el disparador de auditoría permanecía habilitado.

### 6. Conservación de evidencias

Se exportó una copia de la bitácora del servidor para su análisis.

Posteriormente, se generó un archivo con su hash **SHA-256** y se comprobó la integridad de la exportación.

Finalmente, se elaboró una cronología de los acontecimientos utilizando la bitácora del servidor y los registros almacenados en la tabla de auditoría.

### 7. Verificaciones finales

Se realizaron consultas para comprobar la configuración, el funcionamiento del disparador y la protección de los registros.

Los resultados obtenidos fueron:

| Verificación | Resultado |
|---|---|
| Configuración de bitácoras | Correcta |
| Disparador `trg_auditoria_clientes` | Activo |
| Eventos registrados | 8 |
| Inserciones | 1 |
| Actualizaciones | 6 |
| Eliminaciones | 1 |
| Acceso directo de `app_ventas` a auditoría | Denegado |
| Acceso directo de `soporte_ana` a auditoría | Denegado |

## Actividad opcional omitida: pgAudit

La guía del Laboratorio 01 incluye una sección opcional relacionada con el uso de la extensión **pgAudit** para ampliar las capacidades de auditoría de PostgreSQL.

Durante la práctica se comprobó que esta extensión no se encontraba disponible en la instalación local de PostgreSQL 16 utilizada.

Debido a que su implementación era **opcional**, se decidió omitir esta sección y completar las actividades obligatorias del laboratorio mediante las bitácoras nativas de PostgreSQL y la auditoría implementada con funciones y disparadores.

**No se instaló ni configuró pgAudit, y no se presentan resultados de ejecución de dicha extensión.**

## Estructura del repositorio

```text
unidad-03/
│
├── README.md
│
└── laboratorio-01-bitacoras-auditoria-postgresql/
    │
    ├── README.md
    ├── informe.md
    │
    ├── sql/
    │   └── Scripts SQL
    │
    └── evidencias/
        ├── Documentación de las actividades
        ├── Capturas de pantalla
        └── Archivos de evidencia
```

## Documentación y evidencias

El contenido del laboratorio puede consultarse en los siguientes enlaces:

- [Laboratorio 01 — Documentación principal](laboratorio-01-bitacoras-auditoria-postgresql/README.md)
- [Informe final](laboratorio-01-bitacoras-auditoria-postgresql/informe.md)
- [Scripts SQL](laboratorio-01-bitacoras-auditoria-postgresql/sql/)
- [Evidencias](laboratorio-01-bitacoras-auditoria-postgresql/evidencias/)

**Nota de seguridad:** Los registros originales de PostgreSQL pueden contener información sensible. Antes de publicar evidencias se debe verificar que no incluyan contraseñas, tokens u otros secretos.

## Conclusión

El Laboratorio 01 permitió comprender la importancia de implementar mecanismos de auditoría y trazabilidad en PostgreSQL.

Mediante la configuración de bitácoras, la creación de funciones y disparadores, el análisis de privilegios y la conservación de evidencias, se consiguió identificar y documentar distintos acontecimientos relacionados con la seguridad de una base de datos.

Se comprobó que las bitácoras del servidor y la auditoría a nivel de dato son mecanismos complementarios, ya que permiten relacionar las operaciones ejecutadas con los cambios concretos realizados sobre la información.

**Se completaron las actividades obligatorias del laboratorio, omitiendo únicamente la sección opcional de pgAudit.**
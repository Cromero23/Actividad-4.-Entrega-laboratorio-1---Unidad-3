
-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- ACTIVIDAD 4 - CONFIGURACION DE BITACORAS
--
-- Archivo: 02-configuracion-bitacora.sql
-- Base de datos: comercial
-- PostgreSQL 16 - Windows
-- Usuario administrador: postgres
-- ============================================================


-- ============================================================
-- 1. VERIFICAR EL ENTORNO ACTUAL
-- ============================================================

SELECT
    current_database() AS base_actual,
    current_user AS usuario_actual;


-- ============================================================
-- 2. CONSULTAR CONFIGURACION ANTES DE LOS CAMBIOS
-- ============================================================

SELECT
    name,
    setting,
    source
FROM pg_settings
WHERE name IN (
    'log_connections',
    'log_disconnections',
    'log_line_prefix',
    'log_statement'
)
ORDER BY name;


-- ============================================================
-- 3. ACTIVAR EL REGISTRO DE CONEXIONES
-- EJECUTAR ESTA SENTENCIA POR SEPARADO
-- ============================================================

ALTER SYSTEM SET log_connections = on;


-- ============================================================
-- 4. ACTIVAR EL REGISTRO DE DESCONEXIONES
-- EJECUTAR ESTA SENTENCIA POR SEPARADO
-- ============================================================

ALTER SYSTEM SET log_disconnections = on;


-- ============================================================
-- 5. AMPLIAR LA INFORMACION DEL PREFIJO
--
-- %m = marca de tiempo con milisegundos
-- %p = PID del proceso
-- %u = usuario de PostgreSQL
-- %d = base de datos
-- %a = nombre de la aplicacion
-- %h = direccion del cliente
--
-- EJECUTAR ESTA SENTENCIA POR SEPARADO
-- ============================================================

ALTER SYSTEM SET log_line_prefix =
'%m [%p] user=%u db=%d app=%a client=%h ';


-- ============================================================
-- 6. REGISTRAR CAMBIOS DE ESTRUCTURA
-- EJECUTAR ESTA SENTENCIA POR SEPARADO
-- ============================================================

ALTER SYSTEM SET log_statement = 'ddl';


-- ============================================================
-- 7. APLICAR LA CONFIGURACION
-- EJECUTAR POR SEPARADO
-- ============================================================

SELECT pg_reload_conf();


-- ============================================================
-- 8. VERIFICAR CONFIGURACION ACTIVA
-- EJECUTAR EN UNA CONSULTA NUEVA
-- ============================================================

SELECT
    name,
    setting,
    source,
    sourcefile,
    pending_restart
FROM pg_settings
WHERE name IN (
    'log_connections',
    'log_disconnections',
    'log_line_prefix',
    'log_statement'
)
ORDER BY name;


-- ============================================================
-- 9. CONSULTAR CAMBIOS EN LA BITACORA
-- ============================================================

SELECT
    num,
    linea
FROM dba.bitacora
WHERE linea ILIKE '%parameter%'
ORDER BY num DESC
LIMIT 15;


-- ============================================================
-- 10. REVISAR LOS ULTIMOS EVENTOS
-- ============================================================

SELECT
    num,
    linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 10;


-- ============================================================
-- INTERPRETACION
-- ============================================================

-- log_connections = on
-- Registra los intentos y eventos de conexion.

-- log_disconnections = on
-- Registra las desconexiones de las sesiones.

-- log_line_prefix
-- Permite identificar tiempo, PID, usuario,
-- base de datos, aplicacion y cliente.

-- log_statement = ddl
-- Registra sentencias de definicion de datos.
-- No registra automaticamente los UPDATE exitosos.

-- pg_reload_conf()
-- Solicita la recarga de la configuracion sin reiniciar
-- el servicio completo de PostgreSQL.

-- ALTER SYSTEM
-- Escribe valores en postgresql.auto.conf.

-- Los cambios son globales para esta instancia.
-- ============================================================


-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- ACTIVIDAD 2 - COLECTOR Y VISTA DE BITACORA
--
-- Archivo: 01-colector-y-vista.sql
-- Base de datos: comercial
-- Motor: PostgreSQL 16
-- Sistema operativo: Windows
-- Ejecutar como: postgres
--
-- OBJETIVO:
-- Verificar el colector de registros y crear una vista
-- administrativa para consultar la bitacora del servidor.
--
-- CORRECCIONES:
-- 1. Lectura binaria para evitar errores UTF-8.
-- 2. Conversion LATIN1 para tolerar bytes de Windows.
-- 3. COLLATE "default" para conservar el ordenamiento
--    original de la columna linea.
-- ============================================================


-- ============================================================
-- 1. COMPROBAR LA BASE DE DATOS Y EL USUARIO
-- ============================================================

SELECT
    current_database() AS base_actual,
    current_user AS usuario_actual;


-- ============================================================
-- 2. VERIFICAR EL ESTADO DEL COLECTOR
-- ============================================================

SELECT
    name,
    setting,
    source,
    pending_restart
FROM pg_settings
WHERE name = 'logging_collector';


-- ============================================================
-- 3. LOCALIZAR EL ARCHIVO ACTUAL DE BITACORA
-- ============================================================

SELECT
    pg_current_logfile() AS archivo_bitacora;


-- ============================================================
-- 4. CONSULTAR LAS RUTAS Y EL FORMATO DE REGISTRO
-- ============================================================

SHOW data_directory;

SHOW log_directory;

SHOW log_filename;


-- ============================================================
-- 5. CREAR EL ESQUEMA ADMINISTRATIVO
-- ============================================================

CREATE SCHEMA IF NOT EXISTS dba;


-- ============================================================
-- 6. RESTRINGIR EL ACCESO PUBLICO AL ESQUEMA
-- ============================================================

REVOKE ALL ON SCHEMA dba FROM PUBLIC;


-- ============================================================
-- 7. CREAR O ACTUALIZAR LA VISTA DE BITACORA
--
-- pg_read_binary_file:
-- Lee los bytes del archivo de registro.
--
-- convert_from(..., 'LATIN1'):
-- Convierte los bytes a texto y permite tolerar
-- caracteres que provocaban errores UTF-8.
--
-- regexp_split_to_table:
-- Divide el contenido en lineas.
--
-- WITH ORDINALITY:
-- Asigna un numero consecutivo a cada linea.
--
-- COLLATE "default":
-- Conserva el ordenamiento original de la columna
-- y evita el error SQLSTATE 42P16.
-- ============================================================

CREATE OR REPLACE VIEW dba.bitacora AS
SELECT
    t.n AS num,
    t.linea COLLATE "default" AS linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'LATIN1'
    ),
    E'\n'
) WITH ORDINALITY AS t(linea, n)
WHERE t.linea <> '';


-- ============================================================
-- 8. PROTEGER LA VISTA
-- ============================================================

REVOKE ALL ON dba.bitacora FROM PUBLIC;


-- ============================================================
-- 9. CONSULTAR LAS ULTIMAS DIEZ LINEAS
-- ============================================================

SELECT
    num,
    linea
FROM dba.bitacora
ORDER BY num DESC
LIMIT 10;


-- ============================================================
-- 10. COMPROBAR EL EVENTO DE LA ACTIVIDAD 2
-- ============================================================

SELECT
    num,
    linea
FROM dba.bitacora
WHERE linea LIKE '%LAB01_ACT2_PRUEBA_BITACORA%'
ORDER BY num DESC
LIMIT 10;


-- ============================================================
-- RESULTADOS VERIFICADOS DURANTE EL LABORATORIO
-- ============================================================

-- logging_collector = on
--
-- La vista recupero correctamente el evento WARNING:
-- LAB01_ACT2_PRUEBA_BITACORA
--
-- Se recupero tambien su contexto PL/pgSQL.
--
-- Posteriormente se detecto un problema de codificacion
-- UTF-8 al leer el archivo completo.
--
-- Se sustituyo pg_read_file por pg_read_binary_file
-- con conversion LATIN1.
--
-- Ademas, se agrego COLLATE "default" para conservar
-- la definicion original de la vista.
--
-- La consulta corregida se ejecuto correctamente.
--
-- La vista es de uso administrativo.
-- No se conceden permisos publicos sobre ella.
--
-- NOTA:
-- La conversion LATIN1 permite consultar el archivo,
-- pero ciertos caracteres especiales pueden mostrarse
-- incorrectamente cuando se mezclan codificaciones.


-- ============================================================
-- CONCLUSION
-- ============================================================

-- Se verifico que PostgreSQL tiene habilitado el
-- colector de registros.
--
-- Se creo una vista administrativa para consultar
-- las lineas del archivo de bitacora mediante SQL.
--
-- Se corrigieron los problemas de codificacion
-- y ordenamiento encontrados en Windows.
--
-- La lectura de los registros quedo funcional.
-- ============================================================

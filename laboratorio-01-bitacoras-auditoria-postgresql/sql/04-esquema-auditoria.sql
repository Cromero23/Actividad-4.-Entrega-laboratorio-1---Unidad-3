
-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- PARTE B - ACTIVIDAD 10
-- DISENO Y CREACION DEL REGISTRO DE AUDITORIA
--
-- Archivo: 04-esquema-auditoria.sql
-- Base de datos: comercial
-- PostgreSQL 16 - Windows
-- Ejecutar como: postgres
-- ============================================================


-- 1. Verificar el entorno

SELECT
    current_database() AS base_actual,
    current_user AS usuario_actual;


-- 2. Crear esquema separado para auditoria

CREATE SCHEMA auditoria;


-- 3. Restringir el acceso publico

REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;


-- 4. Crear la tabla de auditoria

CREATE TABLE auditoria.cambios_clientes (

    id_evento BIGSERIAL PRIMARY KEY,

    momento TIMESTAMPTZ NOT NULL DEFAULT now(),

    usuario_sesion TEXT NOT NULL DEFAULT session_user,

    usuario_efectivo TEXT NOT NULL DEFAULT current_user,

    aplicacion TEXT DEFAULT current_setting('application_name'),

    ip_cliente INET DEFAULT inet_client_addr(),

    operacion TEXT NOT NULL,

    id_cliente BIGINT,

    valores_antes JSONB,

    valores_despues JSONB

);


-- 5. Verificar las columnas creadas

SELECT
    ordinal_position AS posicion,
    column_name AS columna,
    data_type AS tipo,
    is_nullable AS permite_nulos,
    column_default AS valor_predeterminado
FROM information_schema.columns
WHERE table_schema = 'auditoria'
  AND table_name = 'cambios_clientes'
ORDER BY ordinal_position;


-- 6. Verificar que inicialmente no hay eventos

SELECT
    COUNT(*) AS total_eventos
FROM auditoria.cambios_clientes;


-- 7. Comprobar las restricciones para usuarios ordinarios

SELECT
    rolname AS usuario,
    has_schema_privilege(
        rolname, 'auditoria', 'USAGE'
    ) AS acceso_esquema,
    has_table_privilege(
        rolname,
        'auditoria.cambios_clientes',
        'SELECT'
    ) AS permiso_select,
    has_table_privilege(
        rolname,
        'auditoria.cambios_clientes',
        'INSERT'
    ) AS permiso_insert
FROM pg_roles
WHERE rolname IN ('app_ventas', 'soporte_ana')
ORDER BY rolname;


-- ============================================================
-- OBSERVACIONES
-- ============================================================

-- La tabla conserva el momento y el contexto de la sesion.
-- Los valores anteriores y nuevos se almacenan en JSONB.
--
-- En esta actividad solo creamos la estructura.
-- La funcion y el disparador se crearan en la Actividad 11.
--
-- Los usuarios ordinarios no necesitan acceso directo
-- a los registros de auditoria.
-- ============================================================

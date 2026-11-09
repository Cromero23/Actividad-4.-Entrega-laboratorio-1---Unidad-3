
-- =====================================================
-- UNIDAD III - LAB-01
-- Preparacion de roles y permisos
-- Base de datos: comercial
-- =====================================================

-- 1. Confirmar la base de datos
SELECT current_database() AS base_actual;

-- 2. Crear las cuentas de laboratorio
CREATE ROLE app_ventas LOGIN;
CREATE ROLE soporte_ana LOGIN;

-- 3. Permitir acceso a la base comercial
GRANT CONNECT ON DATABASE comercial
TO app_ventas, soporte_ana;

-- 4. Permitir acceso al esquema public
GRANT USAGE ON SCHEMA public
TO app_ventas, soporte_ana;

-- 5. Aplicar privilegios del escenario
GRANT SELECT, UPDATE
ON public.clientes
TO app_ventas;

GRANT SELECT
ON public.clientes
TO soporte_ana;

-- 6. Verificar los roles y sus privilegios
SELECT
    rolname AS usuario,
    rolcanlogin AS puede_conectarse,
    rolsuper AS es_superusuario,
    has_table_privilege(
        rolname, 'public.clientes', 'SELECT'
    ) AS permiso_select,
    has_table_privilege(
        rolname, 'public.clientes', 'UPDATE'
    ) AS permiso_update
FROM pg_roles
WHERE rolname IN ('app_ventas', 'soporte_ana')
ORDER BY rolname;

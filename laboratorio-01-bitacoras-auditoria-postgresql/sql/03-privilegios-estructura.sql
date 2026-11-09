
-- ===================================================
-- UNIDAD III - LABORATORIO 01
-- ACTIVIDAD 6 - Privilegios y estructura
--
-- Base de datos: comercial
-- Ejecutar como: postgres
-- ===================================================

-- Confirmar la base de datos
SELECT current_database() AS base_actual;

-- Revocacion preventiva:
-- soporte_ana no dispone de UPDATE actualmente.
REVOKE UPDATE
ON public.clientes
FROM soporte_ana;

-- Confirmar el permiso de la cuenta de ventas
GRANT UPDATE
ON public.clientes
TO app_ventas;

-- Agregar un campo a la estructura
ALTER TABLE public.clientes
ADD COLUMN segmento VARCHAR(20);

-- Verificar la nueva columna
SELECT
    column_name,
    data_type,
    character_maximum_length
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'clientes'
  AND column_name = 'segmento';

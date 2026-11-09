
-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- ACTIVIDAD 14 - MANIPULACION CONTROLADA DE LA AUDITORIA
--
-- Archivo: 08-manipulacion-auditoria.sql
-- Base de datos: comercial
-- Ejecutar exclusivamente como postgres.
-- ============================================================

-- 1. Verificar situacion inicial

SELECT
    (SELECT COUNT(*)
     FROM auditoria.cambios_clientes) AS eventos_antes,

    (SELECT rfc
     FROM public.clientes
     WHERE id = 3) AS rfc_antes;


-- 2. Iniciar transaccion

BEGIN;


-- 3. Desactivar temporalmente el disparador

ALTER TABLE public.clientes
DISABLE TRIGGER trg_auditoria_clientes;


-- 4. Realizar una modificacion sin auditoria de datos

UPDATE public.clientes
SET rfc = 'GAMA780912GHI'
WHERE id = 3;


-- 5. Reactivar el disparador

ALTER TABLE public.clientes
ENABLE TRIGGER trg_auditoria_clientes;


-- 6. Confirmar la transaccion

COMMIT;


-- 7. Verificar el resultado

SELECT
    (SELECT rfc
     FROM public.clientes
     WHERE id = 3) AS rfc_actual,

    (SELECT COUNT(*)
     FROM auditoria.cambios_clientes) AS eventos_despues,

    (SELECT tgenabled
     FROM pg_trigger
     WHERE tgname = 'trg_auditoria_clientes') AS estado_disparador;


-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- PARTE B - ACTIVIDAD 11
-- FUNCION Y DISPARADOR DE AUDITORIA
--
-- Archivo: 05-funcion-disparador.sql
-- Base de datos: comercial
-- Motor: PostgreSQL 16
-- Ejecutar como: postgres
-- ============================================================

-- 1. Confirmar base de datos y usuario

SELECT
    current_database() AS base_actual,
    current_user AS usuario_actual;


-- 2. Crear la funcion de auditoria

CREATE OR REPLACE FUNCTION auditoria.registrar_cambio_cliente()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN

    -- Registrar una insercion
    IF TG_OP = 'INSERT' THEN

        INSERT INTO auditoria.cambios_clientes
            (operacion, id_cliente, valores_despues)
        VALUES
            (TG_OP, NEW.id, to_jsonb(NEW));

        RETURN NEW;

    -- Registrar una actualizacion
    ELSIF TG_OP = 'UPDATE' THEN

        INSERT INTO auditoria.cambios_clientes
            (operacion, id_cliente,
             valores_antes, valores_despues)
        VALUES
            (TG_OP, NEW.id,
             to_jsonb(OLD), to_jsonb(NEW));

        RETURN NEW;

    -- Registrar una eliminacion
    ELSIF TG_OP = 'DELETE' THEN

        INSERT INTO auditoria.cambios_clientes
            (operacion, id_cliente, valores_antes)
        VALUES
            (TG_OP, OLD.id, to_jsonb(OLD));

        RETURN OLD;

    END IF;

    RETURN NULL;

END;
$$;


-- 3. Restringir la ejecucion publica de la funcion

REVOKE ALL ON FUNCTION
    auditoria.registrar_cambio_cliente()
FROM PUBLIC;


-- 4. Crear el disparador sobre clientes

CREATE TRIGGER trg_auditoria_clientes
AFTER INSERT OR UPDATE OR DELETE
ON public.clientes
FOR EACH ROW
EXECUTE FUNCTION auditoria.registrar_cambio_cliente();


-- 5. Verificar que el disparador existe y esta habilitado

SELECT
    tgname AS nombre_disparador,
    tgenabled AS estado,
    tgrelid::regclass AS tabla
FROM pg_trigger
WHERE NOT tgisinternal
  AND tgname = 'trg_auditoria_clientes';


-- 6. Comprobar las propiedades de seguridad

SELECT
    p.proname AS funcion,
    r.rolname AS propietario,
    p.prosecdef AS security_definer,
    p.proconfig AS configuracion
FROM pg_proc p
JOIN pg_roles r ON r.oid = p.proowner
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'auditoria'
  AND p.proname = 'registrar_cambio_cliente';


-- 7. Comprobar que todavia no hay eventos

SELECT
    COUNT(*) AS total_eventos
FROM auditoria.cambios_clientes;


-- ============================================================
-- OBSERVACIONES
-- ============================================================

-- SECURITY DEFINER:
-- La funcion se ejecuta con los privilegios del propietario.
--
-- session_user:
-- Conserva el usuario que inicio la sesion.
--
-- current_user:
-- Refleja el usuario efectivo durante la insercion;
-- en este caso sera el propietario de la funcion.
--
-- AFTER:
-- La auditoria registra operaciones ya realizadas,
-- dentro de la misma transaccion.
--
-- OLD:
-- Contiene el registro anterior.
--
-- NEW:
-- Contiene el registro nuevo.
--
-- El usuario app_ventas no necesita permisos directos
-- sobre auditoria.cambios_clientes.
--
-- No ejecutar UPDATE, INSERT ni DELETE de prueba
-- hasta comenzar la Actividad 12.
-- ============================================================

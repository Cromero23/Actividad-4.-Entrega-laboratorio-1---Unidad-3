
-- =====================================================
-- UNIDAD III - LABORATORIO 01
-- ACTIVIDAD 13 - ALTAS Y BAJAS
--
-- Archivo: 07-altas-bajas.sql
-- Base de datos: comercial
-- Ejecutar como: postgres
-- =====================================================


-- 1. Verificar que el cliente de prueba no exista

SELECT
    id,
    nombre,
    rfc
FROM public.clientes
WHERE rfc = 'RUPE950101AAA';


-- 2. INSERTAR CLIENTE FICTICIO
-- Ejecutar una sola vez.

INSERT INTO public.clientes
    (nombre, correo, rfc, edad, ciudad, codigo_postal)
VALUES
    (
        'Pedro Ruiz',
        'pedro.ruiz@example.test',
        'RUPE950101AAA',
        30,
        'Guasave',
        '81000'
    )
RETURNING id, nombre, rfc;


-- 3. Verificar que existe el evento INSERT

SELECT
    id_evento,
    usuario_sesion,
    operacion,
    id_cliente,
    valores_despues ->> 'nombre' AS nombre,
    valores_despues ->> 'rfc' AS rfc
FROM auditoria.cambios_clientes
WHERE operacion = 'INSERT'
  AND valores_despues ->> 'rfc' = 'RUPE950101AAA'
ORDER BY id_evento DESC;


-- 4. ELIMINAR CLIENTE FICTICIO
-- Ejecutar una sola vez, despues de comprobar INSERT.

DELETE FROM public.clientes
WHERE nombre = 'Pedro Ruiz'
  AND correo = 'pedro.ruiz@example.test'
  AND rfc = 'RUPE950101AAA'
RETURNING id, nombre, rfc;


-- 5. Verificar que ya no existe en clientes

SELECT COUNT(*) AS clientes_restantes
FROM public.clientes
WHERE rfc = 'RUPE950101AAA';


-- 6. Consultar el historial de auditoria

SELECT
    id_evento,
    usuario_sesion,
    aplicacion,
    ip_cliente,
    operacion,
    id_cliente,
    valores_antes ->> 'rfc' AS rfc_antes,
    valores_despues ->> 'rfc' AS rfc_despues
FROM auditoria.cambios_clientes
ORDER BY id_evento;


-- =====================================================
-- RESULTADO ESPERADO
--
-- UPDATE: Cambio del RFC de Maria Garcia.
-- INSERT: Alta del cliente Pedro Ruiz.
-- DELETE: Baja del cliente Pedro Ruiz.
--
-- La eliminacion del cliente no borra la auditoria.
-- =====================================================

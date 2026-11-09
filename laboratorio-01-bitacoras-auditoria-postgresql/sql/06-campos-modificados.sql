
-- ============================================================
-- UNIDAD III - LABORATORIO 01
-- PARTE B - ACTIVIDAD 12
-- COMPARACION DE VALORES ANTERIORES Y POSTERIORES
--
-- Archivo: 06-campos-modificados.sql
-- Base de datos: comercial
-- Ejecutar como: postgres
--
-- Solo contiene consultas de lectura.
-- ============================================================


-- 1. Verificar la base de datos

SELECT current_database() AS base_actual;


-- 2. Consultar el historial del cliente 3

SELECT
    id_evento,
    momento,
    usuario_sesion,
    usuario_efectivo,
    aplicacion,
    ip_cliente,
    operacion,
    id_cliente
FROM auditoria.cambios_clientes
WHERE id_cliente = 3
ORDER BY id_evento;


-- 3. Comparar los valores anteriores y nuevos

SELECT
    a.id_evento,
    a.momento,
    a.usuario_sesion,
    a.ip_cliente,
    d.key AS campo,
    a.valores_antes ->> d.key AS antes,
    d.value #>> '{}' AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL
    jsonb_each(a.valores_despues) AS d(key, value)
WHERE a.operacion = 'UPDATE'
  AND a.id_cliente = 3
  AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY
    a.id_evento,
    d.key;


-- 4. Comprobar el RFC actual

SELECT
    id,
    nombre,
    rfc
FROM public.clientes
WHERE id = 3;


-- ============================================================
-- RESULTADO ESPERADO DE LA PRUEBA
--
-- Campo: rfc
-- Antes: GAMA780912XYZ
-- Despues: GAMA780912ZZZ
--
-- Los valores se comprobaran mediante la auditoria real.
-- ============================================================

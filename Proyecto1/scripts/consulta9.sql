SELECT mes, Monto
FROM(
    SELECT  EXTRACT(MONTH FROM o.fecha_orden) AS mes, SUM(products.precio*ov.cantidad) as Monto
    FROM orden_de_venta o
    INNER JOIN detalle_de_orden ov
    ON o.id_orden = ov.id_orden
    INNER JOIN productos products
    ON products.id_producto = ov.productos_id_producto
    GROUP BY EXTRACT(MONTH FROM o.fecha_orden)
    ORDER BY Monto desc)
WHERE ROWNUM <= 1
UNION ALL
SELECT mes, Monto
FROM(
    SELECT  EXTRACT(MONTH FROM o.fecha_orden) AS mes, SUM(products.precio*ov.cantidad) as Monto
    FROM orden_de_venta o
    INNER JOIN detalle_de_orden ov
    ON o.id_orden = ov.id_orden
    INNER JOIN productos products
    ON products.id_producto = ov.productos_id_producto
    GROUP BY EXTRACT(MONTH FROM o.fecha_orden)
    ORDER BY Monto asc)
WHERE ROWNUM <= 1;
/*
Mostrar el mes con más y menos ventas. Se debe de mostrar el número de mes y
monto. (Una sola consulta).
*/
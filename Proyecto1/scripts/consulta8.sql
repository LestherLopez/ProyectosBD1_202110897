SELECT  EXTRACT(MONTH FROM o.fecha_orden) AS mes, SUM(product.precio*ov.cantidad) as Monto
FROM pais p
INNER JOIN vendedores v
ON v.id_pais = p.id_pais
INNER JOIN detalle_de_orden ov
ON v.id_vendedor = ov.vendedores_id_vendedor
INNER JOIN orden_de_venta o
ON ov.id_orden = o.id_orden
INNER JOIN productos product
ON product.id_producto = ov.productos_id_producto
WHERE p.id_pais = 10
GROUP BY EXTRACT(MONTH FROM o.fecha_orden);
/*
Mostrar las ventas por mes de Inglaterra. Debe de mostrar el número del mes y el
monto.
*/
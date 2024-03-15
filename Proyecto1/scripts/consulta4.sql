SELECT nombrep, Monto, numeroveces
FROM(
SELECT p.nombre AS nombrep, SUM(products.precio*detalleo.cantidad) as Monto, COUNT(v.id_vendedor) AS numeroveces
FROM pais p 
INNER JOIN vendedores v 
ON p.id_pais= v.id_pais
INNER JOIN detalle_de_orden detalleo
ON v.id_vendedor = detalleo.vendedores_id_vendedor 
INNER JOIN productos products
ON products.id_producto = detalleo.productos_id_producto
GROUP BY p.nombre
ORDER BY numeroveces desc)
WHERE ROWNUM <= 1
UNION ALL
SELECT nombrep, Monto, numeroveces
FROM(
SELECT p.nombre AS nombrep, SUM(products.precio*detalleo.cantidad) as Monto, COUNT(v.id_vendedor) AS numeroveces
FROM pais p 
INNER JOIN vendedores v 
ON p.id_pais= v.id_pais
INNER JOIN detalle_de_orden detalleo
ON v.id_vendedor = detalleo.vendedores_id_vendedor 
INNER JOIN productos products
ON products.id_producto = detalleo.productos_id_producto
GROUP BY p.nombre
ORDER BY numeroveces asc)
WHERE ROWNUM <= 1;
/*
Mostrar el país que más y menos ha vendido. Debe mostrar el nombre del país y el
monto. (Una sola consulta).
*/
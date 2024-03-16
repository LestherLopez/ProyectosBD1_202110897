SELECT ven.id_vendedor, ven.nombre, SUM(products.precio*detalleo.cantidad) as Monto, SUM(detalleo.cantidad) AS numeroveces
FROM vendedores ven
INNER JOIN detalle_de_orden detalleo
ON ven.id_vendedor = detalleo.vendedores_id_vendedor 
INNER JOIN productos products
ON products.id_producto = detalleo.productos_id_producto
GROUP BY ven.id_vendedor, ven.nombre
ORDER BY numeroveces desc
FETCH FIRST 1 ROWS ONLY;
/*
Mostrar a la persona que más ha vendido. Se debe mostrar el id del vendedor,
nombre del vendedor, monto total vendido.
*/
SELECT do.productos_id_producto, pr.nombre, SUM(pr.precio * do.cantidad) as Monto
FROM detalle_de_orden do
INNER JOIN productos pr ON pr.id_producto = do.productos_id_producto
WHERE pr.categoria_id_categoria = 15
GROUP BY do.productos_id_producto, pr.nombre;
/*
Mostrar las ventas de cada producto de la categoría deportes. Se debe de mostrar el
id del producto, nombre y monto
*/
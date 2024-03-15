SELECT c.id_cliente, c.nombre, c.apellido, p.nombre, SUM(product.precio*detalleo.cantidad) as Monto, COUNT(c.id_cliente) AS numeroveces
FROM clientes c
INNER JOIN pais p 
ON c.id_pais = p.id_pais
INNER JOIN orden_de_venta o 
ON c.id_cliente = o.clientes_id_cliente
INNER JOIN detalle_de_orden detalleo 
ON o.id_orden = detalleo.id_orden
INNER JOIN productos product 
ON detalleo.productos_id_producto = product.id_producto
GROUP BY c.id_cliente, c.nombre, c.apellido, p.nombre
ORDER BY numeroveces desc
FETCH FIRST 1 ROWS ONLY;
/*
Mostrar el cliente que más ha comprado. Se debe de mostrar el id del cliente,
nombre, apellido, país y monto total.
*/
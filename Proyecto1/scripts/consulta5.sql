select idp, nombrep, Monto, numeroveces
FROM(
    SELECT p.id_pais AS idp, p.nombre AS nombrep, SUM(products.precio*detalleo.cantidad) as Monto, COUNT(o.clientes_id_cliente) AS numeroveces
    FROM pais p 
    INNER JOIN clientes c
    ON p.id_pais= c.id_pais
    INNER JOIN orden_de_venta o
    ON c.id_cliente = o.clientes_id_cliente
    INNER JOIN detalle_de_orden detalleo 
    ON o.id_orden = detalleo.id_orden
    INNER JOIN productos products
    ON products.id_producto = detalleo.productos_id_producto
    GROUP BY p.id_pais , p.nombre
    ORDER BY numeroveces desc
    FETCH FIRST 5 ROWS ONLY
)
ORDER by numeroveces ASC;

/*
Top 5 de países que más han comprado en orden ascendente. Se le solicita mostrar
el id del país, nombre y monto total.
*/
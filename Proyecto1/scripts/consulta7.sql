SELECT nombrecat, nombrepais, unidades
FROM (
    SELECT cat.nombre AS nombrecat, p.nombre AS nombrepais, SUM(detalleo.cantidad) AS unidades,
           RANK() OVER (PARTITION BY p.nombre ORDER BY SUM(detalleo.cantidad) DESC) AS rank_num
    FROM categoria cat
    INNER JOIN productos product ON cat.id_categoria = product.categoria_id_categoria
    INNER JOIN detalle_de_orden detalleo ON product.id_producto = detalleo.productos_id_producto
    INNER JOIN orden_de_venta orderv ON orderv.id_orden = detalleo.id_orden
    INNER JOIN clientes cli ON cli.id_cliente = orderv.clientes_id_cliente
    INNER JOIN pais p ON p.id_pais = cli.id_pais
    GROUP BY cat.nombre, p.nombre
)
WHERE rank_num = 1;
/*
Mostrar la categoría más comprada por cada país. Se debe de mostrar el nombre del
país, nombre de la categoría y cantidad de unidades.
*/

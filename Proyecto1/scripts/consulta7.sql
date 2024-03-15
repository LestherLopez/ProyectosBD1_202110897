SELECT nombre_pais, nombre_categoria, numeroveces
FROM (
    SELECT p.nombre AS nombre_pais,
           category.nombre AS nombre_categoria,
           SUM(detalleo.cantidad) AS numeroveces,
           ROW_NUMBER() OVER (PARTITION BY p.nombre ORDER BY SUM(detalleo.cantidad) DESC) AS rank_num
    FROM clientes c
    INNER JOIN pais p ON c.id_pais = p.id_pais
    INNER JOIN orden_de_venta o ON c.id_cliente = o.clientes_id_cliente
    INNER JOIN detalle_de_orden detalleo ON o.id_orden = detalleo.id_orden
    INNER JOIN productos product ON product.id_producto = detalleo.productos_id_producto
    INNER JOIN categoria category ON category.id_categoria = product.id_producto
    GROUP BY p.nombre, category.nombre
)
WHERE rank_num = 1;

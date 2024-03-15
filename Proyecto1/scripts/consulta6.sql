SELECT nombrec, numeroveces
FROM(
    SELECT category.nombre AS nombrec,  SUM(detalleo.cantidad) AS numeroveces
    FROM categoria category 
    INNER JOIN productos pr
    ON category.id_categoria = pr.categoria_id_categoria
    INNER JOIN detalle_de_orden detalleo
    ON pr.id_producto = detalleo.productos_id_producto
    GROUP BY category.nombre
    ORDER BY numeroveces desc
    )
WHERE ROWNUM <= 1
UNION ALL
SELECT nombrec, numeroveces
FROM(
    SELECT category.nombre AS nombrec,  SUM(detalleo.cantidad) AS numeroveces
    FROM categoria category 
    INNER JOIN productos pr
    ON category.id_categoria = pr.categoria_id_categoria
    INNER JOIN detalle_de_orden detalleo
    ON pr.id_producto = detalleo.productos_id_producto
    GROUP BY category.nombre
    ORDER BY numeroveces asc)
WHERE ROWNUM <= 1;

/*
Mostrar la categoría que más y menos se ha comprado. Debe de mostrar el nombre
de la categoría y cantidad de unidades. (Una sola consulta).
*/
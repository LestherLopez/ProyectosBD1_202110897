SELECT products.id_producto, products.nombre, category.nombre, SUM(detalleo.cantidad) AS cantidad,  SUM(products.precio*detalleo.cantidad) as Monto 
FROM productos products
INNER JOIN categoria category
ON products.categoria_id_categoria = category.id_categoria
INNER JOIN detalle_de_orden detalleo
ON products.id_producto = detalleo.productos_id_producto
GROUP BY products.id_producto, products.nombre, category.nombre
ORDER BY cantidad asc
FETCH FIRST 1 ROWS ONLY;
SELECT products.id_producto, products.nombre, category.nombre, SUM(detalleo.cantidad) AS cantidad,  SUM(products.precio*detalleo.cantidad) as Monto 
FROM productos products
INNER JOIN categoria category
ON products.categoria_id_categoria = category.id_categoria
INNER JOIN detalle_de_orden detalleo
ON products.id_producto = detalleo.productos_id_producto
GROUP BY products.id_producto, products.nombre, category.nombre
ORDER BY cantidad desc
FETCH FIRST 1 ROWS ONLY;
/*
 Mostrar el producto más y menos comprado. Se debe mostrar el id del producto,
nombre del producto, categoría, cantidad de unidades y monto vendido
*/
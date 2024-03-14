INSERT INTO pais (id_pais, nombre) 
VALUES (:id_pais, :nombre);

INSERT INTO categoria (id_categoria, nombre) 
VALUES (:id_categoria, :nombre);

INSERT INTO vendedores (id_vendedor, nombre, id_pais) 
VALUES (:id_vendedor, :nombre, :id_pais);

INSERT INTO clientes (id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, id_pais) 
VALUES (:id_cliente, :nombre, :apellido, :direccion, :telefono, :tarjeta, :edad, :salario, :genero, :id_pais);

INSERT INTO productos (id_producto, nombre, precio, categoria_id_categoria) 
VALUES (:id_producto, :nombre, :precio, :categoria_id_categoria);

INSERT INTO temporden (id_orden, linea_orden, fecha_orden, clientes_id_cliente,  vendedores_id_vendedor, productos_id_producto, cantidad) 
VALUES (:id_orden, :linea_orden, :fecha_orden, :clientes_id_cliente,  :vendedores_id_vendedor, :productos_id_producto, :cantidad);

INSERT INTO orden_de_venta (id_orden, fecha_orden, clientes_id_cliente) 
SELECT DISTINCT id_orden, fecha_orden, clientes_id_cliente FROM temporden;

INSERT INTO detalle_de_orden (id_orden, linea_orden, vendedores_id_vendedor, productos_id_producto, cantidad) 
SELECT id_orden, linea_orden, vendedores_id_vendedor, productos_id_producto, cantidad
FROM temporden
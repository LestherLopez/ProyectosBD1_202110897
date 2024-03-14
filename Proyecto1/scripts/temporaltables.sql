CREATE TABLE tempcategoria (
    id_categoria INTEGER NOT NULL,
    nombre       VARCHAR2(100) NOT NULL
);


CREATE TABLE tempclientes (
    id_cliente   INTEGER NOT NULL,
    nombre       VARCHAR2(30) NOT NULL,
    apellido     VARCHAR2(30) NOT NULL,
    direccion    VARCHAR2(60),
    telefono     INTEGER NOT NULL,
    tarjeta      INTEGER NOT NULL,
    edad         INTEGER,
    salario      INTEGER,
    genero       VARCHAR2(1),
    pais_id_pais INTEGER NOT NULL
);


CREATE TABLE tempdetalle_de_orden (
    orden_de_venta_id_orden INTEGER NOT NULL,
    linea_orden             INTEGER NOT NULL,
    vendedores_id_vendedor  INTEGER NOT NULL,
    productos_id_producto   INTEGER NOT NULL,
    cantidad                INTEGER NOT NULL
);



CREATE TABLE temporden_de_venta (
    id_orden            INTEGER NOT NULL,
    fecha_orden         DATE NOT NULL,
    clientes_id_cliente INTEGER NOT NULL
);


CREATE TABLE temppais (
    id_pais INTEGER NOT NULL,
    nombre  VARCHAR2(30) NOT NULL
);


CREATE TABLE tempproductos (
    id_producto            INTEGER NOT NULL,
    nombre                 VARCHAR2(30) NOT NULL,
    precio                 FLOAT NOT NULL,
    categoria_id_categoria INTEGER NOT NULL
);


CREATE TABLE tempvendedores (
    id_vendedor  INTEGER NOT NULL,
    nombre       VARCHAR2(30) NOT NULL,
    pais_id_pais INTEGER NOT NULL
);





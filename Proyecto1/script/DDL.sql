CREATE TABLE categoria (
    id_categoria INTEGER NOT NULL,
    nombre       VARCHAR2(100) NOT NULL
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( id_categoria );

CREATE TABLE clientes (
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

ALTER TABLE clientes ADD CONSTRAINT clientes_pk PRIMARY KEY ( id_cliente );

CREATE TABLE orden_de_venta (
    id_orden               INTEGER NOT NULL,
    linea_orden            INTEGER NOT NULL,
    fecha_orden            DATE NOT NULL,
    clientes_id_cliente    INTEGER NOT NULL,
    vendedores_id_vendedor INTEGER NOT NULL,
    productos_id_producto  INTEGER NOT NULL,
    cantidad               INTEGER NOT NULL
);

ALTER TABLE orden_de_venta ADD CONSTRAINT orden_de_venta_pk PRIMARY KEY ( id_orden );

CREATE TABLE pais (
    id_pais INTEGER NOT NULL,
    nombre  VARCHAR2(30) NOT NULL
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( id_pais );

CREATE TABLE productos (
    id_producto            INTEGER NOT NULL,
    nombre                 VARCHAR2(30) NOT NULL,
    precio                 FLOAT NOT NULL,
    categoria_id_categoria INTEGER NOT NULL
);

ALTER TABLE productos ADD CONSTRAINT productos_pk PRIMARY KEY ( id_producto );

CREATE TABLE vendedores (
    id_vendedor  INTEGER NOT NULL,
    nombre       VARCHAR2(30) NOT NULL,
    pais_id_pais INTEGER NOT NULL
);

ALTER TABLE vendedores ADD CONSTRAINT vendedores_pk PRIMARY KEY ( id_vendedor );
-- llaves foraneas
ALTER TABLE clientes
    ADD CONSTRAINT clientes_pais_fk FOREIGN KEY ( pais_id_pais )
        REFERENCES pais ( id_pais );

ALTER TABLE orden_de_venta
    ADD CONSTRAINT orden_de_venta_clientes_fk FOREIGN KEY ( clientes_id_cliente )
        REFERENCES clientes ( id_cliente );

ALTER TABLE orden_de_venta
    ADD CONSTRAINT orden_de_venta_productos_fk FOREIGN KEY ( productos_id_producto )
        REFERENCES productos ( id_producto );

ALTER TABLE orden_de_venta
    ADD CONSTRAINT orden_de_venta_vendedores_fk FOREIGN KEY ( vendedores_id_vendedor )
        REFERENCES vendedores ( id_vendedor );

ALTER TABLE productos
    ADD CONSTRAINT productos_categoria_fk FOREIGN KEY ( categoria_id_categoria )
        REFERENCES categoria ( id_categoria );

ALTER TABLE vendedores
    ADD CONSTRAINT vendedores_pais_fk FOREIGN KEY ( pais_id_pais )
        REFERENCES pais ( id_pais );
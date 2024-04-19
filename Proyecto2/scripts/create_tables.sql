
CREATE TABLE clientes (
    idcliente           INTEGER NOT NULL,
    nombre              VARCHAR2(40) NOT NULL,
    apellidos           VARCHAR2(40) NOT NULL,
    telefono            VARCHAR2(12) NOT NULL,
    correo              VARCHAR2(40) NOT NULL,
    usuario             VARCHAR2(40) NOT NULL,
    contraseña          VARCHAR2(200) NOT NULL,
    tipo_cliente_idtipo INTEGER NOT NULL,
    fecha_creacion      DATE NOT NULL
);

ALTER TABLE clientes ADD CONSTRAINT clientes_pk PRIMARY KEY ( idcliente );

CREATE TABLE compras (
    id_compra                  INTEGER NOT NULL,
    fecha                      DATE,
    importe_compra             NUMBER(12, 2) NOT NULL,
    otros_detalles             VARCHAR2(40),
    producto_servicio_codigo INTEGER NOT NULL,
    clientes_idcliente         INTEGER NOT NULL
);

ALTER TABLE compras ADD CONSTRAINT compras_pk PRIMARY KEY ( id_compra );

CREATE TABLE cuenta (
    id_cuenta          INTEGER NOT NULL,
    monto_apertura     NUMBER(12, 2) NOT NULL,
    saldo_cuenta       NUMBER(12, 2) NOT NULL,
    descripcion        VARCHAR2(100),
    fecha_de_apertura  VARCHAR2(20) NOT NULL,
    otros_detalles     VARCHAR2(100),
    tipo_cuenta_codigo INTEGER NOT NULL,
    clientes_idcliente INTEGER NOT NULL
);


ALTER TABLE cuenta ADD CONSTRAINT cuenta_pk PRIMARY KEY ( id_cuenta );

CREATE TABLE debito (
    id_debito          INTEGER NOT NULL,
    fecha              DATE NOT NULL,
    monto              NUMBER(12, 2) NOT NULL,
    otros_detalles     VARCHAR2(40),
    clientes_idcliente INTEGER NOT NULL
);

ALTER TABLE debito ADD CONSTRAINT debito_pk PRIMARY KEY ( id_debito );

CREATE TABLE depositos (
    id_deposito        INTEGER NOT NULL,
    fecha              DATE NOT NULL,
    monto              NUMBER(12, 2) NOT NULL,
    otros_detalles     VARCHAR2(40),
    clientes_idcliente INTEGER NOT NULL
);

ALTER TABLE depositos ADD CONSTRAINT depositos_pk PRIMARY KEY ( id_deposito );

CREATE TABLE producto_servicio (
    codigo      INTEGER NOT NULL,
    tipo        INTEGER NOT NULL,
    costo       NUMBER(12, 2),
    descripcion VARCHAR2(100)
);

ALTER TABLE producto_servicio ADD CONSTRAINT producto_servicio_PK PRIMARY KEY ( codigo );

CREATE TABLE tipo_cliente (
    idtipo      INTEGER NOT NULL,
    nombre      VARCHAR2(40) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL
);

ALTER TABLE tipo_cliente ADD CONSTRAINT tipo_cliente_pk PRIMARY KEY ( idtipo );

CREATE TABLE tipo_cuenta (
    codigo      INTEGER NOT NULL,
    nombre      VARCHAR2(40) NOT NULL,
    descripcion VARCHAR2(100)
);

ALTER TABLE tipo_cuenta ADD CONSTRAINT tipo_cuenta_pk PRIMARY KEY ( codigo );

CREATE TABLE tipo_transaccion (
    codigo_transaccion INTEGER NOT NULL,
    nombre             VARCHAR2(40) NOT NULL,
    descripcion        VARCHAR2(100)
);

ALTER TABLE tipo_transaccion ADD CONSTRAINT tipo_transaccion_pk PRIMARY KEY ( codigo_transaccion );

CREATE TABLE transaccion (
    id_transaccion          INTEGER NOT NULL,
    fecha                   DATE NOT NULL,
    otros_detalles          VARCHAR2(40),
    tipo_transaccion_codigo INTEGER NOT NULL,
    no_cuenta               INTEGER NOT NULL,
    compras_id_compra       INTEGER,
    depositos_id_deposito   INTEGER,
    debito_id_debito        INTEGER
);

ALTER TABLE transaccion ADD CONSTRAINT transaccion_pk PRIMARY KEY ( id_transaccion );

ALTER TABLE clientes
    ADD CONSTRAINT clientes_tipo_cliente_fk FOREIGN KEY ( tipo_cliente_idtipo )
        REFERENCES tipo_cliente ( idtipo );

ALTER TABLE compras
    ADD CONSTRAINT compras_clientes_fk FOREIGN KEY ( clientes_idcliente )
        REFERENCES clientes ( idcliente );

ALTER TABLE compras
    ADD CONSTRAINT compras_producto_servicio_FK FOREIGN KEY ( producto_servicio_codigo )
        REFERENCES producto_servicio ( codigo );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_clientes_fk FOREIGN KEY ( clientes_idcliente )
        REFERENCES clientes ( idcliente );

ALTER TABLE cuenta
    ADD CONSTRAINT cuenta_tipo_cuenta_fk FOREIGN KEY ( tipo_cuenta_codigo )
        REFERENCES tipo_cuenta ( codigo );

ALTER TABLE debito
    ADD CONSTRAINT debito_clientes_fk FOREIGN KEY ( clientes_idcliente )
        REFERENCES clientes ( idcliente );

ALTER TABLE depositos
    ADD CONSTRAINT depositos_clientes_fk FOREIGN KEY ( clientes_idcliente )
        REFERENCES clientes ( idcliente );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_compras_fk FOREIGN KEY ( compras_id_compra )
        REFERENCES compras ( id_compra );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_debito_fk FOREIGN KEY ( debito_id_debito )
        REFERENCES debito ( id_debito );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_depositos_fk FOREIGN KEY ( depositos_id_deposito )
        REFERENCES depositos ( id_deposito );

ALTER TABLE transaccion
    ADD CONSTRAINT transaccion_transaccion_fk FOREIGN KEY ( tipo_transaccion_codigo )
        REFERENCES tipo_transaccion ( codigo_transaccion );

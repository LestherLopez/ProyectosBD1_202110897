

-- 1. crear tipo de Cliente
CREATE SEQUENCE seq_idTipo
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
--restart sequence
--ALTER SEQUENCE seq_idTipo RESTART;
CREATE OR REPLACE PROCEDURE registrarTipoCliente(
    idTipo IN NUMBER,
    nombre IN VARCHAR2,
    descripcion IN VARCHAR2
)
IS
    descripcion_valid BOOLEAN;
    newId_Tipo NUMBER;
BEGIN
  
    descripcion_valid := validarLetras(descripcion);


    IF NOT descripcion_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Descripción inválida, debe contener solo letras.');
    ELSE
      
        INSERT INTO tipo_cliente (idTipo, nombre, descripcion) 
        VALUES (seq_idTipo.NEXTVAL, nombre, descripcion);
    END IF;
END;
/

-- 2. registrarCliente

CREATE OR REPLACE PROCEDURE registrarCliente(
    idCliente IN INTEGER, --idCliente
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    telefono IN VARCHAR2,
    correo IN VARCHAR2,
    usuario_name IN VARCHAR2,
    contraseña_user IN VARCHAR2,
    tipoCliente IN INTEGER
)
IS
    name_valid BOOLEAN;
    lastname_valid BOOLEAN;
    phone_valid VARCHAR2(12);
    email_valid BOOLEAN;
    user_count INTEGER;
    typeuser_count INTEGER;
    fecha_actual DATE;
BEGIN
    name_valid := validarLetras(nombre); 
    lastname_valid := validarLetras(apellidos);  --validar solo letras en nombre
    phone_valid := validarTelefono(telefono);
    email_valid := validarEmail(correo);  
    fecha_actual := SYSDATE;
    SELECT COUNT(*)
    INTO user_count
    FROM CLIENTES
    WHERE usuario = usuario_name;

    SELECT COUNT(*)
    INTO typeuser_count
    FROM tipo_cliente
    WHERE idtipo = tipoCliente;

    IF NOT name_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nombre invalido, debe contener solo letras.');
    ELSIF NOT lastname_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Apellido invalida, debe contener solo letras.');
    ELSIF NOT email_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Correo invalido, la estructura no es correcta.');
    ELSIF user_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Usuario invalido, el usuario ya existe.');
    ELSIF typeuser_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo cliente invalido, puesto que no existe.');
    ELSE
        INSERT INTO clientes ( idcliente, nombre, apellidos, telefono, correo, usuario, contraseña, tipo_cliente_idtipo, fecha_creacion )
        VALUES (
            idCliente, nombre, apellidos, phone_valid, correo, usuario_name, contraseña_user, tipoCliente, fecha_actual
        );
    END IF;
END;
/
-- 4. registrarTipoCuenta
CREATE SEQUENCE seq_idTipoCuenta
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
--restart sequence
--ALTER SEQUENCE seq_idTipo RESTART;

-- crear Tipo de Cuenta
CREATE OR REPLACE PROCEDURE registrarTipoCuenta(
    codigoCuenta IN NUMBER,
    nombreCuenta IN VARCHAR2,
    descripcionCuenta IN VARCHAR2
)
IS
    newId_Tipo NUMBER;
BEGIN
        INSERT INTO tipo_cuenta (codigo, nombre, descripcion) 
        VALUES (seq_idTipoCuenta.NEXTVAL, nombreCuenta, descripcionCuenta);
END;
/

-- 3. registrarCuenta

CREATE OR REPLACE PROCEDURE registrarCuenta(
    idCuenta IN INTEGER, --idCliente
    montoApertura IN NUMBER,
    saldoCuenta IN NUMBER,
    descripcionCuenta IN VARCHAR2,
    fechadeApertura IN VARCHAR2,
    otrosDetalles IN VARCHAR2,
    tipoCuenta IN INTEGER,
    idCliente IN INTEGER
)
IS
    montoApertura_valid BOOLEAN;
    saldoCuenta_valid BOOLEAN;
    fechaAperturaValid VARCHAR2(20);
    tipoCuenta_Valid INTEGER;
    idCliente_valid INTEGER;
    idCuenta_valid INTEGER;
   
BEGIN
    montoApertura_valid := validarPositivo(montoApertura); 
    saldoCuenta_valid := validarSaldoCuenta(saldoCuenta); 
    
    -- obtener fecha
    IF fechadeApertura IS NOT NULL THEN
        fechaAperturaValid := fechadeApertura;
    ELSE
        fechaAperturaValid := TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS');
    END IF;

    -- validar que no exista cuenta
    SELECT COUNT(*)
    INTO idCuenta_valid
    FROM CUENTA
    WHERE id_cuenta = idCuenta;

    -- validar que exista cliente
    SELECT COUNT(*)
    INTO idCliente_valid
    FROM CLIENTES
    WHERE idcliente = idCliente;
    -- validar que exista cuenta
    SELECT COUNT(*)
    INTO tipoCuenta_Valid
    FROM tipo_cuenta
    WHERE codigo = tipoCuenta;

    IF NOT montoApertura_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Monto de apertura invalido, debe ser un valor positivo.');
    ELSIF NOT saldoCuenta_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Saldo de cuenta invalido, debe ser mayor o igual a 0.');
    ELSIF idCliente_valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cliente invalido, el cliente no existe.');
    ELSIF idCuenta_valid > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cuenta invalida, la cuenta ya existe.');
    ELSIF tipoCuenta_Valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo cuenta invalido, puesto que no existe.');
    ELSE
        INSERT INTO cuenta ( id_cuenta, monto_apertura, saldo_cuenta, descripcion, fecha_de_apertura, otros_detalles, tipo_cuenta_codigo, clientes_idcliente )
        VALUES (
            idCuenta, montoApertura, saldoCuenta, descripcionCuenta, fechaAperturaValid, otrosDetalles, tipoCuenta, idCliente
        );
    END IF;
END;
/


-- 5. crearProductoServicio
CREATE OR REPLACE PROCEDURE crearProductoServicio(
    codigoProducto IN INTEGER,
    tipoProducto IN INTEGER,
    costoProducto IN NUMBER,
    descripcionProducto IN VARCHAR2
)
IS
BEGIN
    IF tipoProducto = 1 THEN
        IF costoProducto > 0 THEN 
            INSERT INTO producto_servicio (codigo, tipo, costo, descripcion) 
            VALUES (codigoProducto, tipoProducto, costoProducto, descripcionProducto);
        ELSE
             RAISE_APPLICATION_ERROR(-20001, 'El costo es nulo, debe contener costo por ser servicio.');
        END IF;
       
    ELSE
        INSERT INTO producto_servicio (codigo, tipo, costo, descripcion) 
        VALUES (codigoProducto, tipoProducto, costoProducto, descripcionProducto);
    END IF;
END;
/



--  6. realizarCompra
CREATE OR REPLACE PROCEDURE realizarCompra(
    idCompra IN INTEGER,
    fechaCompra IN VARCHAR2,
    importeCompra IN NUMBER,
    otrosDetalles IN VARCHAR2,
    codigoProducto IN INTEGER,
    idCliente IN INTEGER
)
IS
    idCliente_valid INTEGER;
    prodserv_Valid INTEGER;
    tipoProducto INTEGER;
BEGIN
    
    -- validar que exista cliente
    SELECT COUNT(*)
    INTO idCliente_valid
    FROM CLIENTES
    WHERE idcliente = idCliente;
    -- validar que exista el codigo de producto/servicio
    SELECT COUNT(*)
    INTO prodserv_Valid
    FROM producto_servicio
    WHERE codigo = codigoProducto;
    -- obtener el tipo del producto
    IF idCliente_valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cliente invalido, el cliente no existe.');
    ELSIF prodserv_Valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Codigo Invalido, el producto/servicio no existe.');
    ELSE
        SELECT tipo
        INTO tipoProducto
        FROM PRODUCTO_SERVICIO
        WHERE codigo = codigoProducto;
        -- es producto
        IF tipoProducto = 2 THEN
            IF importeCompra > 0 THEN 
                INSERT INTO compras (id_compra, fecha, importe_compra, otros_detalles, producto_servicio_codigo, clientes_idcliente) 
                VALUES (idCompra, TO_DATE(fechaCompra, 'DD/MM/YYYY'), importeCompra, otrosDetalles, codigoProducto, idCliente);
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Importe compra es invalido, debe contener el importe mayor a 0 por ser producto.');
            END IF;
        -- es servicio
        ELSE
            IF importeCompra = 0  THEN 
                INSERT INTO compras (id_compra, fecha, importe_compra, otros_detalles, producto_servicio_codigo, clientes_idcliente) 
                VALUES (idCompra, TO_DATE(fechaCompra, 'DD/MM/YYYY'), importeCompra, otrosDetalles, codigoProducto, idCliente);
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Importe compra es invalido, puesto que servicio ya cuenta con monto.');
            END IF;
        END IF;
    END IF;
END;
/

-- 7. realizarDeposito

CREATE OR REPLACE PROCEDURE realizarDeposito(
    idDeposito IN NUMBER,
    fechaDeposito IN VARCHAR2,
    montoDeposito IN VARCHAR2,
    otrosDetalles IN VARCHAR2,
    idCliente IN INTEGER
)
IS
    idCliente_valid NUMBER;
BEGIN
        -- validar que exista cliente
        SELECT COUNT(*)
        INTO idCliente_valid
        FROM CLIENTES
        WHERE idcliente = idCliente;
        IF idCliente_valid = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cliente invalido, el cliente no existe.');
        ELSE
            INSERT INTO depositos (id_deposito, fecha, monto, otros_detalles, clientes_idcliente) 
            VALUES (idDeposito, fechaDeposito, montoDeposito, otrosDetalles, idCliente);
        END IF;
END;
/




/*
Verify emails, password and cellphones in registrarCliente!!!!!
verify monto apertura and floats in registrarCuenta
*/
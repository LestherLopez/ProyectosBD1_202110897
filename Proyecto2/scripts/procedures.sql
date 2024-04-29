

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
    idDeposito IN INTEGER,
    fechaDeposito IN DATE,
    montoDeposito IN NUMBER,
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
        ELSIF montoDeposito <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Monto invalido, el monto debe ser mayor a 0.');
        ELSE
            INSERT INTO depositos (id_deposito, fecha, monto, otros_detalles, clientes_idcliente) 
            VALUES (idDeposito, TO_DATE(fechaDeposito, 'DD/MM/YYYY'), montoDeposito, otrosDetalles, idCliente);
        END IF;
END;
/


-- 8. realizarDebito

CREATE OR REPLACE PROCEDURE realizarDebito(
    idDebito IN INTEGER,
    fechaDebito IN DATE,
    montoDebito IN NUMBER,
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
        ELSIF montoDebito <= 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Monto invalido, el monto debe ser mayor a 0.');
        ELSE
            INSERT INTO debito (id_debito, fecha, monto, otros_detalles, clientes_idcliente) 
            VALUES (idDebito,  TO_DATE(fechaDebito, 'DD/MM/YYYY'), montoDebito, otrosDetalles, idCliente);
        END IF;
END;
/


-- 10. registrarTipoTransaccion
CREATE SEQUENCE seq_idTipoTransaccion
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
--restart sequence
--ALTER SEQUENCE seq_idTipoTransaccion RESTART;

CREATE OR REPLACE PROCEDURE registrarTipoTransaccion(
    codigoTransaccion IN NUMBER,
    nombreTransaccion IN VARCHAR2,
    descripcionTransaccion IN VARCHAR2
)
IS
BEGIN
        INSERT INTO tipo_transaccion (codigo_transaccion, nombre, descripcion) 
        VALUES (seq_idTipoTransaccion.NEXTVAL, nombreTransaccion, descripcionTransaccion);
END;
/


-- 9. asignarTransaccion
CREATE SEQUENCE seq_idTransaccion
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;
--ALTER SEQUENCE seq_idTransaccion RESTART;
CREATE OR REPLACE PROCEDURE asignarTransaccion(
    idTransaccion IN INTEGER,
    fechaTransaccion IN VARCHAR2,
    otrosDetalles IN VARCHAR2,
    idTipoTransaccion IN INTEGER, 
    idComDepDeb IN INTEGER,
    nocuenta IN INTEGER
)
IS
    tipoTransaccion_valid NUMBER;
    comdepdeb_valid NUMBER;
    cliente_id INTEGER;
    cuenta_valid NUMBER;
    monto_valor NUMBER;
    cliente_saldo NUMBER;

BEGIN
    -- verificar que exista el tipo de transaccion
    SELECT COUNT(*)
    INTO tipoTransaccion_valid
    FROM tipo_transaccion
    WHERE codigo_transaccion = idTipoTransaccion;
    -- verificar que exista la compra/deposito/debito
    SELECT COUNT(*)
    INTO comdepdeb_valid
    FROM (
        SELECT id_compra FROM compras WHERE id_compra = idComDepDeb
        UNION ALL
        SELECT id_debito FROM debito WHERE id_debito = idComDepDeb
        UNION ALL
        SELECT id_deposito FROM depositos WHERE id_deposito = idComDepDeb
    );
    -- verificar que corresponda al cliente
        -- obtener el cliente
    SELECT clientes_idcliente
    INTO cliente_id
    FROM (
        SELECT clientes_idcliente FROM compras WHERE id_compra = idComDepDeb
        UNION ALL
        SELECT clientes_idcliente FROM debito WHERE id_debito = idComDepDeb
        UNION ALL
        SELECT clientes_idcliente FROM depositos WHERE id_deposito = idComDepDeb
    );
    SELECT COUNT(*)
    INTO cuenta_valid
    FROM CUENTA 
    WHERE cliente_id = clientes_idcliente;
   

    SELECT mo
        INTO monto_valor
        FROM (
            SELECT  importe_compra AS mo FROM compras WHERE id_compra = idComDepDeb
            UNION ALL
            SELECT monto AS mo FROM debito WHERE id_debito = idComDepDeb
            UNION ALL
            SELECT monto AS mo FROM depositos WHERE id_deposito = idComDepDeb
        );
    IF tipoTransaccion_valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo Transaccion invalido, el tipo de transaccion no existe.');
    ELSIF comdepdeb_valid = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La compra/deposito/debito no existe, ingresa un valor valido');
    ELSE 
        -- obtener saldo de la cuenta
        SELECT saldo_cuenta
        INTO cliente_saldo
        FROM cuenta
        WHERE id_cuenta = nocuenta;

         -- obtener el monto de la compra/debito/deposito
        
        -- compra (verificar, cuenta y saldo)
        IF idTipoTransaccion = 1 THEN
            IF cuenta_valid = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'La cuenta no pertenece a la del cliente, ingresa un valor valido');
            ELSIF monto_valor>cliente_saldo THEN
                RAISE_APPLICATION_ERROR(-20001, 'Transaccion fallida, el saldo es insuficiente');
            ELSE
                INSERT INTO transaccion (id_transaccion, fecha, otros_detalles, tipo_transaccion_codigo, no_cuenta, compras_id_compra, depositos_id_deposito, debito_id_debito) 
                VALUES (idTransaccion, TO_DATE(fechaTransaccion, 'DD/MM/YYYY'), otrosDetalles, idTipoTransaccion, nocuenta, idComDepDeb, NULL, NULL);
            END IF;
        --deposito (aqui puede ser cuenta que no es del cliente)
        ELSIF idTipoTransaccion = 2 THEN
        

            INSERT INTO transaccion (id_transaccion, fecha, otros_detalles, tipo_transaccion_codigo, no_cuenta, compras_id_compra, depositos_id_deposito, debito_id_debito) 
            VALUES (idTransaccion, TO_DATE(fechaTransaccion, 'DD/MM/YYYY'), otrosDetalles, idTipoTransaccion, nocuenta, NULL, idComDepDeb, NULL);
        
        -- debito (verificar, cuenta y saldo)
        ELSE 
            IF cuenta_valid = 0 THEN
                RAISE_APPLICATION_ERROR(-20001, 'La cuenta no pertenece a la del cliente, ingresa un valor valido');
            ELSIF monto_valor>cliente_saldo THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Transaccion fallida, el saldo es insuficiente');
            ELSE
                INSERT INTO transaccion (id_transaccion, fecha, otros_detalles, tipo_transaccion_codigo, no_cuenta, compras_id_compra, depositos_id_deposito, debito_id_debito) 
                VALUES (idTransaccion, TO_DATE(fechaTransaccion, 'DD/MM/YYYY'), otrosDetalles, idTipoTransaccion, nocuenta, NULL, NULL, idComDepDeb);
            END IF;
        END IF;
    END IF;
END;
/




/*
Verify emails, password and cellphones in registrarCliente!!!!!
verify monto apertura and floats in registrarCuenta
Verify in transaction the errors
*/
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
-- registroTipoCliuente
--                  idtipo,     nombre,                         descripcion
EXEC registrarTipoCliente(4, 'Cliente Extraordinario', 'Este cliente no esta definido en el enunciado es un tipo de cliente extra');

-- registros de cliente 
--            idcliente,   nombre,    apellido,    telefono,       correo,            usuario,  contrasena,tipo
EXEC registrarCliente(1001, 'Juan Isaac','Perez Lopez','22888080','micorreo@gmail.com','jisaacp2024','12345678','1' );
EXEC registrarCliente(1002, 'Maria Isabel','Gonzalez Perez','22805050-22808080','micorreo1@gmail.com','mariauser','12345679','2' );

-- registro de tipo de cuenta
--                   idtipo,     nombre,            descripcion
EXEC registrarTipoCuenta(7,'Cuenta Extraordinaria','Cuenta Extraordinaria a enunciado');

-- registro de cuenta
--            idcuenta, montoapertura,*saldo, descripcion,     fechaapertura,otrosdetalles,idtipocuenta,idcliente
EXEC registrarCuenta(3030206080, to_number('500,00'), to_number('800,00'), 'Apertura de cuenta con Q500','','',2,1001);
EXEC registrarCuenta(3030206081, to_number('600,00'), to_number('600,00'), 'Apertura de cuenta con Q500','01/04/2024 07:00:00','esta apertura tiene fecha',2,1001);

-- registro de productoservicio
--                    id, tipo, costo, descripcion
EXEC crearProductoServicio(18, 1, to_number('50,80'), 'Este es un servicio el cual tiene un precio predefinido'); --servicio
EXEC crearProductoServicio(19, 2, 0, 'Este es un producto el cual tiene un precio variable'); --producto, tiene un precio de "cero" el cual indica que es variable

-- realizar compra
--              id,      fecha,   monto,  otrosdetalles, codProducto/Servicio, idcliente
realizarCompra(1111, '10/04/2024', 40, 'compra de servicio', 18, 1001); --aqui hay error ya que el monto deberia de ser cero por que ya tiene un precio preestablecido por ser un servicio
realizarCompra(1112, '10/04/2024', 0, 'compra de producto', 19, 1001); --aqui hay error debido a que el monto deberia de ser > 0 ya que es un producto y no tiene un precio preestablecido
realizarCompra(1113, '10/04/2024', 50, 'compra de producto', 19, 1001); --aqui esta correcto ya que el monto es mayor a cero y es un producto

-- realizar deposito
--              id,      fecha,     monto,  otrosdetalles, idcliente
realizarDeposito(1114, '10/04/2024', 100, 'deposito de dinero', 1001);
realizarDeposito(1115, '10/04/2024', 0, 'deposito de dinero', 1001); --aqui hay error ya que el monto deberia de ser mayor a cero

-- realizar retiro
--              id,      fecha,     monto,  otrosdetalles, idcliente
realizarDebito(1116, '10/04/2024', 100, 'retiro de dinero', 1001);
realizarDebito(1117, '10/04/2024', 0, 'retiro de dinero con error', 1001); --aqui hay error ya que el monto deberia de ser mayor a cero

-- tipo transaccion
-- Se van a tener 3 tipos de transacción
-- 1. compra
-- 2. deposito
-- 3. debito

-- registrar tipo de transaccion
--                  id, nombre, descripcion
registrarTipoTransaccion(1, 'Compra', 'Transacción de compra');
registrarTipoTransaccion(2, 'Deposito', 'Transacción de deposito');
registrarTipoTransaccion(3, 'Debito', 'Transacción de debito');

-- registrar transaccion
--              id,      fecha,  otrosdetalles, id_tipo_transaccion, idcompra/deposito/debito, nocuenta
registrarTransaccion(1118, '10/04/2024','', 1, 1, 1113, 3030206080); -- aqui hay error debido a que no se tiene el saldo suficiente para realizar la compra
registrarTransaccion(1115, '10/04/2024','',2, 2, 1114, 3030206080); -- se realia deposito *aqui se puede depositar a una cuenta que no es del cliente
registrarTransaccion(1120, '10/04/2024','este si tiene detalle',3, 3, 1116, 3030206080); -- se realiza un debito


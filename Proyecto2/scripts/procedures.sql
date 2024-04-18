-- 1. crear tipo de carrera
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
   
BEGIN
    name_valid := validarLetras(nombre); 
    lastname_valid := validarLetras(apellidos);  --validar solo letras en nombre
    phone_valid := validarTelefono(telefono);
    email_valid := validarEmail(correo);  

    SELECT COUNT(*)
    INTO user_count
    FROM CLIENTES
    WHERE usuario_name = usuario;

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
        INSERT INTO clientes ( idcliente, nombre, apellidos, telefono, correo, usuario, contraseña, tipo_cliente_idtipo )
        VALUES (
            idCliente, nombre, apellidos, phone_valid, correo, usuario_name, contraseña_user, tipoCliente
        );
    END IF;
END;
/

/*
Verify emails, password and cellphones in registrarCliente
*/
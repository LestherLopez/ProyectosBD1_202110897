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
    -- Evaluate if the description is only letters
    descripcion_valid := ValidarLetras(descripcion);

    -- Check if the description is valid
    IF NOT descripcion_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Descripción inválida, debe contener solo letras.');
    ELSE
        -- Insert the new record
        INSERT INTO tipo_cliente (idTipo, nombre, descripcion) 
        VALUES (seq_idTipo.NEXTVAL, nombre, descripcion);
    END IF;
END;
/

-- 2. registrarCliente
DROP PROCEDURE IF EXISTS registrarCliente;
DELIMITER $$
CREATE PROCEDURE registrarCliente(
    IN idCliente NUMBER(10),
    IN nombre VARCHAR(40),
    IN apellidos VARCHAR(40),
    IN telefono VARCHAR(12),
    IN correo VARCHAR(50),
    IN usuario INTEGER,
    IN contraseña VARCHAR(50),
    IN tipoCliente BIGINT
)
    BEGIN
        DECLARE name_valid BOOLEAN;
        DECLARE lastname_valid BOOLEAN;
        DECLARE phone_valid   BOOLEAN;
        DECLARE email_valid BOOLEAN;
        DECLARE user BOOLEAN;
        DECLARE user_password VARCHAR(50)
        DECLARE type_client INTEGER(10);

        SET date_birth = STR_TO_DATE(newBirthDay, '%d-%m-%Y');

        -- Evaluate if the email is valid
        SET email_valid = IsEmailValid(newEmail);

        -- Get the id from "CARRERA" table
        SET new_id_carrera = GetCareer(newCarrera);

        -- get current date
        SET currentDate = GetDate();

        -- Validate
        IF email_valid = FALSE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El email no es valido.';
        ELSEIF new_id_carrera IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La carrera no existe.';
        ELSE
            INSERT INTO Cliente( carnet, nombres, apellidos, fecha_nacimiento, correo, telefono, direccion, dpi, creditos, registro_creacion, id_carrera )
                VALUES (
                        newCarnet,
                        newNames,
                        newLastName,
                        date_birth,
                        newEmail,
                        newPhone,
                        newAddress,
                        newDpi,
                        0,
                        currentDate,
                        new_id_carrera
                       );
        END IF;
    END;
    $$
DELIMITER ;

--registrarCliente(1001, 'Juan Isaac','Perez Lopez','22888080','micorreo@gmail.com','jisaacp2024','12345678','1' );
--registrarCliente(1002, 'Maria Isabel','Gonzalez Perez','22805050-22808080','micorreo1@gmail.com|micorreo2@gmail.com','mariauser','12345679','2' );
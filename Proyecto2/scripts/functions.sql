DELIMITER $$
CREATE OR REPLACE FUNCTION validatTelefono (telefono VARCHAR2) 
    RETURN VARCHAR2 IS telefono_valido VARCHAR2(20);
BEGIN
    -- Eliminar cualquier caracter que no sea un dígito
    telefono_valido := REGEXP_REPLACE(telefono, '[^0-9]', '');
    
    -- Si el número tiene más de 8 dígitos, omitir los primeros 3
    IF LENGTH(telefono_valido) > 8 THEN
        telefono_valido := SUBSTR(telefono_valido, -8);
    END IF;

    -- Si hay múltiples números separados por guiones, separarlos y unirlos con comas
    IF INSTR(telefono_valido, '-') > 0 THEN
        telefono_valido := REPLACE(telefono_valido, '-', ',');
    END IF;

    RETURN telefono_valido;
END;
DELIMITER ;

DELIMITER $$
CREATE OR REPLACE FUNCTION validarEmail(inputEmail varchar(255))
    RETURNS BOOLEAN READS SQL DATA
    DETERMINISTIC
    BEGIN
        DECLARE is_valid BOOLEAN;
        SET is_valid = FALSE;
        -- Evaluate with REGEX if the email is valid
    IF inputEmail REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
        SET is_valid = TRUE;
    END IF;

        RETURN is_valid;
    END $$
DELIMITER ;

--DROP FUNCTION ValidarLetras;
CREATE OR REPLACE FUNCTION validarLetras(name VARCHAR2)
    RETURN BOOLEAN IS
    valid BOOLEAN;
BEGIN
    valid := TRUE;
    
    IF REGEXP_LIKE(name, '^[a-zA-Z]') THEN
        valid := TRUE;
    ELSE
        valid := FALSE;
    END IF;
    
    RETURN valid;
END;
/

/*DECLARE
    resultado BOOLEAN;
BEGIN
    resultado := ValidarLetras('Juan Pérez');
    IF resultado THEN
        DBMS_OUTPUT.PUT_LINE('El nombre contiene solo letras.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El nombre contiene caracteres no permitidos.');
    END IF;
END;
*/
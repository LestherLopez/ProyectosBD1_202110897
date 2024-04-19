CREATE OR REPLACE FUNCTION validarTelefono(telefono VARCHAR2)
    RETURN VARCHAR2
IS
    telefono_valido VARCHAR2(20);
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
/


CREATE OR REPLACE FUNCTION validarEmail(inputEmail VARCHAR2)
    RETURN BOOLEAN
    IS is_valid BOOLEAN;
BEGIN
    is_valid := TRUE;
    -- Evaluate with REGEXP if the email is valid
    IF REGEXP_LIKE(inputEmail, '^[A-Za-z0-9._%\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,4}$') THEN
        is_valid := TRUE;
    ELSE
        is_valid := FALSE;
    END IF;

    RETURN is_valid;
END;
/
--DROP FUNCTION ValidarLetras;
CREATE OR REPLACE FUNCTION validarLetras(name VARCHAR2)
    RETURN BOOLEAN 
    IS valid BOOLEAN;
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
-- valida que el valor sea mayor a 0
CREATE OR REPLACE FUNCTION validarPositivo (
    p_valor IN NUMBER
)
RETURN BOOLEAN
IS
BEGIN
    IF p_valor > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END validarPositivo;
/

-- valida que el valor sea mayor o igual a 0
CREATE OR REPLACE FUNCTION validarSaldoCuenta (
    p_valor IN NUMBER
)
RETURN BOOLEAN
IS
BEGIN
    IF p_valor >= 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END validarSaldoCuenta;
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
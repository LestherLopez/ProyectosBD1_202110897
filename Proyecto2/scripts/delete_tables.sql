DROP TABLE CLIENTES CASCADE CONSTRAINTS;
DROP TABLE COMPRAS CASCADE CONSTRAINTS;
DROP TABLE CUENTA CASCADE CONSTRAINTS;
DROP TABLE DEBITO CASCADE CONSTRAINTS;
DROP TABLE DEPOSITOS CASCADE CONSTRAINTS;
DROP TABLE PRODUCTO_SERVICIO CASCADE CONSTRAINTS;
DROP TABLE TIPO_CLIENTE CASCADE CONSTRAINTS;
DROP TABLE TIPO_CUENTA CASCADE CONSTRAINTS;
DROP TABLE TIPO_TRANSACCION CASCADE CONSTRAINTS;
DROP TABLE TRANSACCION CASCADE CONSTRAINTS;
-- delete info
--DELETE FROM TIPO_CLIENTE;

DELETE FROM CLIENTES;
DELETE FROM COMPRAS;
DELETE FROM CUENTA;
DELETE FROM DEBITO;
DELETE FROM DEPOSITOS;
DELETE FROM PRODUCTO_SERVICIO;
DELETE FROM TIPO_CLIENTE;
DELETE FROM TIPO_CUENTA;
DELETE FROM TIPO_TRANSACCION;
DELETE FROM TRANSACCION;
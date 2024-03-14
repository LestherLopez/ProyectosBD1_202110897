require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/temporaltables.sql';
const path = require('path');
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const filePaises = path.resolve(__dirname, '../data/paises.csv');
const fileCategorias = path.resolve(__dirname, '../data/Categorias.csv');
const fileClientes = path.resolve(__dirname, '../data/clientes.csv');
const fileOrdenes = path.resolve(__dirname, '../data/ordenes.csv');
const fileProductos = path.resolve(__dirname, '../data/productos.csv');
const fileVendedores = path.resolve(__dirname, '../data/vendedores.csv');
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
};
exports.cargarmodelo = async (req, res) => {
    let connection
    try {
        // Obtener una conexión a la base de datos
        connection = await oracledb.getConnection(dbConfig);
        // crear tablas temporales
        const scriptSql = fs.readFileSync(rutaAbsoluta, 'utf8');
        const scriptWithoutComments = scriptSql.replace(/(--.*)/g, '');
        const sqlCommands = scriptWithoutComments.split(";").map(command => command.trim());
        sqlCommands.splice(-1);
        for (const query of sqlCommands) {
            await connection.execute(query.trim());
            console.log(`Consulta ejecutada correctamente: ${query.trim()}`);
        }

        // agregar tabla paises
        const datosPaises = fs.readFileSync(filePaises, 'utf-8');
        const lines = datosPaises.split('\n');
        for (let i = 1; i < lines.length; i++) {
            const fields = lines[i].split(';');
            const id_pais = fields[0];
            const nombre = fields[1];        
            const query = `INSERT INTO temppais (id_pais, nombre) VALUES (:id_pais, :nombre)`;
            await connection.execute(query, [id_pais, nombre], {autoCommit: true});

        }
        const query2 = `INSERT INTO pais (id_pais, nombre) SELECT id_pais, nombre FROM temppais`;   
        await connection.execute(query2, [],  { autoCommit: true });
        await connection.execute('DROP TABLE temppais')
        // agregar tabla categorias
        const datosCategorias = fs.readFileSync(fileCategorias, 'utf-8');
        const linescategory = datosCategorias.split('\n');
        for (let i = 1; i < linescategory.length; i++) {
            const fields_category = linescategory[i].split(';');
            const id_categoria = fields_category[0];
            const nombre = fields_category[1];
            const query = `INSERT INTO tempcategoria (id_categoria, nombre) VALUES (:id_categoria, :nombre)`;
            await connection.execute(query, [id_categoria, nombre], {autoCommit: true});

        }
        const querycategoria = `INSERT INTO categoria (id_categoria, nombre) SELECT id_categoria, nombre FROM tempcategoria`;   
        await connection.execute(querycategoria, [],  { autoCommit: true });
        await connection.execute('DROP TABLE tempcategoria')
        // agregar tabla de vendedores
       
         const datosVendedores = fs.readFileSync(fileVendedores, 'utf-8');
         const linesvendedores = datosVendedores.split('\n');
         for (let i = 1; i < linesvendedores.length; i++) {
             const fields_vendedores = linesvendedores[i].split(';');
             const id_vendedor = fields_vendedores[0];
             const nombre = fields_vendedores[1];
             const pais_id_pais = fields_vendedores[2];
             const query = `INSERT INTO vendedores (id_vendedor, nombre, pais_id_pais) VALUES (:id_vendedor, :nombre, :pais_id_pais)`;
             await connection.execute(query, [id_vendedor, nombre, pais_id_pais], {autoCommit: true});
         }
         await connection.execute('DROP TABLE tempvendedores')



        // agregar tabla clientes
        const datosClientes = fs.readFileSync(fileClientes, 'utf-8');
        const linesclientes = datosClientes.split('\n');
        for (let i = 1; i < linesclientes.length; i++) {
            const fields_clientes = linesclientes[i].split(';');
            const id_cliente = fields_clientes[0];
            const nombre = fields_clientes[1];
            const apellido = fields_clientes[2];
            const direccion = fields_clientes[3];
            const telefono = fields_clientes[4];
            const tarjeta = fields_clientes[5];
            const edad = fields_clientes[6];
            const salario = fields_clientes[7];
            const genero = fields_clientes[8];
            const pais_id_pais = fields_clientes[9];
            const query = `INSERT INTO tempclientes (id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id_pais) VALUES (:id_cliente, :nombre, :apellido, :direccion, :telefono, :tarjeta, :edad, :salario, :genero, :pais_id_pais)`;
            await connection.execute(query, [id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id_pais], {autoCommit: true});

        }
        const querycliente = `INSERT INTO clientes (id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id_pais) SELECT id_cliente, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id_pais FROM tempclientes`;   
        await connection.execute(querycliente, [],  { autoCommit: true });
        await connection.execute('DROP TABLE tempclientes')
        // agregar tabla de productos
        const datosProductos = fs.readFileSync(fileProductos, 'utf-8');
        const linesproductos = datosProductos.split('\n');
        for (let i = 1; i < linesproductos.length; i++) {
            const fields_productos = linesproductos[i].split(';');
            const id_producto = fields_productos[0];
            const nombre = fields_productos[1];
            const precio = parseFloat(fields_productos[2]);
            const categoria_id_categoria = fields_productos[3];
            const query = `INSERT INTO productos (id_producto, nombre, precio, categoria_id_categoria) VALUES (:id_producto, :nombre, :precio, :categoria_id_categoria)`;
            await connection.execute(query, [id_producto, nombre, precio, categoria_id_categoria], {autoCommit: true});
        }
        await connection.execute('DROP TABLE tempproductos')
       
        // tabla de ordenes
        const datosOrdenes = fs.readFileSync(fileOrdenes, 'utf-8');
        const linesordenes = datosOrdenes.split('\n');
        for (let i = 1; i < linesordenes.length; i++) {
            const fields_ordenes = linesordenes[i].split(';');
            const id_orden = fields_ordenes[0];
            const linea_orden = fields_ordenes[1];
            const fecha_orden = fields_ordenes[2];
            const clientes_id_cliente = fields_ordenes[3];
            const vendedores_id_vendedor = fields_ordenes[4];
            const productos_id_producto  = fields_ordenes[5];
            const cantidad = fields_ordenes[6];
            const query = `INSERT INTO temporden (id_orden, linea_orden, fecha_orden, clientes_id_cliente,  vendedores_id_vendedor, productos_id_producto, cantidad) VALUES (:id_orden, :linea_orden, :fecha_orden, :clientes_id_cliente,  :vendedores_id_vendedor, :productos_id_producto, :cantidad)`;
            await connection.execute(query, [id_orden, linea_orden, fecha_orden, clientes_id_cliente,  vendedores_id_vendedor, productos_id_producto, cantidad], {autoCommit: true});

        }
        const querymaestro_orden = `INSERT INTO orden_de_venta (id_orden, fecha_orden, clientes_id_cliente) SELECT DISTINCT id_orden, fecha_orden, clientes_id_cliente FROM temporden`;   
        await connection.execute(querymaestro_orden, [],  { autoCommit: true });
        const querymaestro_detalle = `INSERT INTO detalle_de_orden (orden_de_venta_id_orden, linea_orden, vendedores_id_vendedor, productos_id_producto, cantidad) 
                                      SELECT id_orden, linea_orden, vendedores_id_vendedor, productos_id_producto, cantidad
                                      FROM temporden`;   
        await connection.execute(querymaestro_detalle, [],  { autoCommit: true });
        await connection.execute('DROP TABLE temporden')
      } catch (error) {
        console.error('Error al ejecutar la consulta:', error);
      } finally {
        // Liberar la conexión
        if (connection) {
          try {
            await connection.close();
          } catch (error) {
            console.error('Error al cerrar la conexión:', error);
          }
        }
      }

    res.send('¡Modelo creado con exito!');
}

/*
DROP TABLE tempcategoria;
DROP TABLE tempclientes;
DROP TABLE tempdetalle_de_orden;
DROP TABLE temporden_de_venta;
DROP TABLE temppais;
DROP TABLE tempproductos;
DROP TABLE tempvendedores;

SELECT COUNT(*) AS total_tablas
             FROM USER_TABLES
*/ 
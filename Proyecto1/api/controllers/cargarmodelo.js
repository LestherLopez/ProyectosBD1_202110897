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
            //console.log("vamos dentro: ",nombre, correo, direccion);
            // Insertar los datos en la tabla temporal
            
            
            const query = `INSERT INTO temppais (id_pais, nombre) VALUES (:id_pais, :nombre)`;
            await connection.execute(query, [id_pais, nombre], {autoCommit: true});

        }
        const query2 = `INSERT INTO pais (id_pais, nombre) SELECT id_pais, nombre FROM temppais`;   
        await connection.execute(query2, [],  { autoCommit: true });
      //  await connection.execute('DROP TABLE temppais')
        // agregar tabla categorias
    /*    const datosCategorias = fs.readFileSync(fileCategorias, 'utf-8');
        const linescategory = datosCategorias.split('\n');
        for (let i = 1; i < linescategory.length; i++) {
            const fields_category = lines[i].split(';');
            const id_categoria = fields[0];
            const nombre = fields[1];
            //console.log("vamos dentro: ",nombre, correo, direccion);
            // Insertar los datos en la tabla temporal
            
            
            const query = `INSERT INTO tempcategoria (id_categoria, nombre) VALUES (:id_categoria, :nombre)`;
            await connection.execute(query, [id_categoria, nombre], {autoCommit: true});

        }
        const querycategoria = `INSERT INTO categoria (id_categoria, nombre) SELECT id_categoria, nombre FROM tempcategoria`;   
        await connection.execute(querycategoria, [],  { autoCommit: true });
        await connection.execute('DROP TABLE tempcategoria')*/

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
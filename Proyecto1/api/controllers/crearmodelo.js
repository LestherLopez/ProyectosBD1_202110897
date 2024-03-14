require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/createmodel.sql';
const path = require('path');
// Obtener la ruta absoluta
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };
  

exports.crearmodelo = async (req, res) => {
    let connection;
    try {
        // Obtener una conexión a la base de datos
        connection = await oracledb.getConnection(dbConfig);
        
        const scriptSql = fs.readFileSync(rutaAbsoluta, 'utf8');
        const scriptWithoutComments = scriptSql.replace(/(--.*)/g, '');
        const sqlCommands = scriptWithoutComments.split(";").map(command => command.trim());
        sqlCommands.splice(-1);
        for (const query of sqlCommands) {
            await connection.execute(query.trim());
            console.log(`Consulta ejecutada correctamente: ${query.trim()}`);
        }
        
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
require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/consulta2.sql';
const path = require('path');
// Obtener la ruta absoluta
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };
  

exports.consulta2 = async (req, res) => {
    let message = ""
    let connection;
    try {
        // Obtener una conexión a la base de datos
        connection = await oracledb.getConnection(dbConfig);
        
        const scriptSql = fs.readFileSync(rutaAbsoluta, 'utf8');
        const scriptWithoutComments = scriptSql.replace(/(--.*)/g, '');
        const sqlCommands = scriptWithoutComments.split(";").map(command => command.trim());
        sqlCommands.splice(-1);
     
        result = await connection.execute(sqlCommands[0].trim());
        message += `Producto menos vendido
                    ID Producto: ${result.rows[0][0]}
                    Nombre Producto: ${result.rows[0][1]}
                    Categoria: ${result.rows[0][2]}
                    Cantidad de unidades: ${result.rows[0][3]}
                    Monto Total: ${result.rows[0][4]}
                    
                    `
        result = await connection.execute(sqlCommands[1].trim());
        message += `Producto mas vendido
                    ID Producto: ${result.rows[0][0]}
                    Nombre Producto: ${result.rows[0][1]}
                    Categoria: ${result.rows[0][2]}
                    Cantidad de unidades: ${result.rows[0][3]}
                    Monto Total: ${result.rows[0][4]}
                    `
        
        res.send(message);

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
    
     
    
   
}

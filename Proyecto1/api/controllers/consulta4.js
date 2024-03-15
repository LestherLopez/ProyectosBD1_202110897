require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/consulta4.sql';
const path = require('path');
// Obtener la ruta absoluta
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };
  

exports.consulta4 = async (req, res) => {
    let result
    let connection;
    try {
        // Obtener una conexión a la base de datos
        connection = await oracledb.getConnection(dbConfig);
        
        const scriptSql = fs.readFileSync(rutaAbsoluta, 'utf8');
        const scriptWithoutComments = scriptSql.replace(/(--.*)/g, '');
        const sqlCommands = scriptWithoutComments.split(";").map(command => command.trim());
        sqlCommands.splice(-1);
        for (const query of sqlCommands) {
            result = await connection.execute(query.trim());
       
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
    
      const message = ` Pais que mas ha vendido
                        Nombre del país: ${result.rows[0][0]}
                        Monto total: ${result.rows[0][1]}
                        Veces que vendió el país: ${result.rows[0][2]}
                        
                        Pais que menos ha vendido
                        Nombre del país: ${result.rows[1][0]}
                        Monto Total: ${result.rows[1][1]}
                        Veces que vendió el país: ${result.rows[1][2]}`;
      res.send(message);
   
}

require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/consulta1.sql';
const path = require('path');
// Obtener la ruta absoluta
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };
  

exports.consulta1 = async (req, res) => {
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
    
      const message = ` Cliente que más ha comprado
                        ID Cliente: ${result.rows[0][0]}
                        Nombre Cliente: ${result.rows[0][1]}
                        Apellido Cliente: ${result.rows[0][2]}
                        País: ${result.rows[0][3]}
                        Monto Total: ${result.rows[0][4]}
                        Veces que compró: ${result.rows[0][5]}`;
      res.send(message);
   
}

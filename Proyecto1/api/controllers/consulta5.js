require('dotenv').config();
const express = require('express');
const oracledb = require('oracledb');
const rutaRelativa = '../../scripts/consulta5.sql';
const path = require('path');
// Obtener la ruta absoluta
const rutaAbsoluta = path.resolve(__dirname, rutaRelativa);
const fs = require('fs');
const dbConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING,
  };
  

exports.consulta5 = async (req, res) => {
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
      let message = `Top 5 de países que más han comprado en orden ascendente.\n`
      
      for (let i = 0; i < 5; i++) {
          message +=       `Id del pais: ${result.rows[i][0]}
                            Nombre del país: ${result.rows[i][1]}
                            Monto total: ${result.rows[i][2]}
                            Veces que compró el país: ${result.rows[i][3]}\n`
      }
      res.send(message);
   
}

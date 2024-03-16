const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const cors = require('cors');
const { initApi } =  require('./controllers/initapi')
const { cargarmodelo } =  require('./controllers/cargarmodelo')
const { crearmodelo } =  require('./controllers/crearmodelo');
const { eliminarmodelo } = require('./controllers/eliminarmodelo');
const { borrarinfodb } = require('./controllers/borrarinfodb');
const { consulta1 } = require('./controllers/consulta1');
const { consulta2 } = require('./controllers/consulta2');
const { consulta3 } = require('./controllers/consulta3');
const { consulta4 } = require('./controllers/consulta4');
const { consulta5 } = require('./controllers/consulta5');
const { consulta6 } = require('./controllers/consulta6');
const { consulta7 } = require('./controllers/consulta7');
const { consulta8 } = require('./controllers/consulta8');
const { consulta9 } = require('./controllers/consulta9');
const { consulta10 } = require('./controllers/consulta10');
app.use(express.json());
app.use(cors());


// Rutas
app.get('/', initApi);


app.get('/consulta1', consulta1);

app.get('/consulta2', consulta2);

app.get('/consulta3', consulta3); 

app.get('/consulta4', consulta4); 


app.get('/consulta5', consulta5); 


app.get('/consulta6', consulta6);


app.get('/consulta7', consulta7); //corregir


app.get('/consulta8', consulta8); 

app.get('/consulta9', consulta9);


app.get('/consulta10', consulta10);


app.get('/eliminarmodelo', eliminarmodelo);

app.get('/crearmodelo', crearmodelo);

app.get('/borrarinfodb', borrarinfodb);

app.get('/cargarmodelo', cargarmodelo);


// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor en ejecución en http://localhost:${PORT}`);
});

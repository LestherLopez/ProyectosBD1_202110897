const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const cors = require('cors');
const { initApi } =  require('./controllers/initapi')
const { cargarmodelo } =  require('./controllers/cargarmodelo')
const { crearmodelo } =  require('./controllers/crearmodelo');
const { eliminarmodelo } = require('./controllers/eliminarmodelo');
const { borrarinfodb } = require('./controllers/borrarinfodb');
app.use(express.json());
app.use(cors());


// Rutas
app.get('/', initApi);


app.get('/consulta1', (req, res) => {
    res.send('¡Consulta1 realizada!');
});

app.get('/consulta2', (req, res) => {
    res.send('¡Consulta2 realizada!');
});

app.get('/consulta3', (req, res) => {
    res.send('¡Consulta3 realizada!');
});

app.get('/consulta4', (req, res) => {
    res.send('¡Consulta4 realizada!');
});


app.get('/consulta5', (req, res) => {
    res.send('¡Consulta5 realizada!');
});


app.get('/consulta6', (req, res) => {
    res.send('¡Consulta6 realizada!');
});


app.get('/consulta7', (req, res) => {
    res.send('¡Consulta7 realizada!');
});


app.get('/consulta8', (req, res) => {
    res.send('¡Consulta8 realizada!');
});

app.get('/consulta9', (req, res) => {
    res.send('¡Consulta9 realizada!');
});


app.get('/consulta10', (req, res) => {
    res.send('¡Consulta10 realizada!');
});


app.get('/eliminarmodelo', eliminarmodelo);

app.get('/crearmodelo', crearmodelo);

app.get('/borrarinfodb', borrarinfodb);

app.get('/cargarmodelo', cargarmodelo);


// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor en ejecución en http://localhost:${PORT}`);
});

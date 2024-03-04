const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Rutas
app.get('/', (req, res) => {
    res.send('¡Bienvenido a mi API!');
});


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


app.get('/eliminarmodelo', (req, res) => {
    res.send('¡Modelo eliminado!');
});


app.get('/crearmodelo', (req, res) => {
    res.send('¡Modelo creado!');
});


app.get('/borrarinfodb', (req, res) => {
    res.send('¡Infromacion eliminada!');
});


app.get('/cargarmodelo', (req, res) => {
    res.send('¡Datos cargados al modelo!');
});


// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor en ejecución en http://localhost:${PORT}`);
});

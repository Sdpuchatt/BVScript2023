/**Creamos una carpeta api, usamos comando npm init -y
 * me genera el archivo package.json, luego usamos el 
 * comando npm install -S express me genera los codigos node_modules
 * usaremos mongoose
 */
const express = require('express');
const user = require('./user.controller')
const app = express();
const port = 3000;

app.get('/',(req,res)=>{
    res.status(200).send('<h1>Chanchito feliz</h1>')
})
app.post('/',(req,res)=>{
    res.status(201).send('creando chanchito')
})
app.get('/:id',(req,res)=>{
    console.log(req.params)
    res.status(200).send(req.params)
})
app.put('/:id',(req,res)=>{
    console.log(req.params)
    res.sendStatus(204)
})
app.patch('/:id',(req,res)=>{
    res.sendStatus(204)
})
app.delete('/:id',(req,res)=>{
    res.sendStatus(204)
})


app.listen(port, ()=>{
    console.log('Arrancando la aplicacion')
})

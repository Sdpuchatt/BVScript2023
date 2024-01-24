const express = require('express');
const mongoose = require('mongoose')
const user = require('./user.controller')
const app = express();
const port = 3000;

mongoose.connect('mongodb+srv://spuchatt:IbRRtz5nBdOEUWFy@cluster0.gt6m1ox.mongodb.net/miappg4?retryWrites=true&w=majority')
// middleware
app.use(express.json())

app.get('/', user.list)
app.post('/', user.create)
app.get('/:id',user.get)
app.put('/:id',user.update)
app.patch('/:id',user.update)
app.delete('/:id',user.destroy)

app.get('*',(req,res)=>{
    res.status(404).send('Esta pagina no existe')
})

app.listen(port, ()=>{
    console.log('Arrancando la aplicacion')
})

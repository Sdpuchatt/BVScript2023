const User = {
    get: (req,res) =>{
        res.status(200).send('este es un chanchito =D')
    },
    list: (req,res) =>{
        res.status(200).send('Hola chanchito!')
    },
    create: (req,res)=>{
        res.status(201).send('Creando un chanchito')
    },
    update: (req,res)=>{
        res.status(204).send('Actualizando chanchito')
    },
    destroy: (req,res)=>{
        res.status(204).send('eliminando un chanchito :(')
    }
}
module.exports = User;
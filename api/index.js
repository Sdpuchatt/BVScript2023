const mongoose = require('mongoose')

mongoose.connect('mongodb+srv://spuchatt:IbRRtz5nBdOEUWFy@cluster0.gt6m1ox.mongodb.net/miappg4?retryWrites=true&w=majority')

const User = mongoose.model('User',{
    username: String,
    edad: Number,
})

const crear = async () => {
    const user = new User({username: 'chanchito trizte', edad: 25})
    const savedUser = await user.save()
    console.log(savedUser)
}
//crear()
const buscarTodo = async () => {
    const users = await User.find()
    console.log(users)
}
//buscarTodo()
const buscar = async () => {
    const user = await User.find({ username: 'chanchito trizte'})
    console.log(user)
}
// buscar()
const buscarUno = async () => {
    const user = await User.findOne({username:'chanchito feliz'})
    console.log(user)
}
// buscarUno()
const actualizar = async () =>{
    const user = await User.findOne({username : 'chanchito trizte'})
    console.log(user)
    user.edad = 45
    await user.save()
    console.log(user)
}
// actualizar();
const eliminar = async () => {
    const user = await User.findOne({username : 'chanchito trizte'})
    console.log(user)
    if(user){
        await user.remove()
    }
}
eliminar()
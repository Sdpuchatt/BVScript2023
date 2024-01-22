const mongoose = require('mongoose')

mongoose.connect('mongodb+srv://spuchatt:IbRRtz5nBdOEUWFy@cluster0.gt6m1ox.mongodb.net/miappg4?retryWrites=true&w=majority')

const User = mongoose.model('User',{
    username: String,
    edad: Number,
})

const crear = async () => {
    const user = new User({username: 'chanchito feliz', edad: 15})
    const savedUser = await user.save()
    console.log(savedUser)
}
crear()
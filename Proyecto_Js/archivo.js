document.write('Saludos a todos')
document.write('Saludos a todos')
/*Var de clara las variable de forma global **/
/*let de modo local **/
var nombre = 'Pedro';
var Nombre = 'Anny';
var _nombre = 'Tomas';
var NOMBRE = 'Sergio';
var $_nombre = 'Juan';

let saludo = 'Hola';
let Saludo = 'Que tal';
let _saludo = 'Como te va?';
let SALUDO = 'encantado';
let $_saludo = 'buenos dias';

let persona = {
    nombre:'Carlos',
    apellido: 'Benites'
}
document.write('<br>')
document.write(JSON.stringify(persona))

document.write(`<h2>${nombre}</h2>`)
document.write(`<h2>${_saludo}</h2>`)
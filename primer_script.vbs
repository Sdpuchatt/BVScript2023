'Nos obliga a declarar variables
Option Explicit
''''''''''''''''''''''''''''''''''''''''''''''''''''
'Autor: Sergio
'Fecha: 21/12/2023
'Version: 1.0
'Titulo: Mi primer Scripting
'''''''''''''''''''''''''''''''''''''''''''''''''''''
'Primer programa
'wscript.echo ("hola "+ inputbox("cual es tu nombre?") +"!")

'Segundo programa
wscript.echo "Muestra una alerta!!"
'MsgBox prompt[, buttons][, tittle][, helpfile, context]
msgbox "Muestra un mensaje o alerta!!",vbOkOnly,"Alerta de atento"
msgbox "Muestra un mensaje o alerta!!",3,"Alerta de atento"

'declaracion de variable
Dim totalDeudas
totalDeudas = 1500
wscript.echo totalDeudas

dim otraDeuda
'InputBox(prompt[, title][, default][, xpos][, ypos][, helpfile, context])
otraDeuda = inputBox("Cual es tu deuda?","Deuda Total",235)
wscript.echo otraDeuda
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Documentacion : https://www.vbsedit.com/html/ae073d50-e4a4-4e23-8e46-0cb1369965e7.asp
'youtube: https://www.youtube.com/watch?v=uPoeH1nJ5Es&list=PLsa1p-QNUZ9AVeTRDIAVcbD1HLWmWH7Ye&index=6&ab_channel=ManuelOrtiz
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
import Root.*




// Clase que nos permite instanciar a los jugadores
// Nota: El tag de los jugadores es tal que nos permite conocer el nombre de su archivo
class Bombermans inherits DefaultVisual{
    // Metodo para que el jugador y la maquina se mueva dentro de los limites
    // Direction: string que nos permite definir hacia donde se mueve el pj
    // SoundObject: (vea Effectos.Sounds) objeto personalizado de sonido
    method move(direction, soundObject) {
        if (soundObject != null) { soundObject.playSound() }
        
        if ( (direction == "left") && (position.x() != 0) ) {
            // Solo nos podemos mover a la izquierda en x > 0
            image = tag + "_left.png"
            position = position.left(playersMovementFactor)

        } else if ( (direction == "right") && (position.x() < gameWidth - 1)) {
            // Esta permitido el movimiento hacia la izquierda unicamente en x < (ancho-1) debido al tamaño del personaje (16x16)px
            image = tag + "_right.png"
            position = position.right(playersMovementFactor)

        } else if ( (direction == "up") && (position.y() < gameHeight - 2) ) {
            // Solo nos moveremos arriba en y < height - 2 (tamaño jugador + altura de los score)
            image = tag + "_up.png"
            position = position.up(playersMovementFactor)

        } else if ( (direction == "down") && (position.y() != 0) ) {
            // Movimiento hacia abajo solo en y > 0
            image = tag + "_down.png"
            position = position.down(playersMovementFactor)
        }
    }
}
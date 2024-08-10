import wollok.game.*

object root {
    // Ancho
    method gameWidth() = 15
    
    // Alto
    method gameHeight() = 12
    
    // Tamaño de celda
    method cellSize() = 16

    // Tiempo de aparicion de una moneda
    method coinsAppearTime() = 5000

    // Tiempo cada cuanto se mueve el bot
    method botMovementTime() = 900
}

/* Clase "basica" de un visual para wollok game */
class DefaultVisual {
    var property position
    var property image
    var property tag
}
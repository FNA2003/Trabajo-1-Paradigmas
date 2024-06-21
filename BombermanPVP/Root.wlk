import wollok.game.*


/* Constantes que se utilizaran en los distintos archivos para evitar errores de la libreria game */
const gameWidth = 15
const gameHeight = 12
const cellSize = 16

const playersMovementFactor = 1

const bombTime = 1700
const coinsAppearTime = 5000
const botMovementTime = 900


/* Clase "basica" de un visual para wollok game */
class DefaultVisual {
    var property position
    var property image
    var property tag
}
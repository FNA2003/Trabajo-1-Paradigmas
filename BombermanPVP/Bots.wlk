import Bombermans.Bombermans
import Bombas.Bombs



/* Clase para generar un bot que se mueva solo */
class Bots inherits Bombermans {
    // Lista de direcciones que YO le asigne posible al bot a las que se puede mover en UNA SOLA LLAMADA
    const posibleMoves = [
        ["up"], ["down"],
        ["left"], ["right"],
        ["up", "left"], ["up", "right"],
        ["down", "left"], ["down", "right"]
    ]

    // Metodo que, cuando se programa una tarea cada x tiempo, le permite mover al bot
    method randomMove() {
        // Elegimos una direccion aleatoriamente
        const index = (0.randomUpTo(posibleMoves.size())).truncate(0)

        // Y le permitimos moverse (Nota: El bot no hace sonido de movimiento para no confundir a los jugadores de una mala pulsacion)
        posibleMoves.get(index).forEach({ direction => 
            self.move(direction, null)
        })
    }

    // Metodo para que la pc ponga bombas si la chocamos
    method plantBomb(plantSound, explosionSound) {
        const b = new Bombs(position=position, image="bomb.png", tag="bomb")
        game.addVisual(b)

        b.plantBomb(b, plantSound, explosionSound)
    } 

    // Redefino el metodo de reinicio para no tener que leer errores en consola
    method restartGame(originPosition) {
        image = "fireBomberman_down.png"
        position = originPosition
    }
}
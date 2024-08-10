import Manager.*
import Bombermans.Bombermans
import Bombas.Bombs
import Movements.*


/* Clase para generar un bot que se mueva solo */
class Bots inherits Bombermans {
    const originalPos //Posicion Original de cada bomberman

    // Lista de direcciones que YO le asigne posible al bot a las que se puede mover en UNA SOLA LLAMADA
    const posibleMoves = [
        [up], [down],
        [left], [right],
        [up, left], [up, right],
        [down, left], [down, right]
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

    // Metodo para cuando un player colisiona con el bot
    method collide(player, bot) {
        soundKick.playSound()
        game.schedule(250, { bot.plantBomb(gameManager.counterOnTick()) gameManager.counterOnTick(gameManager.counterOnTick()+1)})
    }

    // Metodo para que la pc ponga bombas si la chocamos
    method plantBomb(counterOnTick) {
        const b = new Bombs(position=position, nameOnTick=counterOnTick)
        game.addVisual(b)

        b.plantBomb(b)
    } 

    // Redefino el metodo de reinicio para no tener que leer errores en consola
    method restartGame() {
        image = "fireBomberman_down.png"
        position = originalPos
    }
}
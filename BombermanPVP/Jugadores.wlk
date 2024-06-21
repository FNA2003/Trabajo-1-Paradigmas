import Bombermans.Bombermans
import Bombas.Bombs




/* Forma basica en la que se encuentra el archivo de imagen del score de las bombas (Igual para todos los jugadores) */
const bombsRoute = [
    "_bombs_0.png",
    "_bombs_1.png",
    "_bombs_2.png",
    "_bombs_3.png",
    "_bombs_4.png"
]
/* Forma basica de la ruta para el puntaje de las monedas (Unica por jugador) */
const coinsRoute = [
    "_coins_0.png",
    "_coins_1.png",
    "_coins_2.png",
    "_coins_3.png",
    "_coins_4.png",
    "_coins_5.png"
]


class Players inherits Bombermans {
    var property coinsPicked = 0 // Monedas actuales
    var property avaibleBombs = 1 // Bombas disponibles (Aumentan al agarrar monedas)


    /* Metodo para poner bombas */
    method plantBomb(bombScore ,plantSound, explosionSound) {
        if (avaibleBombs > 0) {
            const b = new Bombs(position=position, image="bomb.png", tag="bomb")
            game.addVisual(b)

            b.plantBomb(b, plantSound, explosionSound)
            avaibleBombs -= 1

            bombScore.image("bombermans" + bombsRoute.get(avaibleBombs))
        }
    }    

    /* Metodo que permite agarrar una moneda y variar el objeto de los puntajes */
    method getCoin(coinVisual, getSound,bombsScore, coinsScore) {
        // Salvamos la cantidad de monedas del jugador y le damos una bomba
        coinsPicked += 1
        avaibleBombs += 1

        getSound.playSound()

        game.removeVisual(coinVisual)

        // Verificamos que no pase el maximo impuesto de cada variable
        coinsPicked = coinsPicked.min(5)
        avaibleBombs = avaibleBombs.min(4)

        // Hacemos visual el cambio
        coinsScore.image(tag + coinsRoute.get(coinsPicked))
        bombsScore.image("bombermans" + bombsRoute.get(avaibleBombs))        
    }

    /* Metodo para manejar cuando recibimos una explosion y perder monedas */
    method getExplosion(coinsScore, originalPos, hurtSound) {
        // Modificamos la cantidad de monedas
        coinsPicked -= 1
        hurtSound.playSound()
        
        // Verificamos que sea negativo
        coinsPicked = coinsPicked.max(0)
        position = originalPos

        // Acentamos el cambio en el cartel
        coinsScore.image(tag + coinsRoute.get(coinsPicked))
    }

    /* Reiniciamos las variables del jugador cuando se termina la ronda */
    method restartGame(originPosition, bombsScore, coinsScore) {
        coinsPicked = 0
        avaibleBombs = 1

        position = originPosition

        bombsScore.image("bombermans" + bombsRoute.get(1))
        coinsScore.image(tag + coinsRoute.get(0))
    }
}
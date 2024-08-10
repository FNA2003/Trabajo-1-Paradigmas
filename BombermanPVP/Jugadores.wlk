import Bombermans.Bombermans
import Bombas.Bombs
import Sonidos.*


class Players inherits Bombermans {
    const originalPos //Posicion Original de cada bomberman

    // Tableros
    const coinsScore
    const bombsScore

    var coinsPicked = 0 // Monedas actuales
    method coinsPicked() = coinsPicked // Para consultar monedas actuales

    var availableBombs = 1 // Bombas disponibles (Aumentan al agarrar monedas)


    /* Metodo para poner bombas */
    method plantBomb(counterOnTickParameter) {
        if (availableBombs > 0) {
            const b = new Bombs(position=position, nameOnTick=counterOnTickParameter)
            game.addVisual(b)

            b.plantBomb(b)
            availableBombs -= 1

            bombsScore.image("bombermans_bombs_" + availableBombs.toString() + '.png')
        }
    }    

    /* Metodo que permite agarrar una moneda y variar el objeto de los puntajes */
    method getCoin(coinVisual) {
        // Salvamos la cantidad de monedas del jugador y le damos una bomba
        coinsPicked += 1
        availableBombs += 1

        getSound.playSound()

        game.removeVisual(coinVisual)

        // Verificamos que no pase el maximo impuesto de cada variable
        coinsPicked = coinsPicked.min(5)
        availableBombs = availableBombs.min(4)

        // Hacemos visual el cambio
        coinsScore.image(tag + '_coins_' + coinsPicked.toString() + '.png')
        bombsScore.image("bombermans_bombs_" + availableBombs.toString() + '.png')        
    }

    /* Metodo para manejar cuando recibimos una explosion y perder monedas */
    method getExplosion() {
        // Modificamos la cantidad de monedas
        coinsPicked -= 1
        soundDies.playSound()
        
        // Verificamos que no sea negativo
        coinsPicked = coinsPicked.max(0)
        position = originalPos

        // Acentamos el cambio en el cartel
        coinsScore.image(tag + '_coins_' + coinsPicked.toString() + '.png')
    }

    /* Reiniciamos las variables del jugador cuando se termina la ronda */
    method restartGame() {
        coinsPicked = 0
        availableBombs = 1

        position = originalPos

        bombsScore.image("bombermans_bombs_1.png")
        coinsScore.image(tag + '_coins_0.png')
    }
}
import Root.*
import Jugadores.Players
import Bots.Bots
import Monedas.Coins
import Sonidos.Sounds
import Bombas.Bombs
import Movements.*


object gameManager {
    // Posiciones por defecto de los bombermans
    const originalPosBomberman = game.at(0, 0)
    const originalPosAntiBomberman = game.at(root.gameWidth()-1, root.gameHeight() - 2)
    const originalPosBot = game.at( ((root.gameWidth()-1)/2).truncate(0), ((root.gameHeight()-1)/2).truncate(0) )

    // Monedas que se muestran en pantalla
    const property coins = []

    // Creamos los objetos puntaje
    const scoreCoinsBomberman = new DefaultVisual(position=game.at(3,11), image="bomberman_coins_0.png", tag="cartel")
    const scoreCoinsAntibomberman = new DefaultVisual(position=game.at(11,11), image="antiBomberman_coins_0.png", tag="cartel")
    const scoreBombsBomberman = new DefaultVisual(position=game.at(1,11), image="bombermans_bombs_1.png", tag="cartel")
    const scoreBombsAntibomberman = new DefaultVisual(position=game.at(9,11), image="bombermans_bombs_1.png", tag="cartel")

    // Creamos a los personajes
    const bomberman = new Players(position=originalPosBomberman, image="bomberman_down.png", tag="bomberman", originalPos=originalPosBomberman, coinsScore=scoreCoinsBomberman, bombsScore=scoreBombsBomberman)
    const antiBomberman = new Players(position=originalPosAntiBomberman, image="antiBomberman_down.png", tag="antiBomberman", originalPos=originalPosAntiBomberman, coinsScore=scoreCoinsAntibomberman, bombsScore=scoreBombsAntibomberman)
    const bot = new Bots(position=originalPosBot, image="fireBomberman_down.png", tag="fireBomberman", originalPos=originalPosBot)

    // Agregamos sonidos del juego (de caminar y de reinicio)
    const soundWalking = new Sounds(soundPath="Walking.mp3")
    const soundStageClear = new Sounds(soundPath="Stage_Clear.wav")

    // Y, al objeto que contiene el fin de juego
    const endOfGame = new DefaultVisual(tag="cartel", image="game_over_retro.png", position=game.at(4, 2))

    // Identificador unico de los OnTick de cada bomba/explosion
    var property counterOnTick = 0

    // Metodo para dar un origen y clase a cada objeto necesario para el juego
    method initialize() {
        // Inicializamos el tablero
        game.width(root.gameWidth())
        game.height(root.gameHeight())
        game.cellSize(root.cellSize())
        game.boardGround("background.png")
    }

    // Bucle/Entorno principal de ejecucion del juego
    method runGame() {
        // Agregamos los visuales de los jugadores
        game.addVisual(bomberman)
        game.addVisual(antiBomberman)
        game.addVisual(bot)

        // Y del puntaje
        game.addVisual(scoreCoinsBomberman)
        game.addVisual(scoreCoinsAntibomberman)
        game.addVisual(scoreBombsBomberman)
        game.addVisual(scoreBombsAntibomberman)

        // Movimiento del jugador 1, bomberman
        keyboard.a().onPressDo({ bomberman.move(left, soundWalking) })
        keyboard.d().onPressDo({ bomberman.move(right, soundWalking) })
        keyboard.w().onPressDo({ bomberman.move(up, soundWalking) })
        keyboard.s().onPressDo({ bomberman.move(down, soundWalking) })

        // Movimiento de antiBomberman, jugador 2
        keyboard.left().onPressDo({ antiBomberman.move(left, soundWalking) })
        keyboard.right().onPressDo({ antiBomberman.move(right, soundWalking) })
        keyboard.up().onPressDo({ antiBomberman.move(up, soundWalking) })
        keyboard.down().onPressDo({ antiBomberman.move(down, soundWalking) })

        // Bombas de bomberman
        keyboard.space().onPressDo({ bomberman.plantBomb(counterOnTick) counterOnTick+=1})
        // Bombas de antiBomberman
        keyboard.enter().onPressDo({ antiBomberman.plantBomb(counterOnTick) counterOnTick+=1})


        // Colisiones de bomberman ante explosiones y monedas
        game.onCollideDo(bomberman, { collider =>
            collider.collide(bomberman, collider)
        })

        // Colisiones de antiBomberman ante explosiones y monedas
        game.onCollideDo(antiBomberman, { collider =>
            collider.collide(antiBomberman, collider)
        })

        // Agregamos una moneda cada 7seg
        game.onTick(root.coinsAppearTime(), "nuevaMoneda", {
            if (coins.size() < 2) {
                const coin = new Coins()
                coins.add(coin)
                game.addVisual(coin)
                game.onTick(400, "girarMoneda", {coin.newImage()})
            }
        })

        // Cada cierto tiempo se mueve el bot
        game.onTick(root.botMovementTime(), "botMovement", { bot.randomMove() })

        // Reinicio manual del juego
        keyboard.r().onPressDo({ self.restartGame() })

        // Le damos inicio al juego 
        game.start()
    }


    method restartGame(){
        soundStageClear.playSound()

        game.addVisual(endOfGame)
        coins.forEach({ coin => game.removeVisual(coin) coins.remove(coin) })
        game.removeTickEvent("girarMoneda")

        bomberman.restartGame()
        antiBomberman.restartGame()
        bot.restartGame()

        game.schedule(2000, { game.removeVisual(endOfGame) })
    }
}
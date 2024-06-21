import Root.*
import Jugadores.Players
import Bots.Bots
import Monedas.Coins
import Sonidos.Sounds
import Bombas.Bombs


object gameManager {
    // Personajes que se mostraran
    var bomberman = null
    var antiBomberman = null
    var bot = null

    // Posiciones por defecto de los bombermans
    const originalPosBomberman = game.at(0, 0)
    const originalPosAntiBomberman = game.at(gameWidth-1, gameHeight - 2)
    const originalPosBot = game.at( ((gameWidth-1)/2).truncate(0), ((gameHeight-1)/2).truncate(0) )

    // Monedas que se muestran en pantalla
    const coins = []

    // Carteles de puntaje (Objetos)
    var scoreCoinsBomberman = null
    var scoreBombsBomberman = null
    var scoreCoinsAntibomberman = null
    var scoreBombsAntibomberman = null

    // Objeto que muestra que termino la ronda
    var endOfGame = null

    // Sonidos correspondientes a cada accion del juego
    var soundExplotion = null
    var soundDies = null
    var soundItemGet = null
    var soundKick = null
    var soundPlaceBomb = null
    var soundWalking = null
    var soundStageClear = null


    // Metodo para dar un origen y clase a cada objeto necesario para el juego
    method initialize() {
        // Inicializamos el tablero
        game.width(gameWidth)
        game.height(gameHeight)
        game.cellSize(cellSize)
        game.boardGround("background.png")

        // Creamos a los personajes
        bomberman = new Players(position=originalPosBomberman, image="bomberman_down.png", tag="bomberman")
        antiBomberman = new Players(position=originalPosAntiBomberman, image="antiBomberman_down.png", tag="antiBomberman")
        bot = new Bots(position=originalPosBot, image="fireBomberman_down.png", tag="fireBomberman")

        // Agregamos los sonidos del juego
        soundExplotion = new Sounds(soundPath="Bomb_Explodes.mp3")
        soundDies = new Sounds(soundPath="Bomberman_Dies.mp3")
        soundItemGet = new Sounds(soundPath="Item_Get.mp3")
        soundKick = new Sounds(soundPath="Kick.mp3")
        soundPlaceBomb = new Sounds(soundPath="Place_Bomb.mp3")
        soundWalking = new Sounds(soundPath="Walking.mp3")
        soundStageClear = new Sounds(soundPath="Stage_Clear.wav")

        // Creamos los objetos puntaje
        scoreCoinsBomberman = new DefaultVisual(position=game.at(3,11), image="bomberman_coins_0.png", tag="cartel")
        scoreCoinsAntibomberman = new DefaultVisual(position=game.at(11,11), image="antiBomberman_coins_0.png", tag="cartel")
        scoreBombsBomberman = new DefaultVisual(position=game.at(1,11), image="bombermans_bombs_1.png", tag="cartel")
        scoreBombsAntibomberman = new DefaultVisual(position=game.at(9,11), image="bombermans_bombs_1.png", tag="cartel")

        // Y, al objeto que contiene el fin de juego
        endOfGame = new DefaultVisual(tag="cartel", image="game_over_retro.png", position=game.at(4, 2))
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
        keyboard.a().onPressDo({ bomberman.move("left", soundWalking) })
        keyboard.d().onPressDo({ bomberman.move("right", soundWalking) })
        keyboard.w().onPressDo({ bomberman.move("up", soundWalking) })
        keyboard.s().onPressDo({ bomberman.move("down", soundWalking) })
        // Movimiento de antiBomberman, jugador 2
        keyboard.left().onPressDo({ antiBomberman.move("left", soundWalking) })
        keyboard.right().onPressDo({ antiBomberman.move("right", soundWalking) })
        keyboard.up().onPressDo({ antiBomberman.move("up", soundWalking) })
        keyboard.down().onPressDo({ antiBomberman.move("down", soundWalking) })

        // Bombas de bomberman
        keyboard.space().onPressDo({ bomberman.plantBomb(scoreBombsBomberman, soundPlaceBomb, soundExplotion) })
        // Bombas de antiBomberman
        keyboard.enter().onPressDo({ antiBomberman.plantBomb(scoreBombsAntibomberman, soundPlaceBomb, soundExplotion) })


        // Colisiones de bomberman ante explosiones y monedas
        game.onCollideDo(bomberman, { collider =>
            if(collider.tag() == "explosion"){
                bomberman.getExplosion(scoreCoinsBomberman, originalPosBomberman, soundDies)
                game.removeVisual(collider)
            } else if (collider.tag() == "moneda"){
                bomberman.getCoin(collider, soundItemGet, scoreBombsBomberman, scoreCoinsBomberman)
                if (bomberman.coinsPicked() >= 5){ self.restartGame() }
                coins.remove(collider)
            }
        })
        // Colisiones de antiBomberman ante explosiones y monedas
        game.onCollideDo(antiBomberman, { collider =>
            if(collider.tag() == "explosion"){
                antiBomberman.getExplosion(scoreCoinsAntibomberman, originalPosAntiBomberman, soundDies)
                game.removeVisual(collider)
            } else if (collider.tag() == "moneda"){
                antiBomberman.getCoin(collider, soundItemGet, scoreBombsAntibomberman, scoreCoinsAntibomberman)
                if (antiBomberman.coinsPicked() >= 5){ self.restartGame() }
                coins.remove(collider)                
            }
        })

        // Cuando el bot colisiona con nosotros pone una bomba
        game.onCollideDo(bot, { collider =>
            if (collider.tag() == "bomberman" || collider.tag() == "antiBomberman") {
                soundKick.playSound()
                game.schedule(250, { bot.plantBomb(soundPlaceBomb, soundExplotion) })
            }
        })

        // Agregamos una moneda cada 7seg
        game.onTick(coinsAppearTime, "nuevaMoneda", {
            if (coins.size() < 2) {
                const coin = new Coins()
                coins.add(coin)
                game.addVisual(coin)
                game.onTick(400, "girarMoneda", {coin.newImage()})
            }
        })

        // Cada cierto tiempo se mueve el bot
        game.onTick(botMovementTime, "botMovement", { bot.randomMove() })

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

        bomberman.restartGame(originalPosBomberman, scoreBombsBomberman, scoreCoinsBomberman)
        antiBomberman.restartGame(originalPosAntiBomberman, scoreBombsAntibomberman, scoreCoinsAntibomberman)
        bot.restartGame(originalPosBot)

        game.schedule(2000, { game.removeVisual(endOfGame) })
    }
}
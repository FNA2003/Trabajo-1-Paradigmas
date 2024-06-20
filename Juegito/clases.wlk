import wollok.game.*

// ==================================================================================================
// Clase que permite generar las explosiones, pues estas mismas no presisan métodos
class Effects {
    const property position
    var property image
    var property tag
}

// ==================================================================================================

// Jugadores
class Bombermans{
    var property position
    var property image
    var property tag // Nombre de los jugadores (tal que se encuentre en las carpeta de assets)
    const movementFactor = 1 // Celdas que se mueve el jugador por cada vez que se pulsa la tecla
    var property monedasRecogidas = 0
    var property bombasDisponibles = 1

    const nombreMonedas = [
            "_coins_0.png",
            "_coins_1.png",
            "_coins_2.png",
            "_coins_3.png",
            "_coins_4.png",
            "_coins_5.png"
        ]
        const nombreBombas = [
        "_bombs_0.png",
        "_bombs_1.png",
        "_bombs_2.png",
        "_bombs_3.png",
        "_bombs_4.png"
    ]
    // Metodo para que el jugador se mueva dentro de los limites
    method move(direction) {        
        game.sound("Walking.wav").play()
        if (direction == "left" && position.x() != 0) {
            image = tag + "_left.png"
            position = position.left(movementFactor)
        } else if (direction == "right" && position.x() < (game.width() - 1)) {
            image = tag + "_right.png"
            position = position.right(movementFactor)
        } else if (direction == "up" && position.y() < (game.height() - 2)) {
            image = tag + "_up.png"
            position = position.up(movementFactor)
        } else if (direction == "down" && position.y() != 0) {
            image = tag + "_down.png"
            position = position.down(movementFactor)
        }
    }

    method variarCantBombas(cartelBombas) {
        if (bombasDisponibles > 4) { bombasDisponibles = 4 }
        cartelBombas.image("bombermans" + nombreBombas.get(bombasDisponibles))
    }
    method agarrarMoneda(moneda, cartelMonedas) {
        monedasRecogidas += 1
        if (monedasRecogidas > 5) { monedasRecogidas = 5 }
        if (moneda != null){ game.removeVisual(moneda) }
        cartelMonedas.image(tag + nombreMonedas.get(monedasRecogidas))
    }
    method recibirExplosion(cartelMonedas) {
        monedasRecogidas -= 1
        if (monedasRecogidas < 0) { monedasRecogidas = 0 }
        cartelMonedas.image(tag + nombreMonedas.get(monedasRecogidas))
    }
    method finPartida(cartelMonedas, cartelBombas) {
        monedasRecogidas = 0
        bombasDisponibles = 1

        cartelBombas.image("bombermans" + nombreBombas.get(1))
        cartelMonedas.image(tag + nombreMonedas.get(0))
    }
}

// ==================================================================================================

// Bot
object bot {
  var property image = "fireBomberman_down.png"
  var property position = game.at(7,5)
  const property tag = "bot"
  const movementFactor = 1  
  const imagenes = [
        "fireBomberman_up.png", "fireBomberman_down.png",
        "fireBomberman_left.png", "fireBomberman_right.png",
        "fireBomberman_left.png", "fireBomberman_right.png",
        "fireBomberman_left.png", "fireBomberman_right.png"
    ]

  method randomMove() {
    const posibleMoves = [
        position.up(movementFactor), position.down(movementFactor),
        position.left(movementFactor), position.right(movementFactor),
        position.up(movementFactor).left(movementFactor), position.up(movementFactor).right(movementFactor),
        position.down(movementFactor).left(movementFactor), position.down(movementFactor).right(movementFactor)
    ]
    const indice = (0.randomUpTo(posibleMoves.size())).truncate(0)
    const newPosition = posibleMoves.get(indice)
    
    if ((newPosition.x() > 0 && newPosition.x() < 14)  && (newPosition.y() > 0 && newPosition.y() < 10)) {
        image = imagenes.get(indice)
        position = newPosition
    }
    
  }
  method restartGame() {
    image = "fireBomberman_down.png"
    position = game.center()
  }
}


// ==================================================================================================

// Bombas que pueden poner los jugadores y la "CPU"
class Bomb {
    var property position
    var property image = "bomb.png"
    var property tag = "bomba"

    // =====================================================================
    
    // Partes de la explosion (key: parte (U-D-UD-C-R-L-RL), value: posicion de la parte)
    // 1: Menor, 2: Media-baja, 3: Media-alta, 4: Mayor
    // U: Up, D: Down, UD: Up-Down, C: Centre, R: Right, L: Left, RL: Right-Left
    const explodeParts = [
        'U'-> position.up(2), 
        'D' -> position.down(2), 
        'UD' -> position.up(1), 
        'UD' -> position.down(1), 
        'C' -> position, 
        'R' -> position.right(2), 
        'L' -> position.left(2), 
        'RL' -> position.right(1),
        'RL' -> position.left(1)
    ]

    method explode(visual){
        // Sacamos la imagen de la bomba
        game.removeVisual(visual)
        // Reproducimos el efecto de explosion 
        game.sound("Bomb_Explodes.wav").play()
        // Creamos una lista para los objetos que representaran cada parte de la explosion
        const explodePartsObjects = []
        // Creamos un contador para recorrer esta lista posteriormente
        var partNumber = -1
        // Agregamos el efecto de explosion que tiene definida por defecto cada instancia de esta clase
        explodeParts.forEach({pair => const explodePart = new Effects(
                    position = pair.value(), 
                    image = ('explosion_' + pair.key().toString() + '_1' + '.png'), 
                    tag = "explosion"
                    )
                    explodePartsObjects.add(explodePart)
                    game.addVisual(explodePart)
            })
        
        // Hacemos la animacion de explosion (cambiar la imagen) 
        
        game.schedule(250, {
            explodeParts.forEach({pair => 
            partNumber += 1 
            explodePartsObjects.get(partNumber).image('explosion_' + pair.key().toString() + '_2' + '.png')
            })

            partNumber = -1
            game.schedule(250, {
                explodeParts.forEach({pair => 
                partNumber += 1 
                explodePartsObjects.get(partNumber).image('explosion_' + pair.key().toString() + '_3' + '.png')
                })
                
                partNumber = -1
                game.schedule(250, {
                    explodeParts.forEach({pair => 
                    partNumber += 1 
                    explodePartsObjects.get(partNumber).image('explosion_' + pair.key().toString() + '_4' + '.png')
                    })

                    // Y, por ultimo, borramos la explosion
                    game.schedule(250, { explodePartsObjects.forEach({ element => game.removeVisual(element) }) })
                })
            })
        })
    }
}

// ==================================================================================================

object gameManager {
    // Tiempo para que explote una bomba       
    const bombTime = 1700
    var bomberman = null
    var antiBomberman = null

    // Lista de monedas que se renderizaron en la pantalla
    const monedas = []

    method iniciarPartida() {
        // Seteo del tablero a un multiplo de 16px (tamaño de assets)
        game.width(15)
        game.height(12)
        game.cellSize(16)
        
        const cartelMonedasJug1 = new Effects(position=game.at(3,11), image="bomberman_coins_0.png", tag="cartel")
        const cartelMonedasJug2 = new Effects(position=game.at(11,11), image="antiBomberman_coins_0.png", tag="cartel")
        const cartelBombasJug1 = new Effects(position=game.at(1,11), image="bombermans_bombs_1.png", tag="cartel")
        const cartelBombasJug2 = new Effects(position=game.at(9,11), image="bombermans_bombs_1.png", tag="cartel")

        game.addVisual(cartelMonedasJug1)
        game.addVisual(cartelMonedasJug2)
        game.addVisual(cartelBombasJug1)
        game.addVisual(cartelBombasJug2)

        // =====================================================================
        
        // Creacion del personaje 1
        bomberman = new Bombermans(position=game.origin(), image="bomberman_down.png", tag="bomberman")
        // Creacion del personaje 2 
        antiBomberman = new Bombermans(position=game.at(14,10), image="antiBomberman_down.png", tag="antiBomberman")

        // =====================================================================

        // Bombas del personaje 1
        keyboard.space().onPressDo({
            if (bomberman.bombasDisponibles() > 0){
                game.sound("Place_Bomb.wav").play()
                const b = new Bomb(position=bomberman.position())
                game.addVisual(b)
                game.schedule(bombTime, { b.explode(b) })
                bomberman.bombasDisponibles(bomberman.bombasDisponibles() - 1)
                bomberman.variarCantBombas(cartelBombasJug1)
            }
        })
        // Bombas del personaje 2
        keyboard.enter().onPressDo({
            if (antiBomberman.bombasDisponibles() > 0) {
                game.sound("Place_Bomb.wav").play()
                const b = new Bomb(position=antiBomberman.position())
                game.addVisual(b)
                game.schedule(bombTime, { b.explode(b) })
                antiBomberman.bombasDisponibles(antiBomberman.bombasDisponibles() - 1)
                antiBomberman.variarCantBombas(cartelBombasJug2)
            }
        })

        // =====================================================================

        // Movimiento de bomberman
        keyboard.a().onPressDo({ bomberman.move("left") })
        keyboard.d().onPressDo({ bomberman.move("right") })
        keyboard.w().onPressDo({ bomberman.move("up") })
        keyboard.s().onPressDo({ bomberman.move("down") })
        // Movimiento de antiBomberman
        keyboard.left().onPressDo({ antiBomberman.move("left") })
        keyboard.right().onPressDo({ antiBomberman.move("right") })
        keyboard.up().onPressDo({ antiBomberman.move("up") })
        keyboard.down().onPressDo({ antiBomberman.move("down") })

        // =====================================================================

        // Colisiones de bomberman ante explosiones y monedas
        game.whenCollideDo(bomberman, {collider =>
            if (collider.tag() == "explosion"){
                bomberman.recibirExplosion(cartelMonedasJug1)
                bomberman.position(game.origin())
                game.sound("Bomberman_Dies.wav").play()
                game.removeVisual(collider)

                if(antiBomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                }
            } 
            else if (collider.tag() == "moneda"){
                bomberman.agarrarMoneda(collider, cartelMonedasJug1)
                monedas.remove(collider)

                if(bomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                } 
                else {
                    bomberman.bombasDisponibles(bomberman.bombasDisponibles() + 1)
                    bomberman.variarCantBombas(cartelBombasJug1)
                }
            }
        })
        // Colisiones de antiBomberman ante explosiones y monedas
        game.whenCollideDo(antiBomberman, {collider =>
            if (collider.tag() == "explosion"){
                antiBomberman.recibirExplosion(cartelMonedasJug2)
                antiBomberman.position(game.at(14,10))
                game.sound("Bomberman_Dies.wav").play()
                game.removeVisual(collider)

                if(bomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                }
            } 
            else if (collider.tag() == "moneda"){
                antiBomberman.agarrarMoneda(collider, cartelMonedasJug2)
                monedas.remove(collider)
                
                if(antiBomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                } 
                else {
                    game.removeVisual(collider)
                    antiBomberman.bombasDisponibles(antiBomberman.bombasDisponibles() + 1)
                    antiBomberman.variarCantBombas(cartelBombasJug2)
                }
            }
        })

        // =====================================================================

        // Si alguien colisiona con el bot, este pone una bomba
        game.onCollideDo(bot, {collider =>
            if(collider.tag() == "bomberman" || collider.tag() == "antiBomberman"){
                game.sound("Kick.wav").play()
                game.schedule(100, {
                    game.sound("Place_Bomb.wav").play()
                    const b = new Bomb(position=bot.position())
                    game.addVisual(b)
                    game.schedule(bombTime, { b.explode(b) })
                })                
            }
        })

        // =====================================================================
        
        //Agrego moneda al mapa y a la lista de monedas, y su efecto de rotar
        game.onTick(7000, "nuevaMoneda", {
            if (monedas.size() < 2) {
                const moneda = new Moneda()
                monedas.add(moneda)
                game.addVisual(moneda)
                game.onTick(400, "girarMoneda", {moneda.newImage()})
            }
        })
        // =====================================================================
        
        // Cada cierto tiempo el bot se mueve solo
        game.onTick(900, "botMovement", {
            bot.randomMove()
        })

        // =====================================================================

        // Reinicio de juego
        keyboard.r().onPressDo({ restart.restart(bomberman, antiBomberman, monedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2) })

    
        // Agregamos los personajes
        game.addVisual(bot)
        game.addVisual(bomberman)
        game.addVisual(antiBomberman)
        game.boardGround("fondo.png")
    }    
}

// ==================================================================================================

// Objeto para reinicios del juego
object restart {
    method restart(jugador1, jugador2, listaDeMonedas, cartelMonedasJug1, cartelBombasJug1, cartelMonedasJug2, cartelBombasJug2){
        listaDeMonedas.forEach({moneda => game.removeVisual(moneda) listaDeMonedas.remove(moneda)})
        jugador1.position(game.origin())
        jugador2.position(game.at(14,10))
        game.removeTickEvent("girarMoneda")

        jugador1.finPartida(cartelMonedasJug1, cartelBombasJug1)
        jugador2.finPartida(cartelMonedasJug2, cartelBombasJug2)
        bot.restartGame()
    }
}

// ==================================================================================================

// Imagen para cuando finaliza el juego
object finDeJuego {
    var posicion = null
    method image() = "game_over_retro.png"
    method position() = game.at(4, 2)
    method position(nuevaPosicion){
        posicion = nuevaPosicion
    }
}

// ==================================================================================================

// Clase de monedas
class Moneda {
    var property tag = "moneda"
    var numeroDeImagen = 0
    const posicionInicialX = 0.randomUpTo(game.width()).truncate(0)
    const posicionInicialY = 0.randomUpTo(game.height() - 1).truncate(0)
    var property image = "coin_a.png"
    const imagenes = [
        "coin_a.png", 
        "coin_b.png", 
        "coin_c.png", 
        "coin_d.png", 
        "coin_e.png", 
        "coin_f.png", 
        "coin_g.png", 
        "coin_h.png"
        ]
    
    method position() = game.at(posicionInicialX, posicionInicialY)
    
    method newImage() {
        const imagen = imagenes.get(numeroDeImagen)
        numeroDeImagen = ((numeroDeImagen + 1) % 8)
        image = imagen
        }
}

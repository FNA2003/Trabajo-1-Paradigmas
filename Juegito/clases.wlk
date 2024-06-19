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


    // Metodo para que el jugador se mueva dentro de los limites
    method move(direction) {        
        game.sound("Walking.wav").play()
        if (direction == "left" && position.x() != 0) {
            image = tag + "_left.png"
            position = position.left(movementFactor)
        } else if (direction == "right" && position.x() < (game.width() - 1)) {
            image = tag + "_right.png"
            position = position.right(movementFactor)
        } else if (direction == "up" && position.y() < (game.height() - 1)) {
            image = tag + "_up.png"
            position = position.up(movementFactor)
        } else if (direction == "down" && position.y() != 0) {
            image = tag + "_down.png"
            position = position.down(movementFactor)
        }
    }

    // =====================================================================

    // Metodos para que los personajes hablen
    method festejo() = "Woho! tengo " + bombasDisponibles + " bombas"
    method quejarse() = "Oh no! perdi una moneda"
    method puntaje() = "Woho! Ya tengo " + monedasRecogidas + "/5 monedas"
}

// ==================================================================================================

// Bombas que pueden poner los jugadores
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
        game.height(11)
        game.cellSize(16)

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
                antiBomberman.bombasDisponibles(antiBomberman.bombasDisponibles() + 1)
                game.say(antiBomberman, { antiBomberman.festejo() })
                bomberman.monedasRecogidas(bomberman.monedasRecogidas() - 1)
                game.say(bomberman, { bomberman.quejarse() })
                bomberman.position(game.origin())
                game.sound("Bomberman_Dies.wav").play()
            } 
            else if (collider.tag() == "moneda"){
                bomberman.monedasRecogidas(bomberman.monedasRecogidas() + 1)
                
                if(bomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                } 
                else {
                    game.removeVisual(collider)
                    bomberman.bombasDisponibles(bomberman.bombasDisponibles() + 1)
                    game.say(bomberman, { bomberman.puntaje() })
                    game.schedule(1000, {game.say(bomberman, bomberman.festejo())})
                }
            }
        })
        // Colisiones de antiBomberman ante explosiones y monedas
        game.whenCollideDo(antiBomberman, {collider =>
            if (collider.tag() == "explosion"){
                bomberman.bombasDisponibles(bomberman.bombasDisponibles() + 1)
                game.say(bomberman, { bomberman.festejo() })
                antiBomberman.monedasRecogidas(antiBomberman.monedasRecogidas() - 1)
                game.say(antiBomberman, { antiBomberman.quejarse() })
                antiBomberman.position(game.at(14,10))
                game.sound("Bomberman_Dies.wav").play()
            } 
            else if (collider.tag() == "moneda"){
                antiBomberman.monedasRecogidas(antiBomberman.monedasRecogidas() + 1)
                
                if(antiBomberman.monedasRecogidas() >= 5){
                    game.addVisual(finDeJuego)
                    restart.restart(bomberman, antiBomberman, monedas)
                    game.schedule(2000, { game.removeVisual(finDeJuego) })
                } 
                else {
                    game.removeVisual(collider)
                    antiBomberman.bombasDisponibles(antiBomberman.bombasDisponibles() + 1)
                    game.say(antiBomberman, { antiBomberman.puntaje() })
                    game.schedule(2000, {game.say(antiBomberman, antiBomberman.festejo())})
                }
            }
        })

        // =====================================================================
        
        //Agrego moneda al mapa y a la lista de monedas, y su efecto de rotar
        game.onTick(7000, "nuevaMoneda", {
            const moneda = new Moneda()
            monedas.add(moneda)
            game.addVisual(moneda)
            game.onTick(400, "girarMoneda", {moneda.newImage()})
        })

        // =====================================================================

        // Reinicio de juego
        keyboard.r().onPressDo({restart.restart(bomberman, antiBomberman, monedas)})

        // Agregamos los personajes
        game.addVisual(bomberman)
        game.addVisual(antiBomberman)
        game.boardGround("fondo.png")
    }    
}

// ==================================================================================================

// Objeto para reinicios del juego
object restart {
    method restart(jugador1, jugador2, listaDeMonedas){
        listaDeMonedas.forEach({moneda => game.removeVisual(moneda) listaDeMonedas.remove(moneda)})
        jugador1.position(game.origin())
        jugador2.position(game.at(14,10))
        game.removeTickEvent("girarMoneda")
        
        jugador1.bombasDisponibles(1)
        jugador2.bombasDisponibles(1)
        jugador1.monedasRecogidas(0)
        jugador2.monedasRecogidas(0)
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
    const posicionInicialY = 0.randomUpTo(game.height()).truncate(0)
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
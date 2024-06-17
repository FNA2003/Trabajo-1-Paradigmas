import wollok.game.*




// Clase que permite generar las explosiones, pues estas mismas no presisan métodos
class Effects {
    const property position
    var property image
    var property tag
}

// Jugadores
class Bombermans{
    var property position
    var property image
    var property tag // Nombre de los jugadores (tal que se encuentre en las carpeta de assets)
    const movementFactor = 16 // Celdas que se mueve el jugador por cada vez que se pulsa la tecla
    var property frutasComidas = 0
    var property bombasDisponibles = 1


    // Metodo para que el jugador se mueva dentro de los limites
    method move(direction) {        
        game.sound("Walking.wav").play()
        if (direction == "left" && position.x() != 0) {
            image = tag + "_left.png"
            position = position.left(movementFactor)
        } else if (direction == "right" && position.x() < (game.width() - 16)) {
            image = tag + "_right.png"
            position = position.right(movementFactor)
        } else if (direction == "up" && position.y() < (game.height() - 16)) {
            image = tag + "_up.png"
            position = position.up(movementFactor)
        } else if (direction == "down" && position.y() != 0) {
            image = tag + "_down.png"
            position = position.down(movementFactor)
        }
    }
}


// Bombas que pueden poner los jugadores
class Bomb {
    var property position
    var property image = "bomb.png"
    var property tag = "bomba"
    // Partes de la explosion
    const explosion = [new Effects(position=position, image="explosion_C_1.png", tag="explosion"),
                                        new Effects(position=position.up(32), image="explosion_A_1.png", tag="explosion"),
                                        new Effects(position=position.up(16), image="explosion_AAB_1.png", tag="explosion"),
                                        new Effects(position=position.down(16), image="explosion_AAB_1.png", tag="explosion"),
                                        new Effects(position=position.down(32), image="explosion_AB_1.png", tag="explosion"),
                                        new Effects(position=position.right(32), image="explosion_D_1.png", tag="explosion"),
                                        new Effects(position=position.right(16), image="explosion_DI_1.png", tag="explosion"),
                                        new Effects(position=position.left(16), image="explosion_DI_1.png", tag="explosion"),
                                        new Effects(position=position.left(32), image="explosion_I_1.png", tag="explosion")]
                                

    method explode(visual){
        // Sacamos la imagen de la bomba
        game.removeVisual(visual)
        // Reproducimos el efecto de explosion 
        game.sound("Bomb_Explodes.wav").play()
        // Agregamos el efecto de explosion que tiene definida por defecto cada instancia de esta clase
        explosion.forEach({element =>  game.addVisual(element) })
        
        /* Hacemos la animacion de explosion (cambiar la imagen) */
        game.schedule(250, {
            explosion.get(0).image("explosion_C_2.png")
            explosion.get(1).image("explosion_A_2.png")
            explosion.get(2).image("explosion_AAB_2.png")
            explosion.get(3).image("explosion_AAB_2.png")
            explosion.get(4).image("explosion_AB_2.png")
            explosion.get(5).image("explosion_D_2.png")
            explosion.get(6).image("explosion_DI_2.png")
            explosion.get(7).image("explosion_DI_2.png")
            explosion.get(8).image("explosion_I_2.png")

            game.schedule(250, {
                explosion.get(0).image("explosion_C_3.png")
                explosion.get(1).image("explosion_A_3.png")
                explosion.get(2).image("explosion_AAB_3.png")
                explosion.get(3).image("explosion_AAB_3.png")
                explosion.get(4).image("explosion_AB_3.png")
                explosion.get(5).image("explosion_D_3.png")
                explosion.get(6).image("explosion_DI_3.png")
                explosion.get(7).image("explosion_DI_3.png")
                explosion.get(8).image("explosion_I_3.png")

                game.schedule(250, {
                    explosion.get(0).image("explosion_C_4.png")
                    explosion.get(1).image("explosion_A_4.png")
                    explosion.get(2).image("explosion_AAB_4.png")
                    explosion.get(3).image("explosion_AAB_4.png")
                    explosion.get(4).image("explosion_AB_4.png")
                    explosion.get(5).image("explosion_D_4.png")
                    explosion.get(6).image("explosion_DI_4.png")
                    explosion.get(7).image("explosion_DI_4.png")
                    explosion.get(8).image("explosion_I_4.png")

                    /* Y, por ultimo, borramos la explosion */
                    game.schedule(250, { explosion.forEach({ element => game.removeVisual(element) }) })
                })
            })
        })
    }
}


object gameManager {
    // Tiempo para que explote una bomba       
    const bombTime = 1700
    var bomberman = null
    var antiBomberman = null

    method iniciarPartida() {        
        // Seteo del tablero a un multiplo de 16px (tamaño de assets)
        game.width(240)
        game.height(176)
        game.cellSize(1)

        // Creacion del personaje 1
        bomberman = new Bombermans(position=game.origin(), image="bomberman_down.png", tag="bomberman")
        // Personaje 2 
        antiBomberman = new Bombermans(position=game.at(224,160), image="antiBomberman_down.png", tag="antiBomberman")

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

        // Colisiones de bomberman ante explosiones
        game.whenCollideDo(bomberman, {collider =>
            if (collider.tag() == "explosion"){
                bomberman.position(game.origin())
                game.sound("Bomberman_Dies.wav").play()
            }
        })
        // Colisiones de antiBomberman ante explosiones
        game.whenCollideDo(antiBomberman, {collider =>
            if (collider.tag() == "explosion"){
                antiBomberman.position(game.at(224,160))
                game.sound("Bomberman_Dies.wav").play()
            }
        })

        // Reinicio de juego
        keyboard.r().onPressDo({ 
            bomberman.position(game.origin())
            antiBomberman.position(game.at(224,160))
            
            antiBomberman.bombasDisponibles(1)
            bomberman.bombasDisponibles(1)
            bomberman.frutasComidas(0)
            antiBomberman.frutasComidas(0)
        })

        // Agregamos los personajes
        game.addVisual(bomberman)
        game.addVisual(antiBomberman)
        game.boardGround("fondo.png")
    }    
}
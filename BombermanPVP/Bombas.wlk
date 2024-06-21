import Root.*


// Bombas que pueden poner los jugadores y la "CPU"
class Bombs inherits DefaultVisual{
    // Partes de la explosion (key: parte (U-D-UD-C-R-L-RL), value: posicion de la parte)
    // 1: Menor, 2: Media-baja, 3: Media-alta, 4: Mayor
    // U: Up, D: Down, UD: Up-Down, C: Centre, R: Right, L: Left, RL: Right-Left
    const explosionParts = [
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

    // Metodo para reutilizar codigo cada vez que un bomberman pone una bomba
    method plantBomb(bombVisual, plantSound, explosionSound) {
        plantSound.playSound()
        game.schedule(bombTime, { self.explode(bombVisual, explosionSound) })
    }

    method explode(bombVisual, explosionSound){
        // Sacamos la imagen de la bomba
        game.removeVisual(bombVisual)
        // Reproducimos el efecto de explosion 
        explosionSound.playSound()
        
        const explodePartsObjects = [] // Creamos una lista para los objetos que representaran cada parte de la explosion
        var counter = 0 // Creamos un contador para recorrer esta lista posteriormente
        

        // Agregamos el efecto de explosion que tiene definida por defecto cada instancia de esta clase
        explosionParts.forEach({ pair => 
            const explodePart = new DefaultVisual(
                position = pair.value(), 
                image = ('explosion_' + pair.key().toString() + '_1' + '.png'), 
                tag = "explosion"
            )
            explodePartsObjects.add(explodePart)
            game.addVisual(explodePart)
        })
        
        // Hacemos la animacion de explosion (cambiar la imagen) 
        
        game.schedule(250, {
            explosionParts.forEach({pair =>
                explodePartsObjects.get(counter).image('explosion_' + pair.key().toString() + '_2' + '.png')
                counter += 1
            })

            counter = 0
            game.schedule(250, {
                explosionParts.forEach({pair => 
                    explodePartsObjects.get(counter).image('explosion_' + pair.key().toString() + '_3' + '.png')
                    counter += 1
                })
                
                counter = 0
                game.schedule(250, {
                    explosionParts.forEach({pair => 
                        explodePartsObjects.get(counter).image('explosion_' + pair.key().toString() + '_4' + '.png')
                        counter += 1 
                    })

                    // Y, por ultimo, borramos la explosion
                    game.schedule(250, { explodePartsObjects.forEach({ element => game.removeVisual(element) }) })
                })
            })
        })
    }
}
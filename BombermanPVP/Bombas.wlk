import Root.*
import Explosion.*
import Sonidos.*

// Bombas que pueden poner los jugadores y la "CPU"
class Bombs inherits DefaultVisual(tag = 'bomb', image='bomb.png'){
    // tiempo en el que se planta la bomba
    const bombTime = 1700

    // sonidos
    const plantSound = new Sounds(soundPath="Place_Bomb.mp3")
    const explosionSound = new Sounds(soundPath="Bomb_Explodes.mp3")

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

    const nameOnTick // Identificador unico del OnTick de cada bomba/explosion

    // Metodo para reutilizar codigo cada vez que un bomberman pone una bomba
    method plantBomb(bombVisual) {
        plantSound.playSound()
        game.schedule(bombTime, { self.explode(bombVisual) })
    }

    method explode(bombVisual){
        // Sacamos la imagen de la bomba
        game.removeVisual(bombVisual)
        // Reproducimos el efecto de explosion 
        explosionSound.playSound()
        
        const explodePartsObjects = [] // Creamos una lista para los objetos que representaran cada parte de la explosion
        var counterIntensity = 2 // Creamos un contador para cambiar la intensidad de la explosion
        

        // Agregamos el efecto de explosion que tiene definida por defecto cada instancia de esta clase
        explosionParts.forEach({ pair => 
            const explodePart = new Explosion(
                position = pair.value(), 
                image = 'explosion_' + pair.key().toString() + '_1' + '.png'
            )
            explodePartsObjects.add(explodePart)
            game.addVisual(explodePart)
        })
        
        // Hacemos la animacion de explosion (cambiar la imagen)
        game.onTick(250, nameOnTick.toString(), { => self.changeExplosion(explodePartsObjects, counterIntensity) counterIntensity+=1})
    }

    method changeExplosion(explodePartsObjects, counterIntensity) {
        var counter = 0 // Se crea un contador para recorrer la lista explodePartsObjects
        if(counterIntensity <= 4){
            explosionParts.forEach({pair => 
            explodePartsObjects.get(counter).image('explosion_' + pair.key().toString() + '_' + (counterIntensity) + '.png')
            counter += 1
            })
        }
        else {
            game.removeTickEvent(nameOnTick.toString())
            explodePartsObjects.forEach({ element => game.removeVisual(element) })
        }
    }

    // metodo para cuando un player colisiona con la bomba (no con la explosion)
    method collide(player, bomb) {}
}
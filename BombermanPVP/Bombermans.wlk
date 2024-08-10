import Root.*
import Movements.*
import Sonidos.*


// Clase que nos permite instanciar a los jugadores
// Nota: El tag de los jugadores es tal que nos permite conocer el nombre de su archivo
class Bombermans inherits DefaultVisual(){
    const soundDies = new Sounds(soundPath="Bomberman_Dies.mp3")
    const getSound = new Sounds(soundPath="Item_Get.mp3")
    const soundKick = new Sounds(soundPath="Kick.mp3")

    // Metodo para que el jugador y la maquina se mueva dentro de los limites
    // Direction: objeto que nos permite definir hacia donde se mueve el pj
    // SoundObject: (vea Effectos.Sounds) objeto personalizado de sonido
    method move(direction, soundObject) {
        if (soundObject != null) { soundObject.playSound() }
        image = tag + direction.image()
        position = direction.position(position)
    }
}
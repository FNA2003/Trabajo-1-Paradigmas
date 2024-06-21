import Root.*




/* Clase que nos permite tener UN UNICO objeto por sonido para toda la ejecucion */
class Sounds {
    var soundObject = null // Game.Sound() class obj
    const soundPath 

    /* Evitamos solapamiento de un mismo sonido */
    method playSound() {
        if (soundObject == null || soundObject.played()) {
            soundObject = game.sound(soundPath)
            soundObject.play()
        }
    }
}
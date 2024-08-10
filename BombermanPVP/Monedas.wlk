import Manager.*
import Root.*


// Clase de monedas
class Coins {
    var imageIndex = 0 // Indice para cambiar la imagen de la moneda (Animacion de rotar)
    const x = 0.randomUpTo(root.gameWidth()).truncate(0)
    const y = 0.randomUpTo(root.gameHeight() - 1).truncate(0)
    const property tag = "moneda"
    var property image = "coin_0.png"

    // Cuando se genera la moneda, esta irá a una posicion aleatoria
    method position() = game.at(x, y)

    // Que hacer cuando se colisione con una moneda
    method collide(player, coin) {
        player.getCoin(coin)
        if (player.coinsPicked() >= 5){ gameManager.restartGame() }
        gameManager.coins().remove(coin)
    }
    
    // Rotar la imagen
    method newImage() {
        // Cambiamos a la siguiente imagen
        image = 'coin_' + imageIndex.toString() + '.png'
        // Y actualizamos el indice
        imageIndex = ((imageIndex + 1) % 8)
    }
}
import Root.*




// Clase de monedas
class Coins {
    var imageIndex = 0 // Indice cambiar la imagen de la moneda (Animacion de rotar)
    const x = 0.randomUpTo(gameWidth).truncate(0)
    const y = 0.randomUpTo(gameHeight - 1).truncate(0)
    const property tag = "moneda"
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
    
    // Cuando se genera la moneda, esta irá a una posicion aleatoria
    method position() = game.at(x, y)
    
    // Vector circular para rotar la imagen
    method newImage() {
        // Cambiamos a la siguiente imagen
        image = imagenes.get(imageIndex)
        // Y actualizamos el indice
        imageIndex = ((imageIndex + 1) % 8)
    }
}
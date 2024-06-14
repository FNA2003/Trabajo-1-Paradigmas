import wollok.game.*

object juego {
  method iniciar() {
  game.title("Juego1")
  game.cellSize(15)
	game.height(30)
	game.width(30)
  game.boardGround("fondo.jpg")
  game.addVisualCharacter(personaje)

  keyboard.left().onPressDo({personaje.voltearIzq()})
  keyboard.right().onPressDo({personaje.voltearDer()})

  var bala
  const direccion = if(personaje.derecha()) 1 else -1 //calculo hacia en que direccion se movera la bala
  keyboard.space().onPressDo({ //al presionar espacio ejecuto las siguientes acciones
    bala = new Bala(posicion = game.at( //creo una bala con la misma posicion que el personaje
    personaje.position().x(), 
    personaje.position().y()
    ), 
    derecha = personaje.derecha(), //le paso a la bala si el personaje mira hacia la derecha
    izquierda = personaje.izquierda()) //o hacia la izquierda
    game.addVisual(bala) //agrego la bala al tablero
    })
  game.onTick(500, "impulso", { bala.impulso(direccion) }) //hago que la bala se mueva cada medio segundo
  game.start()
  }
}

object personaje {
  var posicion = game.origin()
  var imagen = "personaje2_der.png"
  var property izquierda = false
  var property derecha = true

  method position(nuevaPosicion) {
    posicion = nuevaPosicion
  }

  method position() = posicion

  method image() = imagen

  method voltearIzq() {
    imagen = "personaje2_izq.png"
    //self.position(game.at(self.position().x()-1, self.position().y()))
    izquierda = true
    derecha = false
  }

  method voltearDer() {
    imagen = "personaje2_der.png"
    //self.position(game.at(self.position().x()+1, self.position().y()))
    derecha = true
    izquierda = false
  }
}

class Bala {
  var posicion
  const derecha
  const izquierda

  method image(){ 
    if(derecha) {
      return "bala2_der.png"
      } 
    else {
      return "bala2_izq.png"
    }
    }

  method position(){
    var posicionActual = posicion
    if(derecha){
      posicionActual = game.at((posicionActual.x() + 2), posicionActual.y())
    }
    else{
      posicionActual = game.at((posicionActual.x() - 1), posicionActual.y())
    }
    return posicionActual
  }

  method impulso(direccion){
    posicion = posicion + direccion
  }
}
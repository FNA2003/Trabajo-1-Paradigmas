/*
Macaron
- Cada macaron tiene un peso diferente y pueden tener o no cobertura. Los macarons son naturales si no tienen cobertura. 
- Un macaron es especial cuando su peso es mayor a 50 gramos y además tiene cobertura. 
- Su valoración es de 120 unidades si es especial y de 80 en caso contrario.
*/

class Macaron {
  const property peso // Inicializar
  const tiene_cobertura // Inicializar

  method es_natural() = not tiene_cobertura
  
  method es_especial() = (peso > 50) && tiene_cobertura
  
  method valoracion() {
    if(self.es_especial()){
      return 120
    } 
    else {
      return 80
    }
  }

  method precio(){
    if (self.es_natural()){
      const precio = (self.valoracion() * 30) + 120
      return '$' + precio.toString()
    } 
    else {
      const precio = (self.valoracion() * 30)
      return '$' + precio.toString()
    }
  }
}

// ====================================================================================================================================
/*
Alfajor 
- Su peso es el del relleno que tiene más el peso de las tapas.   
- El alfajor tiene dos tapas iguales, pero no siempre pesan lo mismo entre un alfajor y otro.

- Cada alfajor puede hacerse con diferente relleno. Los rellenos que existen en la patisserie actualmente son los siguientes,
pero podría haber otros en un futuro, con diferentes valores:
    + dulce de leche pesa 30 gramos y no es natural
    + confiture de groseilles pesa 25 gramos y tampoco es natural
    + miel pesa 20 gramos y es natural.

- Un alfajor es natural según el relleno con que esté hecho. 
- La valoración del alfajor se calcula como su peso / 10.
- No se consideran especiales.
*/

class Alfajor {
  const peso_de_tapas // Inicializar
  const relleno // Inicializar
  const property peso = rellenos_existentes.peso(relleno) + peso_de_tapas

  method es_natural() = rellenos_existentes.es_natural(relleno)
  
  method es_especial() = false
  
  method valoracion() = (peso / 10)

  method precio(){
    if (self.es_natural()){
      const precio = (self.valoracion() * 30) + 120
      return '$' + precio.toString()
    } 
    else {
      const precio = (self.valoracion() * 30)
      return '$' + precio.toString()
    }
  }
}

// ============================================================

class Relleno {
  const property peso // Inicializar
  const property es_natural // Inicializar
}

// ============================================================

object rellenos_existentes {
  const dulce_de_leche = new Relleno(peso = 30, es_natural = false)
  const confiture_de_groseilles = new Relleno(peso = 25, es_natural = false)
  const miel = new Relleno(peso = 20, es_natural = true)

  const rellenos = [dulce_de_leche, confiture_de_groseilles, miel].asSet()

  method peso(relleno){
    if(rellenos.contains(relleno)){
      const peso = relleno.peso()
      return peso
    } 
    else {
      console.println('No existe el relleno seleccionado para el alfajor')
    }
  }

  method es_natural(relleno){
    if(rellenos.contains(relleno)){
      const es_natural = relleno.es_natural()
      return es_natural
    } 
    else {
      console.println('No existe el relleno seleccionado para el alfajor')
    }
  }

  method nuevo_relleno(relleno, peso, es_natural) {
    const objeto_relleno = new Relleno(peso = peso, es_natural = es_natural)
    const nombre_del_relleno = relleno.toString()
    rellenos.put(nombre_del_relleno, objeto_relleno)
  }
}

// ====================================================================================================================================
/*
Porciones de tortas
- Puede ser la mejor torta fraiser, una clásica pastafrola, o muchas otras. 
- Puede tener chocolate, crema o algun otro ingrediente destacado. 
- Su peso no está predeterminado y se considera especial si tiene chocolate. 
- Siempre son naturales y su valoracion es 100.
*/
class Porciones_de_torta {
  const tipo_de_torta // Inicializar
  const ingredientes // Inicializar
  const tiene_chocolate = ingredientes.contains('chocolate') || ingredientes.contains('Chocolate')

  const property peso // Inicializar

  method es_natural() = true
  
  method es_especial() = tiene_chocolate
  
  method valoracion() = 100

  method precio(){
    if (self.es_natural()){
      const precio = (self.valoracion() * 30) + 120
      return '$' + precio.toString()
    } 
    else {
      const precio = (self.valoracion() * 30)
      return '$' + precio.toString()
    }
  }
}

// ====================================================================================================================================
/*
Mesa dulce
- Una mesa dulce está compuesta por varias porciones de torta, puede tener macarons o incluso venir con uno o más alfajores. 
- El peso es la suma de los pesos de todo lo que lo compone, y es especial cuando tiene al menos 3 componentes. 
- Si alguna de las cosas que incluye no es natural, la mesa dulce tampoco lo es. 
- Su valoración es la mayor valoración de todo lo que la compone.
*/
class Mesa_dulce {
  const componentes = []

  method peso() = componentes.sum{componente => componente.peso()}

  method es_natural() = not componentes.any{componente => not componente.es_natural()}
  
  method es_especial() = (componentes.size() >= 3)
  
  method valoracion() = (componentes.max{componente => componente.valoracion()}).valoracion()

  method precio(){
    if (self.es_natural()){
      const precio = (self.valoracion() * 30) + 120
      return '$' + precio.toString()
    } 
    else {
      const precio = (self.valoracion() * 30)
      return '$' + precio.toString()
    }
  }
}

// ====================================================================================================================================
/*
Clientes

- De cada cliente se conoce una cierta cantidad de crédito que la patisseria otorga, para que haga sus compras en el local. 
- De los clientes que van a la patisserie nos interesa saber si les agrada o no un producto, lo cual dependerá del cliente. 
- Si el cliente es la primera vez que compra, le va a agradar un producto si es natural, mientras que si ya compró antes le agrada cuando
es especial o tiene una valoración mayor a 100.
- Cuando un cliente se quiere dar un gusto en la patisserie, compra el primero de los platos que le agradan y que pueda pagar con su crédito,
entre los que ofrece en ese momento la patisserie. 
- En caso que encuentre algo para comprar se actualiza su crédito, si no se retira sin comprar.
- La patisserie decide hacer una promoción, y le regala una X cantidad de crédito a todos los clientes que alguna vez hayan comprado algo en la
patisserie.
*/

class Cliente {
  var credito // Inicializar
  const productos_de_agrado // Inicializar
  const primera_vez_que_compra // Inicializar
  const productos_comprados = []
  var property presente = false

  method le_agrada(productos){
    if(primera_vez_que_compra){
      productos_de_agrado.addAll(productos.filter{producto => producto.es_natural()})
    } 
    else {
      productos_de_agrado.addAll(productos.filter{producto => (producto.es_especial() || (producto.valoracion() > 100))})
    }
  }

  method darse_un_gusto(){
    const productos_disponibles = patisserie.productos()
    const productos_accesibles = productos_de_agrado.filter{producto => (credito >= producto.precio())}.filter({producto => productos_disponibles.contains(producto)})
    if(productos_accesibles.size() >= 1){
      self.comprar(productos_accesibles.get(0))
      }
    else {
      self.retirarse()
    }
  }

  method comprar(producto) {
    credito -= producto.precio()
    productos_comprados.add(producto)
  }

  method retirarse() {
    presente = false
  }
}

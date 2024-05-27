/*
Macaron
- Cada macaron tiene un peso diferente y pueden tener o no cobertura. Los macarons son naturales si no tienen cobertura. 
- Un macaron es especial cuando su peso es mayor a 50 gramos y además tiene cobertura. 
- Su valoración es de 120 unidades si es especial y de 80 en caso contrario.
*/

class Macaron {
  const property peso = null // Inicializar
  const tiene_cobertura = false // Inicializar

  method es_natural() = tiene_cobertura
  
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
  const peso_de_tapas = null // Inicializar
  const relleno = null // Inicializar
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
  const property peso = null // Inicializar
  const property es_natural = false // Inicializar
}

// ============================================================

object rellenos_existentes {
  const dulce_de_leche = new Relleno(peso = 30, es_natural = false)
  const confiture_de_groseilles = new Relleno(peso = 25, es_natural = false)
  const miel = new Relleno(peso = 20, es_natural = true)

  const rellenos = ['dulce_de_leche' -> dulce_de_leche, 'confiture_de_groseilles' -> confiture_de_groseilles, 'miel' -> miel]

  method peso(relleno){
    if(rellenos.containsKey(relleno)){
      const peso = rellenos[relleno].peso()
      return peso
    } 
    else {
      const peso = 0
      return peso
    }
  }

  method es_natural(relleno){
    if(rellenos.containsKey(relleno)){
      const es_natural = rellenos[relleno].es_natural()
      return es_natural
    } 
    else {
      const es_natural = false
      return es_natural
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
  const tipo_de_torta = null // Inicializar
  const ingredientes = [] // Inicializar
  const tiene_chocolate = ingredientes.contains('chocolate') || ingredientes.contains('Chocolate')

  const property peso = null // Inicializar

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

  method es_natural() = componentes.all{componente => componente.es_natural()}
  
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
  var credito = null
  const productos_de_agrado = []
  const primera_vez_que_compra = false
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
    const productos_accesibles = productos_de_agrado.filter{producto => (credito >= producto.precio())}
    if(productos_accesibles.size() >= 1){
      self.comprar(productos_accesibles.get(0))
      }
    else {
      self.retirarse()
    }
  }

  method comprar(producto) {
    credito -= producto.precio()
  }

  method retirarse() {
    presente = false
  }
}

// ====================================================================================================================================
/*
La Patisserie
*/

object la_patisserie{
  const clientes = new Dictionary()
  const productos = new Dictionary()
  var cliente_actual = null
  
  method agregar_cliente(cliente, credito, productos_de_agrado, primera_vez_que_compra) {
    const objeto_cliente = new Cliente(credito = credito, productos_de_agrado = productos_de_agrado, primera_vez_que_compra = primera_vez_que_compra)
    const nombre_del_cliente = cliente.toString()
    clientes.put(nombre_del_cliente, objeto_cliente)
  }

  method agregar_producto(producto, tipo_de_producto, peso, tiene_cobertura, peso_de_tapas, relleno, tipo_de_torta, ingredientes) {

    const nombre_del_producto = producto.toString()
    
    if(tipo_de_producto.toString() == 'Macaron'){
      const objeto_producto = new Macaron(peso = peso, tiene_cobertura = tiene_cobertura)
      productos.put(nombre_del_producto, objeto_producto)
    } 
    if(tipo_de_producto.toString() == 'Alfajor'){
      const objeto_producto = new Alfajor(peso_de_tapas = peso_de_tapas, relleno = relleno)
      productos.put(nombre_del_producto, objeto_producto)
    } 
    if(tipo_de_producto.toString() == 'Porciones_de_torta'){
      const objeto_producto = new Porciones_de_torta(peso = peso, tipo_de_torta = tipo_de_torta, ingredientes = ingredientes)
      productos.put(nombre_del_producto, objeto_producto)
    }
  }

  method armar_mesa_dulce(nombre_de_mesa_dulce, componentes) {
    const lista_de_componentes = []
    componentes.forEach({componente => componente.toString()})
    componentes.forEach({componente => lista_de_componentes.add(componente)})
    const objeto_producto = new Mesa_dulce(componentes = lista_de_componentes)
    productos.put(nombre_de_mesa_dulce, objeto_producto)
  }

  method cliente_actual(cliente) {
    if(clientes.containsValue(cliente)){
      cliente_actual = cliente
      cliente_actual.presente(true)
    }
  }

  method cliente_darse_un_gusto() {
    if(cliente_actual.presente()){
      cliente_actual.le_agrada(productos)
      cliente_actual.darse_un_gusto()
    }
  }
}
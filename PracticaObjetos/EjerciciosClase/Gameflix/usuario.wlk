import errores.NoPuedoJugarException

class Usuario{
	const nombre // atributo de color
	var suscripcion
	var saldo
	var humor
	
	// filtar(unaCategoriaDeJuegos)
	// buscar(unJuegoPorNombre)
	// pedirRecomendacion()
	method actualizarSuscripcion(nuevaSuscripcion){
		suscripcion = nuevaSuscripcion
	}
	method malhumorarse(unValor){
		humor -= unValor
	}
	method alegrarse(unValor){
		humor += unValor
	}
	method pagar(unValor){ // comprar o gastar ???
		saldo -= unValor
	}
	method pagarSuscripcion(){
		if (self.puedePagar(suscripcion)){
			self.pagar(suscripcion.costo())
		} else {
			self.actualizarSuscripcion(prueba)
		}
	}
	method puedePagar(unaSuscripcion) = 
		saldo > unaSuscripcion.costo()

	method jugar(unJuego, horas){
		if (suscripcion.permiteJugar(unJuego)){
			unJuego.serJugado(self, horas)
		}else {
			throw new NoPuedoJugarException()
		}
	}
	method tirarTodoAlCarajo(){
		self.actualizarSuscripcion(infantil) // no es un pasamano?? porque rompe en juego
	}
}

/** 
class Suscripcion ??? no tiene sentido si es solo para un atributo costo y su getter. Si para la suscripcion prueba e infantil que repiten la logicade permite jugar
object premium, base, infantil, prueba ???
interface puedeJugar(unJuego) ??? que pasa con costo ???

porque las suscrpciones cambian. Composicion: mayor complejidad
*/
object premium{
  // const costo = 50 no se usa en otro lado asi que no tiene sentido, conviene directo el metodo
  method permiteJugar(unJuego) = true // vs puedeJugar
  method costo() = 50
}

object base{
  method permiteJugar(unJuego) = unJuego.esBarato()
  method costo() = 25
}

class SuscripcionCategorica{
  const categoria
  const costo
  
  method permiteJugar(unJuego) = unJuego.esDeCategoria(categoria)
  method costo() = costo
}

const infantil = new SuscripcionCategorica(categoria = "Infantil", costo = 10)
const prueba = new SuscripcionCategorica(categoria = "Demo", costo = 0)

/**
object infantil{
  const costo = 10
  method permiteJugar(unJuego) = unJuego.esDeCategoria("infantil")
}

object prueba{
  const costo = 0
  method permiteJugar(unJuego) = unJuego.esDeCategoria("demo")
}*/



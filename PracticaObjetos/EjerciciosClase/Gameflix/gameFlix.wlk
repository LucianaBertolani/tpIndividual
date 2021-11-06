import errores.ElJuegoNoExisteException

object gameFlix{
	const juegos = [] // libreria
	const usuarios = []
	
	method filtroPorCategoria(unaCategoria) =
		// juegos.filter({unJuego => unJuego.categoria() == unaCategoria}) -> ROMPE ENCAPSULAMIENTO
		// lo ideal es que retorne el juego completo y no solo el nombre porque no se sabe que se va a querer hacer. Se veria bonito por consola pero no tiene utilidad.
		juegos.filter({unJuego => unJuego.esDeCategoria(unaCategoria)})
		
	method juegoDeNombre(nombreJuego) =
	    /**
		try {
			return juegos.find({unJuego => unJuego.seLlama(nombreJuego)}) 
		} catch error : ElementNotFoundException { ->
			return "El juego no se encuentra disponible" -> no coinciden los tipos para cuando funciona y cuando no. Devolver un string no sirve porque cambia de tipo respecto a lo que devuelve si funciona
			throw new ElJuegoNoExisteException 
		}
		 */
	    // juegos.find({unJuego => unJuego.seLlama(nombreJuego)}) -> Wollok ya tiene exception en el find, pero no es mesaje de error expresivo para el dominio  
	    // no usar try catch con una excepcion no se encuentra el juego porque con el find ya hay una excepcion para no se encuentra. 
	    // conviene un findOrElse para el error adecuadamente
	    juegos.findOrElse({unJuego => unJuego.seLlama(nombreJuego)},{throw new ElJuegoNoExisteException()})  
	
	method juegoRecomendado() = juegos.anyOne() // para las listas devuelve al azar, para set solo el primero
	
	method cobrarSuscripciones(){ // es una orden, tiene que tener efecto entonces forEach y no map
		usuarios.forEach({unUsuario => unUsuario.pagarSuscripcion()})
	}
}



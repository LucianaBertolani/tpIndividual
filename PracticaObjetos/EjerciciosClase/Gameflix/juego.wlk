/// import usuario.infantil

class Juego {
	const nombre
	const precio
	const categoria // infantil, demo
	// tipo: violento, moba, terror, estrategia
	// method categoria() = categoria
	method esDeCategoria(unaCategoria) = categoria == unaCategoria
	method esBarato() = precio < 30
	method seLlama(unNombre) = nombre == unNombre
	// method serJugado(unUsuario, horas) no tiene sentido en la superclase porque no hay logica comun, cada tipo de juego hace lo que quiere
	
}
// Tipos de juego: composicion (objeto para cada tipo) o herencia (clase para cada tipo)
// Si a la herencia porque el tipo de juego no va a cambiar, es estático. Es más simple que la composicion
// Si fuera composicion existirían más objetos en tiempo de ejecucion, existiendo más mensajes, mas chances de error y sin beneficio
// La herencia se puede utilizar una vez y la composición múltiples veces

class Violento inherits Juego{
	method serJugado(unUsuario,horas){
		unUsuario.malhumorarse(horas * 10)
	}
}

class Moba inherits Juego{
	method serJugado(unUsuario,horas){
		unUsuario.pagar(30) // en ningun momento se habla de skins
	}
}

class Terror inherits Juego{
	method serJugado(unUsuario,horas){
		unUsuario.tirarTodoAlCarajo()
		// unUsuario.actualizarSuscripcion(infantil)
	}
}

class Estrategia inherits Juego{
	method serJugado(unUsuario,horas){
		unUsuario.alegrarse(horas * 5)
	}
}
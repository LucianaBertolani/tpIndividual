class CastaSocial {
	const property castaSiguiente
	
 	method tienePermitidoSubirDeExpedicion(unVikingo) = true
}
const castaJarl = new CastaSocial(castaSiguiente = castaKarl)
const castaKarl = new CastaSocial(castaSiguiente = castaThrall)

object castaThrall{
	method castaSiguiente() = throw new Exception(message = "No hay castas superiores, no es posible escalar más")
	/* la casta debe ser quien ascienda el vikingo y no al reves 
	 * envia los mensajes al vikingo para que modifique su casta (setter)
	 * y bonificarAscenso en caso de corresponder
	 */
	method tienePermitidoSubirDeExpedicion(unVikingo) = !unVikingo.tieneArmas() 
}

/**
class Casta {
	method puedeIr(vikingo,expedicion) = true
}

object jarl inherits Casta {
	
	override method puedeIr(vikingo, expedicion) = not vikingo.tieneArmas()

	method ascender(vikingo){
		vikingo.casta(karl)
		vikingo.bonificarAscenso()
	}
}
object karl inherits Casta{
	method ascender(vikingo){
		vikingo.casta(thrall)
	}
}

object thrall inherits Casta{
	method ascender(vikingo){
		// no hace naranja
	}
}
 */
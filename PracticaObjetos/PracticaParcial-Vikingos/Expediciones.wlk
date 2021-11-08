class Expedicion{
	
	const aldeasInvolucradas = #{}
	const capitalesInvolucradas = #{}
	// nombre para unificar en objetivos
	const vikingos = #{}

 	method valeLaPena() = (aldeasInvolucradas + capitalesInvolucradas).all{aldeaOCapital => aldeaOCapital.botinValioso()}
 	// method todasLasCapitalesValenLaPena() = capital --> vuela al unificar en objetivos
	// botinValioso vs self.cantidadIntegrantes()
 	
	method invadir(aldeasocapital)
	method subirVikingoExpedicion(unVikingo){
		if (!unVikingo.puedeSubirExpedicion()) // vs version puedeSubirExpedicion(self)
			throw new Exception(message = "El vikingo no puede subir a la expedicion" )
		vikingos.add(unVikingo)
	}
	
	/**
		objetivos.forEach{obj => obj.serInvadidoPor(self)}
	}

	method repartirBotin(botin){
		integrantes.forEach{int => 
			int.ganar(botin / self.cantidadIntegrantes())
		}
	}
	method aumentarVidasCobradasEn(cantidad) { 
		integrantes.take(cantidad).forEach{int => 
			int.cobrarVida()
		}
	}
	
	method cantidadIntegrantes() = integrantes.size()
	method agregarLugar(objetivo){objetivos.add(objetivo)}
	 */
}

class Capital{}

class Aldea{}

class AldeaAmurallada inherits Aldea{}

/**
class Lugar {
	
	method serInvadidoPor(expedicion) {
		expedicion.repartirBotin(self.botin(expedicion.cantidadIntegrantes()))
		self.destruirse(expedicion.cantidadIntegrantes())

	}
	method destruirse(cantInvasores)
	method botin(cantInvasores)
}

class Aldea inherits Lugar{
	var property crucifijos

	method valeLaPenaPara(cantInvasores) = self.botin(cantInvasores) >= 15

	override method botin(cantInvasores) = crucifijos

	override method destruirse(cantInvasores){
		crucifijos = 0
	}
}

class AldeaAmurallada inherits Aldea {
	var minimosVikingos

	override method valeLaPenaPara(cantInvasores) 
		= cantInvasores >= minimosVikingos and super(cantInvasores)
}

class Capital inherits Lugar{
	var property defensores 
	var riqueza

	method valeLaPenaPara(cantInvasores) =
		cantInvasores <= self.botin(cantInvasores) / 3

	override method botin(cantInvasores) =
		 self.defensoresDerrotados(cantInvasores) * riqueza
	
	override method destruirse(cantInvasores){
		defensores -= self.defensoresDerrotados(cantInvasores)
	}
	override method serInvadidoPor(expedicion){
		expedicion.aumentarVidasCobradasEn(self.defensoresDerrotados(expedicion.cantidadIntegrantes()))
		super(expedicion)
	}
	method defensoresDerrotados(cantInvasores) = defensores.min(cantInvasores)

}
 */
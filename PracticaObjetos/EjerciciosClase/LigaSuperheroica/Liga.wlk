import Superheroes.*

object agrupacionSuperHeroica {
	var integrantes = #{}
	
	method agregarSuperHeroe(unSuperHeroe) {
		integrantes.add(unSuperHeroe)
	}
	method echarSuperHeroe(unSuperHeroe) {
		integrantes.remove(unSuperHeroe)
	}
	method cantidadDeIntegrantes() {
		return integrantes.size()
	}
	method esAmateur() { 	//es amateur cuando la cantidad de integrantes sin poder es mayor a la mitad de sus integrantes
		return self.integrantesSinMuchoPoder().size() > self.cantidadDeIntegrantes() / 2
	}
	method integrantesSinMuchoPoder() {
		return integrantes.filter({ integrante => !integrante.tieneMuchoPoder() })
	}
	method identidadesSecretas() {
		return integrantes.map({ integrante => integrante.identidadSecreta() })
	}
	method latinoamericanizar() {
		integrantes.forEach({ integrante => integrante.latinoamericanizar() })
	}
	method entrenar(minutos) {
		integrantes.forEach({ integrante => integrante.entrenar(minutos) })
	}
}
import PdePCargas.pdepcargas

object rutatlantica { // peaje
	
	method dejarPasar(camion) {
		camion.recorrerRuta(400, self.velocidadQuePasa(camion))
		pdepcargas.pagar(self.costo(camion)) 
	} // unicas responsabilidades: decirle al camion que recorra la ruta y decirle a la empresa que pague
	method velocidadQuePasa(camion) {
		return camion.velocidadMaxima().min(75)
	}
	method costo(camion) { // calcula el costo segun el peso del camion
		return 7000 + camion.pesoCarga().div(1000) * 100
	}
}
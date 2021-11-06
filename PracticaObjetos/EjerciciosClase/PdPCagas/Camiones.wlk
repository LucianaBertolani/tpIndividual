object camionDeVerduras {
	var cajones = 10
	var kilometraje = 700000
	
	method velocidadMaxima() = 80 - self.pesoCarga() / 500
	
	method pesoCarga() {
		return cajones * 50
	}
	
	method recorrerRuta(distancia, velocidad) {  
		kilometraje += distancia // es lo mismo que kilometraje = kilometraje + distancia
	} // la velocidad tiene que estar aunque no se use para respetar la firma del método y poder utilizar polimorfismo
}

object scanion5000 {
	const cargaMaxima = 5000
	var densidadLiquido = 2
	
	method velocidadMaxima() = 140
	
	method pesoCarga() {
		return cargaMaxima * densidadLiquido
	}
	
	method recorrerRuta(distancia, velocidad) {
		// no hace nada, necesario para polimorfismo
	}
}

object camionCerealero {
	var nivelDeDeterioro = 0
	var pesoCarga
	
	method pesoCarga(unPeso) { // esto es un setter
		pesoCarga = unPeso
	}
	
	method velocidadMaxima() = 60 - nivelDeDeterioro
	
	method pesoCarga() { // esto es un getter
		return pesoCarga
	}
	
	method recorrerRuta(distancia, velocidad) {
		nivelDeDeterioro += 0.max(velocidad - 45)
	}
}
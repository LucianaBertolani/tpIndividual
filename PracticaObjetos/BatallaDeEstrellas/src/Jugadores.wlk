object pamela{																			// doctora
	var botiquin = ["algodon", "agua oxigenada", "cinta de papel", "cinta de papel" ] // una lista simplifica el modelado de los repetidos y es necesario el orden para dps toro
	var energia = 6000
	const gritoDeVictoria = "Aca paso la Pamela" // da la sensacion de atributo de los personajes, por eso const y no directo el metodo

	method equipamiento() = botiquin	// lo que retorna varia segun el personaje, pero el metodo se llama igual para polimorfismo
	
	method cantidadElementosEquipamiento() = botiquin.size() // para delegar responsabilidads en el enemigo y no en toro
	
	method ultimoElemento() = botiquin.last()		// para que toro sepa cual robo sin romper encapsulamiento y reutilizar en perderUltimoElemento
	
	method perderUltimoElemento() {
		botiquin.remove(self.ultimoElemento()) }	// analogo a cantidadElementos
	
	method energia() = energia
	
	method perderEnergia(unaEnergia){ // como siempre resta, es mas declarativo perder energia y no un modificar energia pasando negativo. Tambien necesario para mantener encapsulamiento en toro y tulipan
		energia -= unaEnergia }
		
	method estaVivo() = energia > 0 // necesario para filtrar en el combate los sobrevivientes sin romper encapsulamiento y delegar
	
	method lucharManoAMano(enemigo){
		energia += 400 }
		
	method gritoDeVictoria() = gritoDeVictoria 
}

object pocardo{											   // musicoterapeuta
	var botiquin = ["guitarra", "curitas", "cotonetes" ] 
	var energia = 5600
	const gritoDeVictoria = "¡Siente el poder de la musica!"

	method equipamiento() = botiquin
	
	method cantidadElementosEquipamiento() = botiquin.size()
	
	method ultimoElemento() = botiquin.last()
	
	method perderUltimoElemento() {
		botiquin.remove(self.ultimoElemento()) }
	
	method energia() = energia
	
	method perderEnergia(unaEnergia){
		energia -= unaEnergia }
	method estaVivo() = energia > 0
		
	method lucharManoAMano(enemigo){
		energia += 500 }
	method gritoDeVictoria() = gritoDeVictoria
}

object tulipan{														// la guerrera
	var galpon = ["rastrillo", "maceta", "maceta", "manguera" ] 
	var energia = 8400
	const gritoDeVictoria = "Hora de cuidar a las plantas"

	method equipamiento() = galpon
	
	method cantidadElementosEquipamiento() = galpon.size()
	
	method ultimoElemento() = galpon.last()
	
	method perderUltimoElemento() {
		galpon.remove(self.ultimoElemento()) }
			
	method energia() = energia
	method perderEnergia(unaEnergia){
		energia -= unaEnergia }
	method estaVivo() = energia > 0
		
	method lucharManoAMano(enemigo){
		enemigo.perderEnergia(enemigo.energia() * 0.5) // vs enemigo.modificarEnergia(- enemigo.energia() * 0.5) con encapsulamiento roto y poca declaratividad  
		}
	method gritoDeVictoria() = gritoDeVictoria
}



object toro{			// tanque
	var botin = #{}	// en este personaje conviene set porque simplifica la logica de no agregar repetidos al luchar
	var energia = 7800
	const gritoDeVictoria = "No se metan con el toro"

	method equipamiento() = botin
	
	method energia() = energia
	
	method perderEnergia(unaEnergia){
		energia -= unaEnergia }
	
	method estaVivo() = energia > 0
		
	method lucharManoAMano(contrincante){
		self.quitarEnergiaPorObjetoA(contrincante) // delega, mas declarativo y mantiene encapsulamiento
		self.robarElUltimoObjetoDe(contrincante) //  delega, mas declarativo y mantiene encapsulamiento
	}
	
	method quitarEnergiaPorObjetoA(contrincante){
		contrincante.perderEnergia(200 * contrincante.cantidadElementosEquipamiento())
		// enemigo.energia() - 200 * enemigo.elementos().size() -> rompe encapsulamiento, poco declarativo
	} 
	method robarElUltimoObjetoDe(contrincante){
		//const ultimoElemento = contrincante.ultimoElemento()
		botin.add(contrincante.ultimoElemento()) // se podria pasar por parametro la variable local, no tiene sentido crearla porque solo se usaría una vez
		contrincante.perderUltimoElemento()
		// if (!(self.elementos().contains(enemigo.elementos().last()))) 
			// {elementos.add(enemigo.elementos().last())} 			-> poco declarativo, rompe encapsulamiento
	}
	method gritoDeVictoria() = gritoDeVictoria
} 
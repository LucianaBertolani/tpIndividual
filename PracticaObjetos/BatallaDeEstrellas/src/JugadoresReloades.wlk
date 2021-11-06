class Jugador{
	const property gritoDeVictoria // da la sensacion de atributo de los personajes, por eso const y no directo el metodo
	var energia // no utilizo propiedad porque solo necesito el getter y var property tmb viene con el setter
	
	method energia() = energia
	
	method perderEnergia(unaEnergia){ // como siempre resta, es mas declarativo perder energia y no un modificar energia pasando negativo. Tambien necesario para mantener encapsulamiento en toro y tulipan
		energia -= unaEnergia }
	
	method estaVivo() = energia > 0 // necesario para filtrar en el combate los sobrevivientes sin romper encapsulamiento y delegar
	
	method lucharManoAMano(unEnemigo) // abstracto porque cada uno lo define distinto y evita olvidar de definirlo para los personajes 
} 

object pamela inherits Jugador(gritoDeVictoria = "Aca paso la Pamela", energia = 6000){																			// doctora
	var botiquin = ["algodon", "agua oxigenada", "cinta de papel", "cinta de papel" ] // una lista simplifica el modelado de los repetidos y es necesario el orden para dps toro

	method equipamiento() = botiquin	// lo que retorna varia segun el personaje, pero el metodo se llama igual para polimorfismo
	
	method cantidadElementosEquipamiento() = botiquin.size() // para delegar responsabilidads en el enemigo y no en toro
	
	method ultimoElemento() = botiquin.last()		// para que toro sepa cual robo sin romper encapsulamiento y reutilizar en perderUltimoElemento
	
	method perderUltimoElemento() {
		botiquin.remove(self.ultimoElemento()) }	// analogo a cantidadElementos
		
	override method lucharManoAMano(enemigo){
		energia += 400 }
		 
}
// MUSICOTERAPEUTA
object pocardo inherits Jugador(gritoDeVictoria = "¡Siente el poder de la musica!", energia = 5600){											   
	var botiquin = ["guitarra", "curitas", "cotonetes" ] 
	
	method equipamiento() = botiquin
	
	method cantidadElementosEquipamiento() = botiquin.size()
	
	method ultimoElemento() = botiquin.last()
	
	method perderUltimoElemento() {
		botiquin.remove(self.ultimoElemento()) }
	
	override method lucharManoAMano(enemigo){
		energia += 500 }
}
// LA GUERRERA
object tulipan inherits Jugador(gritoDeVictoria = "Hora de cuidar las plantas", energia = 8400){
	var galpon = ["rastrillo", "maceta", "maceta", "manguera" ] 
	
	method equipamiento() = galpon
	
	method cantidadElementosEquipamiento() = galpon.size()
	
	method ultimoElemento() = galpon.last()
	
	method perderUltimoElemento() {
		galpon.remove(self.ultimoElemento()) }
		
	override method lucharManoAMano(enemigo){
		enemigo.perderEnergia(enemigo.energia() * 0.5) 
		// vs enemigo.modificarEnergia(- enemigo.energia() * 0.5) con encapsulamiento roto y poca declaratividad  
		}
}
// TANQUE
object toro inherits Jugador(gritoDeVictoria = "No se metan con el toro", energia = 7800 ){			
	var botin = #{}	// en este personaje conviene set porque simplifica la logica de no agregar repetidos al luchar
	
	method equipamiento() = botin
		
	override method lucharManoAMano(contrincante){
		self.quitarEnergiaPorObjetoA(contrincante) // delega, mas declarativo y mantiene encapsulamiento
		self.robarElUltimoObjetoDe(contrincante) //  delega, mas declarativo y mantiene encapsulamiento
	}
	method quitarEnergiaPorObjetoA(contrincante){
		contrincante.perderEnergia(200 * contrincante.cantidadElementosEquipamiento())
		// enemigo.energia() - 200 * enemigo.elementos().size() -> rompe encapsulamiento, poco declarativo
	} 
	method robarElUltimoObjetoDe(contrincante){
		// const ultimoElemento = contrincante.ultimoElemento()
		botin.add(contrincante.ultimoElemento()) // se podria pasar por parametro la variable local, no tiene sentido crearla porque solo se usaría una vez
		contrincante.perderUltimoElemento()
		// if (!(self.elementos().contains(enemigo.elementos().last()))) 
			// {elementos.add(enemigo.elementos().last())} 			-> poco declarativo, rompe encapsulamiento
	}
} 
import Jugadores.*

object combate {
	const property equipoA = [pocardo, tulipan]
	const property equipoB = [toro, pamela]
	
	method combatir(){
		self.atacar(equipoA,equipoB)
		self.atacar(equipoB,equipoA)
	}
	method atacar(unEquipo, otroEquipo) {
		unEquipo.forEach({personaje => self.personajeLuchaContraEquipo(personaje, otroEquipo)})	
	}
	
	method personajeLuchaContraEquipo(personaje, equipo) {
		equipo.forEach({ otroPersonaje => personaje.luchar(otroPersonaje)})
	}
	
	method ganadores() {
		if (self.energiaDe(equipoA) > self.energiaDe(equipoB)) {
			return equipoA
		} else {
			return equipoB
		}
	}
	
	method energiaDe(equipo) = equipo.sum({ personaje => personaje.energia() })
	
	method sobrevivientes(equipo) = equipo.filter({personaje => personaje.estaVivo()}) 
	
	method gritoGanador() = self.sobrevivientes(self.ganadores()).map({personaje => personaje.gritoDeVictoria()})
}


/*	
	method atacar(equipoAtacante,equipoDefensor) { // forEach porque tiene que producir efecto como lo hace lucharManoAMano, no retorna nada
		equipoAtacante.forEach({jugador => self.jugadorAtacarEquipo(jugador,equipoDefensor)})
	} // "itera" jugadorAtacarEquipo para cada jugador del equipo atacante
	method jugadorAtacarEquipo(atacante,equipo){
		equipo.forEach({jugador => atacante.lucharManoAMano(jugador)})
	} // un jugador del equipo atacante pelea con cada uno del equipo defensor
	method gritoGanador(){
		return self.sobrevivientes(self.ganadores()).map({personaje => personaje.gritoDeVictoria()})
	} 
	method sobrevivientes(equipo){
		return equipo.filter({jugador => jugador.estaVivo()}) // opc2: return equipo.filter({jugador => jugador.energia() > 0})
	} // delego en el jugador la responsabilidad de saber si estaVivo para 
	// evitar romper encapsulamiento y mayor declaratividad que opc2 
	method ganadores(){
		if (self.energiaDe(equipoA) > self.energiaDe(equipoB)) { return equipoA }
		else { return equipoB }
	} // corresponde usar if porque se hace una comparacion en la condicion y debe retornar dos cosas distintas
	method energiaDe (unEquipo){
		return unEquipo.sum({jugador => jugador.energia()})
	}
} */

/** PARA PENSAR DESPUES
object equipoA {
	const jugadores = [pocardo, tulipan]
	
	method puntajeTotalEquipo() = jugadores.sum({jugador => jugador.energia()})
}

object equipoB{
	const jugadores = [toro, pamela]
	
	method puntajeTotalEquipo() = jugadores.sum({jugador => jugador.energia()})
} 

object combate {
	
	method combatir() = equipoGanador.map({jugador => jugador.gritoDeVictoria()})
	method puntajeTotalEquipo() = equipo.sum({jugador => jugador.energia()})
	method equipoGanador() = unEquipo.puntajeTotalEquipo()
}*/
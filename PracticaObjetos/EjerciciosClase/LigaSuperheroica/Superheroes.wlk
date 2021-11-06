object batman {
	var identidadSecreta = "Bruce Wayne"
	var energia = 100
	
	method identidadSecreta() = identidadSecreta
	
	method energia() = energia
	
	method tieneMuchoPoder() = true
	
	method entrenar(minutos) {
		energia -= (minutos/2).min(energia) //otra forma: energia = 0.max(energia - minutos/2) 
	}
	method latinoamericanizar() {
		identidadSecreta = "Bruno Diaz"
	}
}
object elZorro {
	var identidadSecreta = "Don Diego de la Vega"
	var energia = 200
	var habilidades = #{"esgrima", "latigo", "equitacion", "lenguaje con señas"}
	
	method identidadSecreta() = identidadSecreta
	
	method energia() = energia
	
	method habilidades() = habilidades
	
	method tieneMuchoPoder() {
		return habilidades.size() > 4
	}
	method entrenar(minutos) {
		energia *= 5
	}
	method latinoamericanizar() {}
	
	method aprenderHabilidad(unaHabilidad) {
		habilidades.add(unaHabilidad)
	}
	method desaprenderHabilidad(unaHabilidad) {
		habilidades.remove(unaHabilidad)
	}
}

object mujerMaravilla {
	var identidadSecreta = "Diana Prince"
	var energia = 500
	var armasDeCombate = #{"avion invisible", "brazaletes", "lazo de la verdad"}
	
	method identidadSecreta() = identidadSecreta
	
	method energia() = energia
	
	method armasDeCombate() = armasDeCombate
	
	method tieneMuchoPoder() {
		return armasDeCombate.size() > 2
	}
	method entrenar(minutos) {}
	
	method latinoamericanizar() {
		armasDeCombate.remove("avion invisible")
		armasDeCombate.add("ford taunus invisible")
	}
}
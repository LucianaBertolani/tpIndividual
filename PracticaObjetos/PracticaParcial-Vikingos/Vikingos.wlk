class Vikingo{
	var casta
	var cantidadArmas

	method esProductivo()
	method tieneArmas() = cantidadArmas > 0
	method cobrarVida(){}
	method ascenderCasta(){
		casta = casta.castaSiguiente()
		self.premiarAscenso() // en todos los ascensos se estaria premiando, no solo el de esclavo
	}
	method puedeSubirExpedicion() = self.esProductivo() and casta.tienePermitidoSubirDeExpedicion(self)
	method premiarAscenso()
}

class Soldado inherits Vikingo{
	var vidasCobradas

	override method esProductivo() = self.cobroMuchasVidas() and self.tieneArmas()
	method cobroMuchasVidas() = vidasCobradas > 20
	override method premiarAscenso(){
		 cantidadArmas + 10 } 
}

class Granjero inherits Vikingo{
	var cantHijos
	var cantHectarias
	
	override method esProductivo() = cantHectarias.div(cantHijos) >= 2 
	override method premiarAscenso(){
		cantHijos + 2 
		cantHectarias + 2
		}
}

/**
Un vikingo en general puede ir a una expedición siempre y cuando sea productivo. 
Para ello un soldado debe haberse cobrado más de 20 vidas y tener armas. 
Los granjeros también pueden ser productivos pero dependerá de la cantidad de hijos que tienen y 
las hectáreas designadas para poderlos alimentar (mínimo 2 hectáreas por hijo). 

En cualquier caso, hay que tener siempre en cuenta la casta: a un vikingo de cualquier casta social 
se le permite subir a una expedición pero en el caso de los Jarl (esclavos), no pueden ir si tienen armas.
 */
class Operacion{
	// concretada o en reserva ?
	// alquiler o venta?
	// inmueble.operacion()
}

object alquiler{
	var cantMesesAlquiler
	
	method costoComision(inmueble) = cantMesesAlquiler * inmueble.valorTotalInmueble() / 50000
	method contratar(cantMesesAAlquilar) {
		cantMesesAlquiler = cantMesesAAlquilar
	}
}

object venta{
	var porcentajeComision // asumimos porcentaje en decimales 
	
	method costoComision(inmueble) = porcentajeComision * inmueble.valorTotalInmueble()
	method asignarComision(unPorcentaje){
		porcentajeComision = unPorcentaje
	} // porcentajeComision debería ser asignado por la Inmobiliaria
}

class Reserva{
	// clienteQueReserva
	// empleadoQueReserva
	// empleadoQueConcreta
	
	
}

/** COPY PASTE DEL RESUELTO (a diferencia de lo pensado, la operacion no sabe quien cerro y quien concreto)
class Operacion{

	const inmueble
	var estado = disponible

	method comision() 
	method zona() = inmueble.zona()
	method reservarPara(cliente){
		estado.reservarPara(self, cliente)
	}
	method concretarPara(cliente){
		estado.concretarPara(self, cliente)
	}
	
	method estado(nuevoEstado){
		estado = nuevoEstado
	} 
}
class Venta inherits Operacion {

	constructor(unInmueble) = super(unInmueble) {
		unInmueble.validarQuePuedeSerVendido()
	}
	override method comision() = inmueble.valor() * (1 + self.porcentaje() / 100)
	method porcentaje() = inmobiliaria.porcentajeDeComisionPorVenta()
}

class Alquiler inherits Operacion {
	const meses

	constructor(unInmueble, mesesDeContrato) = super(unInmueble) {
		meses = mesesDeContrato
	}

	override method comision() = meses * inmueble.valor() / 50000
}

class EstadoDeOperacion {
	method reservarPara(operacion, cliente)
	
	method concretarPara(operacion, cliente){
		self.validarCierrePara(cliente)
		operacion.estado(cerrada)
	}
	
	method validarCierrePara(cliente){}
}

object disponible inherits EstadoDeOperacion{
	override method reservarPara(operacion, cliente){
		operacion.estado(new Reservada(cliente))
	}
}

class Reservada inherits EstadoDeOperacion{
	const clienteQueReservo
	constructor(cliente){
		clienteQueReservo = cliente
	}
	
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar("Ya había una reserva previa")
	}
	override method validarCierrePara(cliente){
		if(cliente != clienteQueReservo)
			throw new NoSePudoConcretar("La operación está reservada para otro cliente")
	}
}

object cerrada inherits EstadoDeOperacion{
	override method reservarPara(operacion, cliente){
		throw new NoSePudoReservar("Ya se cerró la operación")
	}
	override method validarCierrePara(cliente){
		throw new NoSePudoConcretar("No se puede cerrar la operación más de una vez")
	}
}

class NoSePudoReservar inherits Exception { }
class NoSePudoConcretar inherits Exception { }
 */
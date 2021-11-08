class Empleado{
	const operacionesReservadas = #{}
	const operacionesConcretadas = #{}
	
	method realizarOperacion(unaOperacion)
	
	// metodos para  criterios de  mejorEmpleado
	method totalComisiones() = operacionesConcretadas.sum({unaOperacion => unaOperacion.costoComision()})
	method cantOperacionesConcretadas() = operacionesConcretadas.size()
	method cantReservas() = operacionesReservadas.size()

	method concretarOperacion(unaOperacion){
		// operacionesReservadas.remove(unaOperacion)
		operacionesConcretadas.add(unaOperacion)
	}

	method leChoreoLaReserva(otroEmpleado) = 
		operacionesReservadas.any({unaOperacion => unaOperacion.fueConcretadaPor(otroEmpleado)})
		
	/** OTRA VERSION 	
	method concretoOperacionReservadaPor(otroEmpleado) =
		operacionesCerradas.any({operacion => otroEmpleado.reservo(operacion)})
		
	method reservo(operacion) = reservas.contains(operacion)
	
	method reservar(operacion, cliente){
		operacion.reservarPara(cliente)
		reservas.add(operacion)
	}
	method concretarOperacion(operacion, cliente){
		operacion.concretarPara(cliente)
		operacionesCerradas.add(operacion)
	}

  	*/	
		
	method cerraronOperacionesEnLaMismaZona(otroEmpleado) =
		!(self.zonasDondeConcreta()).intersection(otroEmpleado.zonasDondeConcreta()).isEmpty()
	
	method zonasDondeConcreta() = operacionesConcretadas.map({unaOperacion => unaOperacion.zona()}).asSet()
	
	/**	method cerraronOperacionesEnLaMismaZona2(otroEmpleado) =
			self.zonasDondeConcreta().any({zona => otroEmpleado.operoEnZona(zona)})
			
		method operoEnZona(zona)= self.zonasEnLasQueOpero().contains(zona)
	*/
		
	// deberia estar tieneProblemasCon(otroEmpleado) ???
}


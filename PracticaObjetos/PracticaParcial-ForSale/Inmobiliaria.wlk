object inmobiliaria{
	const operaciones = #{}
	const empleados = #{}
	
	// method elMejorEmpleado(criterio) = empleados.max({unEmpleado => unEmpleado.criterio()}) -> no es posible pasar mensaje como si fuera ordenSuperior
	method elMejorEmpleado(porCriterio) = empleados.max({unEmpleado => porCriterio.ponderacion(unEmpleado)})
	 
	// method elMejorEmpleadoSegunComisiones() = empleados.max({unEmpleado => unEmpleado.totalComisiones()})
	// method elMejorEmpleadoSegunReservas() = empleados.max({unEmpleado => unEmpleado.cantReservas()})
	// method elMejorEmpleadoSegunConcretas() = empleados.max({unEmpleado => unEmpleado.cantOperacionesConcretadas()})
	
	method tienenProblemas(unEmpleado, otroEmpleado) = 
		unEmpleado.cerraronOperacionesEnLaMismaZona(otroEmpleado) and 
		( unEmpleado.leChoreoLaReserva(otroEmpleado) or	otroEmpleado.leChoreoLaReserva(unEmpleado) )
}

// CRITERIOS 
object porTotalComisiones {
	method ponderacion(empleado) = empleado.totalComisiones()
}

object porCantidadDeOperacionesCerradas {
	method ponderacion(empleado) = empleado.cantOperacionesConcretadas()
}

object porCantidadDeReservas {
	method ponderacion(empleado) = empleado.cantReservas()
}

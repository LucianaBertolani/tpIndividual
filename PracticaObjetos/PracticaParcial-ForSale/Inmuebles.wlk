//import Operaciones.*
import Operaciones.alquiler

class Inmueble{
	const property metrosCuadrados
	const property cantAmbientes
	var operacion // = venta or alquiler
	const zona
	
	method valorTotalInmueble() = self.plusZona() + self.valorTipoInmueble()
	method plusZona() = zona.valorZona()
	method valorTipoInmueble()
}

class Casa inherits Inmueble{
	const valorCasa
	
	override method valorTipoInmueble() = valorCasa
}

class PH inherits Inmueble{
	override method valorTipoInmueble() = (14000 * metrosCuadrados).max(500000)
}

class Dpto inherits Inmueble{
	override method valorTipoInmueble() = cantAmbientes * 350000
}
class Local inherits Casa(operacion = alquiler){
  var tipoLocal

  method remodelar(unLocal){
  	tipoLocal = unLocal
  }	
}

class LocalGalpon inherits Local{
	override method valorTipoInmueble() = super() / 2
}

class LocalALaCalle inherits Local{
	const costoFijo
	
	override method valorTipoInmueble() = costoFijo
}

// VERSION con OBJETOS
/* class Local inherits Casa {
	var tipoDeLocal
	
	override method valor() = tipoDeLocal.valorFinal(super())
	override method validarQuePuedeSerVendido(){   					--> se agrega metodo abstracto a class Inmueble
		throw new VentaInvalida("No se puede vender un local")
	}
}

object galpon {
	method valorFinal(valorBase) = valorBase / 2
}

object aLaCalle {
	var montoFijo
	method montoFijo(nuevoMonto){
		montoFijo = nuevoMonto
	}
	
	method valorFinal(valorBase) = valorBase + montoFijo
}
class VentaInvalida inherits Exception{}
 * 
 */



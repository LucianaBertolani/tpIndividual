object neo{
  var carga = 7
  
  method llamar(){
    //if (self.tieneCargaParaLlamar()){ innecesario
    self.tieneCargaParaLlamar()
    carga -= 5 }
  method tieneCargaParaLlamar(){
    return carga >= 5 } 
  method peso(){
  	return 0 }
}
object roberto{
  const peso = 90
  var transporte
  
  method tieneCargaParaLlamar() = false
  method peso(){
    return peso + transporte.pesoVehiculo()
    }
  method viajaEn(unTransporte){
    transporte = unTransporte }
}

object bici{
  method pesoVehiculo() = 1
}
object camion{
  var cantidadAcoplados = 1
  method pesoVehiculo() = 500 * cantidadAcoplados
  method agregarNAcoplados(cantidad){
    cantidadAcoplados += cantidad }
}

object chuck{
  method peso() = 900
  method tieneCargaParaLlamar() = true
}

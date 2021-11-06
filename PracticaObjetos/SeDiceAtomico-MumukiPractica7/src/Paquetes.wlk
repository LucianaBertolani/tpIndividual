import Destinos.*

object paquete{
  var destino = laMatrix
  var estaPago = false
  method puedeSerEntregadoPor(mensajero){
    return destino.dejaEntrar(mensajero) && self.estaPago()}
  method estaPago(){
    return estaPago }
  method pagar(){
    estaPago = true }
  method destino(unDestino){
    destino = unDestino } //setter
}
object paquetito{
  method puedeSerEntregadoPor(mensajero) = true
  method estaPago() = true
  // method pagar
  // method destino
  method precio() = 0
}
object paqueton{
  var destinos = [laMatrix, puenteDeBrooklyn]
  var precio = 0 // 50 + 100 * destinos.size()
  
  method puedeSerEntregadoPor(persona){
    return destinos.all({destino => destino.dejaEntrar(persona)}) and self.estaPago()}
  method estaPago() = precio <= 0 
  method pagar(importe){ 
    precio -= importe }
  method destinos(listaDestinos) { // setter
  	destinos = listaDestinos }
  method destinos() = destinos //  getter
  method precio() = precio
}

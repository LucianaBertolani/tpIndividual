import Paquetes.*
import Mensajeros.*

object mensajeria{
  var empleados = [] // = [roberto, neo]

  method empleados() = empleados

  method contratar(empleado) {
    empleados.add(empleado)}

  method despedir(empleado) {
    empleados.remove(empleado)}

  method despedirATodos() {
    empleados.clear()} //empleados = [] 

  method esGrande(){
    return empleados.size() > 2 }

  method loEntregaElPrimero(){
    return paquete.puedeSerEntregadoPor(empleados.first()) }

  method pesoDelUltimo(){ 
    return empleados.last().peso() }

  method algunoPuedeEntregar(unPaquete){
    return empleados.any({empleado=> unPaquete.puedeSerEntregadoPor(empleado)})}

  method candidatosPara(unPaquete){
    return empleados.filter({empleado => unPaquete.puedeSerEntregadoPor(empleado)})}

  method tieneSobrepeso(){
    return self.promedioPeso() > 500}

  method promedioPeso(){
    return empleados.sum({empleado => empleado.peso()}) / empleados.size()}

// Hacer que la mensajería envíe un paquete. Para ello elige cualquier mensajero entre los que pueden enviarlo y si no puede lo agrega a los paquetes pendientes.
  method enviar(unPaquete){}
   // if (candidatosPara(unPaquete) != []) {}
   // else { paquetesPendientes.add(unPaquete)}
}

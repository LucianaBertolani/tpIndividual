import Mensajeros.*

/**
1) LLAMANDO A LA MATRIX.
 Sabemos que:
- laMatrix deja entrar a quien pueda hacer una llamada.
- neo anda con celular, el muy canchero. El tema es que a veces no tiene crédito para hacer llamadas. 
(Le puso 7$ pesos de carga y cada llamada cuesta 5$).
Implementá los objetos necesarios para que sea posible:
- laMatrix.dejaEntrar(neo)  -> Devuelve true porque sólo tiene $7
- neo.llamar()              -> Su crédito disminuye 5$
- laMatrix.dejaEntrar(neo)  -> Devuelve false porque con 2$ de credito no le alcanza para llamar
 */
/**
2) PAQUETES Y DESTINOS
¡Necesitamos el paquete para entregar! Pero no estamos seguros de si hay que llevarlo a laMatrix o al puenteDeBrooklyn, 
un nuevo destino que deja entrar a todo lo que pese hasta una tonelada (1000 kilos).
- El paquete puede ser entregado por un mensajero si puede entrar al destino indicado y además el paquete está pago.
Queremos saber si el paquete puede ser entregado por neo. 
- Por cierto, neo vuela, así que no pesa nada 
Definí al paquete (inicialmente con destino la matrix y sin pagar) y agregá lo necesario para que se pueda realizar:
- paquete.pagar() 					-> hace que el paquete quede pago 
- paquete.estaPago() 				-> devuelve true, porque se pagó por el paquete 
- paquete.puedeSerEntregadoPor(neo) -> devuelve true, porque neo tiene credito y puede llamar y el paquete está pago
- paquete.destino(puenteDeBrooklyn) -> cambia el destino del paquete
- paquete.puedeSerEntregadoPor(neo) -> devuelve true, porque neo pesa menos de 1000 kilos y sigue estando pago el paquete
 */
/**
3) MAS MENSAJEROS
Contratamos a roberto, que puede viajar en bicicleta o camión. Sabemos que:
- Si viaja en bicicleta, el peso que cuenta es el suyo propio más 1, que es lo que pesa la bici.
- Si viaja en camión, el peso es el propio más el del camión, a razón de media tonelada (500Kg) por cada acoplado.
- No tiene un mango, gracias que tiene cubiertas, así que no puede llamar a nadie.
- El peso propio de Roberto es inicialmente de 90
Declará lo necesario para poder realizar:
- paquete.puedeSerEntregadoPor(roberto)
- roberto.peso()
Además, completá la definición del objeto prueba con métodos que permitan configurar a los objetos de diferentes maneras, para contemplar las posibles situaciones planteadas.
- prueba.robertoTieneBici() 				  -> Hace que roberto maneje una bici
- prueba.robertoTieneCamionCon1Acoplado() 	  -> Hace que Roberto maneje un camión con un acoplado
- prueba.unAcopladoMasParaElCamionDeRoberto() -> Hace que Roberto maneje un cambión con un acoplado más que antes. 
 */
/**
4) LA MENSAJERIA
Ahora aparece una empresa de mensajería. Esta tiene un conjunto de mensajeros, los cuales podrían ser Roberto, Neo y un nuevo mensajero 
- (Chuck Norris, que pesa 900 kg y puede llamar a cualquier persona del universo con sólo llevarse el pulgar al oído y el meñique a la boca)
Vamos a llamarla mensajeria e inicialmente no tiene mensajeros.
Se necesita poder hacer:
- mensajeria.empleados() 			-> retorna la colección con todos sus empleados
- mensajeria.contratar(chuck) 		-> agrega a chuck como empleado
- mensajeria.despedir(unEmpleado)   -> unEmpleado deja de ser empleado de la mensajeria
- mensajeria.despedirATodos()  		-> la empresa se queda sin empleados
- mensajeria.esGrande()  			-> analiza si la mensajeria tiene mas de dos mensajeros
- mensajeria.loEntregaElPrimero() 	-> Consulta si el paquete puede ser entregado por el primer empleado de la empresa de mensajería. (Asumir paquete pago con destino la matrix)
- mensajeria.pesoDelUltimo() 		-> Saber el peso del último mensajero de la empresa.
 */
/**
5) MENSAJERIA RECARGADA
Surgen otros paquetes que la empresa necesita enviar:
- Paquetito: es gratis, o sea, siempre está pago. Además, cualquier mensajero lo puede llevar.
- Paqueton viajero: tiene múltiples destinos. Su precio es 100$ por cada destino. Se puede ir pagando parcialmente y se debe pagar 
totalmente para poder ser enviado. Además, el mensajero debe poder pasar por todos los destinos. 
Se sabe que el paquete original tiene un precio determinado en $50.
Se necesita realizar:
- paqueton.destinos([puenteDeBrooklyn, laMatrix]) 		-> El paqueton tiene dos destinos
- paqueton.pagar(importe) 								-> Registra pago parcial 
- paqueton.estaPago() 									-> Informa si se pagó el total del precio
- mensajeria.algunoPuedeEntregar(unPaquete) 			-> Averiguar si un paquete puede ser entregado por la empresa de mensajería, es decir, si al menos uno de sus mensajeros puede entregar el paquete.
- mensajeria.candidatosPara(unPaquete)  				-> Obtener todos los mensajeros que pueden llevar un paquete dado.
- mensajeria.tieneSobrepeso() 							-> Saber si la mensajería tiene sobrepeso. Esto sucede si el promedio del peso de los mensajeros es superior a 500 Kg.
- mensajeria.enviar(unPaquete)  						-> Hacer que la mensajería envíe un paquete. Para ello elige cualquier mensajero entre los que pueden enviarlo y si no puede lo agrega a los paquetes pendientes.
- mensajeria.enviarTodos([paquete,paquetito,paqueton]) 	-> Dado un conjunto de paquetes, enviarlos a todos, de igual manera.
- mensajeria.enviarPendienteCaro() 						-> Encontrar el paquete pendiente más caro y enviarlo, actualizando los pendientes en caso de haberlo podido enviar. ¡Cuidado! Si el paquete no se pudo enviar, no debe volver a agregarse como pendiente.
- mensajeria.pendientes([paquete,paquetito,paqueton]) 	-> La mensajeria tiene 3 paquetes pendientes
 */ 

// DESTINOS
object laMatrix{ 
  method dejaEntrar(persona){
    return persona.tieneCargaParaLlamar()}
}
object puenteDeBrooklyn{ 
  method dejaEntrar(persona){
    return persona.peso() < 1000 }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
object prueba {
  method robertoTieneBici(){
    roberto.viajaEn(bici)
}
  method robertoTieneCamionCon1Acoplado(){
    roberto.viajaEn(camion)
  }
  method unAcopladoMasParaElCamionDeRoberto(){
    camion.agregarNAcoplados(1)
  }
}
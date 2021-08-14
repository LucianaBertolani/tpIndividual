% Las casas de Hogwarts         https://docs.google.com/document/d/e/2PACX-1vR9SBhz2J3lmqcMXOBs1BzSt7N1YWPoIuubAmQxPIOcnbn5Ow9REYt4NXQzOwXXiUaEQ4hfHNEt3_C7/pub
% https://github.com/pdep-mit/practica-logico-casas-de-hogwarts/tree/solucion-final/src
% https://app.mural.co/t/pdepmit6138/m/pdepmit6138/1593966837434/fdb6a3bfa324c7436e48f8ff17aca145ba62c3f4?sender=b2934283-b118-464f-b043-81ab0fdaa594

casa(gryffindor).
casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).

% lo establezco como una regla para no duplicar esfuerzos. De todo mago voy a conocer su sangre (condicion necesaria para ser mago), segun el enunciado.
mago(Mago):- 
  sangre(Mago,_).

sangre(harry,mestiza).
sangre(draco,pura).
sangre(hermione,impura).

caracteristica(harry,coraje).
caracteristica(harry,amistad).
caracteristica(harry,orgullo).
caracteristica(harry,inteligencia).
caracteristica(draco,inteligencia).
caracteristica(draco,orgullo).
caracteristica(hermione,inteligencia).
caracteristica(hermione,orgullo).
caracteristica(hermione,responsabilidad).

odiariaEntrar(harry,slytherin).
odiariaEntrar(draco,hufflepuff).

caracteristicaBuscada(gryffindor,coraje).
caracteristicaBuscada(slytherin,orgullo).
caracteristicaBuscada(slytherin,inteligencia).
caracteristicaBuscada(ravenclaw,inteligencia).
caracteristicaBuscada(ravenclaw,responsabilidad).
caracteristicaBuscada(hufflepuff,amistad).

% --------------------------------------------- PARTE 1 ---------------------------------------------

% 1) Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura.
% tanto casa como mago deben estar generados para restringir al dominio del enunciado y que sea inversible tto
% si mago fuera variable anonima, podrian entrar numeros u otras personas que no fueran magos, analogamente para casa
permiteEntrar(Casa,Mago):- 
  casa(Casa),
  mago(Mago), 
  Casa \= slytherin. 
permiteEntrar(slytherin,Mago):-
  sangre(Mago,TipoDeSangre),
  TipoDeSangre \= impura.

% 2) Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.
% tener en cuenta que quiero que me responda en el caso que una casa no tenga caracteristicas
% si genero la casa con caracteristicaBuscada(Casa,_), estoy agregando una condicion que la casa tenga al menos una caracteristicaBuscada (coincide de casualidad). falso si no tiene caracteristica, verdadero si tiene, analogo para mago
tieneCaracterApropiado(Mago,Casa):-
  casa(Casa), % al generar casa con caracteristicaBuscada(Casa,_) 
  mago(Mago),
  forall(caracteristicaBuscada(Casa,Caracter),caracteristica(Mago,Caracter)).
% tener en cuenta si el antecedente es falso, el consecuente es verdadero
% no ligar todo en el forall -> ERROR GRAVE

% VERSION CON LISTA DE CARACTERISTICAS DE LOS MAGOS
caracteristicas(harry,[coraje,amistad,orgullo,inteligencia]).
caracteristicas(draco,[inteligencia,orgullo]).
caracteristicas(hermione,[inteligencia,orgullo,responsabilidad]).

tieneCaracterApropiadoV2(Mago,Casa):-
  casa(Casa),
  caracteristicas(Mago,Caracteristicas),
  forall(caracteristicaBuscada(Casa,Caracteristica),member(Caracteristica,Caracteristicas)).
% Desventaja, pensar con listas complejiza la solucion, tira a imperativo, poco declarativo (como y no qué hace)
% se podria delegar el member dentro de un tieneCaracteristica(Mago,Caracteristica) para mayor declaratividadd

% VERSION CON PREDICADO DE CARACTERISTICAS.
orgulloso(harry).
orgulloso(draco).
orgulloso(hermione).
amistoso(harry).
corajudo(harry).
inteligente(harry).
inteligente(draco).
inteligente(hermione).
responsable(hermione).

tieneCaracterApropiadoV3(Mago,gryffindor):-
  corajudo(Mago).
tieneCaracterApropiadoV3(Mago,slytherin):-
  orgulloso(Mago),
  inteligente(Mago).
tieneCaracterApropiadoV3(Mago,ravenclaw):-
  inteligente(Mago),
  responsable(Mago).
tieneCaracterApropiadoV3(Mago,hufflepuff):-
  amistoso(Mago).
% POR QUÉ NO: Poco generalizado (no puedo saber que caracteristicas busca una casa, ni las caracteristicas del mago), en la realidad puede variar constantemente
% en caso de utilizar un predicado no declarado, prolog rompe. No tiene que ver con universo cerrado.
% si una casa no requiere ninguna caracteristica, seria raro de modelar, va en contra del paradigma un predicado que de siempre false

% 3) Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.
% tener en cuenta de no sobre generar, los predicados utilizados son todos inversibles
seleccionado(Mago,Casa):-
  tieneCaracterApropiado(Mago,Casa),
  permiteEntrar(Casa,Mago),
  not(odiariaEntrar(Mago,Casa)).
seleccionado(hermione,gryffindor).

% 4) Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual.
cadenaDeAmistades(Magos):-
  todosAmistosos(Magos),
  cadenaDeCasas(Magos).

todosAmistosos(Magos):-
  forall(member(Mago,Magos),esAmistoso(Mago)).

todosAmistososV2(Magos):-
  findall(Mago,esAmistoso(Mago),Magos).

esAmistoso(Mago):- % se delega para mayor declaratividad
  caracteristica(Mago,amistad).

cadenaDeCasas(Magos):-
  forall(consecutivos(Mago1,Mago2,Magos),seleccionadosMismaCasa(Mago1,Mago2)).

consecutivos(Anterior,Siguiente,Lista):-
  nth1(IndiceAnterior,Lista,Anterior),
  IndiceSiguiente is IndiceAnterior + 1,
  nth1(IndiceSiguiente,Lista,Siguiente).

seleccionadosMismaCasa(UnMago,OtroMago):- % consecuente forall delegado
  seleccionado(UnMago,Casa),
  seleccionado(OtroMago,Casa),
  UnMago \= OtroMago.

% RECURSIVA
cadenaDeCasasV2([Mago1,Mago2 | MagosSiguientes]):- % minimo dos magos
  seleccionado(Mago1,Casa),
  seleccionado(Mago2,Casa),
  cadenaDeCasasV2([Mago2 | MagosSiguientes]). % es necesario armar cadena de cabeza mago2 y los siguientes, si no seria lo estaria salteando.
cadenaDeCasasV2([_]).
cadenaDeCasasV2([]). % patrones mutuamente excluyentes, no importa el orden. Ademas como busca todas las rtas posibles va a entrar de todas formas al que haga verdadero.

% --------------------------------------------- PARTE 2 ---------------------------------------------

hizo(harry, andarFueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, irA(seccionRestringida)).
hizo(harry, irA(bosque)).
hizo(harry, irA(tercerPiso)).
hizo(draco, irA(mazmorras)).
hizo(ron,ganarAlAjedrezMagico).     % V2 hizo(ron, buenaAccion(50, ganarAlAjedrezMagico)).
hizo(hermione, salvarASusAmigos).   % V2 hizo(hermione, buenaAccion(50, salvarASusAmigos)).
hizo(harry,ganarAVoldemort).        % V2 hizo(harry, buenaAccion(60, ganarleAVoldemort)).
% agregados punto 4)
hizo(hermione,responderPregunta(dondeSeEncuentraUnBezoar,20,snape)). 
hizo(hermione, responderPregunta(comoHacerLevitarUnaPluma,25,flitwick)).

% 1a) Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo).
esBuenAlumno(Mago):-
  hizo(Mago,_),
  forall(hizo(Mago,Accion),not(esMalaAccion(Accion))).

esMalaAccion(Accion):-
  puntaje(Accion,Puntos),
  Puntos < 0.

puntaje(andarFueraDeCama,-50).
puntaje(irA(bosque),-50).
puntaje(irA(seccionRestringida),-10).
puntaje(irA(tercerPiso),-75).
puntaje(ganarAlAjedrezMagico,50).
puntaje(salvarASusAmigos,50).
puntaje(ganarAVoldemort,60).
% agregados punto 4)
puntaje(responderPregunta(_,Dificultad,Profesor),Dificultad):- 
  Profesor \= snape. % si no agregara el profesor, la pregunta realizada por snape tendria dos puntajes distintos.
puntaje(responderPregunta(_,Dificultad,snape),Puntos):-
  Puntos is Dificultad / 2.

esBuenAlumnoV2(Mago):-
  hizoAlgunaAccion(Mago),
  not(hizoAlgoMalo(Mago)).

hizoAlgunaAccion(Mago):-
  hizo(Mago, _).
hizoAlgoMalo(Mago):-
  hizo(Mago, Accion),
  puntajeQueGenera(Accion, Puntaje),
  Puntaje < 0.

puntajeQueGenera(fueraDeCama, -50).
puntajeQueGenera(irA(Lugar), PuntajeQueResta):-
  lugarProhibido(Lugar, Puntos),
  PuntajeQueResta is Puntos * -1.
puntajeQueGenera(buenaAccion(Puntaje, _), Puntaje).
puntajeQueGenera(responderPregunta(_, Dificultad, snape), Puntos):-
  Puntos is Dificultad // 2.
puntajeQueGenera(responderPregunta(_, Dificultad, Profesor), Dificultad):- Profesor \= snape.

lugarProhibido(bosque, 50).
lugarProhibido(seccionRestringida, 10).
lugarProhibido(tercerPiso, 75).

% OTRO MODELADO DE INFORMACION, acciones como predicados
fueraDeCama(harry).
fueA(hermione, tercerPiso).
fueA(hermione, seccionRestringida).
fueA(harry, bosque).
fueA(harry, tercerPiso).
fueA(draco, mazmorras).
buenaAccion(ron, 50, ganarAlAjedrezMagico).
buenaAccion(hermione, 50, salvarASusAmigos).
buenaAccion(harry, 60, ganarleAVoldemort).

esBuenAlumnoV3(Mago):-
  hizoAlgunaAccionV2(Mago),
  not(hizoAlgoMaloV2(Mago)).

hizoAlgunaAccionV2(Mago):-
  fueraDeCama(Mago).
hizoAlgunaAccionV2(Mago):-
  fueA(Mago, _).
hizoAlgunaAccionV2(Mago):-
  buenaAccion(Mago, _, _).

hizoAlgoMaloV2(Mago):-
  puntajeQueGeneraV2(Mago, Puntos),
  Puntos < 0.

puntajeQueGeneraV2(Mago, -50):-
  fueraDeCama(Mago).
puntajeQueGeneraV2(Mago, PuntosQueResta):-
  fueA(Mago, Lugar),
  lugarProhibido(Lugar, PuntosPorLugar),
  PuntosQueResta is PuntosPorLugar * -1.
puntajeQueGeneraV2(Mago, Puntos):-
  buenaAccion(Mago, Puntos, _).

/* POCO EXTENSIBLE, si se agregaran mas malas accciones me tendria que acordar de definir si son malas o buenas, en vez de que lo infiera prolog en base al puntaje.
hizoAlgoMalo(Mago):-
  fueraDeCama(Mago).
hizoAlgoMalo(Mago):-
  fueA(Mago, Lugar),
  lugarProhibido(Lugar, _).
*/

% 1b) Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
% Es necesario que la accion sea un individuo porque los predicados consultan por individuos, puedo hablar de un individuo
% No hay que contar los magos, si por ahi cuando la cantidad supera 3  
esRecurrente(Accion):-
  hizo(Mago,Accion),
  hizo(OtroMago,Accion),
  Mago \= OtroMago.

% 2) Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

puntajeTotal(Casa,Puntaje):- % gryffindor deberia dar -100, responde -210 por usar puntajeQueGenera y no puntaje (mezcla versiones)
  esDe(_,Casa),
  findall(Punto,(esDe(Mago,Casa),puntosObtenidos(Mago,_,Punto)),Puntos),
  sum_list(Puntos, Puntaje).

puntosObtenidos(Mago,Accion,Puntos):-
  hizo(Mago,Accion),
  puntaje(Accion,Puntos). % no usar puntajeQueGenera difiere por las buenasAcciones

% 3) Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras.
casaGanadoraCopa(Casa):-
  puntajeTotal(Casa,PuntajeCasaGanadora),
  forall(puntajeTotal(_,OtroPuntaje),OtroPuntaje =< PuntajeCasaGanadora). % El igual considera el empate, si no quiero incorporar el igual,debo aclarar que las casas sean distintas

casaGanadoraCopaV2(Casa):-      % RESPONDE FALSE si fuera > en vez de >=
  puntajeTotal(Casa, PuntajeMayor),
  forall((puntajeTotal(OtraCasa, PuntajeMenor), Casa \= OtraCasa), PuntajeMayor >= PuntajeMenor).

casaGanadoraCopaV3(Casa):-      % RESPONDE TODAS con > y ninguna con >=
  puntajeTotal(Casa,PuntajeMayor),
  not((puntajeTotal(Casa,OtroPuntaje),PuntajeMayor >= OtroPuntaje)). % no existe puntaje mayor al de la casa ganadora

% 4) Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la dificultad de la pregunta y qué profesor la hizo.
% gracias al polimorfismo y la correcta delegacion de predicados, solo es necesario agregar esta nueva informacion al predicado hizo y puntaje.

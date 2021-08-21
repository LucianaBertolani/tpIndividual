% WHO YOUY GONNA CALL                https://docs.google.com/document/d/1GBORNTd2fujNy0Zs6v7AKXxRmC9wVICX2Y-pr7d1PwE/edit
% Posible solucion                   https://github.com/pdep-mit/ejemplos-de-clase-prolog/commit/60f4cd6227ab868b9476263836e143c4d66762f3

cazafantasmas(peter).
cazafantasmas(egon).
cazafantasmas(ray).
cazafantasmas(winston).

% herramientas que requieren los cazafantasmas para realizar alguna tarea de la limpieza a domicilio. En el caso de las aspiradoras se indica la potencia minima para la tarea
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

/* 1) Agregar a la base de conocimientos la siguiente información: - Egon tiene una aspiradora de 200 de potencia. - Egon y Peter tienen un trapeador, Ray y Winston no. - Sólo Winston tiene una varita de neutrones.- Nadie tiene una bordeadora. */
% tiene(Czafantasmas,herramienta).
tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(peter,sopapa).% agrego para probar
tiene(winston,varitaDeNeutrones).

/* 2) Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 
Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida es una aspiradora, 
el integrante debe tener una con potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida.*/
% satisfaceNecesidadDe(Cazafantasmas,HerramientaRequerida).
satisfaceNecesidadDe(Cazafantasmas,HerramientaRequerida):-
    tiene(Cazafantasmas,HerramientaRequerida),
    HerramientaRequerida \= aspiradora(_).

satisfaceNecesidadDe(Cazafantasmas,aspiradora(PotenciaNecesaria)):-
    tiene(Cazafantasmas,aspiradora(Potencia)),
    Potencia >= PotenciaNecesaria.

/* INTENTO DE DELEGACION
satisfaceNecesidadDe(Cazafantasmas,HerramientaRequerida):-
    tiene(Cazafantasmas,HerramientaRequerida),
    condicionNecesaria(HerramientaRequerida).

condicionNecesaria(HerramientaRequerida):-
    HerramientaRequerida \= aspiradora(_).
condicionNecesaria(aspiradora(Potencia)):-
    potenciaSuficiente(Cazafantasmas,PotenciaNecesaria).

potenciaSuficiente(Cazafantasmas,PotenciaNecesaria):-
    tiene(Cazafantasmas,aspiradora(AlgunaPotencia)),
    AlgunaPotencia >= PotenciaNecesaria.*/

/* 3) Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
- Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
- Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas para dicha tarea. */
puedeRealizar(Cazafantasmas,Tarea):-
    herramientasRequeridas(Tarea,_),
    tiene(Cazafantasmas,varitaDeNeutrones).

puedeRealizar(Cazafantasmas,Tarea):-
    cazafantasmas(Cazafantasmas),
    herramientasRequeridas(Tarea,Herramientas),
    forall(member(HerramientaRequerida,Herramientas),satisfaceNecesidadDe(Cazafantasmas,HerramientaRequerida)).

% Abstrayendo logica de que una tarea requiere una herramienta...
puedeRealizarV2(Persona, Tarea):-
	tiene(Persona, _),
	requiereHerramienta(Tarea, _), % elijo ligar con este predicado y no con herramientas requeridas para no sobre generar
	forall(requiereHerramienta(Tarea, Herramienta),satisfaceNecesidadDe(Persona, Herramienta)).

requiereHerramienta(Herramienta,Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    member(Herramienta, Herramientas).    

/* 4) Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). Para ellos disponemos de la siguiente información en la base de conocimientos:
- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por los metros cuadrados de la tarea. */
% tareaPedida(Cliente,TareaPedida,MetrosCuadrados)
tareaPedida(juan,limpiarBanio,20).
tareaPedida(lucas,limpiarBanio,5).
tareaPedida(lucas,cortarPasto,30).

% precio(Tarea,PrecioXMCuadrados)
precio(cortarPasto,10).
precio(limpiarTecho,30).
precio(limpiarBanio,20).
precio(encerarPisos,10).
precio(ordenarCuarto,5).

cobrarA(ImportePedido,Cliente):-
    tareaPedida(Cliente,_,_),
    findall(TotalTarea,precioTotalTarea(Cliente,_,TotalTarea),PreciosTareas),
    sum_list(PreciosTareas,ImportePedido).
    
precioTotalTarea(Cliente,Tarea,TotalTarea):-
    tareaPedida(Cliente,Tarea,MetrosCuadrados),
    precio(Tarea,PrecioXMCuadrados),
    TotalTarea is MetrosCuadrados * PrecioXMCuadrados.

/* 5) Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando puede realizar todas las tareas del pedido y 
además está dispuesto a aceptarlo.Sabemos que:
- Ray sólo acepta pedidos que no incluyan limpiar techos,
- Winston sólo acepta pedidos que paguen más de $500, 
- Egon está dispuesto a aceptar pedidos que no tengan tareas complejas y 
- Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. Además la limpieza de techos siempre es compleja. */
aceptaPedidoDe(Cazafantasmas,Cliente):-
    puedeHacerPedido(Cazafantasmas,Cliente),
    estaDispuestoAHacer(Cazafantasmas,Cliente).

puedeHacerPedido(Cazafantasmas, Cliente):-
	tareaPedida(Cliente, _, _),
	cazafantasmas(Cazafantasmas),
	forall(tareaPedida(Cliente, Tarea, _), puedeRealizar(Cazafantasmas, Tarea)).

estaDispuestoAHacer(peter,_).
estaDispuestoAHacer(ray,Cliente):- not(tareaPedida(Cliente,limpiarTecho,_)).
estaDispuestoAHacer(winston,Cliente):- cobrarA(Cliente,ImportePedido), ImportePedido >= 500.
estaDispuestoAHacer(egon,Cliente):- not((tareaPedida(Cliente,Tarea,_),tareaCompleja(Tarea))). % forall(tareaPedida(Cliente,Tarea,_),not(tareaCompleja(Tarea)))
% Decir  "no existe una tarea que haya pedido un cliente y que sea compleja"      . Equivale a decir "para todas las tareas que pidio un cliente, ninguna es compleja".

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas,CantidadHerramientas),
    CantidadHerramientas > 2.
tareaCompleja(limpiarTecho).
    
/* 6) Necesitamos agregar la posibilidad de tener herramientas reemplazables, que incluyan 2 herramientas de las que pueden tener los integrantes como alternativas, 
para que puedan usarse como un requerimiento para poder llevar a cabo una tarea.
a. Mostrar cómo modelarías este nuevo tipo de información modificando el hecho de herramientasRequeridas/2 para que 
ordenar un cuarto pueda realizarse tanto con una aspiradora de 100 de potencia como con una escoba, además del trapeador y el plumero que ya eran necesarios.
- Sublista dentro de las herramientas para aquellos grupos de reemplazables 
herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).

b. Realizar los cambios/agregados necesarios a los predicados definidos en los puntos anteriores para que se soporten estos nuevos requerimientos de herramientas para poder 
llevar a cabo una tarea, teniendo en cuenta que para las herramientas reemplazables alcanza con que el integrante satisfaga la necesidad de alguna de las herramientas indicadas
para cumplir dicho requerimiento.
- Para el punto 2 agregamos una definición de satisfaceNecesidad que contemplara la posibilidad de listas de herramientas remplazables aprovechando el predicado 
para hacer uso de polimorfismo, y evitando tener que modificar el resto de la solución ya planteada para contemplar este nuevo caso.
satisfaceNecesidadDe(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidadDe(Persona, Herramienta).


c. Explicar a qué se debe que esto sea difícil o fácil de incorporar. 
- Por qué para este punto no bastaba sólo con agregar un nuevo hecho?
Con nuestra definición de puedeRealizar verificabamos con un forall que una persona posea todas las herramientas que requería una tarea; pero sólo ligabamos la tarea. 
Entonces Prolog hubiera matcheado con ambos hechos que encontraba, y nos hubiera devuelto las herramientas requeridas presentes en ambos hechos.
Una posible solución era, dentro de puedeRealizar, también ligar las herramientasRequeridas antes del forall, y así asegurarnos que el predicado matcheara con una única tarea a la vez.
- Cual es la desventaja de esto? 
Para cada nueva herramienta remplazable deberíamos contemplar todos los nuevos hechos a generar para que esta solución siga funcionando como queremos.
- Se puede hacer? En este caso sí, pero con el tiempo se volvería costosa.
La alternativa que planteamos en esta solución es agrupar en una lista las herramientas remplazables, y agregar una nueva definición a satisfaceNecesidad, 
que era el predicado que usabamos para tratar directamente con las herramientas, que trate polimorficamente tantoa nuestros hechos sin herramientas remplazables,
 como a aquellos que sí las tienen. También se podría haber planteado con un functor en vez de lista.
- Cual es la ventaja? 
Cada vez que aparezca una nueva herramienta remplazable, bastará sólo con agregarla a la lista de herramientas remplazables, y no deberá modificarse el resto de la solución.*/
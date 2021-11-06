% MINECRAFT                      https://docs.google.com/document/d/1BE6MIKzMcQMh_D27sIM3JkcOaZRDjdqAMwqD_udM9ro/edit

/* Se tiene la siguiente base de conocimiento en cuanto a los jugadores, con información de cada uno sobre su nombre, ítems que posee, y su nivel de hambre (0 a 10). 
También se tiene información sobre el mapa del juego, particularmente de las distintas secciones del mismo, los jugadores que se encuentran en cada uno, y su nivel de oscuridad (0 a 10).
Por último, se conoce cuáles son los ítems comestibles. */
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% 1) Jugando con los ítems 
% a. Relacionar un jugador con un ítem que posee. tieneItem/2
tieneItem(Jugador,Item):-
    jugador(Jugador,ListaItems,_),
    member(Item,ListaItems).

% b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. (Tratar de resolver sin findall) sePreocupaPorSuSalud/1
sePreocupaPorSuSalud(Jugador):-
    tieneMasDeUnComestible(Jugador).

tieneMasDeUnComestible(Jugador):-
    % jugador(Jugador,ListaItems,_),
    tieneItemComestible(Jugador,Item),
    tieneItemComestible(Jugador,OtroItem),
    Item \= OtroItem.

tieneItemComestible(Jugador,Item):-
    comestible(Item),
    tieneItem(Jugador,Item).

% c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeItem/3
cantidadDeItem(Jugador,Item,Cantidad):-
    jugador(Jugador,_,_),
    tieneItem(_,Item),              % al generar tieneItem(Jugador,Item), no responde 0 por los que no tiene. 
    findall(Item,tieneItem(Jugador,Item),ListaItems),  
    length(ListaItems,Cantidad).

cantidadDeItemV2(Jugador,Item,0):-      % NUNCA RESPONDE CERO
    tieneItem(_,Item),
    not(tieneItem(Jugador,Item)).
cantidadDeItemV2(Jugador,Item,Cantidad):-
    tieneItem(Jugador,Item),
    findall(Item,tieneItem(Jugador,Item),ListaItems),  
    length(ListaItems,Cantidad).

% d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2 CASO PRUEBA ?- tieneMasDe(steve, panceta). true.
tieneMasDe(Jugador,Item):-
    cantidadDeItem(Jugador,Item,Cantidad),
    forall(cantidadDeItem(_,Item,OtraCantidad),Cantidad >= OtraCantidad).

% 2) Alejarse de la oscuridad 
% a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1
hayMonstruos(Lugar):-
    lugar(Lugar, _, NivelOscuridad),
    NivelOscuridad > 6.

% b. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1
correPeligro(Jugador):-
    lugar(Lugar, ListaJugadores, _),
    member(Jugador, ListaJugadores),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    estaHambriento(Jugador),
    not(tieneItemComestible(Jugador,_)).

estaHambriento(Jugador):-
    jugador(Jugador,_,NiveHambre),
    NiveHambre < 4.

/* c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
- Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
- Si hay monstruos, es 100.
- Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

?- nivelPeligrosidad(playa,Peligrosidad). > Peligrosidad = 50. */
nivelPeligrosidad(Lugar,100):-
    hayMonstruos(Lugar).

nivelPeligrosidad(Lugar,Peligrosidad):-
    lugar(Lugar, [], Oscuridad),
    Peligrosidad is Oscuridad * 10.

nivelPeligrosidad(Lugar,Peligrosidad):-
    lugar(Lugar,ListaJugadores,_),
    ListaJugadores \= [],
    not(hayMonstruos(Lugar)),
    porcentajeHambrientos(Lugar,Peligrosidad).
   
poblacionTotal(Lugar,Cantidad):-
    lugar(Lugar,Poblacion,_),
    length(Poblacion,Cantidad).

porcentajeHambrientos(Lugar,Porcentaje):-
    poblacionTotal(Lugar,PoblacionTotal),
    cantidadDeHambrientos(Lugar,CantidadDeHambrientos),
    Porcentaje is CantidadDeHambrientos * 100 / PoblacionTotal.

cantidadDeHambrientos(Lugar,CantidadDeHambrientos):-
    findall(Jugador,vaAUnLugarHambriento(Lugar,Jugador),JugadoresHambrientos),
    length(JugadoresHambrientos,CantidadDeHambrientos).
    
vaALugar(Lugar,Jugador):-
    lugar(Lugar,ListaJugadores,_),
    member(Jugador,ListaJugadores).

vaAUnLugarHambriento(Lugar,Jugador):-
    estaHambriento(Jugador),
    vaALugar(Lugar,Jugador).

% Poblacion total ------ 100 %
% cant hambrientos ---- x = CantHambrientos * 100 / Poblacion total    
    
/* 3) A construir
El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos para poder construirse:
- Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo, 8 unidades de piedra.
- Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2 
?- puedeConstruir(stuart, horno). > true.
?- puedeConstruir(steve, antorcha). > true.

Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes, es decir no puede haber más de un ítem que requiera el mismo elemento. */

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador,NuevoItem):-
    jugador(Jugador,_,_),
    item(NuevoItem,ListaRequisitos),
    poseeLoNecesario(Jugador,ListaRequisitos).

poseeLoNecesario(Jugador,ListaRequisitos):-
    forall(member(Item,ListaRequisitos),cumpleRequisitoItem(Jugador,Item)).

cumpleRequisitoItem(Jugador,itemSimple(Nombre,CantidadRequerida)):-
    tieneItem(Jugador,Nombre),
    cantidadDeItem(Jugador,Nombre,CantidadQueTiene),
    CantidadQueTiene >= CantidadRequerida.

cumpleRequisitoItem(Jugador,itemCompuesto(Nombre)):-
    puedeConstruir(Jugador,Nombre).

% 4) Para pensar sin bloques
% a. ¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?
% Responde false, por universo cerrado, lo desconocido se presume falso.

% b. ¿Cuál es la ventaja que nos ofrece el paradigma lógico frente a funcional a la hora de realizar una consulta?
% ayuda :(
% JUEGO DE LAS SILLAS                                       https://drive.google.com/file/d/1mAUwAJmeUw1b8e65x5KB6ERLV2U43zxY/view

/* Como especialistas en el armado de mesas para eventos (fiestas de Casamiento, Cumpleaños de 15, Comuniones, etc.) se quiere automatizar las relaciones que siempre
se deben de considerar en la distribución de las personas en mesas. Para esto se dispone de la siguiente información en forma de base de conocimiento Prolog: 
de cada persona se conocen sus amigos y sus enemigos. 
Para cada fiesta tenemos las mesas conformadas o Para modelar una mesa vamos a usar un functor que tiene número de mesa y una lista de comensales. */
amigo(juan, alberto).
amigo(juan, pedro).
amigo(pedro,mirta).
amigo(alberto, tomas).
amigo(tomas,mirta).

enemigo(mirta,ana).
enemigo(juan,nestor).
enemigo(juan,mirta).

mesaArmada(navidad2010,mesa(1,[juan,mirta,ana,nestor])).
mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
mesaArmada(navidad2010,mesa(8,[nestor,pedro])).

/* 1)  estaSentadaEn/2 que relaciona a cada persona que esta sentada en una mesa. Este predicado debe de ser inversible.
 ?- estaSentadaEn(Quien,Mesa).    > Quien = juan, Mesa = mesa(1, [juan, mirta, ana, nestor]) ; > Quien = mirta, Mesa = mesa(1, [juan, mirta, ana, nestor]) */
estaSentadaEn(Persona,Mesa):-
    mesaArmada(_,Mesa),
    formaParteDeLosComensales(Persona,Mesa).

formaParteDeLosComensales(Persona,mesa(_,Comensales)):- member(Persona,Comensales).

/* 2) sePuedeSentar/2 que relaciona a una persona y una mesa si la persona puede sentarse en esa mesa. 
% Una persona se sienta en una mesa si hay por lo menos un amigo y no hay enemigos.
% ?- sePuedeSentar(pedro,mesa(1,[juan,mirta,ana,nestor])). true . */
sePuedeSentar(Persona,Mesa):-
    mesaArmada(_,Mesa),
    hayAlgunAmigo(Persona,Mesa),
    noHayEnemigos(Persona,Mesa).

hayAlgunAmigo(Persona,Mesa):-
    amigo(Persona,Amigo),
    estaSentadaEn(Amigo,Mesa).
noHayEnemigos(Persona,Mesa):-
    mesaArmada(_,Mesa),
    forall((enemigo(Enemigo,Persona),Enemigo \= Persona),not(estaSentadaEn(Enemigo,Mesa))).


/* 3) mesaDeCumpleañero/2 donde se crea una mesa ideal para una persona (el cumpleañero). La mesa ideal para alguien el día de su cumpleaños es la mesa
    número 1 donde está él y todos sus amigos.
?- mesaDeCumpleañero(juan,M). M = mesa(1, [juan, alberto, pedro]).
Nota: Recuerde que existe el predicado append(Lista1,Lista2,Lista12). */
mesaDeCumpleaniero(mesa(1,Participantes),Cumpleaniero):-
    amigo(Cumpleaniero,_),
    mesaConAmigos(Cumpleaniero,Participantes).

mesaConAmigos(Persona,MesaConAmigos):-
    findall(Amigo,amigo(Persona,Amigo),Amigos),
    append([Persona],Amigos, MesaConAmigos).

mesaDeCumpleanieroV2(Mesa,Cumpleaniero):-   % NO SIRVE. XQ?
    numeroDeMesa(Mesa,1),
    mesaConAmigos(Cumpleaniero,Mesa).
numeroDeMesa(mesa(Numero,_),Numero).

/* 4) incompatible/2 relacione a dos personas por ser incompatibles, esto pasa cuando tienen una persona en común pero para uno es amigo y para el otro es enemigo.
?- incompatible(X,Y). X = pedro, Y = juan ; */
incompatible(UnaPersona,OtraPersona):-
    amigo(UnaPersona,PersonaEnComun),
    enemigo(OtraPersona,PersonaEnComun),
    UnaPersona \= OtraPersona,
    OtraPersona \= PersonaEnComun.

% 5) laPeorOpcion/2 relaciona a una persona y una mesa posible si todos los que están sentados en ella son sus enemigos.
laPeorOpcion(Persona,Mesa):-
    estaSentadaEn(Persona,_),
    mesaArmada(_,Mesa),
    forall(estaSentadaEn(OtraPersona,Mesa),enemigo(Persona,OtraPersona)).

/* 6) mesasPlanificadas/2: relaciona a una fiesta con todas las mesas que fueron planificadas para ella. Este predicado debe de ser inversible.
?- mesasPlanificadas(F,Mesas). F = navidad2010 , Mesas = [mesa(1, [juan, mirta, ana, nestor]), mesa(5, [andres, german, ludmila, elias]), mesa(8, [nestor, pedro])] */
mesasPlanificadas(Fiesta,Mesas):-
    mesaArmada(Fiesta,_),
    findall(Mesa,mesaArmada(Fiesta,Mesa),Mesas).

/* 7) esViable/1: se verifica para una lista de mesas si:
o Los números de mesa son correctos, es decir, si hay 5 mesas están numeradas del 1 al 5 (pueden no estar en orden).
o Hay 4 personas en cada mesa (si exactamente 4 ni mas ni menos).
o En ninguna mesa hay dos personas que sean enemigas entre sí.
Una lista vacía de mesas no se considera viable.
?- esViable([mesa(1,[juan,pedro,ana,diego]),mesa(2,[ludmi,javi,elias,hernan])]).  true .
?- mesasPlanificadas(navidad2010,Mesas),esViable(Mesas). false.  
                                                        ^^^^^^^ XQ False? si bien en la mesa 1 hay enemigos, hay 4 personas, todas son mesas viables --> Distinta interpretacion */

% INCORRECTA INTERPRETACION                                                        
esViable(Mesas):-
    forall(member(Mesa,Mesas),esViable(Mesa)).
esViable(Mesas):-
    numerosCorrectos(Mesas).

mesaViable(mesa(_,Participantes)):-
    length(Participantes,4).
mesaViable(Mesa):-
    forall(estaSentadaEn(Persona,Mesa),noHayEnemigos(Persona,Mesa)).

numerosCorrectos(Mesas):-
    length(Mesas,CantidadMesas),
    forall((member(Mesa,Mesas),numeroDeMesa(Mesa,Numero)),between(1,CantidadMesas,Numero)).

% RESPONDE AL ENUNCIADO
esViableV2(Mesas):-
    Mesas \= [],
    puedeSerViable(Mesas).

puedeSerViable(Mesas):-
    numerosCorrectos(Mesas).
puedeSerViable(Mesas):-
    forall((member(Mesa,Mesas),estaSentadaEn(Persona,Mesa)),noHayEnemigos(Persona,Mesa)).   
puedeSerViable(Mesas):-
    forall(member(Mesa,Mesas),cantidadParticipantes(Mesa,4)).

cantidadParticipantes(mesa(_,Participantes),Cantidad):- length(Participantes, Cantidad).

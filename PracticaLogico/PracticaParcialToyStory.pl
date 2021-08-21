% TOY STORY          https://drive.google.com/file/d/1pNZ5M3IL6xscFUlfCnPEWBlElqsBn1K9/view

% duenio(NombreDuenio,NombreJuguete,AniosQueTuvoAlJuguete)
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
duenio(andy, buzz, 4).

% juguete(NombreJuguete,TipoJuguete) ; TipoJuguete: deTrapo(tematica) - deAccion(tematica, piezas) - 
                                    % miniFiguras(tematica, cantidadDeFiguras) - caraDePapa(piezas)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial,[original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo),original(pieDerecho),repuesto(nariz)])).

esRaro(deAccion(stacyMalibu,[sombrero])). % Dice Si un TipoJuguete es raro
esRaro(deTrapo(_)).

esColeccionista(sam). % Dice si una persona es coleccionista

% Nota: siempre que nos refiramos al functor que representa al juguete le diremos “juguete”. Y siempre que nos refiramos al átomo con su nombre, le diremos “nombre del juguete”
% 1a) tematica/2: relaciona a un juguete con su temática. La temática de los cara de papa es caraDePapa.
tematica(NombreJuguete,Tematica):-     % tematica(juguete(_,TipoJuguete),Tematica)
    juguete(NombreJuguete,TipoJuguete),
    tematicaSegunTipoJuguete(TipoJuguete,Tematica).

tematicaSegunTipoJuguete(deTrapo(Tematica),Tematica).
tematicaSegunTipoJuguete(deAccion(Tematica,_),Tematica).
tematicaSegunTipoJuguete(miniFiguras(Tematica,_),Tematica).
tematicaSegunTipoJuguete(caraDePapa(_),caraDePapa).

% 1b) esDePlastico/1: Nos dice si el juguete es de plástico, lo cual es verdadero sólo para las miniFiguras y los caraDePapa.
esDePlastico(NombreJuguete):-              % esDePlastico(juguete(_,TipoJuguete))
    juguete(NombreJuguete,TipoJuguete),
    materialPlastico(TipoJuguete).

materialPlastico(miniFiguras(_,_)).
materialPlastico(caraDePapa(_)).

% 1c) esDeColeccion/1:Tanto lo muñecos de acción como los cara de papa son de colección si son raros, los de trapo siempre lo son, y las mini figuras, nunca.
esDeColeccion(NombreJuguete):-     % esDeColeccion(juguete(_,TipoJuguete))
    juguete(NombreJuguete,TipoJuguete),
    esRaro(TipoJuguete).

% Cuando es raro un cara de papa y los muñecos de accion ???

% 2) amigoFiel/2: Relaciona a un dueño con el nombre del juguete que no sea de plástico que tiene hace más tiempo. Debe ser completamente inversible.
amigoFiel(Duenio,NombreJuguete):-
  duenio(Duenio,NombreJuguete,Duracion),
  not(esDePlastico(NombreJuguete)),
  forall(duenio(Duenio,_,OtraDuracion),Duracion >= OtraDuracion).

% 3) superValioso/1: Genera los nombres de juguetes de colección que tengan todas sus piezas originales, y que no estén en posesión de un coleccionista.
superValioso(NombreJuguete):-               
  juguete(NombreJuguete,TipoJuguete),
  esDeColeccion(NombreJuguete),                         % woody y jessie
  not(loPoseeUnColeccionista(NombreJuguete)),           % a jessie loPoseeUnColeccionista => woody puede ser superValioso
  tienePiezasOriginales(TipoJuguete).                   % woody es superValioso porque es de unicaPieza, es original. 

tienePiezasOriginales(TipoJuguete):-
    piezasDe(Piezas,TipoJuguete),
    not(member(repuesto(_), Piezas)).
tienePiezasOriginales(TipoJuguete):-
    unicaPieza(TipoJuguete).

unicaPieza(deTrapo(_)).
unicaPieza(miniFiguras(_,_)).
piezasDe(Piezas,caraDePapa(Piezas)).
piezasDe(Piezas,deAccion(_,Piezas)).

loPoseeUnColeccionista(NombreJuguete):-
    % juguete(NombreJuguete,_),
    duenio(NombreDuenio,NombreJuguete,_),
    esColeccionista(NombreDuenio).

% 4) dúoDinámico/3: Relaciona un dueño y a dos nombres de juguetes que le pertenezcan que hagan buena pareja. 
% Dos juguetes distintos hacen buena pareja si son de la misma temática. Además woody y buzz hacen buena pareja. Debe ser complemenente inversible.
duoDinamico(Duenio,UnJuguete,OtroJuguete):-
    lePertenecen(Duenio,UnJuguete,OtroJuguete),
    UnJuguete \= OtroJuguete,
    buenaPareja(UnJuguete,OtroJuguete).

buenaPareja(woody,buzz).
buenaPareja(UnJuguete,OtroJuguete):-
    mismaTematica(UnJuguete,OtroJuguete).

mismaTematica(UnJuguete,OtroJuguete):-
    tematica(UnJuguete,Tematica),
    tematica(OtroJuguete,Tematica).
    % UnJuguete \= OtroJuguete.

lePertenecen(Duenio,UnJuguete,OtroJuguete):-
    duenio(Duenio,UnJuguete,_),
    duenio(Duenio,OtroJuguete,_).

/* 5) felicidad/2:Relaciona un dueño con la cantidad de felicidad que le otorgan todos sus juguetes:
- las minifiguras le dan a cualquier dueño 20 * la cantidad de figuras del conjunto
- los cara de papas dan tanta felicidad según que piezas tenga: las originales dan 5, las de repuesto,8.
- los de trapo, dan 100
- Los de accion, dan 120 si son de coleccion y el dueño es coleccionista. Si no dan lo mismo que los de trapo.
*/
felicidad(NombreDuenio,CantidadFelicidad):-
    duenio(NombreDuenio,_,_),
    findall(FelicidadJuguete,ganaFelicidad(NombreDuenio,FelicidadJuguete),FelicidadJuguetes),  % NOMBRE MEJOR
    sum_list(FelicidadJuguetes,CantidadFelicidad).

ganaFelicidad(NombreDuenio,PuntosFelicidad):-   % NOMBRE MEJOR
  duenio(NombreDuenio,NombreJuguete,_),
  daXPuntosFelicidad(NombreJuguete,PuntosFelicidad).

daXPuntosFelicidad(NombreJuguete,PuntosFelicidad):-
    juguete(NombreJuguete,TipoJuguete),
    felicidadTipoJuguete(TipoJuguete,PuntosFelicidad).
daXPuntosFelicidad(NombreJuguete,120):-
    juguete(NombreJuguete,deAccion(_,_)),
    duenio(NombreDuenio,NombreJuguete,_),
    esDeColeccion(NombreJuguete),
    esColeccionista(NombreJuguete).

felicidadTipoJuguete(miniFiguras(_,CantidadDeFiguras),FelicidadJuguete):-
    FelicidadJuguete is CantidadDeFiguras * 20.
felicidadTipoJuguete(deTrapo(_),100).
felicidadTipoJuguete(caraDePapa(Piezas),FelicidadJuguete):-
    cantidadPiezasOriginales(Piezas,Originales),            % FALTA DESARROLLAR
    cantidadPiezasRepuesto(Piezas,Repuesto),                % FALTA DESARROLLAR
    FelicidadJuguete is Originales * 5 + Repuesto * 8.
/*felicidadTipoJuguete(deAccion(_,_),120):-                  INCONCLUSO
    duenio(NombreDuenio,NombreJuguete,_),
    esDeColeccion(NombreJuguete),
    esColeccionista(NombreDuenio). */
% felicidadTipoJuguete(deAccion(_,_),100) si no cumple lo anterior

/* 6) puedeJugarCon/2: Relaciona a alguien con un nombre de juguete cuando puede jugar con él. Esto ocurre cuando:
- este alguien es el dueño del juguete
- o bien, cuando exista otro que pueda jugar con este juguete y pueda prestárselo. Alguien puede prestarle un juguete a otro cuando es dueño de una mayor cantidad de juguetes.*/
puedeJugarCon(Persona,NombreJuguete):-
    duenio(Persona,NombreJuguete,_).
puedeJugarCon(Persona,NombreJuguete):-
    puedeJugarCon(OtraPersona,NombreJuguete),
    puedePrestarle(OtraPersona,Persona,NombreJuguete).

puedePrestarle(UnaPersona,OtraPersona,NombreJuguete):-
    duenio(UnaPersona,NombreJuguete,_),
    poseeMasJuguetesQue(UnaPersona,OtraPersona).

poseeMasJuguetesQue(UnaPersona,OtraPersona):-
    cantidadJuguetes(UnaPersona,UnaCantidad),           
    cantidadJuguetes(OtraPersona,OtraCantidad),         
    UnaCantidad > OtraCantidad.

cantidadJuguetes(UnaPersona,Cantidad):-
    juguetesPropios(Juguetes,UnaPersona),
    length(Juguetes,Cantidad).

/* 7) podriaDonar/3: relaciona a un dueño, una lista de juguetes propios y una cantidad de felicidad cuando entre todos los juguetes de la lista 
le generan menos que esa cantidad de felicidad. Debe ser completamente inversible. */
podriaDonar(NombreDuenio,Juguetes,Felicidad):-
    juguetesPropios(Juguetes,NombreDuenio),
    felicidad(NombreDuenio,FelicidadJuguetes),
    Felicidad < FelicidadJuguetes.

juguetesPropios(Juguetes,NombreDuenio):-
    duenio(NombreDuenio,_,_),
    findall(Juguete,duenio(NombreDuenio,Juguete,_),Juguetes).


% 8. Comentar dónde se aprovechó el polimorfismo

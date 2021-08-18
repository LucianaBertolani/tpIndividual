% ESCA-PDEP         https://docs.google.com/document/d/1toV71CIEeJSfQeK9JDcpgR-FK41C0RDH5zEtQGjkQQk/edit

% persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

% esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).
% 6)
esSalaDe(estrellasDePelea,supercelula). 
esSalaDe(choqueDeLaRealeza,supercelula).
esSalaDe(miseriaDeLaNoche,skPista).
% esSalaDe(_,vertigo). % no tiene salas, no agrego? cambiar predicados?, agregar predicado? ->NO AGREGAR (segun posible solucion)


% sala(Nombre, Experiencia). Experiencia = terrorifica(CantidadDeSustos, EdadMinima). | familiar(Tematica, CantidadDeHabitaciones). | enigmatica(Candados).
sala(elPayasoExorcista, terrorifica(100, 18)).                                          % Nivel dificultad: 82  - sal si puedes      
sala(socorro, terrorifica(20, 12)).                                                     %                   8   - sal si puede
sala(linternas, familiar(comics, 5)).                                                   %                   5   - el laberintoso
sala(guerrasEstelares, familiar(futurista, 7)).                                         %                   15  - escapepepe
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).        %                   3   - escapepepe
% 6)
sala(estrellasDePelea,familiar(videojuegos,7)).
% sala(choqueDeLaRealeza,familiar(videojuegos,_)). % no conozco la cantidad, no se pone?
sala(miseriaDeLaNoche,terrorifica(150,21)).

% 1) nivelDeDificultadDeLaSala/2: para cada sala nos dice su dificultad. 
nivelDeDificultadDeLaSala(NombreSala,Dificultad):-
    sala(NombreSala,Experiencia),
    dificultadExperiencia(Experiencia,Dificultad).

dificultadExperiencia(terrorifica(CantidadDeSustos,EdadMinima),Dificultad):-                    % Para las salas de experiencia terrorífica el nivel de dificultad es la cantidad de sustos menos la edad mínima para ingresar. 
Dificultad is CantidadDeSustos - EdadMinima.
dificultadExperiencia(familiar(futurista,_),15).                                                % Para las de experiencia familiar es 15 si es de una temática futurista
dificultadExperiencia(familiar(Tematica,CantidadDeHabitaciones),CantidadDeHabitaciones):-       % y para cualquier otra temática es la cantidad de habitaciones. 
    Tematica \= futurista.
dificultadExperiencia(enigmatica(Candados),Dificultad):-                                        % El de las enigmáticas es la cantidad de candados que tenga.
length(Candados,Dificultad).
    
% 2) puedeSalir/2: una persona puede salir de una sala si la dificultad de la sala es 1 o si tiene más de 13 años y la dificultad es menor a 5. En ambos casos la persona no debe ser claustrofóbica.
puedeSalir(Persona,Sala):-
    salaFacilPara(Sala,Persona),
    not(esClaustrofobica(Persona)).

esClaustrofobica(Persona):-
    persona(Persona,_,Peculiaridades),
    member(claustrofobia,Peculiaridades).

salaFacilPara(Sala,_):- 
    nivelDeDificultadDeLaSala(Sala,1).
salaFacilPara(Sala,Persona):- 
    esAdolescente(Persona), 
    nivelDeDificultadDeLaSala(Sala,Dificultad), 
    Dificultad < 5.

esAdolescente(Persona):-
    persona(Persona,Edad,_),
    Edad > 13.

% 3) tieneSuerte/2: una persona tiene suerte en una sala si puede salir de ella aún sin tener ninguna peculiaridad.
tieneSuerte(Persona,Sala):-
    puedeSalir(Persona,Sala),
    persona(Persona,_,[]).  % abstraccion?  noTienePeculiaridades(Persona):- persona(Persona,_,[]).

% 4) esMacabra/1: una empresa es macabra si todas sus salas son de experiencia terrorífica.
esMacabra(Empresa):-
    esSalaDe(_,Empresa),
    forall(esSalaDe(Sala,Empresa),sala(Sala,terrorifica(_,_))). % abstraccion esSalaTerrorifica(Sala):- sala(Sala,terrorifica(_,_)).

% 5) empresaCopada/1: una empresa es copada si no es macabra y el promedio de dificultad de sus salas es menor a 4.
empresaCopada(Empresa):-
    esSalaDe(_,Empresa),                           % ligo para que la empresa llegue ligada al promedio y esMacabra
    promedioDificultadSalas(Empresa,Promedio),
    Promedio < 4,
    not(esMacabra(Empresa)).

promedioDificultadSalas(Empresa,Promedio):-             % analogo dificultadTotalSalas
% esSalaDe(_,Empresa),                                % sobredelegacion  
dificultadTotalSalas(Empresa,TotalDificultad),      
    cantidadSalas(Empresa,CantidadSalas),
    Promedio is TotalDificultad / CantidadSalas.

dificultadTotalSalas(Empresa,TotalDificultad):- % como no esta generado la empresa, al preguntar existencialmene suma todas las dificultades. debe llegar Individual para Empresa en promedio
% esSalaDe(_,Empresa),                        % sobredelegacion , ligo la empresa solo en empresaCopada
    findall(Dificultad,tieneNivelDificultad(Empresa,Dificultad),Dificultades),
    sum_list(Dificultades,TotalDificultad).

tieneNivelDificultad(Empresa,Nivel):-
    esSalaDe(Sala,Empresa),
    nivelDeDificultadDeLaSala(Sala,Nivel).

cantidadSalas(Empresa,CantidadSalas):-          % analogo dificultadTotalSalas
    % esSalaDe(_,Empresa),                        % sobredelegacion
    findall(Sala,esSalaDe(Sala,Empresa),Salas),
    length(Salas,CantidadSalas).

/* 6) ¡Cada vez hay más salas y empresas! Conozcámoslas para agregarlas a nuestro sistema:
La empresa supercelula es dueña de salas de escape familiares ambientadas en videojuegos. 
La sala estrellasDePelea cuenta con 7 habitaciones pero lamentablemente no sabemos la cantidad que tiene su nueva sala choqueDeLaRealeza.
La empresa SKPista (fanática de un famoso escritor) es la dueña de una única sala terrorífica para mayores de 21 llamada miseriaDeLaNoche que nos asegura 150 sustos.
La nueva empresa que se suma a esta gran familia es Vertigo, pero aún no cuenta con salas.
*/

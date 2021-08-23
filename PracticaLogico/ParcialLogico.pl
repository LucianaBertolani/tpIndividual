% PdePePePePe                       https://docs.google.com/document/d/1G0t9xAB9iy2thod9FZG_-FGyNXqxy1YQ3lrdnjc6v1Q/edit#heading=h.cf7wcou1iav5
% ----------------------------------------------------------- BASE DE CONOCIMIENTOS ------------------------------------------------------------------------------------
%quedaEn(Boliche, Localidad)
quedaEn(pachuli, generalLasHeras).
quedaEn(why, generalLasHeras).
quedaEn(chaplin, generalLasHeras).
quedaEn(masDe40, sanLuis).
quedaEn(qma, caba).
quedaEn(trabajamosYNosDivertimos,concordia). % 7) 
quedaEn(finDelMundo,ushuaia).                % 7)

%entran(Boliche, CapacidadDePersonas)
entran(pachuli, 500).
entran(why, 1000).
entran(chaplin, 700).
entran(masDe40, 1200).
entran(qma, 800).
entran(trabajamosYNosDivertimos,500).       % 7)
entran(finDelMundo,1500).                   % 7)
entran(misterio,1000000).                   % 7)

%sirveComida(Boliche)
sirveComida(chaplin).
sirveComida(qma).
sirveComida(trabajamosYNosDivertimos).      % 7)
sirveComida(misterio).                      % 7)

%esDeTipo(Boliche, Tipo). Tipo: tematico(tematica) - cachengue(listaDeCancionesHabituales) - electronico(djDeLaCasa, horaQueEmpieza, horaQueTermina)
esDeTipo(why, cachengue([elYYo, prrrram, biodiesel, buenComportamiento])).
esDeTipo(masDe40, tematico(ochentoso)).
esDeTipo(qma, electronico(djFenich, 2, 5)).
esDeTipo(trabajamosYNosDivertimos,tematico(oficina)).       % 7)
esDeTipo(finDelMundo,electronico(djLuis,0,6)).              % 7)

% 1) esPiola/1: sabemos que un boliche es piola cuando queda en General Las Heras o cuando es grande, es decir, entran más de 700 personas. 
% En ambos casos es necesario que sirvan comida.
esPiola(Boliche):-
    sirveComida(Boliche),
    cuandoEsPiola(Boliche).

cuandoEsPiola(Boliche):-
    quedaEn(Boliche,generalLasHeras).
cuandoEsPiola(Boliche):-
    entranMuchasPersonas(Boliche).

entranMuchasPersonas(Boliche):-
    entran(Boliche,CapacidadDePersonas),
    CapacidadDePersonas > 700.

% 2) soloParaBailar/1: un boliche es solo para bailar cuando no sirve comida.
soloParaBailar(Boliche):-
    quedaEn(Boliche,_),
    not(sirveComida(Boliche)).

% 3) podemosIrConEsa/1: cuando decimos que podemos ir con una localidad es porque sabemos que todos sus boliches son piolas.
podemosIrConEsa(Localidad):-
    quedaEn(_,Localidad),
    forall(quedaEn(Boliche,Localidad),esPiola(Boliche)).

% 4) puntaje/2: nos permite relacionar un boliche con su puntaje. 
% Los boliches de temática ochentosa tienen un puntaje de 9 mientras que los otros temáticos tienen un puntaje de 7. 
% El puntaje de boliches electrónicos está dado por la suma de la hora en que empieza y deja de tocar el DJ. 
% Por último, los de cachengue son un 10 si suelen pasar biodiesel y buenComportamiento pero no sabemos el puntaje de los que no pasan estos temaikenes.
puntaje(Boliche,Puntaje):-
    % quedaEn(Boliche,_),   sobre generacion ? es de tipo ya es inversible
    esDeTipo(Boliche,TipoBoliche),
    puntajeSegunTipo(TipoBoliche,Puntaje).

puntajeSegunTipo(tematico(ochentoso),9).
puntajeSegunTipo(tematico(Tematica),7):-
    Tematica \= ochentoso.
puntajeSegunTipo(electronico(_,HoraQueEmpieza,HoraQueTermina),Puntaje):-
    Puntaje is HoraQueEmpieza + HoraQueTermina.
puntajeSegunTipo(cachengue(ListaDeCancionesHabituales),10):-
    suelePasar(biodiesel,ListaDeCancionesHabituales),
    suelePasar(buenComportamiento,ListaDeCancionesHabituales).

suelePasar(UnaCancion,ListaDeCancionesHabituales):-         % decido sobredelegar para que el nombre tenga mas que ver con el dominio del problema
    member(UnaCancion,ListaDeCancionesHabituales).         
   
% 5) elMasGrande/2: el boliche más grande de una localidad es aquel que tiene la mayor capacidad.
elMasGrande(Boliche,Localidad):-
    quedaEn(Boliche,Localidad),
    entran(Boliche,CapacidadDePersonas),
    forall((quedaEn(OtroBoliche,Localidad), entran(OtroBoliche, OtraCapacidad), OtroBoliche \= Boliche), CapacidadDePersonas > OtraCapacidad).

elMasGrandeV2(Boliche,Localidad):-              % ante empate, ambos boliches se consideran elMasGrande de una ciudad.
    quedaEn(Boliche,Localidad),                 % se reutiliza tieneCapacidad en el siguiente punto pero no se discrimina que compare boliches distintos
    entran(Boliche,CapacidadDePersonas),        % decido esta opcion
    forall(tieneCapacidad(Localidad,OtraCapacidad),CapacidadDePersonas >= OtraCapacidad).

elMasGrandeV3(Boliche,Localidad):-              % ante empate, ningun boliche es elMasGrande de una ciudad
    quedaEn(Boliche,Localidad),                 % si bien capacidadBolicheMismaCiudad se podria reutlizar en el siguiente punto, tiene parametros innecesarios 
    entran(Boliche,CapacidadDePersonas),        % discrimina comparacion de boliches distintos (diferencia con la otra version)
    forall((capacidadBolicheMismaCiudad(OtroBoliche,Localidad,OtraCapacidad), OtroBoliche \= Boliche), CapacidadDePersonas > OtraCapacidad).

capacidadBolicheMismaCiudad(OtroBoliche,Localidad,OtraCapacidad):-      % analogo a tieneCapacidad, discriminando boliche para poder diferenciar dps
   quedaEn(OtroBoliche,Localidad),                                      % parametros innecesarios para reutilizar en puedeAbastecer.
   entran(OtroBoliche, OtraCapacidad).
   % OtroBoliche \= Boliche.    % como lo relaciono sin pasar el boliche, me conviene multiples parametros en el antecedente o agregar mayor igual

% 6) puedeAbastecer/2: una localidad puede abastecer a una determinada cantidad de personas si la suma de capacidades de los boliches que quedan en ella es mayor o igual a esa cantidad.
puedeAbastecer(Localidad,CantidadDePersonas):-
    capacidadTotalBolichesEn(Localidad,CapacidadTotal),
    CapacidadTotal >= CantidadDePersonas.

capacidadTotalBolichesEn(Localidad,CapacidadTotal):-
    quedaEn(_,Localidad),
    findall(Capacidad,tieneCapacidad(Localidad,Capacidad),CapacidadesPosibles),
    sum_list(CapacidadesPosibles, CapacidadTotal).

tieneCapacidad(Localidad,Capacidad):-
    quedaEn(Boliche,Localidad),
    entran(Boliche,Capacidad).

/* 7) ¡Parame la música! ¡No pare, sigue sigue! 🎶 Se van a abrir más boliches y nos pidieron que reflejemos esta información en nuestra base de conocimientos:
"Trabajamos y nos divertimos" será un boliche de temática oficina en el que entran 500 personas. Se va a poder cenar en esta interesante propuesta de Concordia.
% quedaEn(trabajamosYNosDivertimos,concordia).
% entran(trabajamosYNosDivertimos,500).
% sirveComida(trabajamosYNosDivertimos).
% esDeTipo(trabajamosYNosDivertimos,tematico(oficina)).

"El fin del mundo" será el boliche más austral de la Argentina, con capacidad para 1500 personas. No se va a poder comer pero esto no interesa porque tendrá las vistas más lindas de Ushuaia y al DJ Luis tocando toda la noche: de 00 a 6 de la mañana.
% quedaEn(finDelMundo,ushuaia).
% entran(finDelMundo,1500).
% por universo cerrado no sirven comida no se representa
% esDeTipo(finDelMundo,electronico(djLuis,0,6)).

"Misterio" será el boliche más grande de Argentina, con capacidad para 1.000.000 de personas. La verdad es que no sabemos dónde se hará un boliche tan grande pero sí sabemos que se va a poder comer ahí mismo.
% por universo cerrado, las cosas que no se saben (donde queda misterio) se presumen falso
% entran(misterio,1000000).
% sirveComida(misterio).
% analogo a quedaEn, no se el tipo de misterio, considero falso.
*/
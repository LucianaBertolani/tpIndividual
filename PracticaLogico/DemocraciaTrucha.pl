% ENUNCIADO             https://docs.google.com/document/d/1bmljMbzGNfL5GyO_UC4QgqwcB-GfUAecW_ifXO36ltM/edit

% 1) CANDIDATOS Y PARTIDOS
candidato(rojo,frank,50).
candidato(rojo,claire,52).
candidato(rojo,catherine,59).
candidato(azul,garrett,64).
candidato(azul,linda,30).
candidato(amarillo,jackie,38).
candidato(amarillo,seth,_).%?
candidato(amarillo,heather,52).
candidato(not(amarillo),peter,26).%? No contempalos que pueda ser violeta xq no tienen candidatos.
%           ^^^^^^^^^   amarillo no es un predicado, no un parametro que acepta el not, COMO CARAJO COMPILA

% vs Version con lista de las pvcia y predicado para la cantidad de habitantes
postulaProvincia(azul,buenosAires,15355000).
postulaProvincia(azul,chaco,1143201).
postulaProvincia(azul,tierraDelFuego,160720).
postulaProvincia(azul,sanLuis,489255).
postulaProvincia(azul,neuquen,637913).
postulaProvincia(rojo,buenosAires,15355000).
postulaProvincia(rojo,santaFe,3397532).
postulaProvincia(rojo,cordoba,3567634).
postulaProvincia(rojo,chubut,577466).
postulaProvincia(rojo,tierraDelFuego,160720).
postulaProvincia(rojo,sanLuis,489255).
postulaProvincia(amarillo,chaco,1143201).
postulaProvincia(amarillo,formosa,527896).
postulaProvincia(amarillo,tucuman,1687305).
postulaProvincia(amarillo,salta,1333365).
postulaProvincia(amarillo,santaCruz,273964).
postulaProvincia(amarillo,laPampa,349299).
postulaProvincia(amarillo,corrientes,992595).
postulaProvincia(amarillo,misiones,1189446).
postulaProvincia(amarillo,buenosAires,15355000).
not(postulaProvincia(rojo,formosa,527896)). %? No se si hace falta xq lo que no se dice explicito no existe x universo cerrado mepa. estoy DE ACUERDO

% 2) PROVINCIA PICANTE
esPicante(Provincia):-
    postulaProvincia(UnPartido,Provincia,Habitantes),
    postulaProvincia(OtroPartido,Provincia,Habitantes),
    UnPartido \= OtroPartido, 
    Habitantes > 1000000.

% 3) PASO vs version sin repeticion logica para saber si una persona compiteEn una provincia y de qué partido.
intencionDeVotoEn(buenosAires, rojo, 40).
intencionDeVotoEn(buenosAires, azul, 30).
intencionDeVotoEn(buenosAires, amarillo, 30).
intencionDeVotoEn(chaco, rojo, 50).
intencionDeVotoEn(chaco, azul, 20).
intencionDeVotoEn(chaco, amarillo, 0).
intencionDeVotoEn(tierraDelFuego, rojo, 40).
intencionDeVotoEn(tierraDelFuego, azul, 20).
intencionDeVotoEn(tierraDelFuego, amarillo, 10).
intencionDeVotoEn(sanLuis, rojo, 50).
intencionDeVotoEn(sanLuis, azul, 20).
intencionDeVotoEn(sanLuis, amarillo, 0).
intencionDeVotoEn(neuquen, rojo, 80).
intencionDeVotoEn(neuquen, azul, 10).
intencionDeVotoEn(neuquen, amarillo, 0).
intencionDeVotoEn(santaFe, rojo, 20).
intencionDeVotoEn(santaFe, azul, 40).
intencionDeVotoEn(santaFe, amarillo, 40).
intencionDeVotoEn(cordoba, rojo, 10).
intencionDeVotoEn(cordoba, azul, 60).
intencionDeVotoEn(cordoba, amarillo, 20).
intencionDeVotoEn(chubut, rojo, 15).
intencionDeVotoEn(chubut, azul, 15).
intencionDeVotoEn(chubut, amarillo, 15).
intencionDeVotoEn(formosa, rojo, 0).
intencionDeVotoEn(formosa, azul, 0).
intencionDeVotoEn(formosa, amarillo, 0).
intencionDeVotoEn(tucuman, rojo, 40).
intencionDeVotoEn(tucuman, azul, 40).
intencionDeVotoEn(tucuman, amarillo, 20).
intencionDeVotoEn(salta, rojo, 30).
intencionDeVotoEn(salta, azul, 60).
intencionDeVotoEn(salta, amarillo, 10).
intencionDeVotoEn(santaCruz, rojo, 10).
intencionDeVotoEn(santaCruz, azul, 20).
intencionDeVotoEn(santaCruz, amarillo, 30).
intencionDeVotoEn(laPampa, rojo, 25).
intencionDeVotoEn(laPampa, azul, 25).
intencionDeVotoEn(laPampa, amarillo, 40). 
intencionDeVotoEn(corrientes, rojo, 30).
intencionDeVotoEn(corrientes, azul, 30).
intencionDeVotoEn(corrientes, amarillo, 10).
intencionDeVotoEn(misiones, rojo, 90).
intencionDeVotoEn(misiones, azul, 0).
intencionDeVotoEn(misiones, amarillo, 0).

% VERDADERO CUANDO: son del mismo partido y se presenta en la provincia. 
leGanaA(Ganador,Perdedor,Provincia):-
    Ganador \= Perdedor,
    candidato(Partido,Ganador,_),
    candidato(Partido,Perdedor,_),
    postulaProvincia(Partido,Provincia,_).

% VERDADERO CUANDO: partidos distintos, se presentan a la provincia y el partido del ganador tiene mas votos que el del perdedor.
leGanaA(Ganador,Perdedor,Provincia):-
    Ganador \= Perdedor,
    candidato(PartidoGanador,Ganador,_),
    candidato(PartidoPerdedor,Perdedor,_),
    postulaProvincia(PartidoGanador,Provincia,_),
    postulaProvincia(PartidoPerdedor,Provincia,_),
    intencionDeVotoEn(Provincia,PartidoGanador,PorcentajeGanador),
    intencionDeVotoEn(Provincia,PartidoPerdedor,PorcentajePerdedor),
    PartidoGanador \= PartidoPerdedor,
    PorcentajeGanador > PorcentajePerdedor.

% VERDADERO CUANDO: el partido del Ganador es el unico que se presenta a la provincia, y tienen distinto porcentaje (no empate)
leGanaA(Ganador,Perdedor,Provincia):-
    Ganador \= Perdedor,
    candidato(PartidoGanador,Ganador,_),
    candidato(PartidoPerdedor,Perdedor,_),
    postulaProvincia(PartidoGanador,Provincia,_),
    %not(postulaProvincia(PartidoPerdedor,Provincia,_)),
    intencionDeVotoEn(Provincia,PartidoGanador,PorcentajeGanador),
    intencionDeVotoEn(Provincia,PartidoPerdedor,PorcentajePerdedor),
    PorcentajeGanador \= PorcentajePerdedor,
    PartidoGanador \= PartidoPerdedor.
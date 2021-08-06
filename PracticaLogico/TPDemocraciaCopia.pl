% ENUNCIADO             https://docs.google.com/document/d/1bmljMbzGNfL5GyO_UC4QgqwcB-GfUAecW_ifXO36ltM/edit

% 1) CANDIDATOS Y PARTIDOS
candidato(rojo,frank,50).
candidato(rojo,claire,52).
candidato(rojo,catherine,59).
candidato(azul,garrett,64).
candidato(azul,linda,30).
candidato(amarillo,jackie,38).
% candidato(amarillo,seth).
candidato(amarillo,heather,52).
candidato(not(amarillo),peter,26).%? No contempalos que pueda ser violeta xq no tienen candidatos.
%           ^^^^^^^^^   amarillo no es un predicado, no un parametro que acepta el not, COMO CARAJO COMPILA
cantidadHabitantesProvincia(buenosAires,15355000).
cantidadHabitantesProvincia(chaco,1143201).
cantidadHabitantesProvincia(tierraDelFuego,160720).
cantidadHabitantesProvincia(sanLuis,489255).
cantidadHabitantesProvincia(neuquen,637913).
cantidadHabitantesProvincia(santaFe,3397532).
cantidadHabitantesProvincia(cordoba,3567654).
cantidadHabitantesProvincia(chubut,577466).
cantidadHabitantesProvincia(formosa,527895).
cantidadHabitantesProvincia(tucuman,1687305).
cantidadHabitantesProvincia(salta,1333365).
cantidadHabitantesProvincia(santaCruz,273964).
cantidadHabitantesProvincia(laPampa,349299).
cantidadHabitantesProvincia(corrientes,992595).
cantidadHabitantesProvincia(misiones,1189446).

postulaProvincia(azul,[buenosAires,chaco,tierraDelFuego,sanLuis,neuquen]).
postulaProvincia(rojo,[buenosAires,santaFe,cordoba,chubut,tierraDelFuego,sanLuis]).
postulaProvincia(amarillo,[chaco,formosa,tucuman,salta,santaCruz,laPampa,corrientes,misiones,buenosAires]).

perteneceA(Provincia,Partido):-
  postulaProvincia(Partido,Listaprovincia),
  member(Provincia,Listaprovincia).

% 2) PROVINCIA PICANTE
esPicante(Provincia):-
    perteneceA(Provincia,UnPartido),
    perteneceA(Provincia,OtroPartido),
    cantidadHabitantesProvincia(Provincia,Habitantes),
    UnPartido \= OtroPartido,
    Habitantes > 1000000.
    
/* repeticion logica -> delegacion predicado perteneceA
esPicante(Provincia)
    postulaProvincia(UnPartido,Listaprovincia1),
    member(Provincia,Listaprovincia1),
    postulaProvincia(OtroPartido,Listaprovincia2),
    member(Provincia,Listaprovincia2),
    cantidadHabitantesProvincia(Provincia,Habitantes),
    UnPartido \= OtroPartido, 
    Habitantes > 1000000.
*/   

% 3) PASO
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

% SE PODRIA SACAR EL ARGUMENTO DEL PARTIDO???.    
compiteEn(Persona,Provincia,Partido):-
  candidato(Partido,Persona,_),
  perteneceA(Provincia,Partido).

leGanaA(Ganador,Perdedor,Provincia):-
    compiteEn(Ganador,Provincia,_),
    not(compiteEn(Perdedor,Provincia,_)).

leGanaA(Ganador,Perdedor,Provincia):-
    compiteEn(Ganador,Provincia,UnPartido),
    compiteEn(Perdedor,Provincia,UnPartido),
    intencionDeVotoEn(Provincia,UnPartido,_).

leGanaA(Ganador,Perdedor,Provincia):-
    compiteEn(Ganador,Provincia,UnPartido),
    compiteEn(Perdedor,Provincia,OtroPartido),
    intencionDeVotoEn(Provincia,UnPartido,UnPorcentaje),
    intencionDeVotoEn(Provincia,OtroPartido,OtroPorcentaje),
    UnPorcentaje > OtroPorcentaje.

/* PREDICADOS 
candidato(Partido,Nombre,Edad)
postulaProvincia(Partido,ListaProvincia)
perteneceA(Provincia,Partido)
cantidadHabitantes(Provincia,Cantidad)
intencionDeVotoEn(Provincia, Partido, Porcentaje)
compiteEn(Persona,Provincia,Partido)
esPicante(Provincia)
leGanaA(Ganador,Perdedor,Provincia)
*/  

% 4) EL GRAN CANDIDATO
/*
Se pide realizar elGranCandidato/1. Un candidato es el gran candidato si se cumple:
Para todas las provincias en las cuales su partido compite, el mismo gana.
Es el candidato más joven de su partido
El único gran candidato es Frank. ¿Cómo podemos estar seguros de esto? ¿Qué tipo de consulta deberíamos realizar? ¿Con qué concepto está relacionado?

teniendo en cuenta las provincias en las que compite un partido: 
Tiene que ganar Algun participante de ese partido en esa provincia, 
sin importar a quien le gana 
*/
esElMasJoven(UnCandidato):-
    candidato(UnPartido,UnCandidato,Edad),
    forall(candidato(UnPartido,_,OtraEdad),(Edad =< OtraEdad)).

% 5) MALAS CONSULTORAS
/*La consultora cometió un error al pasarnos los resultados de las encuestas. Para eso, realizaremos el predicado ajusteConsultora/3, el cual relaciona un partido, una provincia y el verdadero porcentaje de votos, los cuales se ajustarán de la siguiente manera:

Si el partido, según la intención de voto, ganaba en la provincia, se le resta 20%.
En otro caso, se le suma 5%

Por ejemplo
La intención de voto del partido rojo en Buenos Aires quedaría en 20
La intención de voto del partido azul en Neuquén quedaría en 15

Si ahora quisiéramos evaluar todos los predicados con los valores reales de votos, ¿Qué cambios deberíamos hacer? ¿Cuántos predicados deberíamos modificar?
*/

% 6) PROMESAS DE CAMPAÑA
% promete(Partido,PromesaCampaña)
promete(azul,construir([edilicio(hospital,1000),edilicio(jardin,100),edilicio(escuela,5)])).
promete(azul,inflacion(2,4)).
promete(amarillo,construir([edilicio(hospital,100),edilicio(universidad,1),edilicio(comisaria,200)])).
promete(amarillo,nuevosPuestosDeTrabajo(10000)).
promete(amarillo,inflacion(1,15)).
promete(rojo,nuevosPuestosDeTrabajo(800000)).
promete(rojo,inflacion(10,30)).

% 7) AJUSTES DE BOCA DE URNA
/* Para la inflación, la intención de votos disminuirá de manera directamente proporcional al 
promedio de las cotas de la promesa realizada.
En cuanto a los nuevos puestos de trabajo, si se promete realizar más de 50.000 nuevos puestos, 
sumará 3%. En el resto de los casos no sumará nuevos votos al partido.
Por último, las construcciones impactarán según el edilicio a construir:
hospitales: sin importar la cantidad, suma 2%.
jardines y escuelas: suma 0,1% por cada edilicio.
comisarías: suma 2% si se construyen exactamente 200.
universidades: la  descree que un partido construya una universidad, por ende no suma.
cualquier otro edilicio resta un 1% porque la población lo considera un gasto innecesario.
*/
influenciaDePromesas(Promesa,VariacionVotos):-
    promete(_,Promesa),
    ajusteSegunPromesa(Promesa,VariacionVotos).

ajusteSegunPromesa(inflacion(CotaInferior,CotaSuperior),Ajuste):-
    promete(_,inflacion(CotaInferior,CotaSuperior)),
    promedio(CotaInferior,CotaSuperior,PromedioInflacion),
    Ajuste is - PromedioInflacion.

ajusteSegunPromesa(nuevosPuestosDeTrabajo(Cantidad),3):-
    promete(_,nuevosPuestosDeTrabajo(Cantidad)),
    Cantidad > 50000.
% si es menor esta okey que responda false o deberia responder por 0
% otra cantidad : ajusteSegun(nuevosPuestosDeTrabajo(Cantidad),0) es necesario para parcial inversible?

ajusteSegunPromesa(construir(ListaEdilicios),Variacion):-
    promete(_,construir(ListaEdilicios)),
    findall(Valor,(member(Edilicio,ListaEdilicios),variacionEdilicia(Edilicio,Valor)),ListaVariaciones),
    sumlist(ListaVariaciones,Variacion).

variacionEdilicia(edilicio(hospital,_),2). % rompe inversibilidad por variable anonima
variacionEdilicia(edilicio(jardin,Cantidad),Variacion):- Variacion is Cantidad * 0.1.
variacionEdilicia(edilicio(escuela,Cantidad),Variacion):- Variacion is Cantidad * 0.1.
variacionEdilicia(edilicio(comisaria,200),2).
% variacionEdilicia(edilicio(universidad,_),0). 
% variacionEdilicia(edilicio(otro,_),-1).

gastoNecesario(hospital).
gastoNecesario(jardin).
gastoNecesario(escuela).
gastoNecesario(comisaria).
gastoNecesario(universidad).
% NO INVERSIBLE
promedio(UnValor,OtroValor,Resultado):-
    Resultado is (UnValor + OtroValor)/2.

% 8) NUEVOS VOTOS
promedioDeCrecimiento(Partido,Promedio):-
    promete(Partido,_),
    findall(VariacionVotos,(promete(Partido,Promesa),influenciaDePromesas(Promesa,VariacionVotos)),VariacionesVoto),
    sumlist(VariacionesVoto,Promedio).

% delegar condiciones findall en punto 7 y 8, lineas 203 y 226
% Syntax error: operator expected 212,91
% revisar variacionEdilicia -1 si es edilicio considerado gasto innecesario
% revisar edad candidato seth (se desconoce) como variable anonima rompe en predicado esElMasJoven
% revisar candidato peter no se postula amarillo, se postula al resto?
% Falta punto 4 y 5
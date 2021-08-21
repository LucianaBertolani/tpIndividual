% REY DE LOS PIRATAS                https://drive.google.com/file/d/1RNw-4BhmNBFoDtvZEt658UQxSvAzM5md/view?usp=sharing
% Posible solucion                  https://github.com/pdep-mit/ejemplos-de-clase-prolog/blob/master/clase6.pl

% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
/* Tripulacion sombreroDePaja 
impactoEnRecompensa(luffy,arlongPark,30000000).     % 30 millones
impactoEnRecompensa(luffy,baroqueWorks,70000000).   % 70 millones
impactoEnRecompensa(luffy,eniesLobby,200000000).    % 200 millones
impactoEnRecompensa(luffy,marineford,100000000).    % 100 millones
impactoEnRecompensa(luffy,dressrosa,100000000).     % 100 millones
impactoEnRecompensa(zoro, baroqueWorks, 60000000).  % 60 millones
impactoEnRecompensa(zoro, eniesLobby, 60000000).    % 60 millones
impactoEnRecompensa(zoro, dressrosa, 200000000).    % 200 millones
impactoEnRecompensa(nami, eniesLobby, 16000000).    % 16 millones
impactoEnRecompensa(nami, dressrosa, 50000000).     % 50 millones
impactoEnRecompensa(ussop, eniesLobby, 30000000).   % 30 millones
impactoEnRecompensa(ussop, dressrosa, 170000000).   % 170 millones
impactoEnRecompensa(sanji, eniesLobby, 77000000).   % 77 millones
impactoEnRecompensa(sanji, dressrosa, 100000000).   % 100 millones
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
% Tripulacion heart
impactoEnRecompensa(law, sabaody, 200000000).       % 200 millones
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).    % 240 millones
impactoEnRecompensa(law, dressrosa, 60000000).      % 60 millones
impactoEnRecompensa(bepo,sabaody,500).
% Tripulacion piratasDeArlong
impactoEnRecompensa(arlong, llegadaAEastBlue,20000000). % 20 millones
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).   % 3 mil */

% NUMEROS MAS FACILES DE COMPROBAR
% Tripulacion sombreroDePaja
impactoEnRecompensa(luffy,arlongPark,300).    
impactoEnRecompensa(luffy,baroqueWorks,700).  
impactoEnRecompensa(luffy,eniesLobby,2000).    
impactoEnRecompensa(luffy,marineford,1000).    
impactoEnRecompensa(luffy,dressrosa,1000).     
impactoEnRecompensa(zoro, baroqueWorks, 600). 
impactoEnRecompensa(zoro, eniesLobby, 600).   
impactoEnRecompensa(zoro, dressrosa, 2000).    
impactoEnRecompensa(nami, eniesLobby, 160).   
impactoEnRecompensa(nami, dressrosa, 500).    
impactoEnRecompensa(ussop, eniesLobby, 300).  
impactoEnRecompensa(ussop, dressrosa, 1700).   
impactoEnRecompensa(sanji, eniesLobby, 770).  
impactoEnRecompensa(sanji, dressrosa, 1000).   
impactoEnRecompensa(chopper, eniesLobby, 5).
impactoEnRecompensa(chopper, dressrosa, 10).
% Tripulacion heart
impactoEnRecompensa(law, sabaody, 2000).       
impactoEnRecompensa(law, descorazonamientoMasivo,2400).    
impactoEnRecompensa(law, dressrosa, 600).     
impactoEnRecompensa(bepo,sabaody,50).
% Tripulacion piratasDeArlong
impactoEnRecompensa(arlong, llegadaAEastBlue,200).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 300).   


/* De vez en cuando, la recompensa de un pirata puede aumentar a partir de ciertos eventos que la Marina y el Gobierno Mundial consideran importantes, 
por eso registramos cuál fue el impacto de distintos eventos sobre su recompensa, siendo la suma de todos esos montos la recompensa actual por su captura. */
precioCabeza(Pirata,Recompensa):-
    tripulante(Pirata,_),
    findall(Monto,impactoEnRecompensa(Pirata,_,Monto),Montos),
    sum_list(Montos,Recompensa).

/* 1) Relacionar a dos tripulaciones y un evento si ambas participaron del mismo, lo cual sucede si dicho evento impactó en la recompensa de al menos un pirata de cada tripulación. Por ejemplo:
- Debería cumplirse para las tripulaciones heart y sombreroDePaja siendo dressrosa el evento del cual participaron ambas tripulaciones.
- No deberían haber dos tripulaciones que participen de llegadaAEastBlue, sólo los piratasDeArlong participaron de ese evento. */
participaronDe(UnaTripulacion,OtraTripulacion,Evento):-
    afectaTripulacion(Evento,UnaTripulacion),
    afectaTripulacion(Evento,OtraTripulacion),
    UnaTripulacion \= OtraTripulacion.

afectaTripulacion(Evento,Tripulacion):-
    tripulante(UnTripulante,Tripulacion),
    impactoEnRecompensa(UnTripulante,Evento,_).

% 2) Saber quién fue el pirata que más se destacó en un evento, en base al impacto que haya tenido su recompensa. En el caso del evento de dressrosa sería Zoro, porque su recompensa subió en $200.000.000. 
pirataMasDestacado(PirataDestacado,Evento):-
    impactoEnRecompensa(PirataDestacado,Evento,MaxRecompensa),
    forall(impactoEnRecompensa(_,Evento,Recompensa),Recompensa =< MaxRecompensa). % para toda recompensa del evento, la del pirata mas destacado es la mayor

pirataMasDestacadoV2(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    not((impactoEnRecompensa(_, Evento, OtraRecompensa), OtraRecompensa > Recompensa)). % no existe otra recompensa y que esta sea mayor a la del pirata mas destacado

/* 3) Saber si un pirata pasó desapercibido en un evento, que se cumple si su recompensa no se vio impactada por dicho evento a pesar de que su tripulación participó del mismo.
Por ejemplo esto sería cierto para Bepo para el evento dressrosa, pero no para el evento sabaody por el cual su recompensa aumentó, ni para eniesLobby porque su tripulación no participó.*/
pasoDesapercibido(Pirata,Evento):-
    tripulante(Pirata,Tripulacion),
    afectaTripulacion(Evento,Tripulacion),
    not(impactoEnRecompensa(Pirata,Evento,_)).

% 4) Saber cuál es la recompensa total de una tripulación, que es la suma de las recompensas actuales de sus miembros.
recompensaTotal(Tripulacion,Total):-
    tripulante(_,Tripulacion),
    findall(Recompensa,aumentaRecompensa(Tripulacion,Recompensa),Recompensas),
    sum_list(Recompensas,Total).

aumentaRecompensa(Tripulacion,Recompensa):-
    tripulante(Tripulante,Tripulacion),
    precioCabeza(Tripulante,Recompensa).

% 5) Saber si una tripulación es temible. Lo es si todos sus integrantes son peligrosos o si la recompensa total de la tripulación supera los $500.000.000.  ($5000)
% Consideramos peligrosos a piratas cuya recompensa actual supere los $100.000.000. ($1000)
esTripulacionTemible(Tripulacion):-
    tripulante(_,Tripulacion),
    forall(tripulante(Pirata,Tripulacion),esPirataPeligrosoSegunPrecioCabeza(Pirata)).
esTripulacionTemible(Tripulacion):-
    recompensaTotal(Tripulacion,Total),
    Total > 5000.       % Total > 500000000

esPirataPeligrosoSegunPrecioCabeza(Pirata):-
    precioCabeza(Pirata,Precio),
    Precio > 1000.      % Precio > 100000000

/* 6)
Necesitamos agregar a nuestro programa un elemento fundamental: las frutas del diablo.
Son unas valiosas frutas místicas que se encuentran dispersas en el mundo y pueden otorgar al consumidor interesantes habilidades en función de la fruta que se coma. 
La desventaja que dan todas las frutas a quienes las consuman es que no podrán nadar nunca más, lo cual es bastante problemático si pasás tu vida luchando arriba de un barco.
Las frutas del diablo se categorizan en tres tipos: paramecia, zoan y logia. Cada fruta a su vez tiene un nombre asociado, como se muestra en los datos que necesitamos 
representar más adelante, pero más allá de eso son muy distintas entre ellas. A continuación se detallan sus particularidades:
- Paramecia: da al consumidor un poder único que puede afectar tanto a su cuerpo, como a la manipulación del entorno.
Como las habilidades que podrían otorgar a quienes coman estas frutas son demasiado variadas, se debe indicar para cada fruta paramecia si es peligrosa o no.
- Zoan: permite al consumidor transformarse en una especie de animal que varía de una fruta a otra. Una fruta de tipo zoan se considera peligrosa si la especie en cuestión es feroz.
Al día de hoy sabemos que las especies feroces que se pueden conseguir comiendo la fruta zoan adecuada son: lobo, leopardo y anaconda.
Aclaración: Pueden haber varias frutas de este tipo con el mismo nombre, ya que se usa el mismo nombre para toda una familia de especies, no para una especie concreta, 
con lo cual podría ser que una fruta zoan se considere peligrosa y otra no, a pesar de que se las llame de la misma forma.
- Logia: da a su consumidor la capacidad de transformarse en un elemento natural. Una de las ventajas de este poder es que el consumidor se vuelve prácticamente inmune 
a ataques físicos, por eso todas las frutas de este tipo son peligrosas.

Sabemos que:
- Luffy comió la fruta gomugomu de tipo paramecia, que no se considera peligrosa.
- Buggy comió la fruta barabara de tipo paramecia, que no se considera peligrosa.
- Law comió la fruta opeope de tipo paramecia, que se considera peligrosa.
- Chopper comió una fruta hitohito de tipo zoan que lo convierte en humano.
- Nami, Zoro, Ussop, Sanji, Bepo, Arlong y Hatchan no comieron frutas del diablo.
- Lucci comió una fruta nekoneko de tipo zoan que lo convierte en leopardo.
- Smoker comió la fruta mokumoku de tipo logia que le permite transformarse en humo.
*/
% comio(Pirata,TipoFruta) Tipo = paramecia(Nombre, PeligrosaSioNO) ; zoan(Nombre, EspecieAnimal) ; logia(Nombre, ElementoNatural)
comio(luffy,paramecia(gomugomu,segura)).
comio(buggy,paramecia(barabara,segura)).
comio(law,paramecia(opeope,peligrosa)).
comio(chopper,zoan(hitohito,humano)).
comio(lucci,zoan(nekoneko,leopardo)).
comio(smoker,logia(mokumoku,humo)).

esPeligrosa(FrutaDelDiablo):- esTipoPeligroso(TipoFruta).

esTipoPeligroso(paramecia(_,peligrosa)).
esTipoPeligroso(zoan(_,EspecieAnimal)):- especieFeroz(EspecieAnimal).
esTipoPeligroso(logia(_,_)).

especieFeroz(lobo).
especieFeroz(leopardo).
especieFeroz(anaconda).

% a) Necesitamos modificar la funcionalidad anterior, porque ahora hay otra forma en la cual una persona puede considerarse peligrosa: alguien que comió una fruta peligrosa se considera
% peligroso, independientemente de cuál sea el precio sobre su cabeza.
esPirataPeligrosoSegunFrutaDelDiablo(Pirata):-
    comio(Pirata,FrutaDelDiablo),
    esPeligrosa(FrutaDelDiablo).

% b) Justificar las decisiones de modelado tomadas para cumplir con lo pedido, tanto desde el punto de vista de la definición como del uso de los nuevos predicados. 
%%% No se pedía, pero porque surgio la duda
nombreDeFruta(paramecia(Nombre,_), Nombre).
nombreDeFruta(zoan(Nombre, _), Nombre).
nombreDeFruta(logia(Nombre, _), Nombre).

piratasDeAsfalto(Tripulacion):-
  tripulante(_, Tripulacion),
  not((tripulante(Pirata, Tripulacion),
      puedeNadar(Pirata))).

puedeNadar(Persona):- not(comio(Persona, _)).

piratasDeAsfaltoV2(Tripulacion):-
  tripulante(_,Tripulacion),
  forall(tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata))).

% El Kisokito  2020                https://docs.google.com/document/d/1RNgFMlSqOKiwe9SEi1U2cQjCmdFfWNflqycSfp7Qa-w/edit#heading=h.8z5fk89ui0rg
% Posible solucion (not found)      https://github.com/pdep-mn-utn/parcial-kioskito-pl

% 1) CALENTANDO MOTORES
atiende(dodain,lunes,9,15).
atiende(dodain,miercoles,9,15).
atiende(dodain,viernes,9,15).
atiende(lucas,martes,10,20).
atiende(juanC,sabados,18,22).
atiende(juanC,domingos,18,22).
atiende(juanFdS,jueves,10,20).
atiende(juanFdS,viernes,12,20).
atiende(leoC,lunes,14,18).
atiende(leoC,miercoles,14,18).
atiende(martu,miercoles,23,24).
atiende(vale,Dia,Inicio,Fin):-
  comparteCon(UnaPersona),
  atiende(UnaPersona,Dia,Inicio,Fin).

comparteCon(dodain).
comparteCon(juanC).

% 2) QUIÉN ATIENDE EL KIOSKO
atendidoPor(Dia,Hora,Persona):-
  atiende(Persona,Dia,Inicio,Fin),
  between(Inicio,Fin,Hora).

% 3) FOREVER ALONE
foreverAlone(Persona,Dia,Hora):-
  atendidoPor(Dia,Hora,Persona),
  not(atiendenJuntos(Persona,_,Dia,Hora)).

atiendenJuntos(UnaPersona,OtraPersona,Dia,Hora):-
  atendidoPor(Dia,Hora,UnaPersona),
  atendidoPor(Dia,Hora,OtraPersona),
  UnaPersona \= OtraPersona.

/* 
foreverAlonePrimerIntento(UnaPersona,Dia,Hora):-
  % atiende(UnaPersona,_,_,_),
  atendidoPor(Dia,Hora,UnaPersona),
  forall(atiende(OtraPersona,_,_,_),not(atendidoPor(Dia,Hora,OtraPersona))).

foreverAloneLara(UnaPersona,Dia,Hora):-
  atendidoPor(_,_,UnaPersona),                                                  
  forall(atendidoPor(Dia,Hora,UnaPersona),not(atendidoPor(Dia,Hora,_))). 

- Como funciona foreverAloneLara
primero se liga la variable Persona con un individuo, ej: julli
antecedente: se encuentran todas las formas de probar que esto sea cierto (se generan todos los días y horas en los que atiende juli)           
consecuente: para cada día y hora en los que atiende juli, comprueba que exista alguien que _no_ atiende en ese día y hora  

LO QUE EN REALIDAD SE QUIERE SABER: es que para una persona en un día y hora, saber si no existe alguien más que atienda en ese horario (dia y hora particular). 
- Entonces: la persona que queremos saber si es foreverAlone tiene que atender en ese día y hora particular. Por eso se LIGA dia, hora y persona.
- Después:  para saber es si no existe alguien más que atienda en ese horario se podría hacer un predicado atiendenJuntos/4
que relacione a una persona con otra persona que trabaja junto a ella en un día y hora en particular
- De esa forma podemos decir que alguien es foreverAlone si atiende en un día y horario y no existe alguien que atienda junto a esa persona (desarrollo en funcionamiento)

antecedente siempre falso para el caso de prueba (salvo lucas), entonces no importa el consecuente es verdadero para todos los que no son Lucas. 
*/

% 4) POSIBILIDADES DE ATENCIÓN
% Dado un dia, queremos relacionar qué personas podrían estar atendiendo el kisko en algun momento de ese día. 
% Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día. 
% Por ejemplo si preguntamos por el miercoles tiene que darnos estas combinatoria:
    % nadie
    % dodain solo
    % dodain y leo
    % dodain , vale, martu, leoC
    % vale y martu,
    % etc
    % no puede aparecer lucas, por ejemplo, porque no atiende el miércoles
posibilidadesAtencion(Dia,Personas):-
  atiende(_,Dia,_,_),
  findall(Persona,atiende(Persona,Dia,_,_),Personas).
% no coincidden combinaciones: ?- posibilidadesAtencion(miercoles,Quien). --> Quien = [dodain, leoC, martu, vale] ;

posibilidadesAtencion2(Dia,Equipo):-
  atiende(_,Dia,_,_),
  findall(Persona,atiende(Persona,Dia,_,_),Personas),
  subset(Equipo,Personas).    % no inversible para primer argumento

posibilidadesAtencion3(Dia,Equipo):-
  atiende(_,Dia,_,_),
  findall(Persona,atiende(Persona,Dia,_,_),Personas),
  subConjunto(Personas,Equipo).

subConjunto(_, []). 
subConjunto([X|L], [A|NTail]):- 
    member(A,[X|L]),  
    subConjunto(L, NTail), 
    not(member(A, NTail)). 

% 5) VENTAS / SUERTUDAS
% golosina(Valor)
% cigarrillos(MarcasVendidas)
% bebidas(alcoholica?,cantidad)
venta(dodain,lunes10,[golosinas(1200),cigarrillos([jockey]),golosinas(50)]).
venta(dodain,miercoles12,[bebidas(alcoholica,8),bebidas(noAlcoholica,1),golosinas(10)]).
venta(martu,miercoles12,[golosinas(1000),cigarrillos([chesterfield,colorado,parisiennes])]).
venta(lucas,martes11,[golosinas(600)]).
venta(lucas,martes18,[bebidas(noAlcoholica,2),cigarrillos([derby])]).

vendedorSuertudo(Vendedor):-
  venta(Vendedor,_,_),
  forall(venta(Vendedor,_,Ventas),primerVentaImportante(Ventas)).

primerVentaImportante(Ventas):-
  nth1(1,Ventas,Venta),
  ventaImportante(Venta).

ventaImportante(golosinas(Valor)):- Valor > 100.
ventaImportante(cigarrillos(MarcasVendidas)):- length(MarcasVendidas,Cantidad),Cantidad > 2.
ventaImportante(bebidas(alcoholica,Cantidad)):- Cantidad > 5.

/* INTENTO SIN REPETICION LOGICA
 1) Calentando motores
rangoHorario(dodain,9,15).
rangoHorario(lucas,10,20).
rangoHorario(juanC,18,22).
rangoHorario(juanFdS,10,20).
rangoHorario(juanFdS,12,20).
rangoHorario(leoC,14,18).
rangoHorario(martu,23,24).
rangoHorario(vale,Inicio,Fin)
  comparteCon(UnaPersona),
  rangoHorario(UnaPersona,Inicio,Fin).

diaAtencion(dodain,lunes).
diaAtencion(dodain,miercoles).
diaAtencion(dodain,viernes).
diaAtencion(lucas,martes).
diaAtencion(juanC,sabado).
diaAtencion(juanC,domingo).
diaAtencion(juanFdS,jueves) rangoHorario(juanFdS,10,20). % aunque separe responde jueves 12,20
diaAtencion(juanFdS,viernes) rangoHorario(juanFdS,12,20).
diaAtencion(leoC,lunes).
diaAtencion(leoC,miercoles).
diaAtencion(martu,miercoles).
diaAtencion(vale,Dia)
  comparteCon(UnaPersona),
  diaAtencion(UnaPersona,Dia).

comparteCon(dodain).
comparteCon(juanC).

 nadie hace el mismo horario que leoC y 
maiu esta pensando si hace el horario de 0 a 8 los martes y miercoles,
no es necesario hacer nada por universo cerrado. 

 2) Quien atiende el kiosko
atendidoPor(Dia,Hora,Persona)
  diaAtencion(Persona,Dia),
  rangoHorario(Persona,Inicio,Fin),
  between(Inicio,Fin,Hora).
 NO FUNCIONA si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes. 
 Responde todos los dias que atiende por no estar relacionado las personas que comparte entre el rangoHorario y diaAtencion.
*/

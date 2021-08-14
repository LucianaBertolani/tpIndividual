% El Kisokito  2020                https://docs.google.com/document/d/1RNgFMlSqOKiwe9SEi1U2cQjCmdFfWNflqycSfp7Qa-w/edit#heading=h.8z5fk89ui0rg
% Posible solucion (not found)      https://github.com/pdep-mn-utn/parcial-kioskito-pl

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

atendidoPor(Dia,Hora,Persona):-
  atiende(Persona,Dia,Inicio,Fin),
  between(Inicio,Fin,Hora).

foreverAlone(UnaPersona,Dia,Hora):-
  atendidoPor(UnaPersona,Dia,Hora),
  forall(atiende(OtraPersona,_,_,_),not(atendidoPor(Dia,Hora,OtraPersona))).
% no funciona dodain: el lunes a las 10 dodain no está forever alone, porque vale también está

posibilidadesAtencion(Dia,Personas):-
  atendidoPor(Dia,Hora,_),
  findall(Persona,atendidoPor(Dia,Hora,Persona),Personas).
% no coincidden combinaciones

% golosina(Valor)
% cigarrillos(MarcaVendida)
% bebidas(alcoholica?,cantidad)

venta(dodain,lunes10,[golosinas(1200),cigarrillos([jockey]),golosinas(50)).
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

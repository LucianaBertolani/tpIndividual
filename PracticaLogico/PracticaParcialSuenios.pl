% SUEÑOS        https://docs.google.com/document/d/1QcIfJEvOb-oxIFH4jeXEfiVTgMFQa00V0nvF11wIEAg/edit

% 1) 
creeEn(gabriel,campanita).
creeEn(gabriel,elMagoDeOz).
creeEn(gabriel,cavenaghi).
creeEn(juan,conejoDePascua).
creeEn(macarena,reyesMagos).
creeEn(macarena,magoCapria).
creeEn(macarena,campanita).
% Por universo cerrado, "Diego no cree en nadie" no se define

% tipoSueños: cantante(CantidadDiscos)  ; futbolista(Equipo)                ; ganarLoteria(SerieNumeros)
% tipoSueño(cantante,CantidadDiscos)    ; tipoSueño(futbolista,Equipo)      ; tipoSueño(ganarLoteria,SerieNumeros)
suenia(gabriel,ganarLoteria([5,9])).
suenia(gabriel,futbolista(arsenal)).
suenia(juan,cantante(100000)).
suenia(macarena,cantante(10000)).
% Por universo cerrado, "Macarena no quiere ganar la loteria", no se define.

% 2) 
/* Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. 
La dificultad de cada sueño se calcula como: 
- 6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
- ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
- lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
Casos de prueba:
Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y quiere ser futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. 
En cambio Juan y Macarena tienen 4 puntos de dificultad (cantantes con menos de 500.000 discos) */
esAmbiciosa(Persona):-
    creeEn(Persona,_),
    dificultadTotalSuenios(Persona,DificultadSuenios),
    DificultadSuenios > 20.

dificultadTotalSuenios(Persona,DificultadSuenios):-
    findall(Dificultad,(suenia(Persona,Suenio),dificultadSuenio(Suenio,Dificultad)),Dificultades),
    sum_list(Dificultades,DificultadSuenios).

condicionFindall(Persona,Dificultad):-  % PENSAR nombre mejor
    suenia(Persona,Suenio),
    dificultadSuenio(Suenio,Dificultad).

dificultadSuenio(cantante(CantidadDiscos),6):- 
    CantidadDiscos > 500000.
dificultadSuenio(cantante(CantidadDiscos),4):- 
    CantidadDiscos =< 500000.
dificultadSuenio(ganarLoteria(SerieNumeros),Dificultad):- 
    length(SerieNumeros,CantidadNumerosApostados),    
    Dificultad is CantidadNumerosApostados * 10.
dificultadSuenio(futbolista(Equipo),3):- 
    esEquipoChico(Equipo).
dificultadSuenio(futbolista(Equipo),16):- 
    not(esEquipoChico(Equipo)).

esEquipoChico(arsenal).
esEquipoChico(aldosivi).

/* 3) Queremos saber si un personaje tiene química con una persona. Esto se da
si la persona cree en el personaje y...
para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
para el resto, 
todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
y la persona no debe ser ambiciosa

No puede utilizar findall en este punto. El predicado debe ser inversible para todos sus argumentos.
CASOS PRUEBA:
Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, que es un sueño de dificultad 3 - menor a 5), 
y los Reyes Magos, el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa. */
tieneQuimica(Personaje,Persona):-
    creeEn(Persona,Personaje),
    cumpleCondicionPersonaje(Persona,Personaje).

cumpleCondicionPersonaje(Persona,campanita):-       % PENSAR OTRO NOMBRE
    suenia(Persona,Suenio),
    dificultadSuenio(Suenio,Dificultad),
    Dificultad < 5.

cumpleCondicionPersonaje(Persona,Personaje):-
    Personaje \= campanita,
    forall(suenia(Persona,Suenio),esSuenioPuro(Suenio)),
    not(esAmbiciosa(Persona)).

esSuenioPuro(futbolista(_)).
esSuenioPuro(cantante(CantidadDiscos)):- CantidadDiscos < 200000.

/* 4) Sabemos que
Campanita es amiga de los Reyes Magos y del Conejo de Pascua
el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
si una persona tiene algún sueño
el personaje tiene química con la persona y...
el personaje no está enfermo
o algún personaje de backup no está enfermo. 
Un personaje de backup es un amigo directo o indirecto del personaje principal

Debe evitar repetición de lógica. El predicado debe ser totalmente inversible. Debe considerar cualquier nivel de amistad posible (la solución debe ser general).
Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo de Cavenaghi que no está enfermo.
*/
amigo(campanita,reyesMagos). % campanita es amiga de reyesMagos
amigo(campanita,conejoDePascua).
amigo(conejoDePascua,cavenaghi).

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).

puedeAlegrarA(Personaje,Persona):-
    suenia(Persona,_),
    tieneQuimica(Personaje,Persona),
    circuloSano(Personaje).

circuloSano(Personaje):-
    not(estaEnfermo(Personaje)).
circuloSano(Personaje):-
    % personajeBackUpDe(OtroPersonaje,Personaje),
    amigosDirectosOIndirectos(Personaje,OtroPersonaje),
    not(estaEnfermo(OtroPersonaje)).
 
amigosIndirectos(UnaPersona, OtraPersona):-
    amigo(UnaPersona, UnIntermediario),
    amigosDirectosOIndirectos(UnIntermediario, OtraPersona).
    
amigosDirectosOIndirectos(UnaPersona, OtraPersona):-
    amigo(UnaPersona, OtraPersona).
    
amigosDirectosOIndirectos(UnaPersona, OtraPersona):-
    amigosIndirectos(UnaPersona, OtraPersona).

/* ERROR EN ORDEN DE ALGUN PARAMETRO, NO ENTIENDO CUÁL
personajeBackUpDe(BackUp,Personaje):-
    amigo(Personaje,BackUp).
personajeBackUpDe(BackUp,Personaje):-
    amigoIndirectamente(Personaje,BackUp).

amigoIndirectamente(BackUp,Personaje):-
    amigo(BackUp,Intermediario),
    personajeBackUpDe(Intermediario,Personaje),
    Personaje \= BackUp. */

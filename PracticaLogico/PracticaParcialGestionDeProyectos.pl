% GESTION DE PROYECTOS                              https://drive.google.com/file/d/1PfqfkonA8cNS56bvPfvxekF37zTUceS4/view

% tarea(nombre, duracion, tareasAnterioresRequeridas). tareaOpcional(nombre, cantidadPersonas, duracion).
proyecto(saeta, tarea(planificacion, 3, [])).
proyecto(saeta, tarea(encuesta, 5, [planificacion])).
proyecto(saeta, tarea(analisis, 5, [encuesta])).
proyecto(saeta, tarea(limpieza, 3, [planificacion])).
proyecto(saeta, tarea(disenio, 6, [analisis])).
proyecto(saeta, tarea(construccion, 5, [disenio, limpieza])).
proyecto(saeta, tarea(ejecucion, 4, [construccion])).
proyecto(saeta, tareaOpcional(presentacion, 4, 10)).

/* % mis ejemplos
proyecto(lateka, tarea(planificacion, 3, [])).
proyecto(lateka, tarea(encuesta, 5, [planificacion])).
proyecto(lateka, tarea(disenio, 6, [analisis])).
proyecto(lateka, tarea(construccion, 5, [disenio, limpieza])).
proyecto(lateka, tareaOpcional(presentacion, 4, 10)).*/

proyecto(larguirucho,tarea(planificacion, 100, [])).
proyecto(larguirucho,tarea(encuesta,6, [planificacion])).
proyecto(larguirucho,tarea(analisis, 9, [])).

% En los puntos que mencionan una “tarea”, se hace referencia a los functores completos y no solo a su nombre. Se necesita realizar los predicados que permitan:
% 1) Relacionar dos tareas del mismo proyecto, de forma tal que la segunda sea siguiente de la primera.
antecede(Anterior,Siguiente):-
  pertenecenAlMismoProyecto(Anterior,Siguiente),
  sonConsecutivas(Anterior,Siguiente).

pertenecenAlMismoProyecto(UnaTarea,OtraTarea):-
    proyecto(Proyecto,UnaTarea),
    proyecto(Proyecto,OtraTarea),
    UnaTarea \= OtraTarea.

sonConsecutivas(tarea(UnNombre,_,_),tarea(_,_,TareasAnterioresRequeridas)):-
    member(UnNombre,TareasAnterioresRequeridas).

/* 2) Saber si una tarea es pesada, que son aquellas cuya duración es mayor a 5 o tienen más de una tarea requerida anterior. 
También son pesadas las tareas opcionales que son para una persona sola. En el ejemplo, son pesadas las tareas presentación, diseño y construcción. */
esTareaPesada(Tarea):-
    proyecto(_,Tarea),
    segunCondicion(Tarea).

segunCondicion(Tarea):- duracionTarea(Tarea,Duracion),Duracion > 5.
segunCondicion(tarea(_,_,TareasAnterioresRequeridas)):- length(TareasAnterioresRequeridas,Cantidad) , Cantidad > 1.
segunCondicion(tareaOpcional(_,1,_)).

% 3) Saber si una tarea es final, inicial o intermedia (final es cuando no tiene tareas siguientes, inicial cuando no tiene anteriores, intermedia las otras.
clasificacionTarea(Tarea,Tipo):-
    proyecto(_,Tarea),
    tipoTarea(Tarea,Tipo).

tipoTarea(Tarea,final):-
    noTieneSiguiente(Tarea).
tipoTarea(Tarea,inicial):-
    noTieneAnterior(Tarea).
tipoTarea(Tarea,intermedia):-
    antecede(_,Tarea),
    antecede(Tarea,_).

noTieneSiguiente(Tarea):- 
    antecede(_,Tarea),    % para que no cuente las opcionales. Sin esta las opcionales son finales
    not(antecede(Tarea,_)).
noTieneAnterior(tarea(_,_,[])).

% 4) Relacionar dos tareas del mismo proyecto con un camino que las une. El camino es una lista de tareas, cada una siguiente a la anterior, que tiene como extremos a las tareas indicadas.
camino(TareaInicial,TareaFinal,Camino):-
    pertenecenAlMismoProyecto(TareaInicial,TareaFinal),
    findall(Tarea,(antecede(TareaInicial,Tarea),antecede(Tarea,TareaFinal)),Medio),
    agregarExtremos(TareaInicial,TareaFinal,Medio,Camino).

camino2(TareaInicial,TareaFinal,Camino):-                   % LISTA INFINITA?
    pertenecenAlMismoProyecto(TareaInicial,TareaFinal),
    findall(Tarea,(antecedeDirectaOIndirectaMente(Tarea,TareaFinal),not(antecede(Tarea,TareaInicial))),Medio),
    agregarExtremos(TareaInicial,TareaFinal,Medio,Camino).

agregarExtremos(ExtremoInicial,ExtremoFinal,Lista,ListaConExtremos):-
    append([ExtremoInicial],Lista,InicioMedio),
    append(InicioMedio, [ExtremoFinal], ListaConExtremos).

% 5) Determinar si un camino es pesado. Lo es cuando todas sus tareas son pesadas y tiene una duración de más de 100.
esCaminoPesado(Camino):-                
    % camino(TareaInicial,TareaFinal,Camino),       COMO INVERSIBILIZAR ???
    forall(member(Tarea,Camino),esTareaPesada(Tarea)),
    esCaminoLargo(Camino).

esCaminoLargo(Camino):-
    duracionCamino(Camino,Duracion),
    Duracion > 100.

duracionCamino(Camino,Total):-
    findall(Duracion,(member(Tarea,Camino),duracionTarea(Tarea,Duracion)),Duraciones),
    sum_list(Duraciones,Total).

duracionTarea(tarea(_,Duracion,_),Duracion).
duracionTarea(tareaOpcional(_,_,Duracion),Duracion).
% tarea(nombre, duracion, tareasAnterioresRequeridas). tareaOpcional(nombre, cantidadPersonas, duracion).
% ejemplo camino [tarea(planificacion, 100, []), tarea(encuesta,6, [planificacion]), tarea(analisis, 9, [encuesta])]
    
% 6). Relacionar a una tarea con la cantidad de tareas anteriores que tiene, en todos los niveles posibles (anterior directa, anterior a la anterior, etc... ¡ojo con las repetidas!). 
% Por ejemplo, analisis tiene 2 y construcción tiene 5.
cantidadDeTareasAnteriores(Tarea,CantidadDeTareasAnteriores):-
    proyecto(_,Tarea),
    findall(TareaAnterior,antecedeDirectaOIndirectaMente(TareaAnterior,Tarea),TareasAnteriores),
    list_to_set(TareasAnteriores,TareasAnterioresSinRepetir),
    length(TareasAnterioresSinRepetir,CantidadDeTareasAnteriores).

antecedeDirectaOIndirectaMente(Anterior,Siguiente):-
    antecede(Anterior,Siguiente).
antecedeDirectaOIndirectaMente(Anterior,Siguiente):-
    antecedeIndirectamente(Anterior,Siguiente).

antecedeIndirectamente(Anterior,Siguiente):-
    antecede(Intermediario,Siguiente),
    antecedeDirectaOIndirectaMente(Anterior,Intermediario).
 
% 7) Relacionar un proyecto con su camino crítico y su duración. El camino crítico es aquel de máxima duración entre los que van desde un nodo inicial hasta un nodo final.
relacionProyectoCaminoCriticoYDuracion(Proyecto,CaminoCritico,Duracion):-          % pensar nombre mejor
    tieneCaminoCritico(Proyecto,CaminoCritico),
    duracionCamino(CaminoCritico,Duracion).

tieneCaminoCritico(Proyecto,CaminoCritico):-
    proyecto(Proyecto,_),
    noTieneAnterior(NodoInicial),
    noTieneSiguiente(NodoFinal),
    pertenecenAlMismoProyecto(NodoInicial,NodoFinal),
    camino(NodoInicial,NodoFinal,CaminoCritico),
    duracionCamino(CaminoCritico,DuracionCritica),
    forall((camino(NodoInicial,NodoFinal,Camino),duracionCamino(Camino,Duracion)), Duracion =< DuracionCritica).


/* 8. Saber si un proyecto es coherente, que es cuando hay al menos una tarea final y una tarea inicial, no hay tareas sueltas 
(una tarea es suelta si no es siguiente ni anterior de ninguna otra, ni tampoco es opcional) y hay alguna tarea pesada.
Se cuenta con un predicado sinRepetidos/2 que relaciona una lista con otra lista con los mismos elementos que la primera, pero una sola vez cada uno. */
esCoherente(Proyecto):-
    proyecto(Proyecto,_),
    noTieneAnterior(TareaInicial),
    noTieneSiguiente(TareaFinal),
    pertenecenAlMismoProyecto(TareaInicial,TareaFinal),
    not(esTareaSuelta(_)),
    esTareaPesada(_).

esTareaSuelta(Tarea):-
    proyecto(_,Tarea),
    noTieneSiguiente(Tarea),
    noTieneAnterior(Tarea),
    Tarea \= tareaOpcional(_,_,_).

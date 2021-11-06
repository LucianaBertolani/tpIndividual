% PULP FICTION              https://docs.google.com/document/d/15mo_2391atBqMjcYzLtKvGG6JiPzjbeyEGVlwZjv4B8/edit#
% Guia 12 mumuki 

/* Tarantino, un poco cansado después de largas horas de filmación de su clásico noventoso Pulp Fiction, decidió escribir un programa Prolog para entender mejor las 
relaciones entre sus personajes. Para ello nos entregó la siguiente base de conocimientos sobre sus personajes, parejas y actividades:*/
personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

pareja(marsellus, mia).
pareja(mia,marsellus).
pareja(pumkin,    honeyBunny).
pareja(honneyBunny,pumpkin).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules,vincent).
amigo(jules, jimmie).
amigo(jummie,jules).
amigo(vincent, elVendedor).
amigo(elVendedor,vincent).

%encargo(Solicitante, Encargado, Tarea). las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

% 1) esPeligroso/1. Nos dice si un personaje es peligroso. Eso ocurre cuando: realiza alguna actividad peligrosa: ser matón, o robar licorerías. O bien, tiene empleados peligrosos
esPeligroso(Personaje):-
    personaje(Personaje,Actividad),
    actividadPeligrosa(Actividad).
    
esPeligroso(Personaje):-
   trabajaPara(Personaje,Empleado),
   esPeligroso(Empleado).
    
actividadPeligrosa(mafioso(maton)).
actividadPeligrosa(ladron(Lista)):-
    member(licorerias,Lista).

% 2) duoTemible/2 que relaciona dos personajes cuando son peligrosos y además son pareja o amigos. 
duoTemible(UnPersonaje,OtroPersonaje):-
    esPeligroso(UnPersonaje),
    esPeligroso(OtroPersonaje),
    relacionPeligrosa(UnPersonaje,OtroPersonaje).

relacionPeligrosa(UnPersonaje,OtroPersonaje):-
    amigo(UnPersonaje,OtroPersonaje).
relacionPeligrosa(UnPersonaje,OtroPersonaje):-
   pareja(UnPersonaje,OtroPersonaje).
    
% 3) estaEnProblemas/1: un personaje está en problemas cuando el jefe es peligroso y le encarga que cuide a su pareja o bien, tiene que ir a buscar a un boxeador. 
% Además butch siempre está en problemas. Ejemplo: ? estaEnProblemas(vincent) > yes. porque marsellus le pidió que cuide a mia, y porque tiene que ir a buscar a butch
estaEnProblemas(butch).
estaEnProblemas(Personaje):-
  trabajaPara(Jefe,Personaje), 
  esPeligroso(Jefe),
  encargo(Jefe,Personaje,cuidar(Persona)),      % delegar
  pareja(Jefe,Persona).
  
estaEnProblemas(Personaje):-
  personaje(Personaje,_), 
  encargo(_,Personaje,buscar(Persona,_)),       % delegar, para abstraer en un unico predicado (ademas del hecho) estaEnProblemas
  personaje(Persona,boxeador).

% 4) sanCayetano/1:  es quien a todos los que tiene cerca les da trabajo (algún encargo). Alguien tiene cerca a otro personaje si es su amigo o empleado. 
sanCayetano(Santo):-
    encargo(Santo,_,_), % porque al menos tiene que dar algun encargo
    forall(estaCercaDe(OtraPersona,Santo),leDaTrabajo(Santo,OtraPersona)).
    
estaCercaDe(UnaPersona,OtraPersona):-
   amigo(UnaPersona,OtraPersona).
estaCercaDe(UnaPersona,OtraPersona):-
   trabajaPara(OtraPersona,UnaPersona).
leDaTrabajo(UnaPersona,OtraPersona):-
   encargo(UnaPersona,OtraPersona,_).
    
% es san cayetano si no existe empleado que no reciba un encargo de el

% 5) masAtareado/1. Es el más atareado aquel que tenga más encargos que cualquier otro personaje.
elMasAtareado(Personaje):-
    cantidadEncargos(Personaje,Valor),
    forall(cantidadEncargos(_,OtroValor),Valor >= OtroValor).
  
cantidadEncargos(UnPersonaje,Valor):-
   personaje(UnPersonaje,_),
   findall(Tarea,encargo(_,UnPersonaje,Tarea),ListaTarea),
   length(ListaTarea,Valor).

/* 6) personajesRespetables/1: genera la lista de todos los personajes respetables. Es respetable cuando su actividad tiene un nivel de respeto mayor a 9. Se sabe que:
Las actrices tienen un nivel de respeto de la décima parte de su cantidad de peliculas.
Los mafiosos que resuelven problemas tienen un nivel de 10 de respeto, los matones 1 y los capos 20.
Al resto no se les debe ningún nivel de respeto. */
personajesRespetables(ListaPersonajes):-
    findall(Personaje,esRespetable(Personaje),ListaPersonajes).
    
esRespetable(Personaje):-
   personaje(Personaje,Actividad),
   nivelRespeto(Actividad,Valor),
   Valor > 9.
    
nivelRespeto(actriz(Peliculas),Valor):-
   length(Peliculas,CantPeliculas),
   Valor is CantPeliculas / 10.
nivelRespeto(mafioso(resuelveProblemas),10).
nivelRespeto(mafioso(maton),1).
nivelRespeto(mafioso(capo),20).

% 7) hartoDe/2: un personaje está harto de otro, cuando todas las tareas asignadas al primero requieren interactuar con el segundo (cuidar, buscar o ayudar) o un amigo del segundo. Ejemplo:
% ? hartoDe(winston, vincent). > true  winston tiene que ayudar a vincent, y a jules, que es amigo de vincent. 
hartoDe(P1, P2):-
  personaje(P1, _), 
  personaje(P2, _), 
  forall(encargo(_, P1, T), seRelacionaCon(T, P2)).

% como evitar repeticion de logica???
seRelacionaCon(cuidar(P2), P2).
seRelacionaCon(cuidar(A), P2):-amigo(A, P2).
seRelacionaCon(buscar(P2), P2).
seRelacionaCon(buscar(A), P2):-amigo(A, P2).
seRelacionaCon(ayudar(P2), P2).
seRelacionaCon(ayudar(A), P2):-amigo(A, P2).

% 8) Desarrollar duoDiferenciable/2, que relaciona a un dúo (dos amigos o una pareja) en el que uno tiene al menos una característica que el otro no. Las caracteristicas nos ayuda a diferenciarlos cuando están de a dos.
duoDiferenciable(UnPersonaje,OtroPersonaje):-
    relacionPeligrosa(UnPersonaje,OtroPersonaje),
    complementanCaracteristicas(UnPersonaje,OtroPersonaje).
    
complementanCaracteristicas(UnPersonaje,OtroPersonaje):-
   caracteristicas(UnPersonaje,UnaLista),
   caracteristicas(OtroPersonaje,OtraLista),
   member(Caracteristica,UnaLista),
   not(member(Caracteristica,OtraLista)).
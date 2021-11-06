% VOCALOID                  https://docs.google.com/document/d/1xbXPZnhwyK5FSHR_oaXU4esfkTd2S-jf3rH1XLw864M/edit
% Posible solucion https://docs.google.com/document/d/1RAvv1IpmmV9wneiLabE6LNo42JAMWxuYWvZd5TYq4vU/edit

% a) BASE CONOCIMIENTO
% sabeCantar(NombreVocaloid,cancion(Titulo,MinutosDuracion)).
sabeCantar(megurineLuka,cancion(nightFever,4)).    
sabeCantar(megurineLuka,cancion(foreverYoung,5)).
sabeCantar(hatsuneMiku,cancion(tellYourWorld,4)). 
sabeCantar(gumi,cancion(foreverYoung,4)).         
sabeCantar(gumi,cancion(tellYourWorld,5)).         
sabeCantar(seeU,cancion(novemberRain,6)).
sabeCantar(seeU,cancion(nightFever,5)).
% kaito no sabe cantar, universo cerrado, no es necesario definir       


% 1) (...) necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.
esNovedoso(Vocaloid):-
    sabeAlMenosDosCanciones(Vocaloid),          
    duracionTotalCanciones(Vocaloid,Duracion),
    Duracion < 15.

sabeAlMenosDosCanciones(Vocaloid):-             % sabeAlMenosDosCancionesV2(Vocaloid):-
    sabeCantar(Vocaloid,UnaCancion),            %      cantaNCanciones(Vocaloid,N),
    sabeCantar(Vocaloid,OtraCancion),           %       N >= 2.
    UnaCancion \= OtraCancion.                  % reutiliza predicado mas adelante

duracionTotalCanciones(Vocaloid,DuracionTotal):-
    % sabeCantar(Vocaloid,_),   % sobregeneracion 
    findall(Duracion,sabeCantar(Vocaloid,cancion(_,Duracion)),Duraciones),
    sum_list(Duraciones,DuracionTotal).

% 2) (...) se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2.
esAcelerado(Vocaloid):-
  sabeCantar(Vocaloid,_),
  forall(sabeCantar(Vocaloid,Cancion),esCancionCorta(Cancion)).

esAcelerado2(Vocaloid):-
    sabeCantar(Vocaloid,_),
    not((sabeCantar(Vocaloid,Cancion),not(esCancionCorta(Cancion)))).

esCancionCorta(cancion(_,Duracion)):- Duracion =< 4.

% 3) Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.
/* Tipos de conciertos: 
- gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y además la duración total de todas las canciones 
tiene que ser mayor a una cantidad dada.
- mediano sólo pide que la duración total de las canciones del cantante sea menor a una 	cantidad determinada.
- pequeño el único requisito es que alguna de las canciones dure más de una cantidad dada.
Conciertos:
- Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, le brinda 2000 de fama al vocaloid que pueda participar en él y 
pide que el vocaloid sepa más de 2 canciones y el tiempo mínimo de 6 minutos.	
- Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y pide saber más de 3 canciones por cantante 
con un tiempo total mínimo de 10 minutos. 
- Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama y exige un tiempo máximo total de 9 minutos.	
- Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al vocaloid que participe en él, 
con la condición de que sepa una o más canciones de más de 4 minutos.
*/
% concierto(Nombre,PaisLugarARealizarse,CantidadFama,TipoConcierto).    
%                                                   TipoConcierto: gigante(CantMinCanciones,DuracionTotalMin) ; mediano(DuracionTotalMax) ; pequeño(DuracionMinAlgunaCancion)
concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).
concierto(magicalMirai,japon,3000,gigante(3,10)).
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,pequenio(4)).
% en caso de que un nombre de concierto pueda realizarse en distintos lugares con distinta fama, separar el tipo de concierto segun el nombre

% 4) Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. 
% También sabemos que Hatsune Miku puede participar en cualquier concierto.
puedeParticipar(hatsuneMiku,_).     % responde sin nombreConcierto, es correcto?
puedeParticipar(Vocaloid,NombreConcierto):-
    sabeCantar(Vocaloid,_),
    concierto(NombreConcierto,_,_,TipoConcierto),
    cumpleRequisitosTipoConcierto(Vocaloid,TipoConcierto).

cumpleRequisitosTipoConcierto(Vocaloid,gigante(CantMinCanciones,DuracionTotalMin)):-
  cantaNCanciones(Vocaloid,CantN),
  CantN >= CantMinCanciones,
  duracionTotalCanciones(Vocaloid,DuracionTotal),
  DuracionTotal > DuracionTotalMin.

cumpleRequisitosTipoConcierto(Vocaloid,mediano(DuracionTotalMax)):-
    duracionTotalCanciones(Vocaloid,DuracionTotal),
    DuracionTotal < DuracionTotalMax.

cumpleRequisitosTipoConcierto(Vocaloid,pequenio(AlgunaDuracionMin)):-
  sabeCantar(Vocaloid,cancion(_,Duracion)),
  Duracion > AlgunaDuracionMin.

cantaNCanciones(Vocaloid,NCanciones):-
  findall(Cancion,sabeCantar(Vocaloid,Cancion),Canciones),
  length(Canciones,NCanciones).
    
/* 5) Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como 
la fama total que le dan los conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar. */
elMasFamoso(Vocaloid):-
    % sabeCantar(Vocaloid,_), % sin esta clausula existencial responde true, con esta clausula false. genero en nivelDeFama(inversible TTO)
    nivelDeFama(Vocaloid,UnNivel),
    forall(nivelDeFama(_,OtroNivel),UnNivel >= OtroNivel).

nivelDeFama(Vocaloid,Nivel):-
    sabeCantar(Vocaloid,_),
    cantaNCanciones(Vocaloid,NCanciones),
    sumatoriaFama(Vocaloid,FamaTotal),    
    Nivel is FamaTotal * NCanciones.

sumatoriaFama(Vocaloid,FamaTotal):-
    findall(Fama,ganaFama(Vocaloid,Fama),Famas),
    list_to_set(Famas,SinRepetidos),
    sum_list(SinRepetidos,FamaTotal).

ganaFama(Vocaloid,Fama):-
    puedeParticipar(Vocaloid,NombreConcierto),
    concierto(NombreConcierto,_,Fama,_).

% 6) Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea directo o indirectos 
%       (en cualquiera de los niveles) participa en el mismo concierto. Sabiendo que:
conoceA(megurineLuka,hatsuneMiku).
conoceA(megurineLuka,gumi).
conoceA(gumi,seeU).
conoceA(seeU,kaito).

unicoParticipante(Vocaloid,Concierto):-
    puedeParticipar(Vocaloid,Concierto),
    forall(conoceDirectaOInderactamenteA(Vocaloid,OtroVocaloid),not(puedeParticipar(OtroVocaloid,Concierto))).

conoceIndirectamenteA(UnaPersona, OtraPersona):-
    conoceA(UnaPersona, UnIntermediario),
    conoceDirectaOInderactamenteA(UnIntermediario, OtraPersona).
    
conoceDirectaOInderactamenteA(UnaPersona, OtraPersona) :-
    conoceA(UnaPersona, OtraPersona).
    
conoceDirectaOInderactamenteA(UnaPersona, OtraPersona) :-
    conoceIndirectamenteA(UnaPersona, OtraPersona).
/*
"conocer a alguien" tiene caracter transitivo.
Pensé en tratar de decirle a prolog que conoceA/2 es transitiva de la siguiente forma:
conoceA(UnaPersona, OtraPersona):-
    conoceA(UnaPersona, UnIntermediario),
    conoceA(UnIntermediario, OtraPersona).
pero esta definicion me da una jaqueca recursiva de las feas, donde puede haber una cadena gigante de "intermediarios" entre las dos personas, y cuando lo pruebo revienta el stack.
RTA: 
En vez de darle el mismo nombre que usamos para los hechos lo definimos en un predicado separado y nos aseguramos de que cuando hace un llamado recursivo 
lo hace siempre con sus argumentos instanciados. (version en funcionamiento)
*/

/* 7) Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, 
explique los cambios que habría que realizar para que siga todo funcionando. ¿Qué conceptos facilitaron dicha implementación?
- Los cambios suficientes para agregar un nuevo tipo de concierto y que siga funcionando, seria agregar una clausula al predicado cumpleRequisitosTipoConcierto,
donde se determinen las condiciones que sean necesarias para que un cantante o vocaloid pueda participar de la misma. Esto es posible gracias al polimorfismo y pattern matching.
No importa la forma que tenga el tipo de concierto, cuando un concierto coincida por pattern matching con este nuevo tipo de concierto, se analizarán las condiciones definidas de este.
*/
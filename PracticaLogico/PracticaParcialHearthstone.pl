% HEARTHSTONE            https://docs.google.com/document/d/1a8RMmT8wsOAsPunOmL_Rgdg-eSBBoB2VJ_AqexdzcgY/edit

/* FUNCTORES
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% cartas
criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
hechizo(Nombre, FunctorEfecto, CostoMana)

% efectos
danio(CantidadDaño)
cura(CantidadCura)
*/
% PREDICADOS AUXILIARES
nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

% 1) Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.
tieneCarta(Jugador,Carta):-
    todasLasCartas(Jugador,TotalCartas),
    member(Carta,TotalCartas).
    
todasLasCartas(Jugador,TotalCartas):-
    cartasMazo(Jugador,CartasMazo),
    cartasMano(Jugador,CartasMano),
    cartasCampo(Jugador,CartasCampo),
    append(CartasMazo, CartasMano, CartasMazoyMano),
    append(CartasCampo,CartasMazoyMano,TotalCartas).
    
% 2) Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene, ya sea en el mazo, la mano o el campo, son criaturas.
esGuerrero(Jugador):-
    nombre(Jugador,_),
    forall(tieneCarta(Jugador,Carta),esCriatura(Carta)).

esCriatura(Carta):-
    nombre(criatura(_,_,_,_),_).

% 3) Relacionar un jugador consigo mismo después de empezar el turno. Al empezar el turno, la primera carta del mazo pasa a estar en la mano y el jugador gana un punto de maná.
turno(JugadorAT,JugadorDT):-            % AT antes del turno        DT despues del turno
    levantarCarta(JugadorAT,JugadorDT,Carta),
    guardarCartaEnMano(JugadorAT,JugadorDT,Carta),
    ganarPuntosMana(JugadorAT,JugadorDT,1).

levantarCarta(JugadorAT,JugadorDT,PrimeraCarta):-
    cartasMazo(JugadorAT,CartasMazoAT),
    nth1(1,CartasMazoAT,PrimeraCarta),
    subtract(CartasMazoAT, PrimeraCarta, CartasMazoDT),
    cartasMazo(JugadorDT,CartasMazoDT).

guardarCartaEnMano(JugadorAT,JugadorDT,Carta):-
    cartasMano(JugadorAT,CartasManoAT),
    append([Carta],CartasManoAT,CartasManoDT),
    cartasMano(JugadorDT,CartasManoDT).

ganarPuntosMana(JugadorAT,JugadorDT,Cantidad):-
    mana(JugadorAT,PuntosAT),
    PuntosDT is Cantidad + PuntosAT,
    mana(JugadorDT,PuntosDT).

% 4) Cada jugador, en su turno, puede jugar cartas.
% a- Saber si un jugador tiene la capacidad de jugar una carta, esto es verdadero cuando el jugador tiene igual o más maná que el costo de maná de la carta. (Este predicado no necesita ser inversible)
puedeJugarCarta(Jugador,Carta):-
    mana(Jugador,ManaJugador),
    mana(Carta,ManaCarta),
    ManaJugador >= ManaCarta.

% b- Relacionar un jugador y las cartas que va a poder jugar en el próximo turno, una carta se puede jugar en el próximo turno si tras empezar ese turno está en la mano y además se cumplen las condiciones del punto 4.a.
vaAPoderJugar(Jugador,Cartas):-
    nombre(Jugador,_),
    findall(Carta,(tieneCartaEnMano(Jugador,Carta),puedeJugarCarta(Jugador,Carta)),Cartas).

tieneCartaEnMano(Jugador,Carta):-           % revisar logica repetida tieneCartaEnAlgunLado
    cartasMano(Jugador,CartasEnMano),
    member(Carta,CartasEnMano).

/* 5) Conocer, de un jugador, todas las posibles jugadas que puede hacer en el próximo turno, esto es, el conjunto de cartas que podrá jugar al mismo tiempo 
sin que su maná quede negativo.
Nota: Se puede asumir que existe el predicado jugar/3 como se indica en el punto 7.b. No hace falta implementarlo para resolver este punto. 
Importante: También hay formas de resolver este punto sin usar jugar/3. 
Tip: Pensar en explosión combinatoria. */
combinacionesPosiblesDeJugada(Jugador,Combinacion):-
    vaAPoderJugar(Jugador,Cartas),
    conjuntoPartes(Cartas,Combinacion),
    puedeJugarCombinacion(Jugador,Combinacion).

% conjuntoPartes(Conjunto,Particiones)
% puedeJugarCombinacion(Jugador,Combinacion):-
%    mana(Jugador,ManaAT),
%    pierdePuntosMana(Combinacion,PuntosPerdidos),
%    ganarPuntosMana(Jugador,JugadorDT, -PuntosPerdidos),
%    mana(JugadorDT,ManaDT),
%    ManaDT >= 0.

% 6) Relacionar a un jugador con el nombre de su carta más dañina.
cartaMasDanina(Jugador,NombreCartaDanina):-
    nombre(CartaMasDanina,NombreCartaDanina),
    tieneCarta(Jugador,CartaMasDanina),
    danio(CartaMasDanina,Danio),
    forall((tieneCarta(Jugador,OtraCarta),danio(OtraCarta,OtroDanio)), Danio >= OtroDanio).

% 7) Cuando un jugador juega una carta, él mismo y/o su rival son afectados de alguna forma:
/* a- jugarContra/3. Modela la acción de jugar una carta contra un jugador. 
Relaciona a la carta, el jugador antes de que le jueguen la carta y el jugador después de que le jueguen la carta. 
Considerar que únicamente afectan al jugador las cartas de hechizo de danio.
Este predicado no necesita ser inversible para la carta ni para el jugador antes de que le jueguen la carta. */

/* b- BONUS: jugar/3. Modela la acción de parte de un jugador de jugar una carta. 
Relaciona a la carta, el jugador que puede jugarla antes de hacerlo y el mismo jugador después de jugarla. 
En caso de ser un hechizo de cura, se aplicará al jugador y no a sus criaturas. No involucra al jugador rival (para eso está el punto a). */
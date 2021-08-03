-- MINIGOLFITO                              https://docs.google.com/document/d/1LeWBI6pg_7uNFN_yzS2DVuVHvD0M6PTlG1yK0lCvQVE/edit                    (Enunciado)
--                                          https://app.mural.co/t/pdepmit6138/m/pdepmit6138/1591559094493/12d95ec7414b17ab985d71857eb35c1894b541c0 (Solucion)
module Lib where
import Text.Show.Functions ()

-- Modelo inicial
data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

type Puntos = Int
type Palo = Habilidad -> Tiro 
type Palos = [Palo]
type Obstaculo = Tiro -> Tiro

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

{-
También necesitaremos modelar los palos de golf que pueden usarse y los obstáculos que deben enfrentar para ganar el juego.

Sabemos que cada palo genera un efecto diferente, por lo tanto elegir el palo correcto puede ser la diferencia entre ganar o perder el torneo.

Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.
El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.
La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, 
la precisión dividida por n y una altura de n-3 (con mínimo 0). Modelarlos de la forma más genérica posible.
Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.ffFF
-}
modificarVelocidad :: Int -> Tiro -> Tiro
modificarVelocidad nuevaVelocidad unTiro  =  unTiro {velocidad = nuevaVelocidad}

modificarPrecision :: (Int -> Int) -> Tiro -> Tiro
modificarPrecision funcion unTiro  =  unTiro {precision = funcion.precision $ unTiro}
 
modificarAltura :: Int -> Tiro -> Tiro
modificarAltura nuevaAltura unTiro = unTiro {altura = nuevaAltura}

elPutter:: Palo 
elPutter unaHabilidad = UnTiro{velocidad = 10, precision = ((*2).precisionJugador $ unaHabilidad) , altura= 0}
--elPutter unaHabilidad = modificarVelocidad 10.modificarPrecision ((*2).precisionJugador $ unaHabilidad).modificarAltura 0 

laMadera:: Palo
laMadera unaHabilidad = UnTiro{velocidad = 100,altura= 5, precision= div (precisionJugador unaHabilidad) 2}

elHierro:: Int -> Palo
elHierro n unaHabilidad = UnTiro {velocidad = (*n).fuerzaJugador $ unaHabilidad , precision = div (precisionJugador unaHabilidad) n, altura = max (n-3) 0}

palos :: Palos
palos = [elPutter,laMadera] ++ map  (elHierro) [1..10] 
-- palos = elPutter : laMadera : map  (elHierro) [1..10] 

{-PUNTO 2 : Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades 
de la persona.
Por ejemplo si Bart usa un putter, se genera un tiro de velocidad = 10, precisión = 120 y altura = 0.-}
golpe :: Jugador -> Palo -> Tiro
golpe unJugador unPalo = unPalo.habilidad $ unJugador

{- PUNTO 3
Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado dicho tiro por el obstáculo. 
En principio necesitamos representar los siguientes obstáculos:
- Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. 
Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.
- Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros.
Luego de superar una laguna el tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.
- Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95.
Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.
Se desea saber cómo queda un tiro luego de intentar superar un obstáculo, teniendo en cuenta que en caso de no superarlo, se detiene, quedando con todos sus componentes en 0.
-}

puedeSuperarlo :: Int -> Int -> Bool
puedeSuperarlo condicon valor = (>condicon) valor  

tiroDetenido :: Tiro -> Tiro
tiroDetenido unTiro = unTiro {velocidad = 0, precision=0, altura = 0}

seDetiene :: Tiro
seDetiene = UnTiro 0 0 0

valRasDelSuelo :: Tiro -> Bool
valRasDelSuelo = (==0).altura

tunelConRampita :: Obstaculo
tunelConRampita unTiro
  | (puedeSuperarlo 90.precision $ unTiro) && valRasDelSuelo unTiro= unTiro {velocidad = (velocidad unTiro)*2,precision = 100,altura = 0}
  | otherwise = seDetiene

laguna :: Int -> Obstaculo
laguna largoLaguna unTiro
    | (puedeSuperarlo 80.velocidad $ unTiro) && between 1 5 (altura unTiro) = unTiro {altura = div (altura unTiro) largoLaguna}
    | otherwise = seDetiene

hoyo :: Obstaculo
hoyo unTiro
    | between 5 20 (velocidad unTiro) && (puedeSuperarlo 95.precision $unTiro) && valRasDelSuelo unTiro = tiroDetenido unTiro
    | otherwise = seDetiene

{- PUNTO 4
a- Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.
b- Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
Por ejemplo, para un tiro de velocidad = 10, precisión = 95 y altura = 0, y una lista con dos túneles con
rampita seguidos de un hoyo, el resultado sería 2 ya que la velocidad al salir del segundo túnel es de 40, por ende no supera el hoyo.
BONUS: resolver este problema sin recursividad, teniendo en cuenta que existe una función takeWhile :: (a -> Bool) -> [a] -> [a]
 que podría ser de utilidad.
c- Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos 
con un solo tiro.
-}

palosUtiles :: Jugador -> Obstaculo -> Palos -> Palos                                           -- REVISAR
palosUtiles unJugador unObstaculo unosPalos = filter (esUtil unObstaculo unJugador) unosPalos

esUtil:: Obstaculo -> Jugador -> Palo -> Bool
esUtil unObstaculo unJugador = (/= seDetiene).unObstaculo.golpe unJugador   -- palo parametro implicito

cuantosPuedeSuperar :: [Obstaculo] -> Tiro ->  Int
cuantosPuedeSuperar variosObstaculos unTiro = length.takeWhile (\unObstaculo -> (/= seDetiene).unObstaculo $ unTiro) $ variosObstaculos -- variosObstaculos implicito

tiroEjemplo :: Tiro
tiroEjemplo = UnTiro 10 95 0

--paloMasUtil :: Jugador -> [Obstaculo] -> Palo
--paloMasUtil unJugador variosObstaculos = maximoSegun (paloQueSuperaMas unJugador variosObstaculos) palos

elMejorPalo :: [Obstaculo] -> (Tiro,Palo) -> (Tiro,Palo) -> Palo
elMejorPalo variosObstaculos tiro1 tiro2
            | (cuantosPuedeSuperar variosObstaculos) (fst tiro1) > (cuantosPuedeSuperar variosObstaculos) (fst tiro2) = snd tiro2
            | otherwise = snd tiro2

combinarTiroConPalo:: Jugador -> [(Tiro,Palo)]
combinarTiroConPalo unJugador = zip (map (golpe unJugador) palos) palos

--paloQueSupereMas :: Jugador -> [Obstaculo]  -> Palo
--paloQueSupereMas unJugador variosObstaculos =  foldl1 (elMejorPalo variosObstaculos) (combinarTiroConPalo unJugador) --cuantosPuedeSuperar variosObstaculos.(map (golpe unJugador) palos)

-- jugador --> habilidades + tiro --> palo
-- jugador + palo + tiro --> golpe
-- tiro + tiro --> obstaculo

{- PUNTO 5
Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo,
 se pide retornar la lista de padres que pierden la apuesta por ser el “padre del niño que no ganó”.
  Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.-}
niñoQueGano :: (Jugador,Puntos) -> (Jugador,Puntos) -> (Jugador,Puntos)
niñoQueGano jugador1 jugador2 
            | snd jugador1 > snd jugador2 = jugador1   
            | otherwise = jugador2

obtenerPerdedores:: [(Jugador,Puntos)] -> (Jugador,Puntos) -> [(Jugador,Puntos)]
obtenerPerdedores listaJugadores ganador = filter (/= ganador) $ listaJugadores

obtenerPadresPerdedores ::  [(Jugador,Puntos)] -> [String]
obtenerPadresPerdedores  = map (padre.fst)
--obtenerPadresPerdedores listaPerdedores = map padre.map fst $ listaPerdedores

padresPerdedores :: [(Jugador,Puntos)] -> [String]
padresPerdedores listaJugadores =  obtenerPadresPerdedores.obtenerPerdedores listaJugadores.foldl1 niñoQueGano $ listaJugadores 

--sin repetidos, mayorSegun, between, takeWhile, 
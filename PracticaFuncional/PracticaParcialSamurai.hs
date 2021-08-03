module Lib where
import Text.Show.Functions ()

type Efecto = (Personaje-> Personaje)

data Elemento = UnElemento{
    tipo:: String,
    ataque :: Efecto,
    defensa :: Efecto
}deriving (Show)

data Personaje = UnPersonaje
 { nombre :: String,
   salud :: Float,
   elementos :: [Elemento],
   anioPresente :: Int } deriving (Show)

modificarSalud:: (Float -> Float) -> Personaje -> Personaje
modificarSalud operacion unPersonaje = unPersonaje {salud = operacion.salud $ unPersonaje}

--Parte 1
{-Empecemos por algunas transformaciones básicas:
mandarAlAnio: lleva al personaje al año indicado.
meditar: le agrega la mitad del valor que tiene a la salud del personaje.
causarDanio: le baja a un personaje una cantidad de salud dada. tener en cuenta al modificar la salud de un personaje nunca puede quedar menor a 0.
-}
mandarAlAnio:: Int -> Efecto
mandarAlAnio anioDeseado unPersonaje =  unPersonaje{anioPresente = anioDeseado }

meditar:: Efecto
meditar unPersonaje = modificarSalud (*1.5) unPersonaje 

causarDanio:: Float -> Efecto
causarDanio danio unPersonaje 
    |  danio < salud unPersonaje = modificarSalud (subtract danio) unPersonaje
    | otherwise = modificarSalud (subtract.salud $ unPersonaje) unPersonaje

--Parte 2
{-Queremos poder obtener algo de información extra sobre los personajes. Definir las siguientes funciones:
esMalvado, que retorna verdadero si alguno de los elementos que tiene el personaje en cuestión es de tipo “Maldad”.
danioQueProduce :: Personaje -> Elemento -> Float, que retorne la diferencia entre la salud inicial del personaje y la salud del personaje luego de usar el ataque del elemento sobre él.
enemigosMortales que dado un personaje y una lista de enemigos, devuelve la lista de los enemigos que pueden llegar a matarlo con un solo elemento. Esto sucede si luego de aplicar el efecto de ataque del elemento, el personaje queda con salud igual a 0.
-}
esMalvado :: Personaje -> Bool
esMalvado  = any (=="Maldad").map tipo.elementos 

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce unPersonaje unElemento = (salud unPersonaje) - atacarCon unElemento unPersonaje

atacarCon:: Elemento -> Personaje -> Float
atacarCon unElemento  = salud.ataque unElemento 

enemigosMortales:: Personaje -> [Personaje] -> [Personaje]
enemigosMortales unPersonaje  = filter (tieneUnElementoQueLoMate unPersonaje) 

elementoMata ::  Personaje -> Elemento -> Bool
elementoMata unPersonaje unElemento = (==0).atacarCon unElemento $ unPersonaje

tieneUnElementoQueLoMate:: Personaje -> Personaje -> Bool
tieneUnElementoQueLoMate unPersonaje  = any (elementoMata unPersonaje).elementos 
--tieneUnElementoQueLoMate unPersonaje unEnemigo = any (elementoMata unPersonaje) (elementos unEnemigo)

--Parte 3
{- Definir los siguientes personajes y elementos:
Definir concentracion de modo que se pueda obtener un elemento cuyo efecto defensivo sea aplicar meditar tantas veces como el nivel de concentración indicado y cuyo tipo sea "Magia".
Definir esbirrosMalvados que recibe una cantidad y retorna una lista con esa cantidad de esbirros (que son elementos de tipo “Maldad” cuyo efecto ofensivo es causar un punto de daño).
Definir jack de modo que permita obtener un personaje que tiene 300 de salud, que tiene como elementos concentración nivel 3 y una katana mágica (de tipo "Magia" cuyo efecto ofensivo es causar 1000 puntos de daño) y vive en el año 200.
Definir aku :: Int -> Float -> Personaje que recibe el año en el que vive y la cantidad de salud con la que debe ser construido. 
    Los elementos que tiene dependerán en parte de dicho año. Los mismos incluyen: concentración nivel 4, Tantos esbirros malvados como 100 veces el año en el que se encuentra.
Un portal al futuro, de tipo “Magia” cuyo ataque es enviar al personaje al futuro (donde el futuro es 2800 años después del año indicado para aku), y su defensa genera un nuevo aku para el año futuro correspondiente que mantenga la salud que tenga el personaje al usar el portal.
-}
concentracion ::  Int -> Elemento
concentracion nivelConcentracion = UnElemento "Magia" undefined (meditarNVeces nivelConcentracion)

meditarNVeces:: Int -> Personaje -> Personaje
meditarNVeces nivelConcentracion = foldl1 (.).replicate nivelConcentracion $ meditar

esbirrosMalvados:: Int -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad esbirro

esbirro :: Elemento
esbirro = UnElemento "Maldad" (causarDanio 1) undefined

--portalAlFututo :: Int -> Personaje-> Elemento dsp probar como serria si fuera un elmento de aku
--portalAlFututo  anioFuturo unPersonaje = UnElemento "Magia" (mandarAlAnio (2800 + (anioPresente unPersonaje))) (aku anioFuturo (salud unPersonaje))

jack :: Personaje
jack = (UnPersonaje "Jack" 300 [katanaMagica,concentracion 3] 200)

aku ::  Int -> Float -> Personaje
aku anioDondeVive saludDeseada = (UnPersonaje "aku" saludDeseada ([concentracion 4]++esbirrosMalvados (anioDondeVive*1)) anioDondeVive) 

katanaMagica :: Elemento
katanaMagica = UnElemento "Magia" (causarDanio 1000) undefined

{-
Finalmente queremos saber cómo puede concluir la lucha entre Jack y Aku. Para ello hay que definir 
la función luchar :: Personaje -> Personaje -> (Personaje, Personaje) donde se espera que si el primer personaje (el atacante) está muerto,
 retorne la tupla con el defensor primero y el atacante después, en caso contrario la lucha continuará invirtiéndose los papeles
  (el atacante será el próximo defensor) luego de que ambos personajes se vean afectados por el uso de todos los elementos del atacante.

O sea que si luchan Jack y Aku siendo Jack el primer atacante, Jack se verá afectado por el poder defensivo de la concentración y Aku se verá afectado por el poder ofensivo de la katana mágica, y la lucha continuará con Aku (luego del ataque) como atacante y con 
-}


{- Inferir el tipo de la siguiente función:
funcion x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))
    -}
module Lib where
import Text.Show.Functions ()

data Turista = UnTurista {
cansancio :: Int,
estress :: Int,
viajaSolo :: Bool,
idiomasHablados :: [Idioma]
} deriving (Show,Eq)

type Idioma = String
type Excursion = Turista -> Turista
type Tour = [Excursion]

{-- intento de parametrizar
modificarNivelDe :: (Turista -> Int) -> (Int -> Int) ->  Turista -> Turista
modificarNivelDe estressoOcansancio funcion unTurista = unTurista {estressOcansancio = funcion.estresOcansancio $ unTurista}

-- BY FER (no funca)
modificarNivelDe' :: ((Int->Int)->Turista -> Turista) -> (Int -> Int) -> Turista -> Turista
modificarNivelDe' estressOcansancio funcion unTurista = estressOcansancio funcion $ unTurista
-}

modificarNivelDeCansancio :: (Int -> Int) ->  Turista -> Turista
modificarNivelDeCansancio funcion  unTurista = unTurista {cansancio = funcion.cansancio $ unTurista}

modificarNivelDeEstress :: (Int -> Int) ->  Turista -> Turista
modificarNivelDeEstress funcion  unTurista = unTurista {estress = funcion.estress $ unTurista}

agregarIdioma :: String -> Turista -> Turista
agregarIdioma unIdioma unTurista = unTurista {idiomasHablados = unIdioma : idiomasHablados unTurista} -- el nuevo idioma se agrega adelante

-- PUNTO 1
ana :: Turista
ana = UnTurista 0 21 False  ["espaniol"]

cathi :: Turista
cathi = UnTurista 15 15 True ["aleman","catalan"]

beto :: Turista
beto = UnTurista 15 15 True ["aleman"]

-- PUNTO 2.a
irALaPlaya :: Excursion
irALaPlaya unTurista 
  | viajaSolo unTurista = modificarNivelDeCansancio (subtract 10) unTurista   -- no se puede con parametros implicitos
  | otherwise = modificarNivelDeEstress (subtract 1) unTurista

apreciarPaisaje :: String -> Excursion
apreciarPaisaje unElemento = modificarNivelDeEstress (subtract. length $ unElemento)

salirAHablar :: String -> Excursion
salirAHablar unIdioma = viajarAcompañado. agregarIdioma unIdioma

viajarAcompañado :: Turista -> Turista
viajarAcompañado unTurista  = unTurista {viajaSolo = False}

caminar :: Int -> Excursion
caminar minutos unTurista = modificarNivelDeCansancio ((+).nivelIntensidadCaminata $ minutos).modificarNivelDeEstress (subtract.nivelIntensidadCaminata $ minutos) $ unTurista    -- parametros implicitos, repeticion logica mintuos?

nivelIntensidadCaminata :: Int -> Int
nivelIntensidadCaminata minutosACaminar = (*4) minutosACaminar

-- pattern maching o guarda??
paseoEnBarco :: String -> Excursion
paseoEnBarco marea unTurista
  | comoEstaLaMarea marea "fuerte" = modificarNivelDeCansancio (+ 10).modificarNivelDeEstress (+ 6) $ unTurista
  | comoEstaLaMarea marea "moderada" = id unTurista                      -- puede ser parametro implicito??
  | comoEstaLaMarea marea "tranquila" = salirAHablar "aleman".apreciarPaisaje "mar".caminar 10 $ unTurista
  | otherwise = unTurista -- no se que hacer

comoEstaLaMarea :: String -> String -> Bool
comoEstaLaMarea marea tipoMarea = (== marea) tipoMarea        -- elem marea ["fuerte","moderada","tranquila"]

{-- PUNTO 2.b (BY FER)
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = Turista -> Int
hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion  = reducirStressPorcentaje (10).excursion

deltaExcursionSegun :: Indice->Turista->Excursion->Int
deltaExcursionSegun indice unTurista excursion = deltaSegun indice (hacerExcursion excursion unTurista) unTurista

reducirStressPorcentaje :: Int -> Turista -> Turista
reducirStressPorcentaje porcentaje unTurista = modificarNivelDeEstress (subtract $ div ((estress unTurista)* porcentaje) 100) unTurista-}

{-- BY ME (resultado distinto al esperado ana al irALaPlaya deberia quedar con 18, me da 19)
--hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion unaExcursion unTurista = sufrirEfectoExcursion.unaExcursion $ unTurista

--sufrirEfectoExcursion :: Turista -> Turista
sufrirEfectoExcursion unTurista = modificarNivelDeEstress (subtract (calcularXPorCiento 10 (estress unTurista))) 

calcularXPorCiento :: Int -> Int -> Int
calcularXPorCiento porcentaje unValor = div (unValor * porcentaje) 100

-- PUNTO 2.b
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Int) -> Excursion -> Turista -> Int
deltaExcursionSegun indice unaExcursion unTurista = deltaSegun indice (hacerExcursion unaExcursion unTurista unTurista) unTurista
-- resultado distinto al esperado, deberia ser -3 pero me da -2, no resta subtract -1 de irALaPlaya
-}

-- PUNTO 2.c (depende del anterior)
esExcursionEducativa :: Excursion -> Turista -> Bool
esExcursionEducativa unaExcursion unTurista = (/= []).idiomasHablados.hacerExcursion unaExcursion unTurista $ unTurista

excursionesDesestresantes :: [Excursion] -> Turista -> [Excursion] -- [Excursion] podria ser Tour o no corresponde semanticamente
excursionesDesestresantes unasExcursiones unTurista = filter (flip esExcursionDesestresante unTurista) unasExcursiones  -- se puede composicion?

esExcursionDesestresante :: Excursion -> Turista -> Bool
esExcursionDesestresante unaExcursion unTurista = (<3).deltaExcursionSegun estress unaExcursion $ unTurista

-- PUNTO 3
completo :: Tour
completo = [caminar 20, apreciarPaisaje "cascada", caminar 40, irALaPlaya, salirAHablar "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB excursionElegida = paseoEnBarco "tranquila" : excursionElegida : [caminar 120]

islaVecina :: String -> Tour
islaVecina mareaAlLlegar
  | comoEstaLaMarea mareaAlLlegar "fuerte" = [paseoEnBarco mareaAlLlegar,apreciarPaisaje "Lago",paseoEnBarco mareaAlLlegar]
  | otherwise = [paseoEnBarco mareaAlLlegar,irALaPlaya,paseoEnBarco mareaAlLlegar]

hacerTour :: Tour -> Turista -> Turista                                                                   -- resultados distintos al esperado
hacerTour unTour unTurista = foldl1 (.) unTour . modificarNivelDeEstress ((+).length $ unTour) $ unTurista

{- 
algunoEsConvincente :: [Tour] -> Turista -> Bool
algunoEsConvincente unosTour unTurista = any (esConvincentePara unTurista) unosTour

esConvincentePara unTurista unTour
  | any esExcursionDesestresante unTour = viajarAcompañado . hacerExcursion $ unTurista    -- Como toma la excursion que cumple el any
  | otherwise = unTurista

efectividadTour :: Tour -> [Turista] -> Int
efectividadTour unTour unosTuristas = sum . espiritualidad . filter turistasConvencidos unTour $ unosTuristas
-}

-- PUNTO 4
{-
visitarInfinitasPlayas :: Tour
visitarInfinitasPlayas = repeat irALaPlaya

a. Para Ana si esuna excursion convincente. Porque viaja acompañada y la excursion es desestresante
Si ir a la playa es una excursion convincente Beto, se podrá saber que el Tour es convincente, sin embargo, si no lo es, se quedará evaluando infinitamente hasta encontrar algun Tour que no lo sea (o sea nunca)
b. Se podrá conocer la efectividad de este Tour en el caso que el conjunto de turistas sea vacio, el cual será 0?
-}
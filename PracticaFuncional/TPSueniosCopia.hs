module Lib where
import Text.Show.Functions ()

data Persona = Unapersona{
    edad         :: Int,
    sueños       :: [Sueño],
    nombre       :: String,
    felicidonios :: Int,
    habilidades  :: [String]
}deriving (Show)

type Sueño = Persona -> Persona
type Operacion = Int->Int->Int
type Factorcomun = Persona -> Int
type Factorvariable = Persona -> Int

cantidadesuenos :: Persona -> Int
cantidadesuenos = length.sueños 

calculoDeGradoOcoeficiente :: Persona->Factorcomun->Factorvariable->Factorvariable->Operacion->Int
calculoDeGradoOcoeficiente  unapersona factorcomun factorvariable1 factorvariable2 funcion
  | felicidonios unapersona > 100 = factorcomun unapersona * factorvariable1 unapersona
  | felicidonios unapersona > 50  = factorcomun unapersona * factorvariable2 unapersona
  | otherwise                     = funcion (factorcomun unapersona) 2

-- 1.a
coeficienteDeSatisfaccion:: Persona -> Int
coeficienteDeSatisfaccion unapersona = calculoDeGradoOcoeficiente unapersona felicidonios edad cantidadesuenos (div)
-- 1.b
gradoDeAmbicionDeUnaPersona:: Persona -> Int
gradoDeAmbicionDeUnaPersona unapersona = calculoDeGradoOcoeficiente unapersona cantidadesuenos felicidonios edad (*)

{- Si ponían la persona como último parámetro podía quedar implícito. (comentario Nico)
calculoDeGradoOcoeficiente :: Factorcomun->Factorvariable->Factorvariable->(Funcion)->Persona->Int
calculoDeGradoOcoeficiente factorcomun factorvariable1 factorvariable2 funcion unapersona
coeficienteDeSatisfaccion = calculoDeGradoOcoeficiente felicidonios edad cantidadesuenos (div)
-}
-- 2.a
nombreLargo :: Persona -> Bool
nombreLargo  = (>10).length.nombre 
-- 2.b
personaSuertuda :: Persona -> Bool
personaSuertuda = even.(*3).coeficienteDeSatisfaccion
-- 2.c
nombreLindo :: Persona -> Bool
nombreLindo  = (== 'a').last.nombre

-- 3
sumarFelicidonios :: Int -> Persona -> Persona
sumarFelicidonios valor unapersona = unapersona {felicidonios = felicidonios unapersona + valor}

recibirseDeUnaCarrera :: String -> Sueño
recibirseDeUnaCarrera nombreCarrera = sumarFelicidonios (length nombreCarrera * 1000).agregarHabilidades nombreCarrera
agregarHabilidades :: String -> Persona -> Persona
agregarHabilidades habilidad unapersona = unapersona {habilidades = [habilidad] ++ habilidades unapersona}

viajarA :: [String] -> Sueño
viajarA listaDeCiudades = cumplirAños.sumarFelicidonios (100 * (length listaDeCiudades))
cumplirAños :: Persona -> Persona
cumplirAños unapersona = unapersona {edad = edad unapersona + 1}

enamorarseDe :: Persona -> Sueño
enamorarseDe otrapersona unapersona = sumarFelicidonios (felicidonios otrapersona) unapersona

queTodoSigaIgual :: Sueño
queTodoSigaIgual = id

comboPerfecto::  Sueño
comboPerfecto = sumarFelicidonios 100.recibirseDeUnaCarrera "Medicina".viajarA ["Berazategui","Paris"] -- Se borraron parentesis al pedo

------------------------------------------------------------- PARTE 2 -------------------------------------------------------------------------

aplicarEnesimoSueño:: Int -> Sueño
aplicarEnesimoSueño enesimo unapersona = (last.take enesimo.sueños $ unapersona) unapersona

devolverListaSinPrimerSueño:: Sueño
devolverListaSinPrimerSueño unapersona =  unapersona{ sueños =  tail (sueños unapersona)}

type Fuente = Persona -> Persona
--Punto 4
--4a
fuenteMinimalista ::  Fuente 
fuenteMinimalista unapersona =  devolverListaSinPrimerSueño.aplicarEnesimoSueño 1$ unapersona

--4b
fuenteCopada :: Fuente
fuenteCopada  unapersona 
  | (cantidadesuenos unapersona) > 0  = fuenteCopada.fuenteMinimalista $ unapersona 
  | otherwise =  unapersona

fuenteCopada2 :: Fuente
fuenteCopada2 unaPersona = (\persona -> persona{sueños = []}).foldl1 (.) (sueños unaPersona) $ unaPersona

--4c
fuenteAPedido :: Int -> Fuente
fuenteAPedido enesimo unapersona = aplicarEnesimoSueño enesimo unapersona -- los parametro se pueden dejar implicito: fuenteAPedido = aplicarEnesimoSueño

--4d
fuenteSorda:: Fuente
fuenteSorda  = queTodoSigaIgual

-- Punto 5 
fuenteGanadora:: Ord a => (a -> a -> Bool) -> (Persona-> a )-> [Fuente] -> Persona -> Fuente
fuenteGanadora  operador criterio listaDeFuentes unaPersona = foldl1 (compararSegun operador criterio unaPersona ) listaDeFuentes

compararSegun::  Ord a => (a -> a -> Bool) -> (Persona-> a )-> Persona -> Fuente -> Fuente -> Fuente
compararSegun operador criterio unaPersona unaFuente otraFuente 
  | (operador) (criterio.unaFuente $ unaPersona)  (criterio.otraFuente $ unaPersona) = unaFuente  
  | otherwise = otraFuente

-- Punto 6
esSueñoSegun :: (Int -> Bool) -> Persona -> Sueño -> Bool
esSueñoSegun condicion unaPersona sueño = condicion.felicidonios.sueño $ unaPersona

sueñosValiosos :: Persona -> [Sueño]
sueñosValiosos unapersona = filter (esSueñoSegun (>100) unapersona) (sueños unapersona)

tieneSueñosRaro :: Persona -> Bool
tieneSueñosRaro unapersona = any (esSueñoSegun (== felicidonios unapersona) unapersona).sueños $ unapersona

felicidadTotal :: [Persona] -> Int
felicidadTotal listaDePersonas = sum.map felicidonios.map fuenteCopada $ listaDePersonas -- se puede dejar los parametros implicitos

{- VERSION NO MUY LINDA
cumplirSueñosDe :: Persona -> [Persona]
cumplirSueñosDe unapersona = zipWith aplicarEnesimoSueño [1..(cantidadesuenos unapersona)] (replicate (cantidadesuenos unapersona)  unapersona)   

compararMayoresa100 :: Persona -> [Sueño] -> [Persona] -> [Sueño]
compararMayoresa100 _ [] [] = []
compararMayoresa100 unapersona lista listafuncion
 | head (map felicidonios listafuncion) >= 100 = lista ++ [(head (sueños unapersona))] ++ (compararMayoresa100 (devolverListaSinPrimerSueño unapersona) lista (tail listafuncion))
 | head (map felicidonios listafuncion) < 100 = compararMayoresa100 (devolverListaSinPrimerSueño unapersona) lista (tail listafuncion)
 | otherwise = lista

sueñosValiosos :: Persona -> [Sueño]
sueñosValiosos unaPersona = (compararMayoresa100 unaPersona []).cumplirSueñosDe $ unaPersona --
sueñosValiosos' unaPersona = filter ((>100).felicidonios) (cumplirSueñosDe unaPersona)
sueñosValiosos'' unaPersona = map sueños $ filter ((>100).felicidonios) (cumplirSueñosDe unaPersona)

tieneSueñosRaros :: Persona -> Bool
tieneSueñosRaros unapersona = any (== felicidonios unapersona).map felicidonios.cumplirSueñosDe $ unapersona  
-}

--Punto 7
generarListaInfinita :: [Sueño] -> [Sueño]
generarListaInfinita listaDeSueños = cycle listaDeSueños

gus:: Persona
gus = (Unapersona 28 (generarListaInfinita [queTodoSigaIgual]) "gustavo" 1 ["Ser buena onda","Hacer chistes de los Simpsons"])

{-
Si se invoca la fuente Minimalista con una persona de infinitos sueños, dado que Haskell trabaja con "lazy evaluation", devuele la lista sin el primer sueño. Pero como fuente minimlaista devuelve los sueños restantes y como estos son una cantidad infinita, devuelve una lista infinita de sueños (sin el primero)
Si se invoca la fuente Copada con una persona de infinitos sueños, no termina ni devuelve los distintos valores. Depende de si tiene algún sueño extraño que al cumplirlo borre todos los sueños restantes
Si se invoca la fuente APedido con una persona de infinitos sueños, termina, analoga a fuente minimalista
Si se invoca la fuente Sorda con una persona de infinitos sueños. termina, lo que no termina es la lista de infinitos sueños.
-}

--Modelos de Prueba:
juan :: Persona
juan = (Unapersona 23 [recibirseDeUnaCarrera "Bioquimica",viajarA ["uzbekistan","Argelia"]] "Juan" 50   ["Tocar la guitarra con los pies"])

maria :: Persona
maria = (Unapersona 26 [viajarA ["Barcelona"],viajarA ["Barcelona"]] "Maria" 100 [])

pedro :: Persona
pedro = (Unapersona 25 [queTodoSigaIgual , recibirseDeUnaCarrera "Psicologia"] "Pepe" 101 [])

maximiliano :: Persona
maximiliano = (Unapersona 26 [viajarA ["Madrid"], queTodoSigaIgual] "Maximiliano" 12 [])

manuel :: Persona
manuel = (Unapersona 30 [] "Manuel" 15 [])

eugenia:: Persona
eugenia = (Unapersona 22 [ viajarA ["paris"], enamorarseDe manuel,recibirseDeUnaCarrera "diseñoDeInteriores"] "Eugenia" 5000 [])

ciro:: Persona
ciro = (Unapersona 30 [viajarA ["bariloche", "villaLaAngostura", "sanMartinDeLosAndes"], enamorarseDe patagoniaArgentina] "Ciro" 2000 [])

patagoniaArgentina:: Persona
patagoniaArgentina = (Unapersona 300000 [] "lugar" 15 [])

martina :: Persona
martina = (Unapersona 28 [comboPerfecto, recibirseDeUnaCarrera "medicina", enamorarseDe mateo, viajarA ["Barcelona"]] "Tina" 500 [])

mateo :: Persona
mateo = (Unapersona 30 [] "Teo" 0 [])

agustin :: Persona
agustin = (Unapersona 12 [queTodoSigaIgual] "Agus" 100 [])
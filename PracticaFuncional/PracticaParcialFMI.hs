module Lib where
import Text.Show.Functions ()
-- PUNTO 1
type SectorPublico = Int
type SectorPrivado = Int
type Estrategia = Pais -> Pais
type Receta = Pais -> Pais
type Recurso = String

data Pais = UnPais{
    ingresoPC :: Double,
    poblacionActiva :: (SectorPublico,SectorPrivado),
    recursosNaturales :: [String],
    nivelDeuda :: Double -- capaz sea mejor otro nombre
}deriving (Show)

namibia :: Pais
namibia  =  (UnPais 4140 (400000,650000) ["Mineria","Ecoturismo"] 50)

francia :: Pais
francia  =  (UnPais 100 (1000,500) ["Mineria","Ecoturismo"] 10)

modificarDeuda :: (Double -> Double) -> Pais -> Pais
modificarDeuda operacion unpais = unpais {nivelDeuda = operacion.nivelDeuda $ unpais}

totalPoblacionActiva :: Pais -> Int
totalPoblacionActiva unpais = (fst.poblacionActiva $ unpais) + (snd.poblacionActiva $ unpais)

calcularPBI :: Pais -> Double
calcularPBI unpais = fromIntegral (totalPoblacionActiva unpais) * (ingresoPC  unpais)

-- PUNTO 2
prestarleNMillones:: Double -> Estrategia
prestarleNMillones millones unpais = modificarDeuda (+ (millones*1.5)) unpais

reducirXPuestosEnSectorPublico:: Int -> Estrategia
reducirXPuestosEnSectorPublico  cantPuestos unpais = disminuirIngresoPC.reducirCantidadPuestos cantPuestos $ unpais

reducirCantidadPuestos:: Int -> Estrategia
reducirCantidadPuestos cantPuestos unpais = unpais{poblacionActiva = ((fst.poblacionActiva $ unpais) - cantPuestos, (snd.poblacionActiva $ unpais))}

disminuirIngresoPC:: Estrategia
disminuirIngresoPC unpais 
    | fst (poblacionActiva unpais) > 100 = unpais{ingresoPC = (ingresoPC unpais) - (0.2) * (ingresoPC unpais)}
    | otherwise = unpais{ingresoPC =  (ingresoPC unpais) -  0.15 * (ingresoPC unpais)}

-- OPCION 2 
modificarPoblacionActiva :: (Int -> Int) -> (Int -> Int) -> Pais -> Pais
modificarPoblacionActiva operacionSectorPublico operacionSectorPrivado unPais = unPais {poblacionActiva = (operacionSectorPublico.fst.poblacionActiva $ unPais, operacionSectorPrivado.snd.poblacionActiva $ unPais) }

reducirPuestosTrabajo :: Int -> Pais -> Pais
reducirPuestosTrabajo puestosAReducir unPais = disminuirIngresoPerCapita puestosAReducir.modificarPoblacionActiva (subtract puestosAReducir) id $ unPais

disminuirIngresoPerCapita :: Int -> Receta
disminuirIngresoPerCapita puestosAReducir unPais 
  | puestosAReducir > 100 = unPais{ ingresoPC = ingresoPC unPais * 0.8 }
  | otherwise = unPais{ ingresoPC = ingresoPC unPais * 0.85 }  
-- FIN

cederExplotacionDe :: Recurso -> Estrategia
cederExplotacionDe recurso unpais = eliminarRecurso recurso.modificarDeuda (subtract 2) $ unpais 

eliminarRecurso :: Recurso -> Pais -> Pais
eliminarRecurso recurso unpais = unpais{recursosNaturales = filter (/= recurso).recursosNaturales $ unpais}

establecerBlindaje :: Estrategia
establecerBlindaje unpais = reducirXPuestosEnSectorPublico 500.prestarleNMillones (calcularPrestamo unpais) $ unpais

calcularPrestamo :: Pais -> Double
calcularPrestamo unpais = (/) (calcularPBI unpais) 2

--PUNTO 3.a
receta :: Receta
receta = cederExplotacionDe "Mineria".prestarleNMillones 200

-- OPCION 2, otra interpretacion
type Receta' = [Estrategia]
receta' :: Receta'
receta' = [prestarleNMillones 200, cederExplotacionDe "Mineria"]

aplicarReceta unareceta unpais = foldr ($) unpais unareceta
-- PUNTO 3.b: Efecto colateral? Luego de aplicarle la receta a Namibia obtiene una deuda de 348 millones, ademas de perder el recurso natural mineria

-- PUNTO 4
puedenZafar:: [Pais] -> [Pais]
puedenZafar = filter $ elem "Petroleo" . recursosNaturales
--puedenZafar listadepaises = filter (elem "Petroleo" . recursosNaturales) listadepaises

saldoAFavor :: [Pais] -> Double
saldoAFavor listadepaises =  sum.map nivelDeuda $ listadepaises
--saldoAFavor = foldr ((+) . nivelDeuda) 0 

-- PUNTO 5 (segun solucion)
-- Debe resolver este punto con recursividad: dado un país y una lista de recetas, saber si la lista de recetas está ordenada de “peor” a “mejor”, 
-- en base al siguiente criterio: si aplicamos una a una cada receta, el PBI del país va de menor a mayor. 
estaOrdenado :: Pais -> [Receta'] -> Bool
estaOrdenado pais [receta] = True
estaOrdenado pais (receta1:receta2:recetas) 
     = revisarPBI receta1 pais <= revisarPBI receta2 pais && estaOrdenado pais (receta2:recetas)  
     where revisarPBI receta = calcularPBI . aplicarReceta receta

{-
listaOrdenada:: [Pais] -> Bool
listaOrdenada [] = True
listaOrdenada [_] = True
listaOrdenada (x:y:xs) = (calcularPBI x <= calcularPBI y) && listaOrdenada (y:xs)
-}

{- PUNTO 6
Si un país tiene infinitos recursos naturales, modelado con esta función
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

¿qué sucede evaluamos la función 4a con ese país? 
-- En 4a nunca terminaria de evaluar, ya que es una lista infinita la cual no cumple con la condicion del 4a, ergo el filter no cortara nunca

¿y con la 4b? Justifique ambos puntos relacionándolos con algún concepto.
-- En 4b devolvera el saldoAFavor que tenga el pais, ya que la lista infinita de recursos naturales no afecta a este punto, aunque jamas se terminara de mostrar por consola
-}
-- CRYSTAL GEMS                     https://docs.google.com/document/d/1BepktcQsT2GVsduUq8ldi6JXZ4u3A9cjyc-cxZcdQBE/edit#heading=h.1gbtavw6o1gk

module Lib where
import Text.Show.Functions ()

data Aspecto = UnAspecto {
  tipoDeAspecto :: String,
  grado :: Float
} deriving (Show, Eq)

type Situacion = [Aspecto]

tension :: Aspecto
tension = UnAspecto "Tension" 20

incertidumbre :: Aspecto
incertidumbre = UnAspecto "Incertidumbre" 30

peligro :: Aspecto
peligro = UnAspecto "Peligro" 40

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)

buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)

reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion =
    aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

--1a
{-Definir modificarAspecto que dada una función de tipo
 (Float -> Float) y un aspecto, modifique el aspecto alterando su grado en base a la función dada.
-}
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion aspecto = aspecto {grado = funcion.grado $ aspecto}

{-Saber si una situación es mejor que otra: esto ocurre cuando, para la primer situación, cada uno de los aspectos,
 es mejor que ese mismo aspecto en la segunda situación.
Nota: recordar que los aspectos no necesariamente se encuentran en el mismo orden para ambas situaciones. 
Sin embargo, las situaciones a comparar siempre tienen los mismos aspectos.-}
esMejorQue :: Situacion -> Situacion -> Bool
esMejorQue unaSituacion otraSituacion = 

-- gemas: habilidadesSobrehumanas, capacidades (fusionarse), gemaPreciosa, personalidades -> distinto comportamiento
-- situaciones: aspectos problematicos(tension, incertidumbre, peligro)
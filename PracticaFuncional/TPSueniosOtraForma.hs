
module Entrega2 where

-- Data & types
type Sueno = Persona -> Persona
type Fuente = Persona -> Persona

data Persona = Persona{
    edad :: Int, 
    suenos :: [Sueno],
    nombre :: String,
    felicidonios :: Int,
    habilidades :: [String]
}



-- Inicializacion
--martina :: Persona
--martina = Persona { nombre = "Martina", felicidonios = 500, suenos = [comboPerfecto, enamorarseDe mateo, viajarAUnaListaDeCiudades ["Barcelona"]], edad = 19, habilidades = [] }

--mateo :: Persona
--mateo = Persona { nombre = "Mateo", felicidonios = 0, suenos = [], edad = 21, habilidades = [] }

--agustin :: Persona
--agustin = Persona { nombre = "Agustin", suenos = [queTodoSigaIgual], felicidonios = 100, edad = 20, habilidades = [] }


-- https://docs.google.com/document/d/11q_pAjZo_TKzNASjzk4sNpueAV9N2Aa-LtJPQyDOaio/edit

-
-- Helpers
mapSuenos :: ([Sueno] -> [Sueno]) -> Sueno
mapSuenos funcionSuenos unaPersona = unaPersona { suenos = funcionSuenos.suenos $ unaPersona }

-- agarra una funcion y lo mapea al sueño de la persona. construye una persona que va a ser editada dependiendo el sueño que le paso

cumplirSueno :: Persona -> Sueno -> Persona
cumplirSueno unaPersona unSueno = unSueno unaPersona

cumplirListaSuenos :: Persona -> [Sueno] -> Persona
cumplirListaSuenos unaPersona unosSuenos = (cumplirSueno unaPersona).(foldl1 (.)) . reverse $ unosSuenos

cumplirListaSuenos' :: Sueno
cumplirListaSuenos' unaPersona = ($ unaPersona) . foldr1 (.) . suenos $ unaPersona
                                     3             ------2------           1        
--- agarra los sueños de una persona, los compone con el foldr1 y el terecer paso les aplica el resultado a una persona
-- $= aplicar lo que esta a izquierda a derecha

-- Funciones

-- Punto 4 parte a 
quitarPrimerSueno :: Sueno
quitarPrimerSueno unaPersona = mapSuenos tail unaPersona

quitarPrimerSueno' :: Sueno
quitarPrimerSueno' = mapSuenos tail

cumplirPrimerSueno :: Sueno
cumplirPrimerSueno unaPersona = (cumplirSueno unaPersona) . head . suenos $ unaPersona

cumplirPrimerSueno' :: Sueno
cumplirPrimerSueno' unaPersona = ($ unaPersona) . head . suenos $ unaPersona 
--QUEDARSE CON UNA SOLA

fuenteMinimalista :: Fuente
fuenteMinimalista  = quitarPrimerSueno . cumplirPrimerSueno 

-- Punto 4 parte b
fuenteCopada :: Fuente
fuenteCopada unaPersona = (mapSuenos (const [])) . (cumplirListaSuenos unaPersona) . suenos $ unaPersona
                                        
fuenteCopada' :: Fuente
fuenteCopada' = mapSuenos (const []) . cumplirListaSuenos'
                           -- siempre la lista vacia
-- Punto 4 parte c
--cumplirEnesimoSueno sin sacarlo de la lista
suenoEnPosicion :: Int -> [Sueno] -> Sueno
suenoEnPosicion posicion unosSuenos = unosSuenos !! posicion

cumplirEnesimoSueno :: Int -> Sueno
cumplirEnesimoSueno posicion unaPersona = (cumplirSueno unaPersona) . (suenoEnPosicion posicion) . suenos $ unaPersona  

fuenteAPedido :: Int -> Fuente
fuenteAPedido posicion unaPersona = cumplirEnesimoSueno posicion unaPersona

fuenteAPedido' :: Int -> Fuente
fuenteAPedido' indice unaPersona = ($ unaPersona) . (!! indice) . suenos $ unaPersona
                                                   --retorna el elemento n de una lista                                        
--cumplirEnesimoSueno sacando el sueno de la lista
{- unirListasDeTupla :: ([Sueno], [Sueno]) -> [Sueno] 
unirListasDeTupla (principio, final) = principio ++ tail final

quitarEnesimoSueno :: Int -> [Sueno] -> Sueno
cumplirEnesimoSueno posicion unaLista unaPersona = mapSuenos (unirListasDeTupla . splitAt posicion) unaPersona -}


-- Punto 4 parte d
fuenteSorda :: Fuente
fuenteSorda = id 

-- Punto 5                        foldl1 max lista = maximun lista
fuenteGanadora :: (Int -> Int -> Bool) -> (Persona -> Int) -> Persona -> [Fuente]  -> Fuente
fuenteGanadora comparador accesor unaPersona = foldl1 ( compararFuentesSegun comparador accesor unaPersona )

compararFuentesSegun :: (Int -> Int -> Bool) -> (Persona -> Int) -> Persona -> Fuente -> Fuente -> Fuente
compararFuentesSegun comparador accesor unaPersona unaFuente otraFuente
    | comparador (accesor . unaFuente $ unaPersona) (accesor . otraFuente $ unaPersona) = unaFuente
    | otherwise                                                                         = otraFuente

{-
Dar ejemplos de  cómo invocar a esta función desde la consola para resolver los 3 ejemplos.
Ejemplos:
1) fuenteGanadora (>) felicidonios unaPersona listaDeFuentes
2) fuenteGanadora (<) felicidonios unaPersona listaDeFuentes
3) fuenteGanadora (>) (length.habilidades) unaPersona listaDeFuentes
-}

-- Punto 6
{- Saber qué suenos son valiosos para una persona, son aquellos que al cumplirlos la persona queda con más de 100 felicidonios. 
Saber si algún sueno de una persona es raro, que es el que lo deja  con la misma cantidad de felicidonios tras cumplirlo.
Dada una lista de personas, poder conocer la felicidad total de ese grupo si cumplen todos sus suenos. 
Tip: aprovecharse de alguna de las fuentes definidas anteriormente.
-}
-- Resolver el punto invocando únicamente a funciones de orden superior y aplicación parcial

-- ¿dónde aparecen los conceptos aplicación parcial y orden superior? Justifique.

esSuenoValioso :: Persona -> Sueno -> Bool
esSuenoValioso unaPersona = (> 100) . felicidonios . ($ unaPersona)

esSuenoRaro :: Persona -> Sueno -> Bool
esSuenoRaro unaPersona = (== felicidonios unaPersona) . felicidonios . ($ unaPersona)

felicidadTotalDeGrupo :: [Persona] -> Int
felicidadTotalDeGrupo listaDePersonas = sum . map (felicidonios.fuenteCopada') $ listaDePersonas

--Punto 7
{- Modelar a una persona con suenos infinitos. Para cada fuente modelada en el punto 4, 
¿es posible que esta pueda satisfacer a esa persona que tiene infinitos suenos? -}

giornio :: Persona
giornio = Persona { edad = 17, nombre = "Giorno Giovanna", suenos = map (const queTodoSigaIgual) [1..], habilidades = [], felicidonios = 0}


{- 
Justifique su respuesta con un ejemplo concreto: 
“a esta persona P0 con infinitos suenos S0 y la  Fuente F1 la invoco en la consola y... (etc. etc. etc.)”
y relacionelo con algún concepto visto en la cursada.

* Minimalista : Solo necesita el primer elemento de la lista, por lo que funciona gracias a la vieja y confiable lazy evaluation

* Copada: No funciona ya que trata de componer todos los infinitos suenos antes de borrar la lista, por lo que no termina nunca

* A Pedido: Funciona, ya que por lazy evaluation termina de trabajar con la lista infinita en el N-esimo elemento, no la recorre toda

* Sorda: Funciona, ya que id es super mega lazy y no realiza ningun tipo de procesamiento sobre la lista

-}
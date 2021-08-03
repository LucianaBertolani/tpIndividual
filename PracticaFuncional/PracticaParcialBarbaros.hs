-- TIERRA DE BARBAROS                         https://docs.google.com/document/d/1VTRCo5HE5XwvVM52saO2jec8uxJXYRQZ901UG6ifkiI/edit

import Data.Char (toUpper)
import Text.Show.Functions ()

data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [String],
    objetos :: [Objeto]
} deriving Show

type Objeto = Barbaro -> Barbaro

dave :: Barbaro
dave = Barbaro "Dave" 100 ["tejer","escribirPoesia","tejer"] []

faffy :: Barbaro
faffy = Barbaro "Faffy" 100 ["cocinar","Escribir poesia atroz"] [varitaDefectuosa]

modificarFuerza :: (Int -> Int) -> Barbaro -> Barbaro
modificarFuerza operacion unBarbaro =  unBarbaro {fuerza = operacion.fuerza $ unBarbaro}

modificarHabilidades :: ([String] -> [String]) -> Barbaro -> Barbaro
modificarHabilidades operacion unBarbaro = unBarbaro {habilidades = operacion.habilidades $ unBarbaro}

modificarObjetos :: ([Objeto] -> [Objeto]) -> Barbaro -> Barbaro
modificarObjetos operacion unBarbaro = unBarbaro {objetos = operacion.objetos $ unBarbaro}

-- PUNTO 1 
espada :: Int -> Objeto
espada pesoEnKg = modificarFuerza (+2*pesoEnKg)

amuletoMistico :: String -> Objeto
amuletoMistico unaHabilidad = modificarHabilidades (unaHabilidad :)

varitaDefectuosa :: Objeto
varitaDefectuosa = modificarObjetos (const []).modificarHabilidades ("hacer magia" :)

{- 
varitasDefectuosas :: Objeto
varitasDefectuosas unbarbaro = vaciarObjetos.añadirHabilidad "hacerMagia" $ unbarbaro 
vaciarObjetos:: Barbaro -> Barbaro
vaciarObjetos unbarbaro = unbarbaro{objetos = []} 
-}

ardilla :: Objeto
ardilla = id

cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto = unObjeto.otroObjeto
-- con parametros implicitos cuerda = (.)

-- PUNTO 2
megafono :: Objeto
megafono = modificarHabilidades potenciarHabilidades

potenciarHabilidades :: [String] -> [String]
potenciarHabilidades unasHabilidades = [map toUpper.concat $ unasHabilidades]

{- OTRA OPCION
megafono unBarbaro = modificarHabilidades (const [nuevaHabilidad unBarbaro]) unBarbaro  ¿con composicion?
megafono unBarbaro = modificarHabilidades (take 1.(nuevaHabilidad unBarbaro :)) $ unBarbaro

nuevaHabilidad :: Barbaro -> String
nuevaHabilidad = map toUpper.concat.habilidades   -- concat = foldl1 (++) -}

megafonoBarbarico :: Objeto                           
megafonoBarbarico = cuerda ardilla megafono

-- PUNTO 3                     
type Evento = Barbaro -> Bool
type Aventura = [Evento]

invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes = elem "Escribir poesia atroz".habilidades

cremalleraDelTiempo :: Evento 
cremalleraDelTiempo unBarbaro = elem (nombre unBarbaro) ["Faffy","Astro"]
-- cremalleraDelTiempo unBarbaro = ((== "Faffy").nombre $ unBarbaro) || ((== "Astro").nombre $ unBarbaro)
{- sobrevive si no tiene pulgares, Faffy y Astro no tienen pulgares, el resto si
cremalleraDelTiempo = not.tienePulgares
tienePulgares:: Evento
tienePulgares unbarbaro = not.elem (nombre unbarbaro) $ ["Faffy","Astro"] -}

ritualDeFechorias :: Evento
ritualDeFechorias unBarbaro = foldl1 (||) [saqueo unBarbaro,caligrafia unBarbaro,gritoDeGuerra unBarbaro] 
-- ritualDeFechorias unBarbaro = foldl1 (||.$ unBarbaro) [saqueo,caligrafia]
-- pasaPruebas unbarbaro = saqueo unbarbaro|| gritoDeGuerra unbarbaro || caligrafia unbarbaro

-- como puede haber mas pruebas 
ritualDeFechorias2 :: Aventura -> Evento
ritualDeFechorias2 unaAventura unBarbaro = any (\unEvento -> unEvento unBarbaro) listaDeEventos -- puedo usar esSobreviviente any unaAventura

saqueo :: Barbaro -> Bool
saqueo unBarbaro = (elem "robar".habilidades $ unBarbaro) && ((>80).fuerza $ unBarbaro) 
-- puedo descomponer en funciones tieneHabilidad "robar" unBarbaro && esFuerte unBarbaro   con parametros implicitos

gritoDeGuerra :: Barbaro -> Bool
gritoDeGuerra unBarbaro = ((>).poderParaAprobar $ unBarbaro).calcularPoderDelGrito $ unBarbaro

calcularPoderDelGrito :: Barbaro -> Int
calcularPoderDelGrito = length.concat.habilidades

poderParaAprobar :: Barbaro -> Int
poderParaAprobar = (*4).length.objetos  -- parametros implicitos

caligrafia :: Barbaro -> Bool
caligrafia unBarbaro = (all tieneMasDeTresVocales.habilidades $ unBarbaro) && (all comienzaConMayuscula.habilidades $ unBarbaro)

tieneMasDeTresVocales :: String -> Bool
tieneMasDeTresVocales = (>3).length.filter esVocal
esVocal :: Char -> Bool
esVocal caracter = elem caracter "AEIOUaeiou"
comienzaConMayuscula :: String -> Bool
comienzaConMayuscula unaPalabra = elem (head unaPalabra) esMayuscula      -- isUpper.head   import.Data.Char (toUpper)
  where esMayuscula = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

sobrevivientes :: [Barbaro] -> Aventura -> [Barbaro]
sobrevivientes listaDeBarbaros unaAventura = filter (esSobreviviente all unaAventura) listaDeBarbaros

-- type Criterio = Foldable t => (a -> Bool) -> t a -> Bool
-- esSobreviviente :: Criterio -> Aventura -> Barbaro -> Bool     
esSobreviviente criterio unaAventura unBarbaro = criterio (\unEvento -> unEvento unBarbaro) unaAventura

{- 
armarListaSorevivientes:: (Barbaro -> [Char]) -> Aventura
armarListaSorevivientes unaaventura unbarbaro
  | unaaventura unbarbaro == "Sobrevive" = (nombre unbarbaro) 
  | otherwise = ""

sobrevivientes :: [Barbaro] -> Aventura -> [String] 
sobrevivientes variosBarbaros unaaventura = filter  (/="").map (armarListaSorevivientes unaaventura) $ variosBarbaros
-}

-- PUNTO 4 - Dinastía
sinHabilidadesRepetidas :: Barbaro -> Barbaro
sinHabilidadesRepetidas unBarbaro = modificarHabilidades (const eliminarRepetidos.habilidades $ unBarbaro) unBarbaro

eliminarRepetidos :: Eq a => [a] -> [a]
eliminarRepetidos [] = []
eliminarRepetidos (cabeza:cola) = cabeza : eliminarRepetidos (filter (/= cabeza) cola)

descendientes :: Barbaro -> Barbaro
descendientes = iterate descendiente

descendiente :: Barbaro -> Barbaro
descendiente = utilizarObjetos.modificarNombre (++"*").modificarHabilidades sinHabilidadesRepetidas -- * = generacion ; mismo poder y objetos aplicados que el padre ; habilidades sin repetir 

utilizarObjetos :: Barbaro -> Barbaro
utilizarObjetos unBarbaro = foldr1 ($) (objetos unBarbaro) 
-- si utilizo foldl debo invertir los parametros (flip), tambien se podria foldl1 (.) y luego aplicar al barbaro, o con la cuerda

{-
crearHijo :: Barbaro -> Barbaro
crearHijo unbarbaro = unbarbaro{nombre = nombre unbarbaro ++ "*", objetos = objetos unbarbaro }

usarObjetos:: Barbaro -> Barbaro
usarObjetos unbarbaro = (foldl1 (.) (objetos unbarbaro)) unbarbaro

descendientes:: Barbaro -> Barbaro --NO FUNCIONA LA PARTE DE OBJETOS
descendientes unbarbaro = descendientes.crearHijo.usarObjetos $ unbarbaro
-}

--C. Pregunta: ¿Se podría aplicar sinRepetidos sobre la lista de objetos? ¿Y sobre el nombre de un bárbaro? ¿Por qué?
--No, porque los objetos son funciones y las funciones no se pueden comparar entre si por
--Si se podria aplicar sobre el nombre del barbaro porque el tipo string es un type alias para la lista de char, entonces el nombre seria sin letras repetidas, string es comparable
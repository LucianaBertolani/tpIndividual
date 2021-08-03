--                                                                              https://docs.google.com/document/d/1FAENwvt5Il1Ldm7D0bEgGgchysOecmbjsgtShPay1YU/edit#
module Lib where
import Data.Char(intToDigit)
import Data.Char(ord)
import Data.List()
import Data.List(elemIndex)
import Data.Maybe (fromMaybe)
import Text.Show.Functions ()


data Criatura = UnaCriatura{
    nivelPeligrosidad :: Int,
    comoDeshacerseDe :: Deshacerse 
} deriving(Show)

data Persona = UnaPersona{
    edad :: Int,
    items :: [Item],
    experiencia :: Int
} deriving(Show)

type Item = String
type Deshacerse = Persona -> Bool

modificarExperiencia :: Int -> Persona -> Persona
modificarExperiencia nuevaExp unaPersona = unaPersona{experiencia = experiencia unaPersona + nuevaExp}

siempredetras :: Criatura                       -- inofensiva pero no te se puede deshacer de ella
siempredetras = UnaCriatura 0 (const False)

--puedeDeshacerseSi :: (a->Bool) -> Personaje -> Bool                           generalizar tiene y resolverConflicto
--puedeDeshacerseSi condicion unPersonaje = condicion unPersonaje
tiene ::  String -> Persona -> Bool
tiene item = elem item.items

gnomos:: Int -> Criatura
--gnomos cantidadDeGnomos = UnaCriatura (2^cantDeGnomos) (tiene "soplador de hojas")
gnomos cantidadDeGnomos = UnaCriatura (2^cantidadDeGnomos) (puedeDeshacerseSi.elem "soplador de hojas".items)

-- fantasmaCategoriaX categoria = UnaCriatura (20*categoria) comoDeshacerseDe       -- comoDeshacerse queda pendiente segun la categoria

fantasmasCategoria3 :: Criatura
fantasmasCategoria3 = UnaCriatura (20*3) resolverConflictoCategoria3
--fantasmasCategoria3 = UnaCriatura (20*3) (puedeDeshacerseSi.elem "disfraz de oveja".items && puedeDeshacerseSi (<13).edad 

fantasmasCategoria1 :: Criatura
fantasmasCategoria1 = UnaCriatura (20*1) resolverConflictoCategoria1
-- fantasmasCategoria1 = UnaCriatura (20*1) puedeDeshacerseSi (>10).experiencia

resolverConflictoCategoria3 :: Persona -> Bool
resolverConflictoCategoria3 unaPersona = edad unaPersona < 13 && tiene "disfraz de oveja" unaPersona 

resolverConflictoCategoria1 :: Persona -> Bool
resolverConflictoCategoria1  unaPersona = experiencia unaPersona > 10

mabel :: Persona
mabel = UnaPersona 12 ["soplador de hojas"] 0

pato :: Persona -- es un cerdo!!
pato = UnaPersona 12 ["disfraz de oveja"] 0

--Punto 2
enfrentarA :: Criatura -> Persona -> Persona                -- si la persona se deshace gana cantidad de experienca como nivel de peligrosidad, sino gana 1 punto por aprender
enfrentarA unaCriatura unaPersona
  | (comoDeshacerseDe unaCriatura) unaPersona = modificarExperiencia (nivelPeligrosidad unaCriatura) unaPersona
  | otherwise = modificarExperiencia 1 unaPersona

--3B
ganaXExperiencia :: Persona -> [Criatura] -> Int
ganaXExperiencia unaPersona grupoDeCriaturas = experiencia.enfrentamientoSucesivo

enfrentamientoSucesivo :: Persona -> [Criatura] -> Persona
enfrentamientoSucesivo unaPersona grupoDeCriaturas = foldr1 (flip.enfrentarA unaPersona) grupoDeCriaturas

{-enfrentarSucesivamente:: Persona -> [Criatura] -> Int
enfrentarSucesivamente unaPersona = sum.map experiencia.map (enfrentarA unaPersona)

enfrentarSucesivamente':: Persona -> [Criatura] -> Int
enfrentarSucesivamente' unaPersona = experiencia.foldl (enfrentarA ) unaPersona -}

-- ejemplo:         ganaXExperiencia mabel [siempreDetras, gnomos 10, fantasmaCategoria3, fantasmaCategoria1]

{- PUNTO 4
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b] 
que a partir de dos listas retorne una lista donde cada elemento:
- se corresponda con el elemento de la segunda lista, en caso de que el mismo no cumpla con la condición indicada
- en el caso contrario, debería usarse el resultado de aplicar la primer función con el par de elementos de dichas listas
Sólo debería avanzarse sobre los elementos de la primer lista cuando la condición se cumple. 
> zipWithIf (*) even [10..50] [1..7]
[1,20,3,44,5,72,7] ← porque [1, 2*10, 3, 4*11, 5, 6*12, 7]
-}

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b] 
zipWithIf _ _ [] [] = []
zipWithIf  _ _ [] (_:_) = []
zipWithIf  _ _ (_:_) [] = []
zipWithIf funcion condicion (x:xs) (y:ys)  
    |condicion y = funcion x y : zipWithIf funcion condicion (xs) (ys)
    | otherwise = y : zipWithIf funcion condicion (x:xs) ys

{-
2) Notamos que la mayoría de los códigos del diario están escritos en código César, que es una simple sustitución de todas 
las letras por otras que se encuentran a la misma distancia en el abecedario. Por ejemplo, si para encriptar un mensaje se sustituyó
 la a por la x, la b por la y, la c por la z, la d por la a, la e por la b, etc.. Luego el texto "jrzel zrfaxal!" que fue encriptado
  de esa forma se desencriptaría como "mucho cuidado!".

Hacer una función abecedarioDesde :: Char -> [Char] que retorne las letras del abecedario empezando por la letra indicada.
 O sea, abecedarioDesde 'y' debería retornar 'y':'z':['a' .. 'x'].

Hacer una función desencriptarLetra :: Char -> Char -> Char que a partir una letra clave (la que reemplazaría a la a) y la letra que
 queremos desencriptar, retorna la letra que se corresponde con esta última en el abecedario que empieza con la letra clave. 
 Por ejemplo: desencriptarLetra 'x' 'b' retornaría 'e'.

Hint: se puede resolver este problema sin tener que hacer cuentas para calcular índices ;)
Definir la función cesar :: Char -> String -> String que recibe la letra clave y un texto encriptado y retorna todo el texto desencriptado, 
teniendo en cuenta que cualquier caracter del mensaje encriptado que no sea una letra (por ejemplo '!') se mantiene igual. 
Usar zipWithIf para resolver este problema.
Realizar una consulta para obtener todas las posibles desencripciones (una por cada letra del abecedario) usando cesar 
para el texto "jrzel zrfaxal!".
-}


alfabetoDesde :: Char -> String
alfabetoDesde letra
    | letra > 'a' && letra <= 'z' = [letra..'z'] ++ ['a'..pred letra]
    | otherwise            = ['a'..'z']
 

---d
desencriptarLetra :: Char->Char->Char
desencriptarLetra letraClave aDesencriptar = ['a'..'z'] !! (((+) (-96)).ord.head.take (ord aDesencriptar - 97) $(alfabetoDesde letraClave))

--"xyzabcdefghijklmnopqrstuvw"  
--"abcdefghijklmnopqrstuvwxyz"

-- encontre una funcion que podria ayudar...          
--Input: elemIndex 'f' "abcdefghi"
--Output: Just 5
--Si
--NO
--funcionRara :: Char->Char->Char
--funcionRara letraClave aDesencriptar =  alfabetoDesde letraClave !! (length.alfabetoDesde $ aDesencriptar)p

--porfaAnda letraClave aDesencriptar = (!!).(fromMaybe (elemIndex aDesencriptar (alfabetoDesde letraClave))) $ ['a'..'z']

--Input: "Hello" !! 1, 

{-                                  SON LOS PEORES ESTOS EJERCICIO, NO PODES PERO TE ATRAPAN si
mx :: Maybe Int
case mx of
    Just x  -> x
    Nothing -> _
-}
-- Ejercicio 5.1. Definir, por comprensión, la función                  ahora la busco y la paso = elemIndic
--    posiciones :: String -> Char -> [Int]
-- tal que (posiciones xs y) es la lista de la posiciones del carácter y
-- en la cadena xs. Por ejemplo,
--    posiciones "Salamamca" 'a'  ==  [1,3,5,8]
--
-- --------------------------------------------------------------------- me canse de escribir
                                                                        -- Que hace un muerto?, como va a nadar si esta muerto!!
 
posiciones :: String -> Char -> [Int]                                    
posiciones xs y = [n | (x,n) <- zip xs [0..], x == y]

desencriptarLetra' ::  Char -> Char -> Char
desencriptarLetra' letraClave aDesencriptar = last (take ((head.posiciones (alfabetoDesde letraClave) $ aDesencriptar)+1) ['a'..'z'])

--2c
cesar :: Char -> String -> String
cesar letraClave textoEncriptado = zipWithIf desencriptarLetra perteneceAlAbecedario (listaDeLetraClave letraClave (length textoEncriptado)) textoEncriptado

perteneceAlAbecedario :: Char -> Bool
perteneceAlAbecedario letra = elem letra ['a'..'z']

listaDeLetraClave :: Char -> Int -> [Char]
listaDeLetraClave letraClave repeticiones = replicate repeticiones letraClave

--3

vigenere :: String -> String -> String
vigenere clave mensajeEncriptado = zipWithIf d
vigenere :: String -> String -> String
vigenere clave mensajeEncriptado = zipWithIf desencriptarLetra perteneceAlAbecedario (concat (listaDeClave clave (length mensajeEncriptado))) mensajeEncriptado

listaDeClave :: String -> Int -> [String]
listaDeClave clave repeticiones = replicate repeticiones clave
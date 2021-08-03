module Lib where
import Text.Show.Functions ()
import Data.List (nub)
data Persona = Unapersona{
    nombre           :: String,
    direccion        :: String,
    dineroDisponible :: Int,
    comidaFavorita   :: Comidas,
    cupones          :: [Cupon]
}deriving (Show)

data Comidas = Unacomida{
    nombreComida :: String,
    precio       :: Int,
    ingredientes :: [String]
}deriving (Show)

type Cupon = Comidas -> Comidas

napoConFritas :: Comidas
napoConFritas = (Unacomida "Mila Napolitana con Fritas" 500 ["carne","pan rayado","huevo","papas","queso","tomate"])

hamburguesaDeluxe :: Comidas
hamburguesaDeluxe = ( Unacomida "Hamburguesa Deluxe" 350 ["pan","carne","lechuga","tomate","panceta","queso","huevo frito"])

paula :: Persona
paula = (Unapersona "Paula" "Thames al 1585" 3600 hamburguesaDeluxe [] )

fernando :: Persona
fernando = (Unapersona "Fernando" "Ventalia al 2300" 2500 napoConFritas [esoNoEsCocaPapi "CocaCola",largaDistancia])

modificarDinero :: Int -> Persona -> Persona
modificarDinero dinero unapersona = unapersona{dineroDisponible = (-) (dineroDisponible unapersona) dinero }

comprar :: Persona -> Comidas -> Persona
comprar unapersona unacomida
    | precio unacomida < 200 = unapersona{dineroDisponible = dineroDisponible unapersona - precio unacomida, comidaFavorita = unacomida}
    | dineroDisponible unapersona < precio unacomida = modificarDinero 100 unapersona
    |otherwise = unapersona

carritoDeCompras :: [Comidas] -> Persona -> Persona
carritoDeCompras comidas unapersona = (modificarDinero 100).foldl (comprar) unapersona $ comidas

esvegana :: Comidas->[String]->Bool
esvegana unacomida lista = not.any (flip elem lista) $ingredientes unacomida

semanaVegana :: Cupon
semanaVegana unacomida
 |esvegana unacomida ["carne","queso","huevo","huevo frito"]  = unacomida{precio = div (precio unacomida) 2}
 |otherwise = unacomida

esoNoEsCocaPapi :: String -> Cupon
esoNoEsCocaPapi bebida unacomida = unacomida{nombreComida= nombreComida unacomida ++ "Party", ingredientes = ingredientes unacomida ++ [bebida]}

sinTACCis :: Cupon
sinTACCis unacomida = unacomida{nombreComida= nombreComida unacomida ++ " libre de luten"}

findeVegetariano :: Cupon
findeVegetariano unacomida
 |not.(elem "carne") $(ingredientes unacomida) = unacomida{precio = div ((*) (precio unacomida) 30) 100}
 |otherwise = unacomida

largaDistancia :: Cupon
largaDistancia unacomida =  unacomida{precio = (precio unacomida) + 50, ingredientes = filter ((>)10.length).ingredientes $ unacomida}

comprarConCupones :: Persona->Comidas->Persona
comprarConCupones unapersona comida= (comprar unapersona).foldl1 (.) (cupones unapersona) $comida

superComida :: [Comidas] -> Comidas
superComida listaDeComidas = Unacomida{nombreComida= filter esconsonante . concatMap nombreComida $listaDeComidas, precio= sum.map precio $listaDeComidas, ingredientes = nub.concatMap ingredientes $listaDeComidas}

esconsonante :: Char -> Bool
esconsonante = not.flip elem "aeiou"

sinRepetidos :: (Eq a) => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x:xs) = x : sinRepetidos (filter (/= x) xs)

import Text.Show.Functions ()
import Data.List (nub)

-- Parte A
-- A.1
data Persona = Persona {
  nombre :: String,
  direccion :: String,
  dinero :: Float,
  comidaFavorita :: Comida,
  cupones :: [Cupon]
} deriving Show

-- A.2
data Comida = Comida {
  nombreComida :: String,
  costo :: Float,
  ingredientes :: [Ingrediente]
} deriving Show

type Ingrediente = String

type Cupon = Comida -> Comida

-- helpers
type Mapper fieldType _data = (fieldType -> fieldType) -> _data -> _data

mapDinero :: Mapper Float Persona
mapDinero unaFuncion unaPersona = unaPersona { dinero = unaFuncion . dinero $ unaPersona }

mapDireccion :: Mapper String Persona
mapDireccion unaFuncion unaPersona = unaPersona { direccion = unaFuncion . direccion $ unaPersona }

gastarPlata :: Float -> Persona -> Persona
gastarPlata = mapDinero . subtract

mapComidaFavorita :: Mapper Comida Persona
mapComidaFavorita unaFuncion unaPersona = unaPersona { comidaFavorita = unaFuncion . comidaFavorita $ unaPersona }

setComidaFavorita :: Comida -> Persona -> Persona
setComidaFavorita = mapComidaFavorita . const

mapCosto :: Mapper Float Comida
mapCosto unaFuncion unaComida = unaComida { costo = unaFuncion . costo $ unaComida }

multiplicarCosto :: Float -> Comida -> Comida
multiplicarCosto = mapCosto . (*)

mapNombreComida :: Mapper String Comida
mapNombreComida unaFuncion unaComida = unaComida { nombreComida = unaFuncion . nombreComida $ unaComida }

mapIngredientes :: Mapper [Ingrediente] Comida
mapIngredientes unaFuncion unaComida = unaComida { ingredientes = unaFuncion . ingredientes $ unaComida }

agregarIngrediente :: Ingrediente -> Comida -> Comida
agregarIngrediente = mapIngredientes . (:)
-- helpers

-- A.3
paula :: Persona
paula = Persona "Paula" "Thames 1585" 3600 hamburguesaDeluxe []

-- A.4
hamburguesaDeluxe :: Comida
hamburguesaDeluxe = Comida "Hamburguesa Deluxe" 350 ["pan", "carne", "lechuga", "tomate", "panceta", "queso", "huevo frito"]

-- A.5
juli :: Persona
juli = Persona "Julián Berbel Alt" "Juan B. Alberdi 618" 10 pizza []

pizza :: Comida
pizza = undefined

-- Parte B
-- B.1
comprar :: Comida -> Persona -> Persona
comprar unaComida unaPersona
  | leAlcanzaParaComprar unaComida unaPersona = favoritearSiEsBarata unaComida . gastarPlata (costo unaComida) $ unaPersona
  | otherwise                                 = unaPersona

favoritearSiEsBarata :: Comida -> Persona -> Persona
favoritearSiEsBarata unaComida unaPersona
  | esBarata unaComida = setComidaFavorita unaComida unaPersona
  | otherwise          = unaPersona

leAlcanzaParaComprar :: Comida -> Persona -> Bool
leAlcanzaParaComprar unaComida unaPersona = saleMenosDe (dinero unaPersona) unaComida

saleMenosDe :: Float -> Comida -> Bool
saleMenosDe unaCantidad unaComida = costo unaComida <= unaCantidad

esBarata :: Comida -> Bool
esBarata = saleMenosDe 200

-- B.2
carritoDeCompras :: [Comida] -> Persona -> Persona
carritoDeCompras unasComidas unaPersona = gastarPlata 100 . foldr comprar unaPersona $ unasComidas

-- B.3.1
semanaVegana :: Cupon
semanaVegana = descuentoCondicional esComidaVegana 0.5

esComidaVegana :: Comida -> Bool
esComidaVegana unaComida = all (flip noTiene unaComida) ["carne", "huevo", "queso"]

-- B.3.2
esoNoEsCocaPapi :: String -> Cupon
esoNoEsCocaPapi unaBebida = mapNombreComida (++ " Party") . agregarIngrediente unaBebida

-- B.3.3
sinTACCis :: Cupon
sinTACCis = mapIngredientes (map (++ "libre de gluten"))

-- B.3.4
findeVegetariano :: Cupon
findeVegetariano = descuentoCondicional esComidaVegetariana 0.7

esComidaVegetariana :: Comida -> Bool
esComidaVegetariana = noTiene "carne"

noTiene :: Ingrediente -> Comida -> Bool
noTiene unIngrediente = not . elem unIngrediente . ingredientes

descuentoCondicional :: (Comida -> Bool) -> Float -> Comida -> Comida
descuentoCondicional unaCondicion unDescuento unaComida
  | unaCondicion unaComida = multiplicarCosto unDescuento unaComida
  | otherwise              = unaComida

-- B.3.5
largaDistancia :: Cupon
largaDistancia unaComida = perderIngredientesLargos . mapCosto (+ 50) $ unaComida

perderIngredientesLargos :: Comida -> Comida
perderIngredientesLargos = mapIngredientes (filter esIngredienteCorto)

esIngredienteCorto :: Ingrediente -> Bool
esIngredienteCorto unIngrediente = length unIngrediente <= 10

-- C.1
comprarConCupones :: Persona -> Persona
comprarConCupones unaPersona = comprar (foldr ($) (comidaFavorita unaPersona) $ cupones unaPersona) unaPersona

-- C.2
superComida :: [Comida] -> Comida
superComida unasComidas = Comida {
  nombreComida = filter esConsonante . concatMap nombreComida $ unasComidas,
  costo        = sum . map costo $ unasComidas,
  ingredientes = nub . concatMap ingredientes $ unasComidas
}

esConsonante :: Char -> Bool
esConsonante = not . flip elem vocales
  where vocales = "aeiouAEIOU"

-- C.3
carritoDeluxe :: [Comida] -> Persona -> Persona
carritoDeluxe = comprar . superComida . map (multiplicarCosto 2) . filter (saleMenosDe 400)
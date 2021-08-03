import Text.Show.Functions ()

-- PARTE A
data Persona = UnaPersona {
    nombrePersona :: String,
    direccion :: String,
    dineroDisponible :: Float,
    comidaFavorita :: Comida,
    cupones :: [Promocion]
} deriving (Show)

data Comida = UnaComida {
    nombreComida :: String,
    precio :: Float,
    ingredientes :: [String]
} deriving (Show, Eq)

paula :: Persona
paula = (UnaPersona "Paula" "Thames 1585" 3600 hamburguesaDeluxe [])

yo :: Persona
yo = (UnaPersona "Luchi" "Jupiter 2001" 5000  canelones [esoNoEsCocaPapi "agua",largaDistancia])

hamburguesaDeluxe :: Comida
hamburguesaDeluxe = (UnaComida "Hamburguesa Deluxe" 350 ["pan","carne","lechuga","tomate","panceta","queso","huevo frito"])

canelones :: Comida
canelones = (UnaComida "Canelones" 200 ["harina","tomate","cheese","espinaca","cebolla","salsa"])

-- PARTE B
modificarDinero :: (Float -> Float) -> Persona -> Persona
modificarDinero operacion unaPersona = unaPersona {dineroDisponible = operacion.dineroDisponible $ unaPersona}

nuevaComidaFavorita :: Comida -> Persona -> Persona
nuevaComidaFavorita nuevaComida unaPersona = unaPersona {comidaFavorita = nuevaComida}

tienePlataSuficiente :: Comida -> Persona -> Bool -- BUSCAR COMPOSICION
tienePlataSuficiente unaComida unaPersona = precio unaComida <= dineroDisponible unaPersona

{-comprar: cuando una persona compra una comida se descuenta el costo de la misma de su dinero disponible (¡ojo! No se puede comprar si no alcanza la plata). 
Además, si salió menos de $200 se vuelve su nueva comida favorita.-}
comprar :: Comida -> Persona -> Persona
comprar unaComida unaPersona
  | tienePlataSuficiente unaComida unaPersona && ((< 200).precio $ unaComida) = nuevaComidaFavorita unaComida.modificarDinero (subtract.precio $ unaComida) $ unaPersona
  | tienePlataSuficiente unaComida unaPersona = modificarDinero (subtract.precio $ unaComida) $ unaPersona
  | otherwise = unaPersona

{-carritoDeCompras: en nuestra aplicación se pueden comprar muchas comidas al mismo tiempo. 
Lamentablemente usar este servicio hace que el empaque sea más pesado, por lo que se suma $100 más al total.-}
modificarPrecio :: (Float -> Float) -> Comida -> Comida
modificarPrecio operacion unaComida = unaComida {precio = operacion.precio $ unaComida}

carritoDeCompras :: [Comida] -> Persona -> Persona
carritoDeCompras unasComidas unaPersona = modificarDinero (subtract 100) . foldr comprar unaPersona $ unasComidas

type Promocion = Comida -> Comida
{-semanaVegana :: Promocion
semanaVegana unaComida
  | esComidaVegana unaComida = modificarPrecio (div 2) unaComida
  | otherwise                = unaComida

esComidaVegana :: Comida -> Bool
esComidaVegana unaComida = .ingredientes

BY NICO
esIngredienteNoVegano:: String -> Bool
esIngredienteNoVegano ingrediente = elem ingrediente ["carne","queso","huevo"]

esVegana::  Comida -> Bool
esVegana unacomida = all (not.esIngredienteNoVegano) (ingredientes unacomida)

semanaVegana :: Cupon
semanaVegana unacomida
  | esVegana $ unacomida = modificarCostoComida (/ 2) unacomida
  | otherwise = unacomida

BY FER
esvegana :: Comidas->[String]->Bool
esvegana unacomida lista = not.any (flip elem lista) $ingredientes unacomida

semanaVegana :: Cupon
semanaVegana unacomida
 |esvegana unacomida ["carne","queso","huevo","huevo frito"]  = unacomida{precio = div (precio unacomida) 2}
 |otherwise = unacomida
-}
-- semanaVegana: si la comida a comprar es vegana (no contiene carne, huevos o queso entre sus ingredientes) su costo se reduce a la mitad. 
semanaVegana :: Promocion
semanaVegana unaComida
  | esComidaVegana unaComida = modificarPrecio (* 0.5) unaComida
  | otherwise = unaComida

esComidaVegana :: Comida -> Bool
esComidaVegana unaComida = all noEsIngredienteVegano . ingredientes $ unaComida

noEsIngredienteVegano :: String -> Bool
noEsIngredienteVegano unIngrediente = notElem unIngrediente ["carne","huevo","queso"]

esoNoEsCocaPapi :: String -> Promocion
esoNoEsCocaPapi unaBebida unaComida = agregarIngredientes [unaBebida].comidaParty $ unaComida

comidaParty :: Comida -> Comida 
comidaParty  unaComida = unaComida {nombreComida = (++"Party").nombreComida $ unaComida}

agregarIngredientes :: [String] -> Comida -> Comida
agregarIngredientes ingredientesAAgregar unaComida = unaComida {ingredientes = (++ ingredientesAAgregar).ingredientes $ unaComida}

sinTACCis :: Promocion
sinTACCis unaComida = unaComida {ingredientes = map (++" libre de gluten").ingredientes $ unaComida}

findeVegetariano :: Promocion
findeVegetariano unaComida
  | esComidaVegetariana unaComida = modificarPrecio (* 0.7) unaComida
  | otherwise                = unaComida

esComidaVegetariana :: Comida -> Bool
esComidaVegetariana unaComida = not.elem "carne".ingredientes $ unaComida

{-es mas expresivo si existe la funcion calcularDescuento y la resto en modificarPrecio???  + ERROR DE TIPOS
calcularDescuento :: Comida -> Float
calcularDescuento unaComida = div ((*30).precio unaComida) 100 -- (*0.3).precio unComida -}

largaDistancia :: Promocion
largaDistancia unaComida = perderIngredientesPesados.modificarPrecio (+ 50) $ unaComida

perderIngredientesPesados :: Comida -> Comida   -- pueden zafar
perderIngredientesPesados unaComida = unaComida {ingredientes = filter noEsIngredientePesado.ingredientes $ unaComida}

noEsIngredientePesado :: String -> Bool
noEsIngredientePesado = (<10).length

-- comprarConCupones: nos permite que una persona realice la compra de su comida favorita aplicándole todos los cupones que tiene a su disposición.
-- comprarConCupones :: Persona -> Persona
-- comprarConCupones unaPersona = comprar (comidaFavorita unaPersona).superCupon unaPersona $ unaPersona

superCupon :: Persona -> Promocion
superCupon unaPersona = foldr1 (.) (cupones unaPersona)

superComida :: [Comida] -> Comida
superComida listaDeComidas = UnaComida {
    nombreComida = superNombre listaDeComidas,
    precio = superPrecio listaDeComidas,
    ingredientes = superIngredientes listaDeComidas
}

superPrecio :: [Comida] -> Float
superPrecio listaDeComidas = sum.map precio $ listaDeComidas

superNombre :: [Comida] -> String
superNombre listaDeComidas = filter noEsVocal.concatMap nombreComida $ listaDeComidas 

{-juntarNombres :: [Comida] -> String
juntarNombres variasComidas = foldl1 (++) (map (sacarVocales.nombreComida) $ variasComidas)
-}

noEsVocal :: Char -> Bool
noEsVocal letra = not.elem letra $ "AEIOUaeiou"

superIngredientes :: [Comida] -> [String]
superIngredientes listaDeComidas = sinRepetidos.foldl1 (++). map ingredientes $ listaDeComidas

sinRepetidos :: (Eq a) => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x:xs) = x : sinRepetidos (filter (/= x) xs)

{-
obtenerComidasMenoresA400:: [Comida] -> [Comida]
obtenerComidasMenoresA400  = filter ((<400).costo) 

obtenerYMultiplicarPrecioComidas:: [Comida] -> [Comida]
obtenerYMultiplicarPrecioComidas variasComidas = map (modificarCostoComida (*2)) (obtenerComidasMenoresA400 variasComidas)

compraDeluxe:: Persona -> [Comida] -> Persona
compraDeluxe unapersona variasComidas =  (comprar unapersona).superComida.obtenerYMultiplicarPrecioComidas $ variasComidas
-}
--comprar,carrito de compras fold
--cupones con fold
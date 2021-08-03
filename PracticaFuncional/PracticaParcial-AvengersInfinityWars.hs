-- INFINITY HASKELL         https://docs.google.com/document/d/1Y-hixhngNzgeWrNPyLqRHmmcF0h9D6CyRnrrfMhe2Gk/edit

--A.1) Modelar Personaje, estos tienen: nombre, una cantidad de poder, una lista de derrotas y varios equipamientos
-- Cada derrota tiene el nombre de su oponente y el año en el que ocurrió.

data Personaje = Personaje {
  nombre :: String,
  cantidadPoder :: Int,
  derrotas :: [Derrota],
  equipamiento :: [Equipamiento]
}

type Equipamiento = Personaje -> Personaje -- objetos de poder que dado un personaje modifican sus habilidades de manera extraordinaria.
type Derrota = (String, Int)

mapCantidadPoder :: (Int -> Int) -> Personaje -> Personaje 
mapCantidadPoder unaFuncion unPersonaje = unPersonaje {cantidadPoder = unaFuncion.cantidadPoder $ unPersonaje}

mapNombre :: (String -> String) -> Personaje -> Personaje
mapNombre unaFuncion unPersonaje = unPersonaje { nombre = unaFuncion . nombre $ unPersonaje }

mapDerrotas :: ([Derrota] -> [Derrota]) -> Personaje -> Personaje
mapDerrotas unaFuncion unPersonaje = unPersonaje { derrotas = unaFuncion . derrotas $ unPersonaje }

--A.2) lo realizan un grupo de personajes y multiplica el poder de cada uno de ellos por la cantidad de personajes que están entrenando al mismo tiempo.
entrenamiento :: [Personaje] -> [Personaje]
entrenamiento personajes = map (mapCantidadPoder ((*).length $ personajes)) personajes

--A.3) nos dice quienes son rivales para Thanos. Son dignos aquellos personajes que, luego de haber entrenado,  tienen un poder mayor a 500 y además alguna de sus derrotas se llame "Hijo de Thanos".
rivalesDignos :: [Personaje] -> [Personaje]
rivalesDignos personajes = filter esRivalDigno . entrenamiento $ personajes

esRivalDigno :: Personaje -> Bool
esRivalDigno unPersonaje = cantidadPoder unPersonaje > 500 && derrotoA "Hijo de Thanos" unPersonaje

derrotoA :: String -> Personaje -> Bool
derrotoA unHeroe unPersonaje = elem unHeroe . map fst . derrotas $ unPersonaje

--A.4) dado un año y dos conjuntos de personajes hace que cada personaje pelee con su contraparte de la otra lista y nos dice quienes son los ganadores. 
--Cuando dos personajes pelean, gana el que posee mayor poder y se le agregará la derrota del perdedor a su lista de derrotas con el año en el que ocurrió.
guerraCivil :: Int -> [Personaje] -> [Personaje] -> [Personaje]
guerraCivil año unosPersonajes otrosPersonajes = zipWith (pelear año) unosPersonajes otrosPersonajes

pelear :: Int -> Personaje -> Personaje -> Personaje
pelear año unPersonaje otroPersonaje 
  | cantidadPoder unPersonaje > cantidadPoder otroPersonaje = derrotar año unPersonaje otroPersonaje
  | otherwise = derrotar año otroPersonaje unPersonaje
  
derrotar :: Int -> Personaje -> Personaje -> Personaje
derrotar año ganador perdedor = mapDerrotas ((nombre perdedor, año):) ganador

-- B.2a si tiene menos de 5 derrotas le suma 50 de poder, pero si tiene 5 o más le resta 100 de poder. 
escudo :: Equipamiento
escudo unPersonaje
  | (<5).length.derrotas $ unPersonaje = mapCantidadPoder (+50) unPersonaje
  | otherwise = mapCantidadPoder (subtract 100) unPersonaje

-- B.2b devuelve el personaje anteponiendo "Iron" al nombre del personaje y le agrega una versión dada al final del mismo
trajeMecanizado :: Int -> Equipamiento
trajeMecanizado version unPersonaje = mapNombre (\unNombre -> "Iron " ++ unNombre ++ " V" ++ show version) unPersonaje

-- B.3 solo lo pueden usar determinados personajes, , guantelete del Infinito sólo lo puede usar Thanos, gemaDelAlma sólo lo puede usar Thanos
equipamientoExclusivo :: String -> Personaje -> Equipamiento -> Equipamiento
equipamientoExclusivo nombrePersonaje unPersonaje unEquipamiento
  | nombre unPersonaje == nombrePersonaje = unEquipamiento
  | otherwise = id

-- B.3a agrega "dios del trueno" al final del nombre y limpia su historial de derrotas ya que un dios es bondadoso. Solo lo puede usar Thor
stormBreaker :: Equipamiento
stormBreaker unPersonaje = equipamientoExclusivo "Thor" unPersonaje (mapNombre (++ " dios del trueno").mapDerrotas (const [])) $ unPersonaje

-- B.3b Añade a la lista de derrotas a todos los extras, y cada uno con un año diferente comenzando con el actual. Considerar que hay incontables extras. Solo lo puede usar Thanos
gemaDelAlma :: Equipamiento
gemaDelAlma unPersonaje = equipamientoExclusivo "Thanos" unPersonaje (mapDerrotas (++ derrotasExtras)) $ unPersonaje

derrotasExtras :: [Derrota]
derrotasExtras = zip extras [2018 ..]

extras :: [String]
extras = map agregarExtra [1..]

agregarExtra :: Int -> String
agregarExtra valor = ("extra numero "++).show $ valor

-- B.3c Aplica todos los equipamientos que sean gemas del infinito al personaje. 
-- Usar la función sin definirla esGemaDelInfinito la cual recibe un equipamiento y nos dice si la misma es o no una gema del infinito. 

{-
  Parte C
  a. Se cuelga porque definí derrotoAMuchos con un length, y el length de una lista infinita no termina de evaluar.
     Se puede definir derrotoAMuchos de forma de que sea lazy y pueda terminar de evaluar, como:
     derrotoAMuchos = not . null . drop 5 . derrotas
  b. Si no es fuerte luego de entrenar con el resto del equipo, termina bien.
     Si es fuerte y el hijo de thanos se encuentra entre sus derrotados, termina bien.
     En caso contrario, no termina.
  c. Si. Porque haskell trabaja con evaluación perezosa, y no es necesario evaluar toda la lista para tomar los primeros 100 elementos.
-}
import Text.Show.Functions ()

data Persona = UnaPersona {
  nombre :: String,
  cantidadCalorias :: Int,
  indiceHidratacion :: Int,
  minutosDisponibles :: Int,
  equipamiento :: [Equipamiento]
} deriving (Show)

type Equipamiento = String
type Ejercicio = Persona -> Persona

pablo :: Persona
pablo = UnaPersona "Pablito" 1000 100 120 ["pesa","colchoneta"]

modificarNombre :: (String -> String) -> Persona -> Persona
modificarNombre unaFuncion unaPersona = unaPersona { nombre = unaFuncion . nombre $ unaPersona }

modificarCalorias :: (Int -> Int) -> Persona -> Persona 
modificarCalorias unaFuncion unaPersona = unaPersona {cantidadCalorias = unaFuncion.cantidadCalorias $ unaPersona}

perderNCaloriasXRepeticion :: Int -> Int -> Persona -> Persona
perderNCaloriasXRepeticion caloriasDeUnaRepeticion repeticiones  = modificarCalorias (subtract.(*) repeticiones $ caloriasDeUnaRepeticion)

modificarHidratacion :: (Int -> Int) -> Persona -> Persona 
modificarHidratacion unaFuncion unaPersona = unaPersona {indiceHidratacion = unaFuncion.indiceHidratacion $ unaPersona}

deshidratarseSegunRepeticiones :: Int -> Int -> Int -> Persona -> Persona 
deshidratarseSegunRepeticiones deshidratacion cadaCuanto repeticiones = modificarHidratacion (subtract (div (repeticiones * deshidratacion) cadaCuanto))

modificarTiempo :: (Int -> Int) -> Persona -> Persona 
modificarTiempo unaFuncion unaPersona = unaPersona {minutosDisponibles = unaFuncion.minutosDisponibles $ unaPersona}

modificarEquipamiento :: ([String] -> [String]) -> Persona -> Persona
modificarEquipamiento unaFuncion unaPersona = unaPersona { equipamiento = unaFuncion . equipamiento $ unaPersona }

-- PARTE A
abdominales :: Int -> Ejercicio
abdominales = perderNCaloriasXRepeticion 8

flexiones :: Int -> Ejercicio
flexiones repeticiones = deshidratarseSegunRepeticiones 2 10 repeticiones.perderNCaloriasXRepeticion 16 repeticiones

levantarPesas :: Int -> Int -> Ejercicio
levantarPesas peso repeticiones unaPersona
  | tiene "pesa" unaPersona = deshidratarseSegunRepeticiones peso 10 repeticiones.perderNCaloriasXRepeticion 32 repeticiones $ unaPersona
  | otherwise = unaPersona

tiene :: String -> Persona -> Bool
tiene elemento unaPersona = elem elemento (equipamiento unaPersona)

laGranHomeroSimpson :: Ejercicio
laGranHomeroSimpson = id

renovarEquipo :: Persona -> Persona
renovarEquipo unaPersona = modificarEquipamiento (const.agregarNuevo $ unaPersona) unaPersona

agregarNuevo :: Persona -> [Equipamiento]
agregarNuevo unaPersona = map ("Nuevo " ++) (equipamiento unaPersona)

volverseYoguista :: Persona -> Persona
volverseYoguista unaPersona = modificarCalorias (flip div 2).modificarEquipamiento (const ["colchoneta"]).setearIndiceEn (mantenerMax100 unaPersona) $ unaPersona

mantenerMax100 :: Persona -> Int
mantenerMax100 unaPersona = max 100 (indiceHidratacion . modificarHidratacion (* 2) $ unaPersona)

volverseBodyBuilder :: Persona -> Persona
volverseBodyBuilder unaPersona
  | todosEquipamientosPesas unaPersona = modificarNombre (++ "BB").modificarCalorias (* 3) $ unaPersona
  | otherwise = unaPersona

todosEquipamientosPesas :: Persona -> Bool
todosEquipamientosPesas = all (== "pesa").equipamiento

comerUnSandwich :: Persona -> Persona
comerUnSandwich = modificarCalorias (+ 500).setearIndiceEn 100

setearIndiceEn :: Int -> Persona -> Persona
setearIndiceEn valor unaPersona = unaPersona {indiceHidratacion = valor}

-- PARTE B
data Rutina = UnaRutina {
    duracion :: Int,
    secuencia :: [Ejercicio]
} 
hacerRutina :: Rutina -> Persona -> Persona
hacerRutina unaRutina unaPersona 
  | leAlcanzaTiempo unaRutina unaPersona = foldr ($) unaPersona (secuencia unaRutina)
  | otherwise = unaPersona

leAlcanzaTiempo :: Rutina -> Persona -> Bool
leAlcanzaTiempo unaRutina unaPersona = (< duracion unaRutina).minutosDisponibles $ unaPersona

comoEsLaRutina :: (Int -> Bool) -> (Int -> Bool) -> Persona -> Bool
comoEsLaRutina condicionCalorias condicionHidratacion unaPersona = (condicionCalorias.cantidadCalorias $ unaPersona) &&  (condicionHidratacion.indiceHidratacion $ unaPersona)

esPeligrosa :: Rutina -> Persona -> Bool
esPeligrosa unaRutina unaPersona = comoEsLaRutina (< 50) (< 10).hacerRutina unaRutina $ unaPersona

esBalanceada :: Rutina -> Persona -> Bool
esBalanceada unaRutina unaPersona = comoEsLaRutina (< mitadEmpezada unaPersona) (> 80).hacerRutina unaRutina $ unaPersona

mitadEmpezada :: Persona -> Int
mitadEmpezada unaPersona = div (cantidadCalorias unaPersona) 2

elAbominableAbdominal :: Rutina
elAbominableAbdominal = UnaRutina 60 infinitosAbdominales

infinitosAbdominales :: [Ejercicio]
infinitosAbdominales = map abdominales [1,2..]

-- PARTE C
{-seleccionarGrupoDeEjercicio: una persona quiere seleccionar quienes pueden hacer rutina con ella a partir de un grupo de personas. 
Las personas que pueden ser grupo de ejercicio de otra son aquellas que tengan el mismo tiempo disponible.
promedioDeRutina: dada una rutina y un grupo de personas, devolver el promedio de calorías y el índice de hidratación final del grupo tras haber hecho la rutina.-}

seleccionarGrupoDeEjercicio :: Persona -> [Persona] -> [Persona]
seleccionarGrupoDeEjercicio unaPersona unGrupo = filter (puedeHacerEjercicioCon unaPersona) unGrupo

puedeHacerEjercicioCon :: Persona -> Persona -> Bool
puedeHacerEjercicioCon unaPersona otraPersona = minutosDisponibles unaPersona == minutosDisponibles otraPersona

{-
promedioDeRutina: primero el grupo hace la rutina, una vez con la rutina se obtienen los promedios. Tendria la forma
promedioDeRutina :: Rutina -> [Persona] -> (Int,Int)
promedioDeRutina = (obtenerpromedio cantidadCalorias.hacerRutinaEnGrupo, obtenerPromedio nivelHidratacion.hacerRutinaEnGrupo)

hacerRutinaEnGrupo :: Rutina -> [Persona] -> Persona
hacerRutinaEnGrupo unaRutina unGrupo = aplicar el hacerRutina
-}
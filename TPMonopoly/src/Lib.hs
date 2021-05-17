module Lib where
import Text.Show.Functions ()

data Participante = UnParticipante {
    nombre :: Nombre,
    cantidadDeDinero :: Int, 
    tacticaDeJuego :: String,
    propiedadesCompradas :: [Propiedad],
    acciones :: [Accion]
} deriving Show

type Propiedad = (Nombre,Precio)
type Nombre    = String
type Precio    = Int
type Accion    = Participante -> Participante
type Ganador   = Participante

pepe :: Participante
pepe = (UnParticipante "Pepito" 500 "ser" [("pocilga",10),("casucha",30),("finca",300)] [pasarPorElBanco,pagarAAccionistas,enojarse])

carolina :: Participante
carolina = (UnParticipante "Carolina" 500 "Accionista" [] [pasarPorElBanco, pagarAAccionistas])

manuel :: Participante
manuel = (UnParticipante "Manuel" 500 "Oferente Singular" [] [pasarPorElBanco, enojarse])

modificarDinero :: Int -> Participante -> Participante
modificarDinero valor participante = participante {cantidadDeDinero = cantidadDeDinero participante + valor}

pasarPorElBanco :: Accion
pasarPorElBanco = modificarDinero 40.cambiarTacticaDeJuegoA "Comprador compulsivo"
cambiarTacticaDeJuegoA :: String -> Participante -> Participante
cambiarTacticaDeJuegoA nuevaTactica participante = participante {tacticaDeJuego = nuevaTactica}

enojarse :: Accion
enojarse = modificarDinero 50.agregarAcciones gritar
agregarAcciones :: Accion -> Participante -> Participante
agregarAcciones accion participante = participante {acciones = acciones participante ++ [accion]}

gritar :: Accion
gritar participante = participante {nombre = "AHHHH" ++ nombre participante}

subastar :: Propiedad -> Accion
subastar propiedadEnSubasta participante 
  | elem (tacticaDeJuego  participante) ["Oferente Singular","Accionista"] = modificarDinero (- snd propiedadEnSubasta).agregarPropiedad propiedadEnSubasta $ participante 
  | otherwise = participante
agregarPropiedad :: Propiedad -> Participante -> Participante
agregarPropiedad propiedadGanada participante = participante {propiedadesCompradas = propiedadesCompradas participante ++ [propiedadGanada]}

cobrarAlquileres :: Accion
cobrarAlquileres participante = modificarDinero (((*10).cantidadPropiedadesBaratas $ participante) + ((*20).cantidadPropiedadesCaras $ participante)) participante

cantidadPropiedades :: (Int -> Bool) -> Participante -> Int
cantidadPropiedades condicion = length.filter condicion.map snd.propiedadesCompradas
cantidadPropiedadesBaratas :: Participante -> Int
cantidadPropiedadesBaratas participante = cantidadPropiedades (<150) participante
cantidadPropiedadesCaras :: Participante -> Int
cantidadPropiedadesCaras participante = cantidadPropiedades (>=150) participante

pagarAAccionistas :: Accion
pagarAAccionistas participante
  | tacticaDeJuego participante == "Accionista" = modificarDinero (200) participante
  | otherwise                                   = modificarDinero (- 100) participante

hacerBerrinchePor :: Propiedad -> Accion
hacerBerrinchePor propiedad participante
  | snd propiedad > cantidadDeDinero participante = hacerBerrinchePor propiedad.modificarDinero 10.gritar $ participante
  | otherwise                                     = agregarPropiedad propiedad participante

ultimaRonda :: Participante -> Accion
ultimaRonda participante = foldl1 (.) (acciones participante)

juegoFinal :: Participante -> Participante -> Ganador
juegoFinal participante1 participante2
  | cantidadDeDinero (ultimaRonda participante1 participante1) < cantidadDeDinero (ultimaRonda participante2 participante2) = participante2
  | otherwise                                                                               = participante1

propiedadBarata :: Propiedad
propiedadBarata = ("Casita",30)

propiedadCara :: Propiedad
propiedadCara = ("Casona",300)

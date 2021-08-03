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
subastar (nombrePropiedad,precio) participante 
  | elem (tacticaDeJuego  participante) ["Oferente Singular","Accionista"] = modificarDinero (-precio).agregarPropiedad (nombrePropiedad,precio) $ participante 
  | otherwise = participante
agregarPropiedad :: Propiedad -> Participante -> Participante
agregarPropiedad (nombrePropiedad,precio) participante = participante {propiedadesCompradas = propiedadesCompradas participante ++ [(nombrePropiedad,precio)]}

-- ¿COMO SERIA POSIBLE CON COMPOSICION? DELEGAR CALCULO PROPIEDADES
cobrarAlquileres :: Accion
cobrarAlquileres participante = modificarDinero ((10*cantidadPropiedadesBaratas participante) + (20*cantidadPropiedadesCaras participante)) participante
-- cobrarAlquileres participante = modificarDinero (costoPropiedadesBaratas $ participante + costoPropiedadesCaras $ participante) participante

cantidadPropiedades :: (Int -> Bool) -> Participante -> Int
cantidadPropiedades condicion = length.filter condicion.map snd.propiedadesCompradas
cantidadPropiedadesBaratas :: Participante -> Int
cantidadPropiedadesBaratas participante = cantidadPropiedades (<150) participante
cantidadPropiedadesCaras :: Participante -> Int
cantidadPropiedadesCaras participante = cantidadPropiedades (>=150) participante -- participante parametro implicito

-- Intento de parametrizar costo y delegar calculo
-- costoPropiedades :: Int -> Persona -> Int
-- costoPropiedades valor funcionPropiedad = (* valor).funcionPropiedad 
-- costoPropiedadesBaratas :: Participante -> Int
-- costoPropiedadesBaratas participante = (*10).cantidadPropiedadesBaratas $ participante
-- costoPropiedadesCaras :: Participante -> Int
-- costoPropiedadesCaras participante = (*20).cantidadPropiedadesCaras $ participante

calcularCostoAlquiler :: Participante -> Int
calcularCostoAlquiler unParticipante = (10*cantidadPropiedadesBaratas unParticipante) + (20*cantidadPropiedadesCaras unParticipante)
--cobrarAlquileres participante = modificarDinero.((+ 20*cantidadPropiedadesCaras).(10*cantidadPropiedadesBaratas)) $ participante --)) participante

pagarAAccionistas :: Accion
pagarAAccionistas participante
  | tacticaDeJuego participante == "Accionista" = modificarDinero (200) participante
  | otherwise                                   = modificarDinero (-100) participante

hacerBerrinchePor :: Propiedad -> Accion
hacerBerrinchePor propiedad participante
  | snd propiedad > cantidadDeDinero participante = (hacerBerrinchePor propiedad).(modificarDinero 10).gritar $ participante
  | otherwise                                     = agregarPropiedad propiedad participante

ultimaRonda :: Participante -> Accion
ultimaRonda participante = foldl1 (.) (acciones participante)
-- ¿PODRIA DEVOLVER SOLO EL NOMBRE DEL GANADOR O TIENE QUE SER TODOS LOS DATOS DEL GANADOR? ¿COMO PODRIA APLICAR COMPOSICION?
juegoFinal :: Participante -> Participante -> Ganador
juegoFinal participante1 participante2
  | cantidadDeDinero (ultimaRonda participante1 participante1) < cantidadDeDinero (ultimaRonda participante2 participante2) = participante2 -- ? cantidaDeDinero.(ultimaRonda participante) $ participante
  | otherwise                                                                               = participante1

esPropiedad :: Propiedad -> String
esPropiedad propiedad
  | snd propiedad < 150 = "Barata"
  | otherwise           = "Cara"

esPropiedadBarata :: Propiedad -> Bool
esPropiedadBarata propiedad = snd propiedad < 150

esPropiedadCara' :: Propiedad -> Bool
esPropiedadCara' = not.esPropiedadBarata

-- IDEA EXTRA: parametrizar alguna de las funciones agregarPropiedad, agregarAcciones, modificarDinero, cambiarTacticaDeJuego
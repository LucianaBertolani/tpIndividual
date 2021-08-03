module Lib where
import Text.Show.Functions ()

data Libro = UnLibro{ 
  titulo :: String,
  autor :: String,
  cantidadDePaginas :: Int
}deriving (Show,Eq)

type Biblioteca = [Libro]
type Saga = [Libro]

visitante :: Libro
visitante = UnLibro "El visitante" "Stephen King" 592

shingekiNoKyojin1 :: Libro
shingekiNoKyojin1 = UnLibro "Shingeki no Kyojin: capitulo 1" "Hajime Isayama" 40

shingekiNoKyojin3 :: Libro
shingekiNoKyojin3 = UnLibro "Shingeki no Kyojin: capitulo 3" "Hajime Isayama" 40

shingekiNoKyojin127 :: Libro
shingekiNoKyojin127 = UnLibro "Shingeki no Kyojin: capitulo 127" "Hajime Isayama" 40

fundacion :: Libro
fundacion = UnLibro "Fundacion" "Isaac Asimov" 230

sandman5 :: Libro
sandman5 = UnLibro "Sandman: capitulo 5" "Neil Gaiman" 35

sandman10 :: Libro
sandman10 = UnLibro "Sandman: capitulo 10" "Neil Gaiman" 35

sandman12 :: Libro
sandman12 = UnLibro "Sandman: capitulo 12" "Neil Gaiman" 35

eragon :: Libro
eragon = UnLibro "Eragon" "Christopher Paolini" 544

eldest :: Libro
eldest = UnLibro "Eldest" "Christopher Paolini" 704

brisignr :: Libro
brisignr = UnLibro "Brisignr" "Christopher Paolini" 700

legado :: Libro
legado = UnLibro "Legado" "Christopher Paolini" 811

sagaEragon :: Saga
sagaEragon = [eragon,eldest,brisignr,legado]

miBiblioteca :: Biblioteca
miBiblioteca = [visitante, shingekiNoKyojin1, shingekiNoKyojin3, shingekiNoKyojin127, fundacion, sandman5, sandman10, sandman12, eragon, eldest, brisignr, legado]

esDe :: String -> Libro -> Bool
esDe unAutor unLibro = (== unAutor).autor $ unLibro

promedioDePaginas :: Biblioteca -> Int
promedioDePaginas unaBiblioteca = div (cantidadTotalDePaginas unaBiblioteca) (length unaBiblioteca)

cantidadTotalDePaginas :: Biblioteca -> Int
cantidadTotalDePaginas unaBiblioteca = sum.map cantidadDePaginas $ unaBiblioteca

esLecturaObligatoria :: Libro -> Bool
esLecturaObligatoria unLibro = esDe "Stephen King" unLibro || perteneceASagaEragon unLibro || unLibro == fundacion 

perteneceASagaEragon :: Libro -> Bool                     -- Delegar en esta función permite mayor declaratividad
perteneceASagaEragon unLibro = elem unLibro sagaEragon

esBibliotecaFantasiosa :: Biblioteca -> Bool
esBibliotecaFantasiosa unaBiblioteca = any esLibroFantasioso unaBiblioteca     -- no necesito mapear los autores porque delego en otra funcion

esLibroFantasioso :: Libro -> Bool
esLibroFantasioso unLibro = esDe "Christopher Paolini" unLibro || esDe "Neil Gaiman" unLibro

nombreDeLaBiblioteca :: Biblioteca -> String
nombreDeLaBiblioteca unaBiblioteca = sinVocales . concatenatoriaDeTitulos $ unaBiblioteca

sinVocales :: String -> String
sinVocales unString = filter (not . esVocal) unString

esVocal :: Char -> Bool
esVocal unCaracter = elem unCaracter "aeiouAEIOU"

concatenatoriaDeTitulos :: Biblioteca -> String
concatenatoriaDeTitulos unaBiblioteca = concatMap titulo unaBiblioteca
{-nombreDeLaBiblioteca unaBiblioteca = filter (not.esVocal) (concatMap titulo unaBiblioteca)-}

esBibliotecaLigera :: Biblioteca -> Bool
esBibliotecaLigera unaBiblioteca = all (<=40) (map cantidadDePaginas unaBiblioteca)

{- esBibliotecaLigera :: Biblioteca -> Bool
esBibliotecaLigera unaBiblioteca = all esLecturaLigera unaBiblioteca

esLecturaLigera :: Libro -> Bool
esLecturaLigera unLibro = ((<= 40) . cantidadDePaginas) unLibro-}

genero :: Libro -> String
genero unLibro
  | esDe "Stephen King" unLibro = "TERROR"
  | esDe "Hajime Isayama" unLibro= "MANGA"
  | cantidadDePaginas unLibro < 40 = "COMIIC"  -- esLecturaLigera
  | otherwise = "SIN CLASIFICAR"
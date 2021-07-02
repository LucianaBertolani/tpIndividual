%TP 1 logico                            Muerte en la mansión Dreadbury (v1.9)

viveEn(mansionDreadbury,agatha).
viveEn(mansionDreadbury,mayordomo).
viveEn(mansionDreadbury,charles).

odiaA(mayordomo,charles).
odiaA(charles,agatha).
odiaA(agatha,agatha).
odiaA(charles,mayordomo).
odiaA(agatha,mayordomo).

esMasRico(mayordomo,agatha).

mataA(Victima,Asesino):-
  odiaA(Victima,Asesino),
  esMasRico(Victima,Asesino),
  viveEn(mansionDreadbury,Asesino).

/*
1)  ?- mataA(agatha,Quien).
    false.
2)  ?- odiaA(milhouse,_).
    false.
    ?- odiaA(Quien,charles).
    mayordomo.
    ?- odiaA(agatha,Quien).
    charles;
    agatha.
    ?- odiaA(Odiado,Odiador).
    Odiado = mayordomo,
    Odiador = charles ;
    Odiado = charles,
    Odiador = agatha ;
    Odiado = Odiador, Odiador = agatha ;
    Odiado = charles,
    Odiador = mayordomo ;
    Odiado = agatha,
    Odiador = mayordomo.
    ?- odiaA(_,mayordomo).
    true.
*/
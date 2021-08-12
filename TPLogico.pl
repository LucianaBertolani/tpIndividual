%TP 1 logico                            Muerte en la mansión Dreadbury (v1.9)

viveEn(mansionDreadbury,agatha).
viveEn(mansionDreadbury,mayordomo).
viveEn(mansionDreadbury,charles).

odiaA(Odiado,agatha):-
  viveEn(mansionDreadbury,Odiado),
  Odiado \= mayordomo.

odiaA(Odiado,charles):-
  viveEn(mansionDreadbury,Odiado),
  not(odiaA(Odiado,agatha)).

odiaA(Odiado,mayordomo):-
  odiaA(Odiado,agatha).

esMasRico(Rico,agatha):-
  viveEn(mansionDreadbury,Rico),
  not(odiaA(Rico,mayordomo)).

mataA(Victima,Asesino):-
  viveEn(mansionDreadbury,Asesino),
  odiaA(Victima,Asesino),
  not(esMasRico(Asesino,Victima)).

/* 
1 ?- mataA(agatha,Quien).
Quien = agatha ;
false.

2 ?- odiaA(milhouse,_).
false.

3 ?- odiaA(Quien,charles).
Quien = mayordomo ;
false.

4 ?- odiaA(agatha,Quien).
Quien = agatha ;
Quien = mayordomo.

5 ?- odiaA(Odiado,Odiador).
Odiado = Odiador, Odiador = agatha ;
Odiado = charles, Odiador = agatha ;
Odiado = mayordomo, Odiador = charles ;
Odiado = agatha, Odiador = mayordomo ;
Odiado = charles, Odiador = mayordomo.

6 ?- odiaA(_,mayordomo).
true ;
true.
*/
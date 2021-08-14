%TP 1 logico                            Muerte en la mansión Dreadbury (v1.9)

% Al ser mansionDreadbury el único individuo que se utiliza como lugar en viveEn, 
% también podrías haber usado un predicado como viveEnLaMasion(agatha). 
viveEn(mansionDreadbury,agatha).
viveEn(mansionDreadbury,mayordomo).
viveEn(mansionDreadbury,charles).

/* La idea no era que nosotros saquemos las conclusiones 
de quien odia a quien, y lo mismo para esMasRico. 
Sino establecer reglas para saberlo.
odiaA(mayordomo,charles).
odiaA(charles,agatha).
odiaA(agatha,agatha).
odiaA(charles,mayordomo).
odiaA(agatha,mayordomo).

esMasRico(mayordomo,agatha). */
odiaA(UnaPersona, agatha):-
  viveEn(mansionDreadbury, UnaPersona),
  UnaPersona \= mayordomo.

/* "Quien mata es porque odia a su víctima y no es más rico que ella. 
Además, quien mata debe vivir en la mansión Dreadbury."
De la forma que lo hiciste (estableciendo las relaciones manualmente, y no con relgas),
no es lo mismo preguntar

esMasRico(A, B).
que

not(esMasRico(B, A)).
Sería preferible usar esta última.*/

mataA(Victima,Asesino):-
  odiaA(Victima,Asesino),
  esMasRico(Victima,Asesino),
  viveEn(mansionDreadbury,Asesino).

/* Con los cambios anteriores las consultas cambian.
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
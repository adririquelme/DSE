function  [desviacion, score]  = f_test_coplanaridad( X)
% Función de búsqueda de coplanaridad
% Adrián Riquelme, marzo 2013
% Esta función determina si los puntos de la nube introducida son
% coplanares. Si son perfectamente coplanares, los valores propios serán
% únicamente 2. En el caso de que no sean coplanares, habrá un tercer valor
% propio, y su valor comparado con el los otros dos nos indicará cuan
% coplanar cuán coplanar deja de serlo.

[~, score, valor_propio] = princomp (X,'econ');
[n,~]=size(valor_propio);
if n==3
    desviacion=abs(valor_propio(3,1))/(abs(valor_propio(1,1))+abs(valor_propio(2,1))+abs(valor_propio(3,1)));
else
    desviacion=0;
end

function [idx, dist, vertices_tin, calidad_tin, planos]=f_preparaTIN_v03_nocoplanartest(P, npb)
% [idx, dist, vertices_tin, calidad_tin, planos]=f_preparaTIN_v03_nocoplanartest(P, npb)
%% Función que prepara los puntos y genera los planos objeto de estudio
% Adrián Riquelme, abril 2013
% VERSIÓN QUE NO COMPRUEBA LOS COPLANARES
% Input: - P. matriz de nx3 que contiene las coordenadas de los puntos
%
% Output: 
% - idx: matriz [n,npb+1]. La primera columna indica el punto de
% referencia, las npb columnas restantes indican los npb puntos mï¿½s
% cercanos según la norma elegida. El valor es el id del punto.
% - dist: matriz [n,npb+1]. La primera columna sería cero, pues es la
% distancia de un punto consigo mismo. Las npb columnas siguientes indican
% la distancia el punto de referencia con el punto
% - vertices_tin: matriz que indica los puntos que forman parte del plano
% - calidad_tin: indica el n de puntos que forman cada plano
% - planos: matriz que contiene la ecuaciï¿½n de cada plano, ABCD

%    Copyright (C) {2015}  {Adrián Riquelme Guill, adririquelme@gmail.com}
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%   with this program; if not, write to the Free Software Foundation, Inc.,
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrián Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

% cargamos los puntos en una matriz de np x 3
% P = load ('puntos.txt');
[np,~] = size ( P );
% np es el num total de puntos disponibles se comprueba que toda la tabla
% está compuesta por nums y que el n de columnas es de 3 la f isnan
% devuelve 1 si no es número o 0 en caso de que lo sea. Si al final el
% test es de validación es 0 serï¿½ porque todos los valores de la matriz
% son números. En caso de que no lo sea, el test de validación nos
% dirá cuantos valores no numéricos hay.


%% buscamos los puntos cercanos con knnsearch
% primero definimos una matriz con las coordenadas de puntos en las columnas:
% col 1: coordenada x
% col 2: coordenada y
% col 3: coordenada z
% Para ello, hay que quitar la primera columna que es el id de cada punto

X=P(:,1:3);

% Ahora con el knnsearch hay que buscar para cada punto, cuales son los mas
% cercanos y cual es esa distancia. La norma a utilizar es la norma
% euclidea (minkowski p=2) npb (n de puntos en el buffer) indica
% cuantos puntos busca, por lo que como el primer punto mas cercano
% es él mismo, k es npb+1
% npb = input('Indique el num de puntos cercanos a buscar: (num sugerido 8)  ');
if npb<4
    msgbox('Has elegido un número de puntos insuficiente. Se fija en 4','atención!!','warn');
    npb = 4;
end
% como la primera columna serï¿½ el mismo punto, aumentamos el nï¿½ de
% puntos de búsqueda en 1
npb = npb +1;
%disp('El tiempo de búsqueda de vecinos ha sido de')
%tic
[idx,dist]=knnsearch(X,X,'NSMethod','kdtree','distance','euclidean','k',npb);
% idx: matriz [n,npb+1]. La primera columna indica el punto de referencia,
% las npb columnas restantes indican los npb puntos mï¿½s cercanos según
% la norma elegida. El valor es el id del punto. dist: matriz [n,npb+1]. La
% primera columna es cero, pues es la distancia de un punto consigo
% mismo. Las npb columnas siguientes indican la distancia el punto de
% referencia con el punto
%toc
%% CÁLCULO SIN LOS COPLANARES
vertices_tin=idx;
calidad_tin(:,1)=npb;

%% Determinación de los planos
% Creamos la matriz de planos, que tiene dim np filas y 4 columnas
planos = zeros (np, 4);
% Preparamos los vectores con los puntos cercanos y coplanares para la
% determinación de A B C y D como cada punto tiene n puntos cercanos y
% coplanares, programamos con un while

h=waitbar(0,'Calculating planes. Please wait');
for j=1:np
    I=vertices_tin(j,:);
    puntos_tin=P(I,:);
    % determinamos el plano
    x = puntos_tin(:,1);
    y = puntos_tin(:,2);
    z = puntos_tin(:,3);
    [A,B,C]=plane_fit(x,y,z); 
    if C == 0
        planos (j,1)=A;
        planos (j,2)=B;
        planos (j,3)=-1;
        planos (j,4)=0;
    else
        planos (j,1)=-1*A / C;
        planos (j,2)= -1*B / C;
        planos (j,3) = 1/C;
        planos (j,4) = -1;
    end
    waitbar(j/np,h);
end
close(h); %cerramos la ventana de avance
end
    
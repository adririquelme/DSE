function [P, calidad_tin, planos]=f_setup_planes_v07(P, npb, tolerancia)
%% Función que prepara los puntos y genera los planos objeto de estudio
% Adrián Riquelme, abril 2013
%    {For a set of points calculates the k nearest neighbours and calculates its coplanarity and its normal vector}
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
% Input: - P. matriz de nx3 que contiene las coordenadas de los puntos
% V05: el test de coplanaridad sólo admite aquellos que sean coplanares,
% los que no los eliminará
% Output: 
% P2: matrix de puntos que tienen coplanares
% - idx: matriz [n,npb+1]. La primera columna indica el punto de
% referencia, las npb columnas restantes indican los npb puntos mï¿½s
% cercanos según la norma elegida. El valor es el id del punto.
% - dist: matriz [n,npb+1]. La primera columna sería cero, pues es la
% distancia de un punto consigo mismo. Las npb columnas siguientes indican
% la distancia el punto de referencia con el punto
% - calidad_tin: indica el n de puntos que forman cada plano
% - planos: matriz que contiene el vector normal del punto y sus vecinos
% ABC

% cargamos los puntos en una matriz de np x 3
% P = load ('puntos.txt');
[np,~] = size ( P );
% np es el num total de puntos disponibles se comprueba que toda la tabla
% está compuesta por nums y que el n de columnas es de 3 la f isnan
% devuelve 1 si no es n o 0 en caso de que lo sea. Si al final el
% test es de validación es 0 será porque todos los valores de la matriz
% son números. En caso de que no lo sea, el test de validación nos
% dirá cuantos valores no numéricos hay.


%% buscamos los puntos cercanos con knnsearch
% primero definimos una matriz con las coordenadas de puntos en las columnas:
% col 1: coordenada x
% col 2: coordenada y
% col 3: coordenada z
% Para ello, hay que quitar la primera columna que es el id de cada punto

P=P(:,1:3);

% Ahora con el knnsearch hay que buscar para cada punto, cuales son los mas
% cercanos y cual es esa distancia. La norma a utilizar es la norma
% euclidea (Minkowski p=2) npb (n de puntos en el buffer) indica
% cuantos puntos busca, por lo que como el primer punto mas cercano
% es él mismo, k es npb+1

if npb<4
    msgbox('Has elegido un número de puntos insuficiente. Se fija en 4','atención!!','warn');
    npb = 4;
end

% Nota: Matlab utiliza la búqueda de region growing Kd-tree sin no se le
% dice nada. Para hacer la búsqueda exhaustiva hay que decirle que el tipo
% de búsqueda es Mdl, pero no intersa porque kdtree es más rápido


[idx,~]=knnsearch(P,P,'NSMethod','kdtree','distance','euclidean','k',npb);

% idx: matriz [n,npb+1]. La primera columna indica el punto de referencia,
% las npb columnas restantes indican los npb puntos más cercanos según
% la norma elegida. El valor es el id del punto. dist: matriz [n,npb+1]. La
% primera columna es cero, pues es la distancia de un punto consigo
% mismo. Las npb columnas siguientes indican la distancia el punto de
% referencia con el punto


%% búsqueda de coplanares
% Buscamos la coplanaridad de los puntos encontrados
% La salida es una matriz de dim [np k+1]. En primer lugar, la
% creamos con una matriz de ceros.
planos = zeros (np, 3);
calidad_tin=zeros(np,1);
% para iniciar la búsqueda, necesitamos definir una tolerancia de
% coplanaridad. Ésta es el % que supone landa3 sobre el total de los
% valores propios
if tolerancia >0 
else
    msgbox('La tolerancia introducida no es válida. Se fija por defecto a 0,01,','Atensión!!!!!','warn');
    tolerancia=0.01;
end

% hay que recorrer desde 1 hasta np los puntos de búsqueda
% creamos un vector calidad_tin que nos indica la cantidad de puntos con
% los que se crea un plano asociado a un punto de referencia

P2=zeros(size(P)); % inicio la nube de puntos coplanares, al final eliminaré los que no lo son
np2=1; % número de puntos coplanares encontrados
h=waitbar(0,'Searching coplanar points, planes and its poles. Please wait');
for j=1:np
    % primero, chequeamos si todos los puntos cercanos son coplanares. Si lo
    % son, los aceptamos todos y saltamos al siguiente punto de referencia.
    % En caso contrario, buscaremos cual descartar.
    % montamos en la matriz con los puntos
    % idx era una matriz con los indexs de puntos cercanos. El n max de
    % columnas es de npb, cuando un punto no es cercano, rellena con ceros.
    V=find(idx(j,:)>0); %index of the near points
    test_tin=P(idx(j,V),1:3); %points to test coplanarity
    [pc, ~, valor_propio] = pca(test_tin); %Cambio a PCA por compatibilidad
    %[pc, ~, valor_propio] = princomp (test_tin,'econ');
    [n,~]=size(valor_propio);
    if n==3
        %desviacion=((valor_propio(3,1)^2/norm(valor_propio,2)^2))^0.5;
        %l1=abs(valor_propio(1,1));
        %l2=abs(valor_propio(2,1));
        %l3=abs(valor_propio(3,1));
        desviacion=abs(valor_propio(3,1))/(abs(valor_propio(1,1))+abs(valor_propio(2,1))+abs(valor_propio(3,1)));
    else
        desviacion=0;
    end
    if desviacion <= tolerancia
        copl = 1;
    else
        copl = 0;
    end
    if copl == 1
        % como es coplanar, paso el punto y su calidad
        P2(np2,:)=P(j,:); % guardamos el punto en P2
        % vn=cross(pc(:,1),pc(:,2));% vector normal
        % planos(np2,:)=vn;
        planos(np2,:) = pc(:,3); % tomo el tercer vector propio
        calidad_tin(np2,1)=length(V);
        np2=np2+1; % incrementamos el contador de coplanares
    end
    % waitbar(j/np,h,sprintf('Point %d de %d', j, np));
    waitbar(j/np,h);
end
% limpiamos la matriz de salida P2
np2=np2-1;
if np2==0
    msgbox('Atention! No coplanarity was found!');
else
    P=P2(1:np2,:); % actualizamos P2
    planos=planos(1:np2,:); %actualizamos la salida planos
    calidad_tin=calidad_tin(1:np2,1);
end
close(h); %cerramos la ventana de avance
end
    
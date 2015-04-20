function [ dmax, Xmax, Ymax ] = maxsearch2d( X,Y,density,tolerancia)
% maxsearch2d, Adrián Riquelme, abril 2013
%    {Search max value in a 2D matrix, first developed april 2013}
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
%   Función que busca los máximos locales en una superficie no paramétrica,
%   definida por los valores de la función.
%   Busca para cada valor si es el máximo entre sus vecinos.
% Input:
% - X: coordenadas x de los valores. Matriz nxn
% - Y: coordenadas y de los valores. Matriz nxn
% - density: valores de la superficie. Matriz nxn
% - tolerancia: % valor mínimo a de density para buscar el máximo, tanto
% por uno de la densidad máxima
% Output:
% - dmax: vector con los valores máximos encontrados
% - Xmax: vector con las coordenadas x de los valores máximos
% - Ymax: vector con las coordenadas y de los valores máximos

% determinamos el valor total de la suma de valores de density
densidadmaxima=max(max(density,[],1),[],2);
dminima=densidadmaxima*tolerancia;
Xmax=[]; %iniciamos los vectores resultado
Ymax=[];
dmax=[];
[n,n]=size(density);
for ii=2:n-1
    for jj=2:n-1
        if density(ii,jj)>=dminima && ...
                density(ii,jj)>density(ii-1,jj-1) && ...
                density(ii,jj)>density(ii-1,jj) && ...
                density(ii,jj)>density(ii-1,jj+1) && ...
                density(ii,jj)>density(ii,jj-1) && ...
                density(ii,jj)>density(ii,jj+1) && ...
                density(ii,jj)>density(ii+1,jj-1) && ...
                density(ii,jj)>density(ii+1,jj) && ...
                density(ii,jj)>density(ii+1,jj+1)
            dmax=[dmax density(ii,jj)];
            Xmax=[Xmax X(ii,jj)];
            Ymax=[Ymax Y(ii,jj)];
        end
    end
end

temp = [Xmax;Ymax;dmax]';
temp(:,3)=temp(:,3).*(-1);
temp=sortrows(temp,3);
temp(:,3)=temp(:,3).*(-1);
Xmax(1,:)=temp(:,1);
Ymax(1,:)=temp(:,2);
dmax(1,:)=temp(:,3);
end


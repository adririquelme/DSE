function [tabla_homogeneizada] = f_tabla_homogeneizaD(tabla)
% [tabla_homogeneizada] = f_tabla_homogeneizaD(tabla)
% Función que toma la tabla familia - cluster - npuntos - ABCD y traslada D
% de cada familia de su cdg al origen, para que al mostrar la tabla, los
% valores de D puedan interpretarse
% Nota que por columnas tengo:
% C1: índice de familia
% C2: índice de clúster de esa familia
% C3: número de puntos de ese clúster
% C4: A, de la ecuación Ax+By+Cz+D=0
% C5: B
% C6: C; estos tres suelen ser iguales en toda la familia
% C7: D, este es el término que quiero corregir
%    Copyright (C) {2021}  {Adrián Riquelme Guill, ariquelme@ua.es}
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

% Inicio el resultado
tabla_homogeneizada=tabla;

% Busco el número de familias, para ir una a una trasladando D
familias=unique(tabla(:,1));
n_familias=length(familias);
for i=1:n_familias
    % busco los puntos de esa familia
    I=find(tabla(:,1)==familias(i));
    D=tabla(I,7);
    D_mean=mean(D);
    tabla_homogeneizada(I,7)=tabla(I,7)-D_mean;
end


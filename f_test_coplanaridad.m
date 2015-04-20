function  [desviacion, score]  = f_test_coplanaridad( X)
% Función de búsqueda de coplanaridad
% Adrián Riquelme, marzo 2013
%    {Function that test the coplanarity of a set of points}
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

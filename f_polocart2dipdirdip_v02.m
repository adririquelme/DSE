function [ dipdir, dip ] = f_polocart2dipdirdip_v02( x,y )
%% [ dipdir, dip ] = f_polocart2dipdirdip( x,y )
% Función que convierte las coordenadas cartesianas de un polo de un vector
% normal de un plano a la notación de Clar (dirección de buzamiento y
% buzamiento)
% Adrián Riquelme Guill, 4 diciembre 2014
% inputs: x e y, coordenadas del polo en el stereonet
% outputs: dip direction and dip in radians
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

dipdir = zeros(size(x));

% primer cuadrante
I = find(x>=0 & y>=0); 
dipdir(I)=atan(x(I)./y(I))+pi;

% segundo cuadrante
I = find(x>0 & y<0); 
dipdir(I)=2*pi+atan(x(I)./y(I));

% tercer cuadrante
I = find(x<=0 & y<=0); 
dipdir(I)=atan(x(I)./y(I));

% cuarto cuadrante
I = find(x<0 & y>0); 
dipdir(I)=pi+atan(x(I)./y(I));



dip = 2*atan((x.^2+y.^2).^0.5);
I=find(x==0 & y == 0); 
dipdir(I)=0; dip(I)=0;



end





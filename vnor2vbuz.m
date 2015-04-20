function [w,b]=vnor2vbuz(ux,uy,uz)
% Función de conversión vector normal a vector buzamiento del plano
% Adrián Riquelme, abril 2013
% [w,b]=vnor2vbuz(ux,uy,uz)
% Input:
% - componentes del vector normal al plano
% Output:
% - w: Ángulo que forma el vector de buzamiento con el eje OY, considerado
% como el norte
% - b: Ángulo que forma la lÃ­nea de mÃ¡xima pendiente del plano con su
% proyecciÃ³n horizontal.
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
uxy= (ux^2+uy^2)^(0.5);
bz=-uxy;
if uxy==0
    bx=0;
    by=0;
else
    bx=ux/uxy*uz;
    by=uy/uxy*uz;
end
bxy = abs(uz);
if bx>=0 && by>=0
    w = atan(bx/by);
end
if bx>0 && by<0
    w = pi-atan(abs(bx/by));
end
if bx<=0 && by<=0
    w = pi + atan(abs(bx/by));
end
if bx<0 && by>0
    w = 2*pi - atan(abs(bx/by));
end

b = atan(bz/bxy);

if bx==0 ||by==0
    w = 0;
end
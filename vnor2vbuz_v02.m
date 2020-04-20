function [w,b]=vnor2vbuz_v02(ux,uy,uz)
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
% Inicio la salida
w=zeros(size(ux)); 
% n=length(ux);
uxy= (ux.^2+uy.^2).^(0.5);
bx=(zeros(size(ux))); by=bx; bz=-uxy;
% Calculo los vectores horizontales, que son una singularidad
I=find(uxy==0);
bx(I)=0;
by(I)=0;
% Ahora las componentes de los no horizontales
I=find(uxy~=0);
bx(I)=ux(I)./uxy(I).*uz(I);
by(I)=uy(I)./uxy(I).*uz(I);
bxy = abs(uz);
% Buscamos los cuadrantes
C1=find(bx>=0 & by>=0);
C2=find(bx>0 & by<0);
C3=find(bx<=0 & by<=0);
C4=find(bx<0 & by>0);

w(C1)=atan(bx(C1)./by(C1));
w(C2)= pi-atan(abs(bx(C2)./by(C2)));
w(C3)= pi + atan(abs(bx(C3)./by(C3)));
w(C4) = 2*pi - atan(abs(bx(C4)./by(C4)));

b = atan(bz./bxy);

w(bx==0 | by==0)=0;

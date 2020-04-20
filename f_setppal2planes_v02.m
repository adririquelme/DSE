function [polos_estereoppalasignados, puntos_ppalasignados] = f_setppal2planes_v02( cone, polos_estereo_cartesianas, polos_pples_cart ,P)
%    {Function that searches for each plane the nearest principal plane}
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
% Input:
% - cone: max angle between a pole and a principal pole, radians
% - polos_estereo_cartesianas: matriz nx2 con las coordenadas x e y del 
%   polo del vector normal al plano asociado al punto i, en el círculo de 
%   la falsilla
% - polos_pples_cart: matriz con los polos principales en coordenadas
%   cartesianas
% - P
% Output:
% - puntos_ppalasignados: listado de coordenadas P con una 4º columna que
% indica a qué polo principal (familia) ha sido asignado
% - polos_estereoppalasignados: polos asociados a cada punto de P indicando
% a qué familia pertenece

[np,~]=size(polos_estereo_cartesianas);
[nppal,~]=size(polos_pples_cart);
% calculamos el vector normal asociado a cada polo
[VectorNormal]=f_pole2vnor(polos_estereo_cartesianas);
% calculamos el vector normal de cada polo principal
[VectorNormalPrincipal]=f_pole2vnor(polos_pples_cart);
% calculamos el ángulo que forma cada polo con cada polo principal
angulo_polo_principal=zeros(np,nppal);
for ii=1:np
    vpx=VectorNormal(ii,1);
    vpy=VectorNormal(ii,2);
    vpz=VectorNormal(ii,3);
    for jj=1:nppal
        vppx=VectorNormalPrincipal(jj,1);
        vppy=VectorNormalPrincipal(jj,2);
        vppz=VectorNormalPrincipal(jj,3);
        proj=vpx*vppx+vpy*vppy+vpz*vppz;
        angulo=acos(proj);
        if angulo>=pi/2
            angulo=pi-angulo;
        end
        angulo_polo_principal(ii,jj)=angulo;
    end
end
   
% valor el menor ángulo y a qué plano principal
[alphamin, pos] = min(angulo_polo_principal,[],2); 
% pos es la posición de la familia a la que se le asigna
% en polos_ppalasignados ponemos los polos y qué polo principal le toca
polos_estereoppalasignados=zeros(np,3);
polos_estereoppalasignados(:,1:2)=polos_estereo_cartesianas(:,1:2);

% busco el polo principal para cada uno, y compruebo que el ángulo es menor
% que el del cono
I=find(alphamin<=cone);
polos_estereoppalasignados(I,3)=pos(I);
% los que no tienen polo principal se quedan con índice 0
% para los puntos en coordenadas, le asignamos el polo principal que le
% toca
puntos_ppalasignados=zeros(np,4);
puntos_ppalasignados(:,1:3)=P(:,1:3);
puntos_ppalasignados(I,4)=pos(I);
% ahora le eliminamos los puntos que no tengan plano principal asignado

% Hay que buscar las familias que no tienen un punto asignado, por si son
% familias auxiliares
familias=1:1:nppal; % índices de todas las familias
if nppal>length(unique(pos))
    test_familias=ismember(familias,unique(pos));
    I=find(test_familias==0); % posición de familias sin asignar puntos
    for i=1:length(I)
        % tomo un punto sin asignar y le asigno esa familia
        J=find(polos_estereoppalasignados(:,3)==0);
        polos_estereoppalasignados(J(1),3)=familias(I(i));
        puntos_ppalasignados(J(1),4)=familias(I(i));
    end
end
end


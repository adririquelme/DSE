function [ tiporotura ] = f_tiporotura( alphas, alphaj )
% [ tipo_rotura ] = f_tiporotura( alphas, alphaj )
% Es una matriz columna que indica para cada valor ei tpo
% 1: rotura plana
% 2: rotura en vuelco
%   Función que determina el tipo de rotura posible que se puede producir
%   en un talud a partir de las direcciones del buzamiento de la
%   discontinuidad y del talud
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
%    SMRTool, Copyright (C) 2015 Adrián Riquelme Guill
%    SMRTool comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.
aux = abs(alphas - alphaj);
tiporotura=zeros(size(aux));
I=find(aux>180); aux(I)=360-aux(I);
% if aux > 180
%     aux = 360 - aux;
% end
% Fijo el tipo de rotura para todo en planar
tiporotura(:,1)=1;
% Establezco las roturas vuelco
tiporotura(aux>=90)=2;

% if aux >= 90
%     % rotura vuelco
%     tiporotura = 'Toppling';
% else
%     tiporotura = 'Wedge/Planar';
% end


end


function [ coeff3 ] = f_coeff3( alphas, alphaj, betas, betaj )
% [ coeff3 ] = f_coeff3( alphas, alphaj, betas, betaj )
% Calculates SMR adjustment factor F3
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
coeff3=zeros(size(aux));
I=find(aux>180); aux(I)=360-aux(I);
% if aux > 180 
%     aux = 360 - aux;
% end
% Calculamos el ángulo C
C = f_Ccoeff3(alphas, alphaj, betas, betaj);
% Rotura en vuelco
I=find(aux>=90 & C < 110); coeff3(I)=0;
I=find(aux>=90 & C >= 110 & C < 120 ); coeff3(I)=-6;
I=find(aux>=90 & C >= 120 ); coeff3(I)=-25;
% Rotura planar o en cuña
I=find(aux<90 & C > 10  ); coeff3(I)=0;
I=find(aux<90 & C > 0 & C <= 10   ); coeff3(I)=-6;
I=find(aux<90 & C == 0   ); coeff3(I)=-25;
I=find(aux<90 & C >= -10 & C < 0  ); coeff3(I)=-50;
I=find(aux<90 & C <= -10); coeff3(I)=-60;

% if aux >= 90 
%     %rotura vuelco
%     if C < 110 
%         F3 = 0;
%     end
%     if C >= 110 && C < 120 
%         F3 = -6;
%     end
%     if C >= 120 
%         F3 = -25;
%     end
% end
% if aux < 90 
%     % tiporotura = "Wedge/Planar"
%     if C > 10 
%         F3 = 0;
%     end
%     if C > 0 && C <= 10 
%         F3 = -6;
%     end
%     if C == 0 
%         F3 = -25;
%     end
%     if C >= -10 && C < 0 
%         F3 = -50;
%     end
%     if C <= -10 
%         F3 = -60;
%     end
% end
% coeff3 = F3;

end


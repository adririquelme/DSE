function [ Acoeff1 ] = f_Acoeff1( alphas, alphaj )
%[ Acoeff1 ] = f_Acoeff1( alphas, alphaj )
%   Cálculo del ángulo auxiliar A del SMR
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
n=size(aux,1);
Acoeff1=zeros(size(aux));
I=find(aux >= 180 & aux < 270); Acoeff1(I)=aux(I)-180;
I=find(aux > 90 & aux < 180 ); Acoeff1(I)=180 - aux(I);
I=find(aux >= 270 & aux <= 360 ); Acoeff1(I)=360 - aux(I);
% if n==1 
%     % Se homogeneiza el ángulo entre orientaciones de plano
%     if aux > 90 && aux < 270
%         if aux >= 180 
%             aux = aux - 180;
%         else
%             aux = 180 - aux;
%         end
%     end
% 
%     if aux >= 270 && aux <= 360
%         aux = 360 - aux;
%     end
% else
%     I1=find(aux>90 && aux<270);
%     for i=1:n
%         if aux(i) > 90 && aux(i) < 270
%             if aux(i) >= 180 
%                 aux(i) = aux(i) - 180;
%             else
%                 aux(i) = 180 - aux(i);
%             end
%         end
%         if aux(i) >= 270 && aux(i) <= 360
%             aux(i) = 360 - aux(i);
%         end
%     end
% end

end


function [ omega ] = a2o( alfa )
% Función que convierte el ángulo alfa de los polos
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
%  
omega=zeros(size(alfa));
I=find(alfa>=0 & alfa<=pi/2); omega(I)=pi/2-alfa(I);
I=find(alfa>pi/2 & alfa <pi);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=pi & alfa<3*pi/2);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=3*pi/2 & alfa<2*pi);omega(I)=pi/2+(2*pi-alfa(I));

% if alfa>=0 && alfa<pi/2
%     omega = pi/2-alfa;
% else
%     if alfa >=pi/2 && alfa <pi
%         omega=2*pi-(alfa-pi/2);
%     else
%         if alfa>=pi && alfa<3*pi/2
%             omega=2*pi-(alfa-pi/2);
%         else
%             omega=pi/2+(2*pi-alfa);
%         end
%     end
% end

end


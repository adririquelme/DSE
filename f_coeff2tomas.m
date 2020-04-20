function [ coeff2tomas ] = f_coeff2tomas( alphas, alphaj, betaj )
% ' Cálculo del factor F2 para el SMR de Romana según las funciones contínuas de Roberto Tomás et al 2007
% ' Adrián Riquelme, Enero 2014
% ' alphas: azimuth of dip vector of slope, in degrees
% ' alphaj: azimith of dip vector of discontinuity in degrees
% ' betas: value of dip vector of the discontinuity, in degrees
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
coeff2tomas =zeros(size(aux));
I=find(aux>180);aux(I)=360-aux(I);
% if aux > 180 
%     aux = 360 - aux;
% end
coeff2tomas(aux>=90)=1;
coeff2tomas(aux<90)=9 / 16 + 1 / 195 * atan(17 / 100 * betaj(aux<90) - 5) * 180 / pi;
% if aux >= 90 
%     % rotura vuelco
%     coeff2tomas = 1;
%     else
%     % rotura Cuña/Plana
%     coeff2tomas = 9 / 16 + 1 / 195 * atan(17 / 100 * betaj - 5) * 180 / pi;
% end

end


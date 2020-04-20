function [ coeff1 ] = f_coeff1( alphas, alphaj )
% [ coeff1 ] = f_coeff1( alphas, alphaj )
% Calculates SMR adjustment factor F1
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
aux = f_Acoeff1(alphas, alphaj);
coeff1=zeros(size(aux));
coeff1(aux>=30)=0.15;
coeff1(aux>=20 & aux<30)=0.4;
coeff1(aux >= 10 & aux < 20)=0.7;
coeff1(aux >= 5 & aux < 10 )=0.85;
coeff1(aux < 5 )=1;
% if aux >= 30 
%     coeff1 = 0.15;
% end
% if aux >= 20 && aux < 30 
%     coeff1 = 0.4;
% end
% if aux >= 10 && aux < 20 
%     coeff1 = 0.7;
% end
% if aux >= 5 && aux < 10 
%     coeff1 = 0.85;
% end
% if aux < 5 
%     coeff1 = 1;
% end

end


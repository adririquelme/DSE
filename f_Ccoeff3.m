function [ Ccoeff3 ] = f_Ccoeff3( alphas, alphaj, betas,betaj )
% [ Ccoeff3 ] = f_Ccoeff3( alphas, alphaj, betas,betaj )
% Calculates SMR auxiliary angle C
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
if aux > 180
    aux = 360 - aux;
end
if aux >= 90 
    % rotura vuelco
    Ccoeff3 = betas + betaj;
else
    % Rotura Cuña/Plana
    Ccoeff3 = betaj - betas;
end

end


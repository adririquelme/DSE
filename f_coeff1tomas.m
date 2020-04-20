function [ coeff1 ] = f_coeff1tomas( alphas, alphaj )
% [ coeff1 ] = f_coeff1( alphas, alphaj )
% Cálculo del factor F1 para el SMR de Romana según las funciones contínuas de Roberto Tomás et al 2007
% Adrián Riquelme, Enero 2014
% alphas: azimuth of dip vector of slope, in degrees
% alphaj: azimith of dip vector of discontinuity in degrees
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
coeff1 = 16 / 25 - 3 / 500 * atan((abs(aux) - 17) / 10) * 180 / pi;
end


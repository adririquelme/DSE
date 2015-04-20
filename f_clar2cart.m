function [ x,y ] = f_clar2cart( theta,beta )
% [ x,y ] = f_clar2cart( theta,beta )
% Función que convierte un polo en notación de Clar a sus coordenadas
% cartesianas para representar en estereográficas
% los ángulos se meten en grados, pero se calculan en radianes
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

theta = 2*pi- (theta .* pi /180)+pi/2;
beta = beta .* pi ./ 180;
r = sin(beta)./(1+cos(beta));
alpha = pi+theta;
x = r.*cos(alpha);
y = r.*sin(alpha);
end


function [ wplane ] = f_wpole2wplane( wpole )
% wpole2wplane, Adrián Riquelme, abril 2013
%    {Takes the pole angle measured from the north and converts it into an angle measured from the OX axis}
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
% función que toma el omega de un polo y lo convierte en en el omega del
% plano
% Importante: los ángulos son en radianes!!

wplane=zeros(size(wpole));
I=find(wpole>=0 & wpole<pi); wplane(I)=wpole(I)+pi;
I=find(wpole>=pi & wpole<2*pi); wplane(I)=wpole(I)-pi;
% if wpole>=0 && wpole<pi
%     wplane=wpole+pi;
% else
%     wplane=wpole-pi;
% end
end
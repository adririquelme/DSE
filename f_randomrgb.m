function [ rgb ] = f_randomrgb( im0 )
% Función que toma una columna de datos y las clasifica según su color rgb
% de forma aleatoria.
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
% Adrián Riquelme, 4 noviembre 2014
% [ rgb ] = f_randomrgb( im )

% reordeno aleatoriamente la columna
[indices, ~] = sort(unique(im0));
nindices = length(indices);
desorden = randsample(nindices,nindices);
im = zeros(size(im0));
for i=1:nindices
    indice = desorden(i);
    im(im0(:,1)==indices(i))=indice;
end

% transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
im= double(im);
im=im*255/n;
im=uint8(im);
rgb = ind2rgb(im,jet(255));
end


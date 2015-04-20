function matrix = swap(matrix,dimension,idx_a,idx_b)
% función que intercambia filas o columnas
% tomada de http://stackoverflow.com/questions/4939738/swapping-rows-and-columns
% modificada por Adrián Riquelme, 14 marzo 2015
% matrix = swap(matrix,dimension,idx_a,idx_b)
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
[n,m]=size(matrix);
if dimension == 1
    if idx_a<=n && idx_b<=n && idx_a>=1 && idx_b>=1
        row_a = matrix(idx_a,:);
        matrix(idx_a,:) = matrix(idx_b,:);
        matrix(idx_b,:) = row_a;
    else
        % no hacemos nada
    end
elseif dimension == 2
    if idx_a<=m && idx_b<=m idx_a>=1 && idx_b>=1
        col_a = matrix(:,idx_a);
        matrix(:,idx_a) = matrix(:,idx_b);
        matrix(:,idx_b) = col_a;        
    else
        % no hacemos nada
    end
end


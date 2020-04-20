function [salida] = f_savematrix(filename,matrix)
% [salida] = f_savematrix(filename,matrix)
% Function saves a matrix into a text file
% Input: filename is a string that contains the path and the filename
% matrix is the matrix to save
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
salida = 0;
% Uso o no la función de MATLAB, que está desde la 9.6
version=ver;
toolboxes={version.Name};
uso=length(find(contains(toolboxes,'MATLAB')==1));
if uso>=1
    if str2double(getfield(version,{find(contains(toolboxes,'MATLAB')==1)},'Version'))>=9.1
        % Tengo la versión de MATLAB al menos 2019a y puedo usar
        % writematrix
        writematrix(matrix, filename,'Delimiter', 'tab');
    else
        % No lo tengo y empleo la programación antigua
        dlmwrite(filename,matrix, 'delimiter', '\t', 'precision', 16);
    end
end

end


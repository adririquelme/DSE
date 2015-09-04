function [ report ] = f_report( pathname, filename, npoints, knn, tolerancia, nbins, angulovpples, cone, vnfamilia, ksigmas, nfamilias, planospples, familiaclusterplano)
% [ ~ ] = f_report( pathname, filename, npoints, knn, tolerance, nbins, angulovpples, cone, vnfamilia, ksigmas, nfamilias)
% Función que genera un reporte de los parámetros utilizados
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

f = fopen([pathname,filename, ' - report.txt'], 'wt'); % creo la funcíon que abre el archivo para escribir
fprintf(f, 'Discontinuity Set Extractor, %s. Report of the used parameters. \n',datestr(today));
fprintf(f, 'File: %s \n \n', [pathname, filename]);

% Parámetros de cálculo
fprintf(f, 'Used parameters: \n');
fprintf(f, 'Calculation of the normal vectors of each point and its corresponding poles: \n');
fprintf(f, '- knn: %s (k nearest neighbours). \n', num2str(knn)); 
fprintf(f, '- eta: %s (tolerance for the coplanarity test). \n', num2str(tolerancia));
fprintf(f, 'Calculation of the density of the poles: \n');
fprintf(f, '- nbins: %s (number of bins for the kernel density estimation). \n', num2str(nbins));
fprintf(f, '- anglevppal: %s (minimum angle between normal vectors of discontinuity sets). \n', num2str(angulovpples));
fprintf(f, 'Assignment of a discontinuity set to each point: \n');
fprintf(f, '- cone: %s (minimum angle between the normal vector of a discontinuity set and the normal vector of the point). \n', num2str(cone));
fprintf(f, 'Cluster analysis \n');
if vnfamilia==0
    fprintf(f, '- Each cluster has its indepentend normal vector. \n');
else
    fprintf(f, '- All clusters members of a discontinuity set have the same normal vector. \n');
end
fprintf(f, '- ksigmas: %s (parameter used for test if two clusters should be merged). \n \n', num2str(ksigmas));

% Resultados
fprintf(f, 'Results \n');
fprintf(f, '- Number of points of the original point cloud: %s \n',num2str(npoints));
aux = familiaclusterplano(:,3);
auxnpuntos = sum(aux,1);
fprintf(f, '- Number of points of the classified point cloud: %s \n', num2str(auxnpuntos));
fprintf(f, '- Number of unassigned points: %s \n',num2str(npoints-auxnpuntos));
fprintf(f, '- Number of discontinuity sets: %s \n',num2str(nfamilias));
fprintf(f, '- Extracted discontinuity sets: \n');
fprintf(f, '\t\tDip dir\t\tDip\t\tDensity\t\t%% \n');    % Column Titles
fprintf(f, '\t\t%5.2f\t\t%5.2f\t\t%5.4f\t\t%5.2f\n', planospples');      % Write Rows
fprintf(f, '\t\tWhere %% is the number of assigned points to a DS over the total number of points \n');
fprintf(f, '\n - Extracted clusters and its corresponding plane equation (Ax+By+Cz+D=0) \n');
fprintf(f, '\t\tDS\t\tcluster\t\tn_points\t\tA\t\tB\t\tC\t\tD \n');
fprintf(f, '\t\t%5.0f\t\t%5.0f\t\t%5.0f\t\t%5.4f\t\t%5.4f\t\t%5.4f\t\t%5.4f \n', familiaclusterplano');
fclose(f); % cierro el archivo

% Genero la salida completamente inútil
report = 1;

end


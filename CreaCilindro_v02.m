function [ P ] = CreaCilindro_v02( r, h, inc, error)
% [ P ] = CreaCono( r, h, inc, error)
% Función que genera las coordenadas de puntos en la superficie de un
% cilindro
% r: radio del cilindro
% h: altura del cilindro
% inc: separación entre puntos
% Genera una matriz P y un fichero cono.txt con las coordenadas de la
% superficie del cono
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
if r~=0 && h~=0 && inc~=0
    % creamos el primer punto, que será el centro de la base
    P=[0 0 0];
    % base inferior
    S=pi*r^2/4; Si=pi*inc^2/4; n=S/Si;
    rho=rand(n,1).*r+rand(n,1).*error;
    alpha=rand(n,1)*2*pi;
    baseinf(:,1)=rho.*cos(alpha);
    baseinf(:,2)=rho.*sin(alpha);
    baseinf(:,3)=rand(n,1).*error;
    P=[P;baseinf];
    % base superior
    rho=rand(n,1).*r+rand(n,1).*error;
    alpha=rand(n,1)*2*pi;
    basesup(:,1)=rho.*cos(alpha);
    basesup(:,2)=rho.*sin(alpha);
    basesup(:,3)=rand(n,1).*error+h;
    P=[P;basesup];
    % Creamos los anillos de la superficie lateral
    S=2*pi*r*h; n=S/Si;
    rho=rand(n,1)*error+r;
    alpha=rand(n,1)*2*pi+error*rand(n,1);
    z=rand(n,1)*h+error*rand(n,1);
    lateral(:,1)=rho.*cos(alpha);
    lateral(:,2)=rho.*sin(alpha);
    lateral(:,3)=z;
    P=[P;lateral];
else
    disp('Los datos de entrada son incorrectos. R, h e inc deben ser no nulos')
    P=[0 0 0];
end

% guardamos en un archivo cilindro.txt
%     fi = fopen('cilindro.txt', 'w') ;
%     [n,p]=size(P);
%     for k=1:n
%         fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
%     end 
%     fclose(fi);
        fi = fopen('puntos.txt', 'w') ;
    [n,p]=size(P);
    for k=1:n
        fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
    end 
    fclose(fi);

end


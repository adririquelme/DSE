function [ P ] = CreaCono( r, h, inc, error)
% Función que genera las coordenadas de puntos en la superficie de un cono
% r: radio del cono
% h: altura del cono
% inc: separación entre puntos
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
    nr = floor(r/inc)+1; %número de puntos con los que incremento r
    nalfa = floor(2*pi*r / inc)+1; %nº puntos con los que incremento alfa
    dalfa = 2*pi/nalfa; %valor del diferencial de alfa
    for ii=1:nalfa
        alfa = ii*dalfa;
        for jj=1:nr
            radio = jj*r/nr;
            v = [radio * cos(alfa)+random('Normal',0,error/3,1), radio*sin(alfa)+random('Normal',0,error/3,1),+random('Normal',0,error/3,1)];
            P = [P ; v];
        end
    end
    % Creamos los anillos de la superficie lateral
    nh = floor(h/inc)+1;
    dh = h / nh;
    for ii=1:(nh-1)
        radio= r/h*(h-ii*dh);
        for jj=1:nalfa
            alfa = jj*dalfa;
            v = [radio * cos(alfa)+random('Normal',0,error/3,1), radio*sin(alfa)+random('Normal',0,error/3,1),ii*dh+random('Normal',0,error/3,1)];
            P = [P ; v];
        end
    end
    v = [0+random('Normal',0,error/3,1),0+random('Normal',0,error/3,1),h+random('Normal',0,error/3,1)];
    P = [P ; v];
        
else
    disp('Los datos de entrada son incorrectos. R, h e inc deben ser no nulos')
    P=[0 0 0];
end

% % guardamos en un archivo cono.txt
% fi = fopen('cono.txt', 'w') ;
% [n,p]=size(P);
% for k=1:n
%     fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
% end 
% fclose(fi);

% guardamos también en el fichero puntos.txt
fi = fopen('puntos.txt', 'w') ;
[n,p]=size(P);
for k=1:n
    fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
end 
fclose(fi);

end


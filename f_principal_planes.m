function [ planos_pples ] = f_principal_planes( polos_pples)
% [ planos_pples ] = f_principal_planes( polos_pples, vnormal_pples)
% Función que convierte el ángulo alfa de las coordenadas polares al ángulo
% w orientación respecto al norte (OY) para definir el vector buzamiento
% Input
% - polos_pples(alfa(rd), beta(rd), fdensidad). Coord polares del polo
% Output
% - planos_pples(omega(rd), beta(rd), fdensidad). Notación vec buzamiento

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

%%  Preparamos la salida de los planos
[kk, ~]=size(polos_pples);

% convertimos los polos a vectores buzamiento
planos_pples=zeros(kk,3);
alfa=polos_pples(:,1)/180*pi;
omegapolo=a2o(alfa);
omegaplano=wpole2wplane(omegapolo)*180/pi;
planos_pples(:,1)=omegaplano;
planos_pples(:,2)=polos_pples(:,2);
planos_pples(:,3)=polos_pples(:,3);

function [ wplane ] = wpole2wplane( wpole )
% wpole2wplane, Adrián Riquelme, abril 2013
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

function [ omega ] = a2o( alfa )
% Funcón que convierte el ángulo alfa de los polos
%  
omega=zeros(size(alfa));
I=find(alfa>=0 & alfa<=pi/2); omega(I)=pi/2-alfa(I);
I=find(alfa>pi/2 & alfa <pi);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=pi & alfa<3*pi/2);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=3*pi/2 & alfa<2*pi);omega(I)=pi/2+(2*pi-alfa(I));
end

end


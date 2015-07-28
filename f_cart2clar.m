function [ dipdir, dip ] = f_cart2clar( x,y )
% [ dipdir, dip ] = f_cart2clar( x,y )
% Función que convierte las coordenadas cartesianas en notación de Clar
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

% Inicio alpha y beta
alpha=zeros(size(x));
beta = alpha;


I1=find(x>=0 & y>=0);
alpha(I1)=atan(y(I1)./x(I1));
I2=find(x>=0 & y<0);
alpha(I2)=2*pi+atan(y(I2)./x(I2));
I3=find(x<0 & y>=0);
alpha(I3)=pi+atan(y(I3)./x(I3));
I4=find(x<0 & y<0);
alpha(I4)=pi+atan(y(I4)./x(I4));
beta = 2*atan((x.^2+y.^2).^0.5);
I5=find(x==0 & y==0);
alpha(I5)=0;
beta(I5)=0;

% if x>=0
%     if y>=0
%         alpha = atan(y/x);
%     else
%         alpha = 2*pi+atan(y/x);
%     end
% else
%     if y>=0
%         alpha = pi+atan(y/x);
%     else
%         alpha = pi+atan(y/x);
%     end
% end
% beta = 2*atan((x^2+y^2)^0.5);
% if x==0 && y==0
%     alpha=0;
%     beta=0;
% end



omegapolo=a2o(alpha);
omegaplano=wpole2wplane(omegapolo)*180/pi;
dipdir=omegaplano;
dip=beta*180/pi;

function [ wplane ] = wpole2wplane( wpole )
% wpole2wplane, Adrián Riquelme, abril 2013
% función que toma el omega de un polo y lo convierte en en el omega del
% plano
% Importante: los ángulos son en radianes!!

wplane=zeros(size(wpole));
I=find(wpole>=0 & wpole<pi); wplane(I)=wpole(I)+pi;
I=find(wpole>=pi & wpole<2*pi); wplane(I)=wpole(I)-pi;
end

function [ omega ] = a2o( alfa )
% Funcón que convierte el ángulo alfa de los polos

omega=zeros(size(alfa));
I=find(alfa>=0 & alfa<=pi/2); omega(I)=pi/2-alfa(I);
I=find(alfa>pi/2 & alfa <pi);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=pi & alfa<3*pi/2);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=3*pi/2 & alfa<2*pi);omega(I)=pi/2+(2*pi-alfa(I));
end

end




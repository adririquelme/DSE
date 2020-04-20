function [ N ] = f_pole2vnor( varargin )
% [ N ] = f_pole2vnor( varargin )
% Function that converts stereographic coordinates of a plane pole into the
% normal vector coordinates of the plane.
% [N]=f_pole2vnor( poles_cart)
% [N]=f_pole2vnor ( px, py)
% Input:
% - poles_cart: matrix [n,2] with the cart coordinates of the poles
% - px: cartesian coordinates of the pole in stereographic projection
% - py
% Output:
% N = [nx, ny, nz]
% - nx: components of the normal vector of the plane
% - ny
% - nz
%
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


%% desarrollo del programa
% inicializamos las variables
switch nargin
    case 1
        P=varargin{1};
        px=P(:,1);
        py=P(:,2);
    case 2
        px=varargin{1};
        py=varargin{2};
end
avn=zeros(size(px)); %angulo vector normal
% rho=zeros(size(px));
% phi=zeros(size(px));
% beta=zeros(size(px));
% alpha=zeros(size(px));
% nxy=zeros(size(px));
% omega=zeros(size(alpha));
% calculamos los parámetros

I=find(px>0 & py>0);
    %a(I)=atan(py./px);
    avn(I)=atan(py(I)./px(I))+pi;
I=find(px<0 & py>=0);
    %a(I)=pi-atan(-py./px);
    avn(I)=2*pi-atan(-py(I)./px(I));
I=find(px<0 & py<=0);
    avn(I)=atan(py(I)./px(I));
I=find(px>=0 & py<0);
    avn(I)=pi-atan(-py(I)./px(I));
rho = (px.^2+py.^2).^(0.5);
phi = atan(rho);
beta = 2*phi;

alpha = pi/2 - beta;
nxy=cos(alpha);
N(:,1)=nxy.*cos(avn);
N(:,2)=nxy.*sin(avn);
N(:,3)=nxy.*tan(alpha);

% Para los planos horizontales, donde x=y=0, vector vertical
I=find(px==0 & py==0);
N(I,1)=0; N(I,2)=0; N(I,3)=1;


end


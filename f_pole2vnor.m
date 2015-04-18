function [ N ] = f_pole2vnor( varargin )
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
rho=zeros(size(px));
phi=zeros(size(px));
beta=zeros(size(px));
alpha=zeros(size(px));
nxy=zeros(size(px));
omega=zeros(size(alpha));
% calculamos los parámetros
I=find(px>=0 & py>=0);
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
end


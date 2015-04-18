function [ dipdir, dip ] = f_cart2clar( x,y )
% [ dipdir, dip ] = f_cart2clar( x,y )
% Función que convierte las coordenadas cartesianas en notación de Clar

if x>=0
    if y>=0
        alpha = atan(y/x);
    else
        alpha = 2*pi+atan(y/x);
    end
else
    if y>=0
        alpha = pi+atan(y/x);
    else
        alpha = pi+atan(y/x);
    end
end
beta = 2*atan((x^2+y^2)^0.5);
if x==0 && y==0
    alpha=0;
    beta=0;
end
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




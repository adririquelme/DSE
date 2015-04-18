function [ omega ] = a2o( alfa )
% Función que convierte el ángulo alfa de los polos
%  
omega=zeros(size(alfa));
I=find(alfa>=0 & alfa<=pi/2); omega(I)=pi/2-alfa(I);
I=find(alfa>pi/2 & alfa <pi);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=pi & alfa<3*pi/2);omega(I)=2*pi-(alfa(I)-pi/2);
I=find(alfa>=3*pi/2 & alfa<2*pi);omega(I)=pi/2+(2*pi-alfa(I));

% if alfa>=0 && alfa<pi/2
%     omega = pi/2-alfa;
% else
%     if alfa >=pi/2 && alfa <pi
%         omega=2*pi-(alfa-pi/2);
%     else
%         if alfa>=pi && alfa<3*pi/2
%             omega=2*pi-(alfa-pi/2);
%         else
%             omega=pi/2+(2*pi-alfa);
%         end
%     end
% end

end


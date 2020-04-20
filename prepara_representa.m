function [polos_estereo_polares, polos_estereo_cartesianas]=prepara_representa(planos_estereo)
%% Representamos los puntos obtenidos
% Partiendo de los vectores de buzamiento, determinamos la posición del
% polo P (mediante el vector normal) y su proyección estereografica P'. Las
% matrices polos contienen la proyección del polo del vector normal P'
% input
% - planos_estereo: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w (dip direction) y b (dip)
% output
% - polos_estereo_polares
% - polos_estereo_cartesianas
[np,~]=size(planos_estereo);
polos_estereo_polares=zeros(np,2);
polos_estereo_cartesianas=zeros(np,2);
% partiendo de omega y beta, determinamos los parámetros en polares de los
% polos y sus coordenadas en cartesianas
% alfa será el ángulo de P' en coordenadas polares
for ii=1:np
    omega = planos_estereo(ii,1);
    if abs(planos_estereo(ii,2))>=pi/2
        beta = pi  + abs(planos_estereo(ii,2));
    else
        beta = abs(planos_estereo(ii,2));
    end
    alfa = o2a(omega);
    polos_estereo_polares(ii,1)= alfa; % angulo alfa de las polares
    polos_estereo_polares(ii,2)= tan (beta / 2); % radio de las polares
    polos_estereo_cartesianas(ii,1)=tan (beta / 2)*cos(alfa); % x en las cartesianas
    polos_estereo_cartesianas(ii,2)=tan (beta / 2)*sin(alfa); % y en las cartesianas
end


end


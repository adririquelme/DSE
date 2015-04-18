function [polos_estereo_polares, polos_estereo_cartesianas]=prepara_representa(planos_estereo)
%% Representamos los puntos obtenidos
% Partiendo de los vectores de buzamiento, determinamos la posiciÛn del
% polo P (mediante el vector normal) y su proyecciÛn estereografica P'. Las
% matrices polos contienen la proyecciÛn del polo del vector normal P'
% input
% - planos_estereo: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w y b
% output
% - polos_estereo_polares
% - polos_estereo_cartesianas
[np,~]=size(planos_estereo);
polos_estereo_polares=zeros(np,2);
polos_estereo_cartesianas=zeros(np,2);
% partiendo de omega y beta, determinamos los par·metros en polares de los
% polos y sus coordenadas en cartesianas
% alfa ser· el ·ngulo de P' en coordenadas polares
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

% se representa en la plantilla los datos. 
% Nota: podemos jugar d·ndole tamaÒo o color dependiendo de la calidad del
% punto
% subplot(1,2,1);
% % dibujamos la plantilla de wulff
% dibuja_wulff
% scatter(polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2),calidad_tin(:,1),calidad_tin(:,1));
% title('Proyecci√≥n estereogr√°fica de los planos')
% xlabel('eje X'); ylabel('eje Y');
% subplot(1,2,2);
% figure('Name','Histograma de los polos','NumberTitle','on')
% hist3(polos_estereo_cartesianas);
% title('Histograma de los polos P. detectados')
% xlabel('eje X'); ylabel('eje Y');zlabel('n polos');

end


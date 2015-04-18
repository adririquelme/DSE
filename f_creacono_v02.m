function [ P ] = f_creacono_v02( r, h, h2, inc, error)
% Función que genera las coordenadas de puntos en la superficie de un cono
% Adrián J Riquelme, 28 octubre 2014
% adririquelme@gmail.com
% [ P ] = f_creacono_v02( r, h, h2, inc, error)
% r: radio del cono
% h: altura del eje del cono
% h2: altura del cono
% inc: separación entre puntos
if r~=0 && h~=0 && inc~=0
    % Base, en esta función no la pongo
    % Superficie lateral
    % Defino los incrementos para crear la matriz de puntos
    nh = floor(h2/inc); % numero de intervalos en altura
    dh = h2 / nh; % incremento de altura para cada intervalo
    % creo la matriz de puntos
    nincbase = floor(2*pi*r/inc);
    P = zeros(nh*nincbase,6); % inicio la matriz de puntos, mucho más grande de la que tendré
    contador = 1;
    alpha_cono = atan(h/r);
    handle_waitbar=waitbar(0,['Creando el cono']);
    for ii=0:(nh-1)
        radio= r/h*(h-ii*dh); % defino el radio del círculo para esa altura
        longradio=2*pi*radio; % longitud del radio en esa altura
        ninccircunferencia = floor(longradio / inc)+1; % número de incrementos de circunferencia
        alphaunit = 2*pi / ninccircunferencia; 
        alpha=[0:alphaunit:2*pi]';
        P(contador:(contador-1+length(alpha)),1) = radio * cos(alpha) + random('Normal',0,error/3,1);
        P(contador:(contador-1+length(alpha)),2) = radio * sin(alpha) + random('Normal',0,error/3,1);
        P(contador:(contador-1+length(alpha)),3) = ii*dh + random('Normal',0,error/3,1);
        x=P(contador:(contador-1+length(alpha)),1);
        y=P(contador:(contador-1+length(alpha)),2);
        theta = atan2(y,x);
        P(contador:(contador-1+length(alpha)),4) = sin(alpha_cono) .* cos(theta);
        P(contador:(contador-1+length(alpha)),5) = sin(alpha_cono) .* sin(theta);
        P(contador:(contador-1+length(alpha)),6) = cos(alpha_cono);
        % P(contador:(contador-1+length(alpha)),7) = theta/pi*180;

        contador = contador +length(alpha)+1;
        waitbar(ii/nh,handle_waitbar);
    end   
    close(handle_waitbar);
else
    disp('Los datos de entrada son incorrectos. R, h e inc deben ser no nulos')
    P=[0 0 0];
end

% limpio los puntos vacíos
I = find(P(:,1)~=0 & P(:,2)~=0 & P(:,3)~=0);
P = P(I,:);

% guardamos también en el fichero puntos.txt
% fi = fopen('puntos.txt', 'w') ;
% [n,p]=size(P);
% for k=1:n
%     fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
% end 
% fclose(fi);
dlmwrite('tronco_cono_puntos.txt',P, 'delimiter', '\t');

end


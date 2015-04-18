function [ P ] = f_creasemiesfera( r, inc, error)
% Función que genera las coordenadas de puntos en la superficie de un cono
% Adrián J Riquelme, 28 octubre 2014
% adririquelme@gmail.com
% [ P ] = f_creasemiesfera( r, inc, error)
% r: radio de la esfera
% inc: distancia entre puntos
% error: error que metemos en los puntos
if r~=0 && inc~=0
    % calculo el incremento angular para ese inc
    dtheta = inc / r;
    n = floor((pi/2)/dtheta)+1; % n de incrementos para completar el pi /2
    dtheta = pi/2/n;
    % creo la matriz de puntos
    nincbase = floor(2*pi*r/inc);
    P = zeros(n*nincbase,6); % inicio la matriz de puntos, mucho más grande de la que tendré
    contador = 1;
    for ii=0:(n-1)
        theta = ii*dtheta;
        radio= r*cos(theta); % defino el radio del círculo para esa altura
        % calculo el incremento angular para ese inc
        dalpha = inc / radio;
        nalpha = floor((2*pi)/dalpha)+1; % n de incrementos para dar la vuelta completa
        dalpha = 2*pi/nalpha;
        handle_waitbar=waitbar(0,['Creando la semiesfera: altura ',num2str(ii),' de ',num2str(n)]);
        for jj=0:(nalpha-1)
            waitbar(jj/nalpha,handle_waitbar);
            alpha = jj * dalpha; % incremento en radianes para ese círculo
            P(contador,1) = radio * cos(alpha)+random('Normal',0,error/3,1);
            P(contador,2) = radio * sin(alpha)+random('Normal',0,error/3,1);
            P(contador,3) = r * sin (theta) + random('Normal',0,error/3,1);
            modulo = (P(contador,1)^2+P(contador,2)^2+P(contador,3)^2)^(0.5);
            P(contador,4)=P(contador,1)/modulo;
            P(contador,5)=P(contador,2)/modulo;
            P(contador,6)=P(contador,3)/modulo;
            contador = contador +1;
        end
        close(handle_waitbar);
    end   
else
    disp('Los datos de entrada son incorrectos. R, h e inc deben ser no nulos')
    P=[0 0 0];
end

% limpio los puntos vacíos
I = find(P(:,1)~=0 & P(:,2)~=0 & P(:,3)~=0);
P = P(I,:);

dlmwrite('puntos.txt',P, 'delimiter', '\t');

end


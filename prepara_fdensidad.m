%% Script para generar la función de densidad
% input
% - ns: se introduce manualmente
% - planos_estereo_cartesianas
% output
% - fdensidad_cuadrada

ns = input('Introduce el número de divisiones para la función de densidad \n ');
subplot(1,2,1);
%figure('Name','Función de densidad e Histograma','NumberTitle','off')
dat = planos_estereo_cartesianas; 
hold on 
hist3(planos_estereo_cartesianas, [ns ns])       % Draw histogram in 2D 
title('Función de densidad e Histograma');
xlabel('eje X'); ylabel('eje Y');
[fdensidad_cuadrada, C]=hist3(dat, [ns ns]); % generamos la función de densidad en una matriz cuadrada
n = fdensidad_cuadrada;
n1 = n'; 
n1( size(n,1) + 1 ,size(n,2) + 1 ) = 0; 

% Generate grid for 2-D projected view of intensities: 
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1)+1);
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1)+1);
% Make a pseudocolor plot: 
    h = pcolor(xb,yb,n1);
    % Set the z-level and colormap of the displayed grid: 
    set(h, 'zdata', ones(size(n1)) * -max(max(n))) 
    colormap(hot) % heat map 
    title('Función de densidad de los polos encontrados');
    grid on 
    % Display the default 3-D perspective view: 
    view(3);

% con la salida del histograma generamos las isolineas
X=[C{:,1}]; %es el eje X que ha creado el histograma
Y=[C{:,2}]; % eje Y que ha creado el histograma
subplot(1,2,2);
%figure('Name','Isolineas de la función de densidad','NumberTitle','off');
h = polar([0 2*pi], [0 1]);
delete(h);
hold on
[isolineas,hisolineas]=contour(X,Y,fdensidad_cuadrada,10); 

%representamos las isolíneas
clabel(isolineas,hisolineas);
axis equal
set(hisolineas,'ShowText','on','TextStep',get(hisolineas,'LevelStep')*2);
title('Isolineas de la función de densidad');
xlabel('eje X'); ylabel('eje Y');

% limpiamos la basura
clear ns dat n n1 xb yb h X Y h

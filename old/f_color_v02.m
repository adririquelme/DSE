function [color] = f_color_v02(u,base,k)
% Función que devuelve el color de un polo según una base
% para un polo, calcula las distancias a cada posición de la base y asigna
% la parte de color que le corresponde
% Input: 
% u - coordenadas cartesianas del polo a sacar el color, vector dim 2
% base: matriz, columnas 1 y 2 coordenadas del polo, columnas 3 4 y 5 color
% base está en dip direction y dip, por lo que hay que convertirlo
% en RGB de esa base
% k es un parámetro para potenciar los pesos
% k = 0 mezcla todos los colores
% k = 1 mezcla los colores linealmente con la distancia cartesiana
% k = 2 los mezcla dando mayor importancia al núcleo más cercano
% output: color en RGB, vector dim 3

% NOTA: calcular la distancia en cartesianas directamente

[n,~]=size(base); % saco el número de colores principales definidos
color=[0 0 0]; % inicio el color resultante
% distancias=zeros(n,1); % inicio la distancia del polo a los principales
% Convierto la base de Clar a cartesiana
[base_x,base_y]=f_clar2cart(base(:,1),base(:,2));
distancias=((u(1)-base_x).^2+(u(2)-base_y).^2).^0.5;
% Defino los pesos como la inversa de la distancia elevado a k
pesos=1./distancias.^k;
% peso_porcentaje=pesos/(sum(pesos)); % en tanto por uno
% Nota: debería hacer que si la distancia supera un umbral su peso fuera
% nulo

% busco si algún peso es infinito
if sum(isinf(pesos))>=1
    color=base(find(isinf(pesos)==1),3:5);
else
    % no es puro infinito, luego calculo
    % 
    for i=1:n
        color=color+base(i,3:5)*pesos(i);
    end
    color=color/sum(pesos);
end


end
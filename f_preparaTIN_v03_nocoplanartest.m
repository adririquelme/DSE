function [idx, dist, vertices_tin, calidad_tin, planos]=f_preparaTIN_v03_nocoplanartest(P, npb)
%% Función que prepara los puntos y genera los planos objeto de estudio
% Adrián Riquelme, abril 2013
% VERSIÓN QUE NO COMPRUEBA LOS COPLANARES
% Input: - P. matriz de nx3 que contiene las coordenadas de los puntos
%
% Output: 
% - idx: matriz [n,npb+1]. La primera columna indica el punto de
% referencia, las npb columnas restantes indican los npb puntos mï¿½s
% cercanos según la norma elegida. El valor es el id del punto.
% - dist: matriz [n,npb+1]. La primera columna sería cero, pues es la
% distancia de un punto consigo mismo. Las npb columnas siguientes indican
% la distancia el punto de referencia con el punto
% - vertices_tin: matriz que indica los puntos que forman parte del plano
% - calidad_tin: indica el n de puntos que forman cada plano
% - planos: matriz que contiene la ecuaciï¿½n de cada plano, ABCD

% cargamos los puntos en una matriz de np x 3
% P = load ('puntos.txt');
[np,~] = size ( P );
% np es el num total de puntos disponibles se comprueba que toda la tabla
% está compuesta por nums y que el n de columnas es de 3 la f isnan
% devuelve 1 si no es nï¿½mero o 0 en caso de que lo sea. Si al final el
% test es de validaciï¿½n es 0 serï¿½ porque todos los valores de la matriz
% son nï¿½meros. En caso de que no lo sea, el test de validación nos
% dirá cuantos valores no numéricos hay.


%% buscamos los puntos cercanos con knnsearch
% primero definimos una matriz con las coordenadas de puntos en las columnas:
% col 1: coordenada x
% col 2: coordenada y
% col 3: coordenada z
% Para ello, hay que quitar la primera columna que es el id de cada punto

X=P(:,1:3);

% Ahora con el knnsearch hay que buscar para cada punto, cuales son los mas
% cercanos y cual es esa distancia. La norma a utilizar es la norma
% euclidea (minkowski p=2) npb (n de puntos en el buffer) indica
% cuantos puntos busca, por lo que como el primer punto mas cercano
% es él mismo, k es npb+1
% npb = input('Indique el num de puntos cercanos a buscar: (num sugerido 8)  ');
if npb<4
    msgbox('Has elegido un número de puntos insuficiente. Se fija en 4','atención!!','warn');
    npb = 4;
end
% como la primera columna serï¿½ el mismo punto, aumentamos el nï¿½ de
% puntos de búsqueda en 1
npb = npb +1;
%disp('El tiempo de búsqueda de vecinos ha sido de')
%tic
[idx,dist]=knnsearch(X,X,'NSMethod','kdtree','distance','euclidean','k',npb);
% idx: matriz [n,npb+1]. La primera columna indica el punto de referencia,
% las npb columnas restantes indican los npb puntos mï¿½s cercanos según
% la norma elegida. El valor es el id del punto. dist: matriz [n,npb+1]. La
% primera columna es cero, pues es la distancia de un punto consigo
% mismo. Las npb columnas siguientes indican la distancia el punto de
% referencia con el punto
%toc
%% CÁLCULO SIN LOS COPLANARES
vertices_tin=idx;
calidad_tin(:,1)=npb;

%% %% búsqueda de coplanares
% % Buscamos la coplanaridad de los puntos encontrados
% % La salida es una matriz de dim [np k+1]. En primer lugar, la
% % creamos con una matriz de ceros.
% vertices_tin = zeros (np, npb+1);    
% 
% % para iniciar la búsqueda, necesitamos definir una tolerancia de
% % coplanaridad. Ésta es el % que supone landa3 sobre el total de los
% % valores propios
% if tolerancia >0 
% else
%     msgbox('La tolerancia introducida no es válida. Se fija por defecto a 0,01,','Atensión!!!!!','warn');
%     tolerancia=0.01;
% end
% 
% % hay que recorrer desde 1 hasta np los puntos de búsqueda
% % creamos un vector calidad_tin que nos indica la cantidad de puntos con
% % los que se crea un plano asociado a un punto de referencia
% % comienzo = cputime;
% %tic % probamos el tiempo entre vecinos
% calidad_tin = zeros (np,1);

% for j=1:np
%     %primero, chequeamos si todos los puntos cercanos son coplanares. Si lo
%     %son, los aceptamos todos y saltamos al siguiente punto de referencia.
%     %En caso contrario, buscaremos cual descartar.
%     % montamos en la matriz con los puntos
%     %idx era una matriz con los indexs de puntos cercanos. El n max de
%     %columnas es de npb, cuando un punto no es cercano, rellena con ceros.
%     V=find(idx(j,:)>0); %index of the near points
%     test_tin=P(V,1:3); %points to test coplanarity
%     [copl,score] = coplanaridad(test_tin,tolerancia);
%     counter=npb;
%     if copl == 1
%         vertices_tin(j,V)=idx(j,V);
%         calidad_tin(j,1)=counter;
%     else
%         while copl==0 && counter>3
%             [~,I]=max(score(:,3));
%             % I is the noncoplanar point position
%             test_tin(I,:)=[]; % remove the noncoplanar point
%             V(I)=0;
%             counter=counter-1;
%             [copl,score] = coplanaridad(test_tin,tolerancia);
%         end
%         I=find(V>0); V=idx(j,I);
%         [~,b]=size(I);
%         vertices_tin(j,1:b)=V(1:b);
%         calidad_tin(j,1)=counter;
%      end
%     %tfinalizar = floor((cputime - comienzo)/j*(np - j));
%     %avance = floor(j/np*100);
%     %clc
%     %fprintf('Completado %d %%. Tiempo estimado para finalizar: %d minutos %d segundos\n',avance, floor(tfinalizar/60),tfinalizar - floor(tfinalizar/60)*60);
%     waitbar(j/np,h);
% end
% close(h) %cerramos la ventana de avance
% %toc % cerramos el tiempo de bï¿½squeda de coplanares

%% representamos el histograma de calidad
% aux = linspace(4,npb, npb-4+1);
% [nvecinos ]=vec2mat(aux,1);
% n = histc(calidad_tin, nvecinos);       % Conteo de datos
% fr = n./sum(n);                     % Frecuencia relativa
% [aux]=vec2mat(diff(nvecinos),1);
% aux = [aux; [1]];
% frc = fr./aux; % Frecuencia relativa corregida
% subplot(1,2,1);
% bar(nvecinos, frc, 'histc');
% xlabel('Num de vecinos encontrados');
% ylabel('Frecuencia relativa corregida');
% title('Histograma de vecinos encontrados');
% [fa] = [cumsum(fr)]*100;                % frecuencia acumulada
% subplot(1,2,2);
% plot(nvecinos,fa)
% xlabel('Num de vecinos encontrados');
% ylabel('Frecuencia acumulada %');
% title('Frecuencia acumulada num de vecinos encontrados por punto')
% grid

%% Determinación de los planos
% Creamos la matriz de planos, que tiene dim np filas y 4 columnas
planos = zeros (np, 4);
% Preparamos los vectores con los puntos cercanos y coplanares para la
% determinación de A B C y D como cada punto tiene n puntos cercanos y
% coplanares, programamos con un while

% h=waitbar(0,'Calculating planes. Please wait');
for j=1:np
    I=vertices_tin(j,:);
    puntos_tin=P(I,:);
%     test = 1;
%     puntos_tin = zeros (1, 3); %resetamos el vector inicial de los puntos
%     puntos_tin (1,1:3) = P(vertices_tin(j,1),1:3);
%     k = 2;
%     while test == 1
%         v (1,1:3) = P(vertices_tin(j,k),1:3);
%         puntos_tin = [puntos_tin ; v];
%         if vertices_tin(j,k+1) == 0
%             test = 0;
%         end
%         k = k +1;
%     end
    % determinamos el plano
    x = puntos_tin(:,1);
    y = puntos_tin(:,2);
    z = puntos_tin(:,3);
    [A,B,C]=plane_fit(x,y,z); 
    if C == 0
        planos (j,1)=A;
        planos (j,2)=B;
        planos (j,3)=-1;
        planos (j,4)=0;
    else
        planos (j,1)=-1*A / C;
        planos (j,2)= -1*B / C;
        planos (j,3) = 1/C;
        planos (j,4) = -1;
    end
    % waitbar(j/np,h);
end


end
    
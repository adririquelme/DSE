function [ puntos_familia_cluster, familia_cluster_plano ] = f_clusterclear( puntos_familia_cluster_fullclusters, familia_cluster_plano_fullclusters , ds, ppcluster)
% [ puntos_familia_cluster, familia_cluster_plano ] = f_clusterclear( puntos_familia_cluster, familia_cluster_plano , ds, ppcluster)
% Función cluster clear: limpieza de clusters
% puntos_familia_cluster_fullclusters: xyz ds c
% familia_cluster_plano_fullclusters: ds, cluster, n puntos cluster, abcd
% ds: famila sobre la que se va a actuar
% ppcluster: número mínimo de puntos por cluster que va a tener esa DS
% Si ds=0 se asume que se aplica el filtro sobre todos los clusters

% renombro las variables para que sea más fácil programar
A=puntos_familia_cluster_fullclusters;
B=familia_cluster_plano_fullclusters;

% iniciamos la matriz con los puntos filtrados
puntos_salida = zeros(size(A));
contador_puntos_salida=1;


% busco los clusters del ds que cumplen con el mínimo número de pts p
% cluster
if ds == 0
    % se aplica el filtro sobre todas las familias
    I = find(B(:,3)>=ppcluster);
    familia_cluster_plano = B(I,:);
    
    % familias que han superado el filtro
    familiasok=unique(familia_cluster_plano(:,1));
    [nfamiliasok,~]=size(familiasok); % número de familias que superan el filtro
    for i=1:nfamiliasok
        familia = familiasok(i);
        % busco los clusters de esa familia
        I=find(familia_cluster_plano(:,1)==familia);
        clusters=unique(familia_cluster_plano(I,2)); % clusters que han superado el filtro, familia estudiada
        % en los puntos, busco aquellos de las familias y clusters que han
        % superado el filtro
        I=find(A(:,4)==familia);
        puntos_auxiliar = A(I,:);
        [indice]=f_findarray (puntos_auxiliar(:,5), clusters);
        puntos_auxiliar=puntos_auxiliar(indice,:);
        [npuntos_auxiliar,~]=size(puntos_auxiliar);
        posicion_inicial=contador_puntos_salida;
        posicion_final=contador_puntos_salida+npuntos_auxiliar-1;
        puntos_salida(posicion_inicial:posicion_final,:)=puntos_auxiliar;
        contador_puntos_salida=posicion_final+1;
        
    end
    % redimensiono puntos_salida a su tamaño final
    puntos_familia_cluster=puntos_salida(1:posicion_final,:);   
else
    % el filtro se aplica sólo en la familia seleccionada
    I = find(B(:,3)>=ppcluster & B(:,1)==ds);
    familia_cluster_plano = B(I,:);
    
    % familias que han superado el filtro
    familiasok=unique(familia_cluster_plano(:,1));
    [nfamiliasok,~]=size(familiasok); % número de familias que superan el filtro
    for i=1:nfamiliasok
        familia = familiasok(i);
        % busco los clusters de esa familia
        I=find(familia_cluster_plano(:,1)==familia);
        clusters=unique(familia_cluster_plano(I,2)); % clusters que han superado el filtro, familia estudiada
        % en los puntos, busco aquellos de las familias y clusters que han
        % superado el filtro
        I=find(A(:,4)==familia);
        puntos_auxiliar = A(I,:);
        [indice]=f_findarray (puntos_auxiliar(:,5), clusters);
        puntos_auxiliar=puntos_auxiliar(indice,:);
        [npuntos_auxiliar,~]=size(puntos_auxiliar);
        posicion_inicial=contador_puntos_salida;
        posicion_final=contador_puntos_salida+npuntos_auxiliar-1;
        puntos_salida(posicion_inicial:posicion_final,:)=puntos_auxiliar;
        contador_puntos_salida=posicion_final+1;
        
    end
    % redimensiono puntos_salida a su tamaño final
    puntos_salida=puntos_salida(1:posicion_final,:);
    % puntos salida tiene únicamente el DS seleccionado, hay que reordenar
    % el conjunto de puntos salida
    I=find(A(:,4)~=ds);
    puntos_salida2=A(I,:);
    puntos_familia_cluster=[puntos_salida; puntos_salida2];    
    % preparo la salida de familia_cluster_plano
    I = find(B(:,1)~=ds);
    familia_cluster_plano2 = B(I,:);
    familia_cluster_plano=[familia_cluster_plano; familia_cluster_plano2];
    familia_cluster_plano = sortrows(familia_cluster_plano);
end


end





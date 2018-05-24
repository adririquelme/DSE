function [familia_cluster_plano] = f_merge_clusters_v01(ksigmas, vnfamilia, puntos_familia_cluster, familia_cluster_plano)
% function [familia_cluster_plano] = f_merge_clusters_v01(ksigmas, vnfamilia, puntos_familia_cluster, familia_cluster_plano)
% Function that takes the families assigned to each point and calculates
% the clusters.
% Each cluster is a real plane, with the same normal vector
% Input:
% - ksigmas: parámetro para ver cuanto se tienen que solapar las funciones
% de densidad de dos clusters para considerarlos alineados. Valores entre
% 0 y 3 (o más). Normalmente 1.5
% - vnfamilia: determina si se le asigna el vector normal del DS (1) o se
% calcula la orientación del plano al cluster (0)
% - puntos_familia_cluster: matriz con los puntos, familias y el cluster al que pertenece
% - familia_cluster_plano: matriz que contiene qué familia, a qué cluster y
% la ecuación del plano del clúster notación Ax+By+Cz+D=0. Es una matriz de
% índices
% Output:
% - familia_cluster_plano: matriz que contiene qué familia, a qué cluster y
% la ecuación del plano del clúster notación Ax+By+Cz+D=0. Es una matriz de
% índices
%
% El vector normal puede calcularse ajustándo al clúster o utilizar
% El de toda la familia. Si vnfamilia=0 el plano se ajusta al clúster, si vnfamilia=1 se utiliza la orientación del plano principal. 
% En ambos casos, la posición del plano se determina a posteriori.
%vnfamilia=1;
%ksigmas=1.5; % parámetro para ver cuanto se tienen que solapar las funciones de densidad de dos clusters para considerarlos alineados
% A mayor ksigmas, más fácil une los clusters
% valores si fuera normal, que no lo es:
% ksigmas=1 solape mayor al 15,8%
% ksigmas=2 solape mayor al 2,3%
% ksigmas=3 solape mayor al 0,1%
%
%    Copyright (C) {2015}  {Adrián Riquelme Guill, adririquelme@gmail.com}
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%   with this program; if not, write to the Free Software Foundation, Inc.,
%   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrián Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

%% unificación de clusters según su desviación típica
% calculamos la sigma de cada cluster para cada familia

if or(ksigmas==0,vnfamilia==0) % ksigmas==0 && vnfamilia==1
    % no hacemos nada porque o bien ksigmas es nulo y por tanto no se
    % unifican o bien los planos de los clusters no son paralelos, y por
    % tanto no tiene sentido hacer este ajuste
else
    jointset = unique(puntos_familia_cluster(:,4)); % vector con los índices de las familias
    [njs,~]=size(jointset); % njs es el número de familias que hay
    % Calculamos las desviaciones típicas de las distancias punto-plano
    % para cada cluster
    % calculo el número de clusters que hay, y por tanto así habrá de
    % desviaciones típicas
    ncl = sum(familia_cluster_plano(:,2));
    sigmas = zeros(ncl,3); %matriz dd se guardan las sigmas fam cluster
    % h=waitbar(0,['Calculating the deviations of the point - best-fit-plane. Please wait']);
    contadorsigmas = 1;
    for i=1:njs
        Mjs=puntos_familia_cluster(puntos_familia_cluster(:,4)==jointset(i),:); % matriz con los puntos js y cluster de la familia i
        cluster = unique(familia_cluster_plano(familia_cluster_plano(:,1)==i,2));
        [ncs,~]=size(cluster); % ncs es el número de clusters de esa familia
        for j=1:ncs
            vn=familia_cluster_plano(familia_cluster_plano(:,1)==jointset(i) & familia_cluster_plano(:,2)==cluster(j),4:7); % vector normal del cluster j
            Aj=vn(1);
            Bj=vn(2);
            Cj=vn(3); 
            Dj=vn(4);
            ptos_j=Mjs(Mjs(:,4)==jointset(i) & Mjs(:,5)==cluster(j),1:3); % puntos del cluster j
            [N,~]=size(ptos_j(:,1)); % numero de puntos del cluster j
            sigma_j=sqrt(sum((Aj.*ptos_j(:,1)+Bj.*ptos_j(:,2)+Cj.*ptos_j(:,3)+Dj.*ones(size(ptos_j(:,1)))).^2,1)/(N-1)); % sigma de los puntos del cluster j
            sigmas(contadorsigmas,1)=i;
            sigmas(contadorsigmas,2)=j;
            sigmas(contadorsigmas,3)=sigma_j;
            contadorsigmas = contadorsigmas +1;
            % waitbar(j/(ncs-1),h);
        end
        % close(h);
    end
    
    for i=1:njs % recorremos todas las familias
        h=waitbar(0,['Merging clusters of the joint set ',num2str(jointset(i)),'. Please wait']);
        cluster = unique(familia_cluster_plano(familia_cluster_plano(:,1)==i,2));
        [ncs,~]=size(cluster); %ncs es el número de clusters de esa familia
        sigmas_cluster = sigmas(sigmas(:,1)==i,3); % todos los sigmas de esa familia
        D_cluster = familia_cluster_plano(familia_cluster_plano(:,1)==jointset(i),7); % todos los Ds de esa familia
        % test = zeros(size(sigmas_cluster));
        for j=1:ncs-1 % recorremos todos los clusters menos el último, porque ese no se va a buscar consigo mismo
            sigma_j=sigmas(sigmas(:,1)==i & sigmas(:,2)==j,3);
            % guardo la sigma en ese cluster
            familia_cluster_plano(familia_cluster_plano(:,1)==i & familia_cluster_plano(:,2)==j,8)=sigma_j;
            Dj=familia_cluster_plano(familia_cluster_plano(:,1)==jointset(i) & familia_cluster_plano(:,2)==cluster(j),7);
            test = abs(D_cluster(j+1:ncs,1) - Dj) ./ (sigma_j + sigmas_cluster(j+1:ncs,1));
            b = cluster(ksigmas>=test)+j; % ids de los clusters que han pasado el test para esa familia
            % antes de asignar el valor de D a los clusters que toquen,
            % debo de comprobar si hay algún cluster al que asignar eso
            if isempty(b)
                % como está vacía, no asigno nada
            else
                % hay algún clúster al que asignar
                % hay que recorrer uno a uno los clusters, luego tengo que
                % meter un for
                for mm=1:length(b)
                    familia_cluster_plano(familia_cluster_plano(:,1)==i & familia_cluster_plano(:,2)==b(mm),7)=Dj;
                    % Le añado también el valor del sigma que se ha usado
                    % para el cálculo
                    familia_cluster_plano(familia_cluster_plano(:,1)==i & familia_cluster_plano(:,2)==b(mm),8)=sigma_j;
                end
            end
            waitbar(j/(ncs-1),h);
        end
        close(h);
    end
end


end


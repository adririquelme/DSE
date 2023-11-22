function [ puntos_familia_cluster, familia_cluster_plano, polos_estereoppalasignados_afterdbscan ] = f_ppal2cluster_v10( puntos_ppalasignados, planos_pples, ppcluster,vnfamilia, polos_estereoppalasignados)
% [ puntos_familia_cluster, familia_cluster_plano, polos_estereoppalasignados_afterdbscan ] = f_ppal2cluster_v10( puntos_ppalasignados, planos_pples, ppcluster,vnfamilia, polos_estereoppalasignados)
% Function that takes the families assigned to each point and calculates
% the clusters.
% Each cluster is a real plane, with the same normal vector
% Input:
% - puntos_ppalasignados: matriz con los puntos y familia a la que pertenece
% - planos_pples: matriz con dipdir y dip (º) del vector buzamiento
% - vnfamilia: determina si se le asigna el vector normal del DS (1) o se
% calcula la orientación del plano al cluster (0)
% - polos_estereoppalasignados
% Output:
% - puntos_familia_cluster: matriz con los puntos, familias y el cluster al que pertenece
% - familia_cluster_plano: matriz que contiene qué familia, a qué cluster y
% la ecuación del plano del clúster notación Ax+By+Cz+D=0. Es una matriz de
% índices
% - polos_estereoppalasignados
% La v10 incorpora los polos, para eliminar los descartados por el dbscan
% El vector normal puede calcularse ajustándo al clúster o utilizar
% El de toda la familia. Si vnfamilia=0 el plano se ajusta al clúster, si vnfamilia=1 se utiliza la orientación del plano principal. 
% En ambos casos, la posición del plano se determina a posteriori.
% ksigmas=1.5; % parámetro para ver cuanto se tienen que solapar las funciones de densidad de dos clusters para considerarlos alineados
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

        
ksigmaseps = 2; % parámetro para determinar el radio de búsqueda de puntos en el DBSCAN
% es cuántas desviaciones sobre la distancia media del 4 vecino se toma.

% buscamos el número de familias que hay
puntos_familia_cluster=puntos_ppalasignados;
familia_cluster_plano=[];
puntos=puntos_ppalasignados(:,1:3);
familia=puntos_ppalasignados(:,4);
nf=max(familia);

% Primero vemos si uso o no del Computer Vision Toolbox de MATLAB
version=ver;
toolboxes={version.Name};
uso=length(find(contains(toolboxes,'Statistics and Machine Learning Toolbox')==1));
if uso==1
    % El toolbox está instalado, vamos a ver si es la versión que tiene
    % el dbscan
    if str2double(getfield(version,{find(contains(toolboxes,'Statistics and Machine Learning Toolbox')==1)},'Version'))>=11.5
        % El DBSCAN se introdujo en la 2019a. Tenemos el DBSCAN, en la
        % versión del SMLT 11.5.
        f = waitbar(0,'1','Name','DBSCAN Analysis via Toolbox: searching for clusters');
    else
        % No hay DBSCAN y hay que ir a mi programación
        f = waitbar(0,'1','Name','DBSCAN Analysis: searching for clusters');
    end
end



for ii=1:nf
	% Empezamos a calcular los clusters
    jointset=find(familia==ii); %índices de los puntos que pertenecen a la fam ii
    % Update waitbar and message
    waitbar(ii/nf,f,sprintf('DBSCAN of DS %d of %d. %d points',ii,nf, size(puntos(jointset,:),1)));
    % puntos(I,:); % coordenadas de los puntos de la familia ii
    % el número de cercanos lo fijamos en 4 por publicación del DBSCAN
    % puntos_familia_cluster(jointset,5)=f_dbscan(puntos(jointset,:),eps, ppcluster);
    
    % Para cada familia calculo el radio de búsqueda eps para el DBSCAN
    npb=4;  % establezco que el radio sea la distancia para el cuarto vecino
    nvecinos=npb+1;
    
    [n,~]=size(puntos(jointset,:));
    if nvecinos > n
        nvecinos=n;
        [~,dist]=knnsearch(puntos(jointset,:),puntos(jointset,:),'NSMethod','kdtree','distance','euclidean','k',nvecinos);
        data=dist(:,nvecinos); %tomamos todos las distancias del 4º vecino
    else
        [~,dist]=knnsearch(puntos(jointset,:),puntos(jointset,:),'NSMethod','kdtree','distance','euclidean','k',nvecinos);
        if n<5
            data=dist(:,n); %tomamos todos las distancias del último vecino
        else
            data=dist(:,5); %tomamos todos las distancias del 4º vecino
        end
    end
    data=unique(data,'sorted'); %ordenamos la las distancias
    eps=mean(data)+ksigmaseps*std(data);

    % ejecutamos el análisis clúster
    % El número mínimo de puntos minpts lo dejamos en 4
    minpts=4;
    % Calculo los clusters que corresponden a cada punto
    T=f_dbscan_v02(puntos(jointset,:),eps, minpts, ppcluster);
    puntos_familia_cluster(jointset,5)=T;
    [nc,~]=max(puntos_familia_cluster(jointset,5)); % nc número de clústers para la familia ii
    % con las familias y los cluster, calculamos la ecuación del plano de
    % cada cluster, notación Ax+By+Cz+D=0, y o metemos en
    % familia_cluster_plano
    h=waitbar(0,['Calculating JS # ',num2str(ii),'/',num2str(nf),' cluster eqs. Please wait']);
    for jj=1:nc
        jointset=find(puntos_familia_cluster(:,4)==ii & puntos_familia_cluster(:,5)==jj);
        M=puntos_familia_cluster(jointset,1:3); % matriz que tiene los puntos le la familia ii y cluster jj
        if vnfamilia==0
            % calculamos el vector normal ajustándolo al clúster
            % [pc, ~, ~ ] = princomp (M,'econ'); % orden que dejará de
            % funcionar
            % [pc, ~, ~ ] = pca (M,'econ');
            [pc, ~, ~ ] = pca (M);
            vn=cross(pc(:,1),pc(:,2));% vector normal
            vn=vn/norm(vn); %vector normal normalizado, |vn|=1
            A=vn(1);
            B=vn(2);
            C=vn(3);
        else
            % utilizamos el vn calculado para toda la familia
            omega=planos_pples(ii,1)/180*pi;
            beta=planos_pples(ii,2)/180*pi;
            [ A,B,C ] = f_vbuz2vnor( omega,beta );
        end
        sx=sum(puntos_familia_cluster(jointset,1));
        sy=sum(puntos_familia_cluster(jointset,2));
        sz=sum(puntos_familia_cluster(jointset,3));
        [np,~]=size(jointset);
        if C~=0
            a1=-A/C;
            a2=-B/C;
            a0=1/np*(sz-a1*sx-a2*sy);
            D=-a0*C;
        else
            if B~=0
                a1=-A/B;
                a0=1/np*(sy-a1*sx);
                D=-a0*B;
            else
                if A~=0
                    a1=-B/A;
                    a0=1/np*(sx-a1*sy);
                    D=-a0*A;
                end
            end
        end
        v=[ii jj size(jointset,1) A B C D ];
        familia_cluster_plano=[familia_cluster_plano; v];
        waitbar(jj/nc,h);
    end 
    close(h);
end

% elimino el waitbar de las familias
close(f);

% limpiamos las familias sin clústers
I=find(puntos_familia_cluster(:,5)>0);
puntos_familia_cluster=puntos_familia_cluster(I,:);
polos_estereoppalasignados_afterdbscan=polos_estereoppalasignados(I,:);

end

%% Changelog
% 20200126 Introduzco el análisis DBSCAN del toolbox de MATLAB, que es
% muuucho más rápido

function [ T ] = f_dbscan_v02( A , eps, minpts, ppcluster)
% [ T, eps ] = f_dbscan_v02( A , npb, minpts, ppcluster)
% B�squeda de cl�sters mediante una b�squeda previa de vecinos
% Aplicaci�n del algoritmo DBSCAN
% Adri�n Riquelme Guill, mayo 2013
% Input:
% - A: matriz con las coordenadas de los puntos
% - eps: radio para b�squeda de vecinos
% - minpts: n�mero m�nimo de vecinos dentro del radio de b�squeda para que
% el punto sea considerado miembro del cl�ster. Suele ser 4.
% - ppcluster: n m�nimo de puntos por cl�ster
% Output:
% - T: cl�sters asignados a cada vecino
%    Copyright (C) {2015}  {Adri�n Riquelme Guill, adririquelme@gmail.com}
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
%    Discontinuity Set Extractor, Copyright (C) 2015 Adri�n Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.

[n,~]=size(A);
% h=waitbar(0,['Cluster analysis in progress. ',num2str(n),' points. Please wait.'],'Name','DBSCAN analysis');

% Primero vemos si uso o no del Computer Vision Toolbox de MATLAB
version=ver;
toolboxes={version.Name};
uso=length(find(contains(toolboxes,'Statistics and Machine Learning Toolbox')==1));
if uso==1
    % El toolbox est� instalado, vamos a ver si es la versi�n que tiene
    % el dbscan
    if str2double(getfield(version,{find(contains(toolboxes,'Statistics and Machine Learning Toolbox')==1)},'Version'))>=11.5
        % El DBSCAN se introdujo en la 2019aTenemos el DBSCAN, en la
        % versi�n del SMLT 11.5.
        casedbscan=1;
    else
        % No hay DBSCAN y hay que ir a mi programaci�n
        casedbscan=0;
    end
end

switch casedbscan
    case 1
        % Tenemos DBSCAN de MATLAB y lo vamos a usar que es m�s r�pido
        % Minpts no necesita correcci�n
        T=dbscan(A,eps, minpts);
    case 0
        % No hay DBSCAN y ejecuto mi programaci�n inicial
        % Minpts: los que tienen que estar m�s �l mismo
        T=zeros(n,1);
        maxcluster=1;
        % 0 sin cl�ster asignado
        % 1,2.... cl�ster asignado
        % calculamos los puntos dentro del radio de eps
        [idx, ~] = rangesearch(A,A,eps);
        for i=1:n
            NeighbourPts=idx{i};
            % si ha encontrado el m�nimo de puntos, hacer lo siguiente
            % cuidado, el primer �ndice de idx es el mismo punto
            if length(NeighbourPts)>=minpts+1 %el punto es un core point
                % �el punto tiene cl�ster asignado?
                cv=T(NeighbourPts); %cl�ster vecinos
                mincv=min(cv); %�ndice del menor cl�ster
                mincv2=min(cv((cv>0))); %�ndice del menor cl�ster no nulo
                maxcv=max(cv);%�ndice del mayor cl�ster
                if maxcv==0
                    caso=0; % todos lo puntos son nuevos
                else
                    if maxcv==mincv2
                        caso=1;
                    else
                        caso=2;
                    end
                end
                switch caso
                    case 0
                        % ning�n punto tiene c�ster asingado, se lo asignamos
                        T(NeighbourPts)=maxcluster;
                        % T(i)=maxcluster;
                        maxcluster=maxcluster+1; %incrementamos el contador para nuevos cl�sters
                    case 1
                        % hay puntos sin cl�ster y el resto todos pertenecen al
                        % mismo cl�ster
                        if mincv==0
                            % asignamos los que no tienen cl�ster
                            T(NeighbourPts(cv==0))=mincv2;
                        end
                        % T(i)=mincv2;
                    case 2
                        % hay puntos sin cl�ster y otros cl�sters ya asignados
                        % menor cl�ster no nulo: mincv2
                        % a los puntos sin cl�ster les asigno uno
                        T(NeighbourPts(cv==0))=mincv2;
                        % reagrupamos los puntos que ya tienen cl�ster
                        b=cv(cv>mincv2); % cl�sters a reasignar
                        [~,n1]=size(b);
                        aux=0;
                        for j=1:n1
                            if b(j)~=aux
                                T(T==b(j))=mincv2;
                                aux=b(j);
                            end
                        end
                end
            else
                % en esta caso, length(NeighbourPts) < minpts
                % el punto no tiene suficientes vecinos.
                % no hago nada y dejo al punto morir
            end
        end
end
%% homogeneizamos la salida
% si la salida est� vac�a (no se encuentra ning�n cluster), no hacemos nada
if sum(T)==0
    % no hademos nada, la salida est� vac�a
    % como todos los puntos tienen valor cero, se eliminar�n despu�s
else
    % en esta fase tomamos los cl�sters obtenidos y eliminamos los que no
    % superen los el n�mero m�nimo (ppcluster)
    % se ordenan los cl�sters seg�n mayor a menor n� de puntos obtenidos
    T2=T;
    cluster=unique(T2,'sorted');
    cluster=cluster(cluster>0); % eliminamos los cl�sters ru�do
    [ nclusters,~]=size(cluster);
    % calculamos el n�mero de puntos que pertenecen a cada cluster
    A=zeros(2,nclusters);
    numeroclusters=zeros(1, nclusters);
    for ii=1:nclusters
        numeroclusters(ii)=length(find(T2(:,1)==cluster(ii,1)));
    end
    A(2,:)=cluster; A(1,:)=numeroclusters;
    % ordeno la matriz seg�n el n�mero de cl�sters encontrados
    [~,IX]=sort(A(1,:),'descend'); A=A(:,IX);
    % buscamos aquellos clusters con m�s de n puntos
    n=ppcluster;
    I=find(A(1,:)>n);
    J=find(A(1,:)<=n);
    % los cl�sters no significativos le asingamos le valor 0
    for ii=1:length(J)
        T(T2==A(2,J(ii)))=0;
    end
    % renombramos los cl�sters seg�n importancia
    for ii=1:length(I)
        T(T2==A(2,I(ii)))=ii;
    end
end



%% Changelog
% 20200126 Introduzco el an�lisis DBSCAN del toolbox de MATLAB, que es
% muuucho m�s r�pido
% 20200127 Le quito el waitbar

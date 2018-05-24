function varargout = gui_persistence(varargin)
% GUI_PERSISTENCE MATLAB code for gui_persistence.fig
%      GUI_PERSISTENCE, by itself, creates a new GUI_PERSISTENCE or raises the existing
%      singleton*.
%
%      H = GUI_PERSISTENCE returns the handle to a new GUI_PERSISTENCE or the handle to
%      the existing singleton*.
%
%      GUI_PERSISTENCE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PERSISTENCE.M with the given input arguments.
%
%      GUI_PERSISTENCE('Property','Value',...) creates a new GUI_PERSISTENCE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_persistence_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_persistence_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_persistence

% Last Modified by GUIDE v2.5 13-Oct-2017 18:35:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_persistence_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_persistence_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_persistence is made visible.
function gui_persistence_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_persistence (see VARARGIN)

% Choose default command line output for gui_persistence
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_persistence wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_persistence_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadfile.
function pushbutton_loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [FileName,PathName] = uigetfile('*.*','Load the classified point cloud xyz-js-c-abcd');
    % name=strcat(PathName,FileName);
    %cd(PathName);
    A=load([PathName, FileName]);
    handles.data.A = A;
    handles.data.PathName=PathName;
    handles.data.FileName=FileName;
    % Inicio los resultados. El número de filas será al número de parámetros D diferentes
    [nfilas,~]=size(unique(A(:,9)));
    handles.data.nfilas=nfilas;
    % los campos son: ds, c, pdip, pdipdir, pmax, parea
    resultados=zeros(nfilas,6);
    handles.data.resultados=resultados;
    % Cargo los DS
    ds_list=unique(A(:,4));
    handles.data.ds_list=ds_list;
    [nds,~]=size(ds_list);
    handles.data.nds=ds_list;
    % Preparo el slider del DS
    set(handles.slider_ds,'Min',1,'Max',nds)
    set(handles.slider_ds,'SliderStep',[1 1]/(nds-1),'Value',1);
    % set(handles.text_ds,'String',num2str(1));
    % Llamo al callback del slider para que lo monte todo
    slider_ds_Callback(hObject, eventdata, handles)
catch error
    errordlg(['Error: ' error.identifier]);
end

guidata(hObject,handles)


% --- Executes on slider movement.
function slider_ds_Callback(hObject, ~, handles)
ds=(get(hObject,'Value'));
set(handles.text_ds,'String',num2str(ds));
% Preparo el slider del cluster

A=handles.data.A;
ds_list=handles.data.ds_list;
ds=(get(handles.slider_ds,'Value'));
% I=find(A(:,4)==ds_list(ds));
B=A(A(:,4)==ds_list(ds),:);

% Ahora busco los clusters que tengan el mismo D
D_list=unique(B(:,9));
% preparo los índices de los clusters
[ncl,~]=size(D_list); % número de clusters de ese ds
% Preparo el slider del cluster
if ncl>1 
    % Si es mayor a uno preparo el slider
    set(handles.slider_cl,'Enable','on');
    set(handles.slider_cl,'Min',1,'Max',ncl)
    set(handles.slider_cl,'SliderStep',[1 1]/(ncl-1),'Value',1);
    set(handles.text_cl,'String',num2str(1));
else
    % Desactivo el slider dejándolo con valor 1
    set(handles.slider_cl,'Enable','off','Value',1);
end

handles.data.B=B;
handles.data.D_list=D_list;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function slider_ds_CreateFcn(hObject, ~, ~)
% hObject    handle to slider_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_cl_Callback(hObject, eventdata, handles)
% hObject    handle to slider_cl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Cargo la información de los clusters y preparo el slider
% filtro los puntos de ese ds
cl=(get(hObject,'Value'));
set(handles.text_cl,'String',num2str(cl));
% Represento la persistencia de ese cluster
% llamar al callback del plot
pushbutton_plot_Callback(hObject, eventdata, handles)
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider_cl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_cl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Preparo los datos de entrada
A=handles.data.A;
ds_list=unique(A(:,4));
ds=(get(handles.slider_ds,'Value'));
I=find(A(:,4)==ds_list(ds));
B=A(I,:);
D_list=unique(B(:,9));
% Empieza el cálculo
[dipdir,dip]=f_vnor2vbuz(B(1,6),B(1,7),B(1,8));
dip = -dip; % para que el buzamiento vaya hacia abajo
i=get(handles.slider_ds,'Value');
j=get(handles.slider_cl,'Value');
% Preparo los puntos de ese cluster
J=find(B(:,9)==D_list(j));
cluster=B(J,:);
% Calculo la matriz de rotación R
%R= [cos(dip)*cos(pi/2-dipdir) cos(pi-dipdir) sin(dip)*cos(pi/2-dipdir);
%cos(dip)*sin(pi/2-dipdir) sin(pi-dipdir) sin(dip)*sin(pi/2-dipdir);
%-sin(dip) 0 cos(dip)];
R= [cos(dip)*sin(dipdir) -cos(dipdir) sin(dip)*sin(dipdir);
cos(dip)*cos(dipdir) sin(dipdir) sin(dip)*cos(dipdir);
-sin(dip) 0 cos(dip)];

% Calculo las coordenadas de los puntos en el nuevo SR, donde OX tiene la
% dirección del buzamiento, OY de la dirección del plano y el OZ del vector
% normal al plano
% Primero me llevo el cluster al cdg
xmean = mean(cluster(:,1));
ymean = mean(cluster(:,2));
zmean = mean(cluster(:,3));
P1=zeros(size(cluster(:,1:3))); % reinicio la matriz auxiliar P1
P1(:,1)=cluster(:,1)-xmean;
P1(:,2)=cluster(:,2)-ymean;
P1(:,3)=cluster(:,3)-zmean;
P2=P1*R; % puntos ya rotados

% Cálculo de la persistencia en la dirección del vector de buzamiento
persistence_dip=max(P2(:,1))-min(P2(:,1));
persistence_strike=max(P2(:,2))-min(P2(:,2));
% Calculo el convex hull de los puntos de ese cluster
% proyectado en el OXY
k = convhull(P2(:,1),P2(:,2)); % k son los índices de los puntos del convex hull
% Calculo el área encerrada en el convex hull
area=polyarea(P2(k,1),P2(k,2));
% Calculo la distancia máxima interna en el convex hull
D=pdist2(P2(k,1:2),P2(k,1:2));
persistence_max=max(max(D));
% Registro las persistencias
% resultados(contador,1)=ds_list(i);
% resultados(contador,2)=min(B(B(:,9)==D_list(j),5));
% resultados(contador,3)= persistence_dip;
% resultados(contador,4)=persistence_dipdir;
% resultados(contador,5)=persistence_max;
% resultados(contador,6)=area;          
% Represento la salida
if get(handles.checkbox_popup,'Value')==1
    h=figure;
    scatter3(P2(:,1),P2(:,2),P2(:,3),'.');
    axis equal
    hold on;
    % plot(cluster(k,1),cluster(k,2),'.'); % Esto representa en 2D
    plot(P2(k,1),P2(k,2),'r*');
    fill(P2(k,1),P2(k,2),'r','facealpha',0.5);
    % Maqueo la figura
    title(['DS ', num2str(ds_list(get(handles.slider_ds,'Value'))), ' - cluster ', num2str(min(B(B(:,9)==D_list(j),5)))]);
    xlabel('direction of dip'); ylabel('direction of strike');
    hold off
else
    h=handles.axes_plot;
    scatter3(h,P2(:,1),P2(:,2),P2(:,3),'.');
    axis equal
    hold on;
    % plot(cluster(k,1),cluster(k,2),'.'); % Esto representa en 2D
    plot(h,P2(k,1),P2(k,2),'r*');
    fill(h,P2(k,1),P2(k,2),'r','facealpha',0.5);
    % Maqueo la figura
    title(['DS ', num2str(ds_list(get(handles.slider_ds,'Value'))), ' - cluster ', num2str(min(B(B(:,9)==D_list(j),5)))]);
    xlabel('direction of dip'); ylabel('direction of strike');
    hold off
end
% Guardo los resultados en el listbox
% guardo la información en el log
l1 = ['DS: ',num2str(ds_list(get(handles.slider_ds,'Value')))]; % DS
l2 = ['cluster: ',num2str(min(B(B(:,9)==D_list(j),5)))]; % cluster
l3 = ['D: ',num2str(D_list(j)) ]; % D
l4 = ['Pdip: ',num2str(persistence_dip) ]; % persistencia dirección del dip
l5 = ['Pstrike: ',num2str(persistence_strike)]; % persistencia dirección de strike
l6 = ['Pmax: ',num2str(persistence_max) ]; % persistencia max
l7 = ['Parea: ',num2str(area) ]; % persistencia area
salida = char(l1,l2,l3,l4,l5,l6,l7);
set(handles.listbox_results,'String',salida);
guidata(hObject,handles)



% --- Executes on button press in checkbox_popup.
function checkbox_popup_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox_popup
popup=get(hObject,'Value');
switch popup
    case 1
        set(hObject,'String','Popup Plot on')
    case 0
        set(hObject,'String','Popup Plot off')
end


% --- Executes on selection change in listbox_results.
function listbox_results_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_results contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_results


% --- Executes during object creation, after setting all properties.
function listbox_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_calculatepersistences.
function pushbutton_calculatepersistences_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pushbutton_calculatepersistences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A=handles.data.A;
% Inicio los resultados. El número de filas será al número de parámetros D
% diferentes
[nfilas,~]=size(unique(A(:,9)));
% los campos son: ds, c, pdip, pdipdir, pmax, parea
resultados=zeros(nfilas,6);

% Cargo los DS
ds_list=unique(A(:,4));
[nds,~]=size(ds_list);

contador = 1; % contador para meter los resultados

% Inicio el array de salida
S=char('Calculation of persistences',[handles.data.PathName,handles.data.FileName],datestr(now),'');
S=char(S,sprintf('   \t    \t Persistence'));
S=char(S,sprintf('DS \t cl \t dip \t     strike \t max \t area'));
Q=char('',sprintf('Summarize of the max persistence values'));
Q=char(Q,sprintf('DS \t mean \t     max'));
for i=1:nds
    % filtro los puntos de ese ds
    B=A(A(:,4)==ds_list(i),:); % lista de los DS
    % Ahora busco los clusters que tengan el mismo D
    D_list=unique(B(:,9));
    % preparo los índices de los clusters
    % Iclusters=find(B(:,9)==D_list);
    % clusters_list=unique(B(Iclusters,5));
    [ncl,~]=size(D_list);
    % Extraigo el dipdir y el dip
    [dipdir,dip]=f_vnor2vbuz(B(1,6),B(1,7),B(1,8));
    dip = -dip; % para que el buzamiento vaya hacia abajo
    for j=1:ncl
        % Preparo los puntos de ese cluster
        cluster=B(B(:,9)==D_list(j),:);
        %[ persistence_dip, persistence_dipdir ] = f_persistence( cluster(:,1:3), dipdir, dip );
        % Calculo la matriz de rotación R
        R= [cos(dip)*cos(pi/2-dipdir) cos(pi-dipdir) sin(dip)*cos(pi/2-dipdir);
       cos(dip)*sin(pi/2-dipdir) sin(pi-dipdir) sin(dip)*sin(pi/2-dipdir);
       -sin(dip) 0 cos(dip)]; % es la misma matriz que antes. No pasa res.

        % Calculo las coordenadas de los puntos en el nuevo SR, donde OX tiene la
        % dirección del buzamiento, OY de la dirección del plano y el OZ del vector
        % normal al plano
        % Primero me llevo el cluster al cdg
        xmean = mean(cluster(:,1));
        ymean = mean(cluster(:,2));
        zmean = mean(cluster(:,3));
        P1=zeros(size(cluster(:,1:3))); % reinicio la matriz auxiliar P1
        P1(:,1)=cluster(:,1)-xmean;
        P1(:,2)=cluster(:,2)-ymean;
        P1(:,3)=cluster(:,3)-zmean;
        P2=P1*R; % puntos ya rotados

        % Cálculo de la persistencia en la dirección del vector de buzamiento
        persistence_dip=max(P2(:,1))-min(P2(:,1));
        persistence_strike=max(P2(:,2))-min(P2(:,2));
        % Calculo el convex hull de los puntos de ese cluster
        % proyectado en el OXY
        k = convhull(P2(:,1),P2(:,2)); % k son los índices de los puntos del convex hull
        % Calculo el área encerrada en el convex hull
        area=polyarea(P2(k,1),P2(k,2));
        % Calculo la distancia máxima interna en el convex hull
        D=pdist2(P2(k,1:2),P2(k,1:2));
        persistence_max=max(max(D));
        % Registro las persistencias
        resultados(contador,1)=ds_list(i);
        resultados(contador,2)=min(B(B(:,9)==D_list(j),5));
        resultados(contador,3)= persistence_dip;
        resultados(contador,4)=persistence_strike;
        resultados(contador,5)=persistence_max;
        resultados(contador,6)=area;
        % Guardo los resultados en el array de salida
        % Nota: para meter un número normal es %d. Si le pongo %0Xd
        % completa con ceros para que el entero tenga X cifras.
        % Para tabulación metemos \t
        % Para un número con X decimales, %.Xf
        S=char(S, sprintf('%02d \t %02d \t %.4f \t %.4f \t %.4f \t %.4f',ds_list(i),min(B(B(:,9)==D_list(j),5)),persistence_dip,persistence_strike,persistence_max,area));
        contador = contador +1;
    end
    % Ya hemos calculado todas las persistencias de un DS, ahora guardo la
    % media y valor máximo
    pmedia=mean(resultados(resultados(:,1)==ds_list(i),5));
    pmax=max(max((resultados(resultados(:,1)==ds_list(i),5))));
    Q=char(Q, sprintf('%02d \t %.4f \t %.4f',ds_list(i),pmedia,pmax));
end

% Guardo el reporte
f = fopen([handles.data.PathName,handles.data.FileName,' - report_persistence.txt'], 'wt');
[n,~]=size(S);
for i=1:n
    fprintf(f, '%s \n', S(i,:));
end
% Ahora añado el resumen con la salida Q
[n,~]=size(Q);
for i=1:n
    fprintf(f, '%s \n', Q(i,:));
end
fclose(f);



% Dibujamos la función de densidad
% el número de ds ya lo tenemos en nds
figure;
nsaltos=30; % número de saltos para la exponencial negativa
% El orden de las persistencias es dip, dipd, max y area
% Primero represento las persistencias en la dirección del dip
for i=1:nds
    subplot(4,nds,i);
    I=find(resultados(:,1)==i);
    [n,~]=size(I); persistencias=zeros(n,1);
    persistencias(1:n,1)=resultados(I,3);
    % persistencias(n+1:2*n,1)=resultados(I,4);
    % persistencias(2*n+1:3*n,1)=resultados(I,5);
    histogram(persistencias,'Normalization','pdf'); % esto está normalizado
    hold on
    media=mean(persistencias); % calculo la media
    lambda = 1/ media; % la intensidad es la inversa de la media
    x=(0:max(persistencias)/nsaltos:max(persistencias));
    y=lambda*exp(-lambda*x);
    plot(x,y);
%     title1='Histogram';
%     title2='f(p) = \lambda \ite^{-\lambda p}';
%     legend(title1,title2);
    g=gca;
    g.Title.String=['DS ', num2str(i),', n = ',num2str(n),', m = ',num2str(media)];
    g.XLabel.String='Persistence dip (m)';
end
% Persistencia en la dirección del strike
for i=1:nds
    subplot(4,nds,nds+i);
    I=find(resultados(:,1)==i);
    [n,~]=size(I); persistencias=zeros(n,1);
    persistencias(1:n,1)=resultados(I,4);
    % persistencias(n+1:2*n,1)=resultados(I,4);
    % persistencias(2*n+1:3*n,1)=resultados(I,5);
    histogram(persistencias,'Normalization','pdf'); % esto está normalizado
    hold on
    media=mean(persistencias); % calculo la media
    lambda = 1/ media; % la intensidad es la inversa de la media
    x=(0:max(persistencias)/nsaltos:max(persistencias));
    y=lambda*exp(-lambda*x);
    plot(x,y);
%     title1='Histogram';
%     title2='f(p) = \lambda \ite^{-\lambda p}';
%     legend(title1,title2);
    g=gca;
    g.Title.String=['DS ', num2str(i),', n = ',num2str(n),', m = ',num2str(media)];
    g.XLabel.String='Persistence strike (m)';
end

% Persistencia max
for i=1:nds
    subplot(4,nds,2*nds+i);
    I=find(resultados(:,1)==i);
    [n,~]=size(I); persistencias=zeros(n,1);
    persistencias(1:n,1)=resultados(I,5);
    % persistencias(n+1:2*n,1)=resultados(I,4);
    % persistencias(2*n+1:3*n,1)=resultados(I,5);
    histogram(persistencias,'Normalization','pdf'); % esto está normalizado
    hold on
    media=mean(persistencias); % calculo la media
    lambda = 1/ media; % la intensidad es la inversa de la media
    x=(0:max(persistencias)/n:max(persistencias));
    y=lambda*exp(-lambda*x);
    plot(x,y);
%     title1='Histogram';
%     title2='f(p) = \lambda \ite^{-\lambda p}';
%     legend(title1,title2);
    g=gca;
    g.Title.String=['DS ', num2str(i),', n = ',num2str(n),', m = ',num2str(media)];
    g.XLabel.String='Persistence max (m)';
end

% Persistencia area
for i=1:nds
    subplot(4,nds,3*nds+i);
    I=find(resultados(:,1)==i);
    [n,~]=size(I); persistencias=zeros(n,1);
    persistencias(1:n,1)=resultados(I,6);
    histogram(persistencias,'Normalization','pdf'); % esto está normalizado
    hold on
    media=mean(persistencias); % calculo la media
    lambda = 1/ media; % la intensidad es la inversa de la media
    x=(0:max(persistencias)/n:max(persistencias));
    y=lambda*exp(-lambda*x);
    plot(x,y);
%     title1='Histogram';
%     title2='f(p) = \lambda \ite^{-\lambda p}';
%     legend(title1,title2);
    g=gca;
    g.Title.String=['DS ', num2str(i),', n = ',num2str(n),', m = ',num2str(media)];
    g.XLabel.String='Persistence area (m^2)';
end

% Meto una leyenda general
title1='Histogram';
title2='f(p) = \lambda \ite^{-\lambda p}';
legend(title1,title2);




function [w,b]=f_vnor2vbuz(ux,uy,uz)
% Función de conversión vector normal a vector buzamiento del plano
% Adrián Riquelme, abril 2013
% [w,b]=vnor2vbuz(ux,uy,uz)
% Input:
% - componentes del vector normal al plano
% Output:
% - w: Ángulo que forma el vector de buzamiento con el eje OY, considerado
% como el norte
% - b: Ángulo que forma la lÃ­nea de mÃ¡xima pendiente del plano con su
% proyecciÃ³n horizontal.
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
uxy= (ux^2+uy^2)^(0.5);
bz=-uxy;
if uxy==0
    bx=0;
    by=0;
else
    bx=ux/uxy*uz;
    by=uy/uxy*uz;
end
bxy = abs(uz);
if bx>=0 && by>=0
    w = atan(bx/by);
end
if bx>0 && by<0
    w = pi-atan(abs(bx/by));
end
if bx<=0 && by<=0
    w = pi + atan(abs(bx/by));
end
if bx<0 && by>0
    w = 2*pi - atan(abs(bx/by));
end

b = atan(bz/bxy);

if bx==0 ||by==0
    w = 0;
end
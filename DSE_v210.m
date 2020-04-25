function varargout = DSE_v210(varargin)
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
% DSE_v210 MATLAB code for DSE_v210.fig
%      DSE_v210, by itself, creates a new DSE_v210 or raises the existing
%      singleton*.
%
%      H = DSE_v210 returns the handle to a new DSE_v210 or the handle to
%      the existing singleton*.
%
%      DSE_v210('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSE_V06.M with the given input arguments.
%
%      DSE_v210('Property','Value',...) creates a new DSE_V06 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DSE_v06_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DSE_v06_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DSE_v210

% Last Modified by GUIDE v2.5 27-Jan-2020 14:47:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSE_v06_OpeningFcn, ...
                   'gui_OutputFcn',  @DSE_v06_OutputFcn, ...
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


% --- Executes just before DSE_v06 is made visible.
function DSE_v06_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSE_v06 (see VARARGIN)

% Choose default command line output for DSE_v210
handles.output = hObject;
    % A = imread('img/salir','bmp');
    % set(handles.pushbutton_exit,'cdata',A);
    % handles.output = hObject;
    % A = imread('img/limpiar3','bmp');
    % set(handles.pushbutton_clear2,'cdata',A);
    A = imread('img/txt_file','bmp');
    set(handles.pushbutton_save_txtfam,'cdata',A);
    handles.data.vnfamilia=1;
    handles.data.ksigmas=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DSE_v06 wait for user response (see UIRESUME)
% uiwait(handles.figure_main1);


% --- Outputs from this function are returned to the command line.
function varargout = DSE_v06_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton_1loadP.
function pushbutton_1loadP_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_1loadP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('puntos.txt', 'file')
    handles.data.P = load ('puntos.txt');
    handles.data.filename='Points';
    % activamos el bot�n de scatter para ver que ha cargado
    handles.pushbutton_scatterpoints.Enable='on';
    % activamola preparaci�n de planos
    handles.pushbutton_2setupplanes.Enable='on';
    handles.pushbutton_2preparaTIN_fast.Enable='on';
    handles.text_ncercanos.Enable='on';
    handles.text_tolerancia.Enable='on';
    handles.box_nneighbours.Enable='on';
    handles.box_tolerancia.Enable='on';
    % activamos el salvado de la base de datos
    handles.menu_saveddbb.Enable='on';
    % activamos el bot�n de representar de nuevo
    handles.pushbutton_plot3dpoints.Enable='on';

    % guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Loaded the pointcloud from puntos.txt'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    handles.data.log = S;
else
  % File does not exist.
  warningMessage = sprintf('Warning: file puntos.txt does not exist');
  uiwait(msgbox(warningMessage));
end



guidata(hObject,handles)

% --- Executes on button press in pushbutton_2setupplanes.
function pushbutton_2setupplanes_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_2setupplanes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% c�lculo de curvatura local incluyendo test de coplanaridad
tic
P=handles.data.P;
npb=str2double(handles.box_nneighbours.String);
tolerancia=str2double(handles.box_tolerancia.String);
% guardo los datos con los que calculamos
handles.data.npb=npb;
handles.data.tolerancia=tolerancia;
% preparamos los planos
    [P, calidad_tin, planos]=f_setup_planes_v07(P, npb, tolerancia); % el n�mero de puntos se habr� reducido por el an�lisis
    % establecemos el n�mero de puntos en la pantalla
    [npuntos,~]=size(P);
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
    handles.data.P=P;
    handles.data.calidad_tin=calidad_tin;
    handles.data.planos=planos;
% convertimos los planos a la proyecci�n estereogr�fica
    [planos_estereo]=prepara_estereo(planos);
    handles.data.planos_estereo=planos_estereo;
% preparamos la representaci�n de los planos
    [~ , polos_estereo_cartesianas]=prepara_representa(planos_estereo);
    handles.data.polos_estereo_cartesianas=polos_estereo_cartesianas;
% activamos el c�lculo de planos (siguiente paso)
    handles.pushbutton_3statanalysis.Enable='on';
    handles.text_nsec.Enable='on';
    handles.text_angulovpples.Enable='on';
    handles.slider_nsec.Enable='on';
    handles.box_nsec.Enable='on';
    handles.box_angulovpples.Enable='on';
    handles.text_box_maxpples.Enable='on';
    handles.box_maxpples.Enable='on';
    % establecemos el n�mero de puntos
    [npuntos,~]=size(P);
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
% activamos el bot�n de representar los polos en stereo
    handles.pushbutton_plotstereopoles.Enable='on';
% registro el tiempo que hemos empleado
    tiempoempleado=floor(toc);
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Local curvature calculation,', ' num of neighbours: ',num2str(npb),', tolerance = ',num2str(tolerancia),', n of points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' seconds'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop= N; % vista de la �ltima l�nea
    handles.data.log = S;
guidata(hObject,handles)

% --- Executes on button press in pushbutton_3statanalysis.
function pushbutton_3statanalysis_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_3statanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% An�lisis estad�stico de los polos de los vectores normales
% preparo los datos de entrada
tic;
polos_estereo_cartesianas=handles.data.polos_estereo_cartesianas;
nsec=str2double(handles.box_nsec.String); % sectorizaci�n de la malla para el kde
angulovpples=str2double(handles.box_angulovpples.String); % m�nimo �ngulo entre polos principales
maxpples=str2double(handles.box_maxpples.String); % m�ximo n�mero de polos principales
% guardo los datos con los que calculamos
handles.data.nsec=nsec;
handles.data.angulovpples=angulovpples;
% preparamos la funci�n de densidad con el kde
    [polos_pples, polos_pples_cart,density, X, Y]=f_prepara_planos_kde(polos_estereo_cartesianas,nsec, angulovpples, maxpples);
    handles.data.polos_pples_cart=polos_pples_cart;
    handles.data.X=X;
    handles.data.Y=Y;
    handles.data.density=density;
% buscamos los planos principales
    [ planos_pples ] = f_principal_planes(polos_pples);
    handles.data.planos_pples=planos_pples;
% introducimos los planos principales en la tabla
    handles.uitable_principalplanes.Visible='on';
    handles.uitable_principalplanes.Enable='on';
    handles.uitable_principalplanes.Data=planos_pples;
% set visible the uipanel for assignment poles to the points
    handles.pushbutton_4ppalpolesassignment.Enable='on';
    handles.text_box_cone.Enable='on';
    handles.box_cone.Enable='on';
% activate the principal poles editor
    handles.pushbutton_31editppalpoles.Enable='on';
% make visible the plot principal poles button
    handles.pushbutton_plotdensitypoles.Enable='on';
% Guardo la info en el cuadro de texto
tiempoempleado=floor(toc);
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Statistic calculation, N� of bins: ',num2str(nsec),', min angle btwn ppal poles: ',num2str(angulovpples),', max n� of ppal poles: ',num2str(maxpples),'; total time: ', num2str(tiempoempleado),' seconds'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
guidata(hObject,handles)


% --- Executes on button press in pushbutton_4ppalpolesassignment.
function pushbutton_4ppalpolesassignment_Callback(hObject, ~, handles)
% Asignaci�n de polos principales a los puntos
tic; % Inicio un contador para ver el tiempo empleado
cone=str2double(handles.box_cone.String);
cone=cone/180*pi;
polos_estereo_cartesianas=handles.data.polos_estereo_cartesianas;
polos_pples_cart=handles.data.polos_pples_cart;
P=handles.data.P;
[polos_estereoppalasignados, puntos_ppalasignados] = f_setppal2planes_v02( cone, polos_estereo_cartesianas, polos_pples_cart ,P);
handles.data.polos_estereoppalasignados=polos_estereoppalasignados;
handles.data.puntos_ppalasignados=puntos_ppalasignados;
handles.pushbutton_plotstereopolesppal.Enable='on';
handles.pushbutton_plot3dpointsppal.Enable='on';
% guardo los datos con los que calculamos
handles.data.cone=str2double(handles.box_cone.String);
% actualizo el numero de puntos que tengo
% I es el �ndice de los puntos con cluster asignado
I=find(polos_estereoppalasignados(:,3)>0);
% actualizo los datos a aquellos con cluster
polos_estereo_cartesianas=polos_estereo_cartesianas(I,:);
P=P(I,:);
planos=handles.data.planos(I,:);
% puntos_ppalasignados=puntos_ppalasignados(I,:);
[npuntos,~]=size(I);
handles.text_npuntos.Visible='on';
handles.text_npuntos.String=npuntos;
handles.text_label_npuntos.Visible='on';
% actualizo el n�mero de puntos que representan los polos principales
planos_pples=handles.data.planos_pples;
[n,~]=size(P); % n�mero de puntos totales
[nf,~]=size(planos_pples); % n�mero de familias que hay
for i=1:nf
    % calculo el % de puntos que hay y lo pongo en la cuarta columna
    [npuntos,~]=size(polos_estereoppalasignados(polos_estereoppalasignados(:,3)==i));
    planos_pples(i,4)=npuntos/n*100;
end
handles.data.planos_pples=planos_pples;

% Activo el DSC
[ dipdir, dip ] = f_cart2clar(polos_estereo_cartesianas(:,1) ,polos_estereo_cartesianas(:,2) );
dipdir=dipdir/180*pi;
dip=dip/180*pi;

% Calculo el �ngulo alpha
% alpha es el �ngulo desde el OX antihorario hasta la proyecci�n del polo
alfa=zeros(size(dipdir));
I=find(dipdir>=0 & dipdir<pi/2); alfa(I)=pi/2-dipdir(I)+pi;
I=find(dipdir>=pi/2 & dipdir <pi);alfa(I)=pi-(dipdir(I)-pi/2);
I=find(dipdir>=pi & dipdir<3*pi/2);alfa(I)=pi/2-(dipdir(I)-pi);
I=find(dipdir>=3*pi/2 & dipdir<2*pi);alfa(I)=7*pi/2-dipdir(I);

% Ahora represento los polos en mi falsilla con colores
% z=zeros(length(alfa),1);

% [x,y] = f_clar2cart(w,b);
HSV=zeros(length(alfa),3);
HSV(:,1)=(alfa)/(2*pi); % Hue
HSV(:,2)=dip/(pi/2); % Saturation
% por si acaso, corrijo estas columnas
HSV(HSV(:,1)>1,1)=1;
HSV(HSV(:,2)>1,2)=1;
HSV(:,3)=1; % Value
% Calculo los colores seg�n el punto
rgb = hsv2rgb(HSV)*255;
% Exportamos los puntos
XYZ_RGB_HSV=zeros(length(alfa),9);
XYZ_RGB_HSV(:,1:3)=P(:,1:3); % las coordenadas
XYZ_RGB_HSV(:,7:9)=planos; % las normales
XYZ_RGB_HSV(:,4:6)=floor(rgb(:,1:3)); % los colores, que los paso a RGB256
handles.data.polos_estereo_cartesianas_HSV=hsv2rgb(HSV);
handles.data.XYZ_RGB_HSV=XYZ_RGB_HSV;

% Uso o no del Computer Vision Toolbox de MATLAB
version=ver;
toolboxes={version.Name};
uso=length(find(contains(toolboxes,'Computer Vision Toolbox')==1));
if uso==1
    if str2double(getfield(version,{find(contains(toolboxes,'Computer Vision Toolbox')==1)},'Version'))>=6.2
        % Ya puedo generar el archivo de nube de MATLAB
        ptCloud_HSV=pointCloud(P(:,1:3));
        ptCloud_HSV.Normal=planos;
        ptCloud_HSV.Color=uint8(rgb);
        handles.data.ptCloud_HSV=ptCloud_HSV;
        % tengo que generar los colores
        ptCloud_RGB=pointCloud(P(:,1:3));
        % Hay que generar los colores por familias
        % comprobamos si hay alguna familia asignada
        if max(puntos_ppalasignados(:,4))>0
            I=find(puntos_ppalasignados(:,4)>0);
            puntos_ppalasignados=puntos_ppalasignados(I,:);
        end
        % Genero los colores seg�n la familia
        im=puntos_ppalasignados(:,4); %guardamos las familias
        % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
        n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
        im= double(im);
        im=im*255/n;
        im=uint8(im);
        rgb = ind2rgb(im,jet(255));
        % Crear nube de puntos con atributo RGB (0 a 255)
        colores=zeros(size(puntos_ppalasignados,1),3);
        colores(:,1)=reshape(round(rgb(:,:,1)*255),[],1);
        colores(:,2)=reshape(round(rgb(:,:,2)*255),[],1);
        colores(:,3)=reshape(round(rgb(:,:,3)*255),[],1);
        ptCloud_RGB.Color=uint8(colores);
        % Guardo la nube de los colores
        handles.data.ptCloud_RGB=ptCloud_RGB;
    else
        % No lo tengo y no guardo nada
    end
end

% activamos la fase de an�lisis cluster
handles.pushbutton_5aclusteranalysis.Enable='on';
handles.checkbox_vnfamilia.Enable='on';
handles.text33.Enable='on';
handles.pushbutton_save_txtfam.Enable='on';
tiempoempleado=floor(toc);
% guardo la informaci�n en el log
a = handles.listbox_log.String;
t= now;
DateString = datestr(t);
S2 = [DateString, ' - Ppal poles assignment to each point, cone angle from the axis to the generatrix: ',num2str(cone),'. N of points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' seconds'];
S = strvcat(a,S2)  ;
handles.listbox_log.String=S;
% fijo la vista del listbox en la �ltima entrada
[N,~]=size(a); % a es el n�mero de entradas antes de meter estas
N = N+1;
handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
handles.data.log = S;
guidata(hObject,handles)

% --- Executes on button press in pushbutton_5aclusteranalysis.
function pushbutton_5aclusteranalysis_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_5aclusteranalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% c�lculo de los cl�sters sin m�nimo de puntos por cluster. Eso se asigna
% con el editor de cl�sters
tic % para tener el tiempo que tardo en hacer el an�lisis cluster, se pondr� en el log
% guardo los datos con los que he calculado los clusters
ppcluster=4; % Es el n�mero m�nimo de puntos que tienen que tener un cluster para ser considerado como tal
% lo dejamos en 0 porque posteriormente se filtran
handles.data.ppcluster=ppcluster;
puntos_ppalasignados=handles.data.puntos_ppalasignados;
planos_pples=handles.data.planos_pples;
vnfamilia=handles.checkbox_vnfamilia.Value; handles.data.vnfamilia = vnfamilia;
ksigmas=str2double(handles.box_ksigmas.String); handles.data.ksigmas = ksigmas;
[ puntos_familia_cluster_fullclusters, familia_cluster_plano_fullclusters ] = f_ppal2cluster_v09( puntos_ppalasignados, planos_pples, ppcluster,vnfamilia); 
% Guardamos en las handles la clasificaci�n con todos los clusters
% la salida es con todos los clusters sin filtrar, luego los guardamos en
% unos handles para utilizarlos siempre
handles.data.puntos_familia_cluster_fullclusters=puntos_familia_cluster_fullclusters;
handles.data.familia_cluster_plano_fullclusters=familia_cluster_plano_fullclusters;
% a partir de aqu�, utilizamos siempre estas dos salidas, que se ir�n
% modificando al editar el n�mero m�nimo de puntos por cluster
handles.data.puntos_familia_cluster=puntos_familia_cluster_fullclusters;
handles.data.familia_cluster_plano=familia_cluster_plano_fullclusters;
% Adem�s, hay que dejar las variables en el workspace local para seguir
% trabajando
% puntos_familia_cluster=puntos_familia_cluster_fullclusters;
familia_cluster_plano=familia_cluster_plano_fullclusters;
handles.uitable_familiaclusterplano.Enable='on';
handles.uitable_familiaclusterplano.Data=familia_cluster_plano;
% activo la edici�n de clusters
handles.pushbutton_51clustereditor.Enable='on';
handles.pushbutton_52restartclusters.Enable='on';
handles.pushbutton_5bmargeclusters.Enable='on';
handles.box_ksigmas.Enable='on';
handles.text34.Enable='on';
% set(handles.popupmenu_save_output.Enable='on';
handles.pushbutton_save_txt_all.Enable='on';
% calculo el n�mero de puntos tras el an�lisis cluster
[npuntos,~]=size(puntos_familia_cluster_fullclusters);
set(handles.text_npuntos,'String',num2str(npuntos));
tiempoempleado=floor(toc);
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    if vnfamilia ==1
        % S3 = ['Cl`s planes are oriented with its ppal pole normal vector, cl are merged with ksigmas = ',num2str(ksigmas)];
        S3 = 'Cl`s planes are oriented with its ppal pole normal vector.';
    else
        S3 = 'Cl`s planes are oriented with its best fit plane.';
    end
    S2 = [DateString, ' - Cluster analysis. ',S3,', n of points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' seconds'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S; 
guidata(hObject,handles)

% --- Executes on button press in pushbutton_51clustereditor.
function pushbutton_51clustereditor_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_51clustereditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo el input para tratarlo
puntos_familia_cluster=handles.data.puntos_familia_cluster;
familia_cluster_plano=handles.data.familia_cluster_plano;
puntos_familia_cluster_fullclusters=handles.data.puntos_familia_cluster_fullclusters;
familia_cluster_plano_fullclusters=handles.data.familia_cluster_plano_fullclusters;
% guardo estos dos inputs como variables globales
setappdata(0,'puntos_familia_cluster',puntos_familia_cluster);
setappdata(0,'familia_cluster_plano',familia_cluster_plano);
setappdata(0,'puntos_familia_cluster_fullclusters',puntos_familia_cluster_fullclusters);
setappdata(0,'familia_cluster_plano_fullclusters',familia_cluster_plano_fullclusters);
% llamo a la gui para editar los clusters
h = gui_clusterseditor;
waitfor(h);
% tomo las variables del workspace global y las guardo en el workspace
% local
puntos_familia_cluster=getappdata(0,'puntos_familia_cluster');
familia_cluster_plano=getappdata(0,'familia_cluster_plano');
% guardo la salida en la tabla de la gui
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano);
% guardo el output en los handles
handles.data.puntos_familia_cluster=puntos_familia_cluster;
handles.data.familia_cluster_plano=familia_cluster_plano;
% calculo el n�mero de puntos
[npuntos,~]=size(puntos_familia_cluster);
set(handles.text_npuntos,'String',num2str(npuntos));
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Cluster edited manually. Number of points: ',num2str(npuntos)];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
guidata(hObject,handles)


% --- Executes on button press in pushbutton_52restartclusters.
function pushbutton_52restartclusters_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_52restartclusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% cargo los datos
puntos_familia_cluster=handles.data.puntos_familia_cluster_fullclusters;
familia_cluster_plano=handles.data.familia_cluster_plano_fullclusters;
% guardo la situaci�n actual de los clusters en la tabla de la gui
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano);
% guardo la informaci�n en las handles
handles.data.puntos_familia_cluster=puntos_familia_cluster;
handles.data.familia_cluster_plano=familia_cluster_plano;
% calculo el n�mero de puntos
[npuntos,~]=size(puntos_familia_cluster);
set(handles.text_npuntos,'String',num2str(npuntos));
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Cluster restored without minimum number of points per cluster. N of points: ',num2str(npuntos)];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
guidata(hObject,handles)


% --- Executes on slider movement.
function slider_family_Callback(hObject, ~, handles)
% hObject    handle to slider_family (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    A=handles.data.puntos_familia_cluster; % cargamos la matriz calculada
    Ifamilias=unique(A(:,4),'sorted'); % �ndices de las familias
    familia=Ifamilias(floor((get(hObject,'Value'))));
    set(handles.text_family,'String',familia);
    B=A(A(:,4)==familia,:); %puntos que pertenecen a la familia seleccionada
    maxcluster=max(B(:,5));
    set(handles.slider_cluster,'Enable','on','Min',0,'Max',maxcluster,'Value',0,'SliderStep',[1 1]/maxcluster);
    % dibujamos para esa familia todos los clusters
    x=B(:,1); y=B(:,2); z=B(:,3); c=B(:,5);
    popup=handles.checkbox_popup_axes11.Value;

    handles.data.puntos_familia_cluster_filtradofamilia=B;
    handles.data.puntos_familia_cluster_filtrado=B;
    guidata(hObject,handles)
catch error
    errordlg(['Error: ' error.identifier]);

end

% --- Executes on slider movement.
function slider_cluster_Callback(hObject, ~, handles)
% hObject    handle to slider_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
B=handles.data.puntos_familia_cluster_filtradofamilia;
cluster=floor((get(hObject,'Value')));
set(handles.text_cluster,'String',cluster);
if cluster==0
    C=B;
    x=C(:,1); y=C(:,2); z=C(:,3); c=C(:,5);
else
    % I=find(B(:,5)==cluster);
    C=B(B(:,5)==cluster,:);
    x=C(:,1); y=C(:,2); z=C(:,3); c=C(:,5);
end
popup=handles.checkbox_popup_axes11.Value;
if popup==0
else
    h=figure;
    h.Color=[1 1 1];
    handles.text_figuretitle.String='';
    % cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
    scatter3(x,y,z,5,c);
    axis('equal') ,xlabel('axis X'),ylabel('axis Y'),zlabel('axis Z');
end
handles.data.puntos_familia_cluster_filtrado=C;
guidata(hObject,handles)



function box_artefacto_a_Callback(hObject, ~, handles)
% hObject    handle to box_artefacto_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_artefacto_a as text
%        str2double(get(hObject,'String')) returns contents of box_artefacto_a as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if valor<=0 
    errordlg('El valor debe ser positivo','Error');
    set(handles.box_artefacto_a,'String','5')
end
% Save the new density value
handles.artefacto.a = valor;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function box_artefacto_a_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_artefacto_b_Callback(hObject, ~, handles)
% hObject    handle to box_artefacto_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_artefacto_b as text
%        str2double(get(hObject,'String')) returns contents of box_artefacto_b as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if valor<=0 
    errordlg('El valor debe ser positivo','Error');
    set(handles.box_artefacto_b,'String','10')
end
% Save the new density value
handles.artefacto.b = valor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_artefacto_b_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_artefacto_c_Callback(hObject, ~, handles)
% hObject    handle to box_artefacto_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_artefacto_c as text
%        str2double(get(hObject,'String')) returns contents of box_artefacto_c as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if valor<=0 
    errordlg('El valor debe ser positivo','Error');
    set(handles.box_artefacto_c,'String','10')
end
% Save the new density value
handles.artefacto.c = valor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_artefacto_c_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function box_artefacto_n_Callback(hObject, ~, handles)
% hObject    handle to box_artefacto_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_artefacto_n as text
%        str2double(get(hObject,'String')) returns contents of box_artefacto_n as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
test = valor - floor(valor);
if valor<=0 || test~=0
    errordlg('N debe ser un entero positivo','Error');
    set(handles.box_artefacto_n,'String','6')
end
% Save the new density value
handles.artefacto.n = valor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_artefacto_n_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function box_artefacto_inc_Callback(hObject, ~, handles)
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if valor<=0 
    errordlg('El valor debe ser positivo','Error');
    set(handles.box_artefacto_inc,'String','0.25')
end
% Save the new density value
handles.artefacto.inc = valor;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_artefacto_inc_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_inc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_artefacto_error_Callback(hObject, ~, handles)
% hObject    handle to box_artefacto_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_artefacto_error as text
%        str2double(get(hObject,'String')) returns contents of box_artefacto_error as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if valor<=0 
    errordlg('El valor debe ser positivo','Error');
    set(handles.box_artefacto_error,'String','5')
end
% Save the new density value
handles.artefacto.error = valor;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function box_artefacto_error_CreateFcn(hObject, ~, ~)
% hObject    handle to box_artefacto_error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu_createartefact.
function popupmenu_createartefact_Callback(hObject, ~, handles)
% hObject    handle to popupmenu_createartefact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_createartefact contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_createartefact

str=get(hObject,'String');
val=get(hObject,'Value');
P=[0 0 0];
a = str2double(handles.box_artefacto_a.String);
b = str2double(handles.box_artefacto_b.String);
c = str2double(handles.box_artefacto_c.String);
n = str2double(handles.box_artefacto_n.String);
inc = str2double(handles.box_artefacto_inc.String);
error = str2double(handles.box_artefacto_error.String);
switch str{val}
    case 'cylinder'
        P= CreaCilindro_v02( a, b, inc, error);
        handles.data.P = P;
        handles.data.filename='Cylinder';
        dlmwrite('Cylinder_3DPC.txt',P, 'delimiter', '\t');
    case 'cone'
        P= CreaCono( a, b, inc, error);
        handles.data.P = P;
        handles.data.filename='Cone';
        dlmwrite('Cone_3DPC.txt',P, 'delimiter', '\t');
    case 'hexahedron'
        P= CreaHexaedro_v02( a, b, c, inc, error);
        handles.data.P = P;
        handles.data.filename='Hexahedron';
        dlmwrite('Hexahedron_3DPC.txt',P, 'delimiter', '\t');
    case 'polyhedron'
        P= CreaPoliedro( a, b, n, inc, error);
        handles.data.P = P;
        handles.data.filename='Polyhedron';
        dlmwrite('Polyhedron.txt',P, 'delimiter', '\t');
    case 'tetrahedron'
        P = CreaTetraedro( a, b, inc, error);
        handles.data.P = P;
        handles.data.filename='Tetrahedron';
        dlmwrite('Tetrahedron_3DPC.txt',P, 'delimiter', '\t');
end
handles.pushbutton_scatterpoints.Enable='on';
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_createartefact_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu_createartefact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_scatterpoints.
function pushbutton_scatterpoints_Callback(~, ~, handles)
% hObject    handle to pushbutton_scatterpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
P=handles.data.P;
handles.text_figuretitle.String='Loaded Points 3D View';
cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
scatter3(handles.axes_11,P(:,1),P(:,2),P(:,3),5,P(:,3));
axis(handles.axes_11,'equal') ,xlabel(handles.axes_11,'eje X'),ylabel(handles.axes_11,'eje Y'),zlabel(handles.axes_11,'eje Z');
% activamola preparaci�n de planos
    handles.pushbutton_2setupplanes.Enable='on';
    handles.pushbutton_2preparaTIN_fast.Enable='on';
    handles.text_ncercanos.Enable='on';
    handles.text_tolerancia.Enable='on';
    handles.box_nneighbours.Enable='on';
    handles.box_tolerancia.Enable='on';
% activamos el salvado de la base de datos
    handles.menu_saveddbb.Enable='on';
% establecemos el n�mero de puntos
[npuntos,~]=size(P);
handles.text_npuntos.Visible='on';
handles.text_npuntos.String=npuntos;
handles.text_label_npuntos.Visible='on';
% activamos el bot�n de representar de nuevo
handles.pushbutton_plot3dpoints.Enable='on';


function box_nneighbours_Callback(hObject, ~, handles)
% hObject    handle to box_nneighbours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_nneighbours as text
%        str2double(get(hObject,'String')) returns contents of box_nneighbours as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', '30');
    errordlg('Debe introducir un n�mero','Error');
else
    test = valor - floor(valor);
    if valor<0 || test~=0 || valor<=3
        errordlg('El valor debe ser entero positivo >=4','Error');
        set(handles.box_nneighbours,'String','30')
    end
    % Save the new density value
    % handles.box_nneighbours = valor;
    % guidata(hObject,handles)
end


% --- Executes during object creation, after setting all properties.
function box_nneighbours_CreateFcn(hObject, ~, ~)
% hObject    handle to box_nneighbours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_tolerancia_Callback(hObject, ~, handles)
% hObject    handle to box_tolerancia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_tolerancia as text
%        str2double(get(hObject,'String')) returns contents of box_tolerancia as a double
valor = str2double(get(hObject, 'String'));
if isnan(valor)
    set(hObject, 'String', '0.20');
    errordlg('Debe introducir un n�mero','Error');
else
    if valor<0 || valor>1
        errordlg('El valor debe ser positivo entre 0 y 1','Error');
        set(handles.box_tolerancia,'String','0.20')
    end
    % Save the new density value
    % handles.box_tolerancia = valor;
    % guidata(hObject,handles)
end

% --- Executes during object creation, after setting all properties.
function box_tolerancia_CreateFcn(hObject, ~, ~)
% hObject    handle to box_tolerancia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_nsec_Callback(hObject, ~, handles)
% hObject    handle to box_nsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_nsec as text
%        str2double(get(hObject,'String')) returns contents of box_nsec as a double
nsec = str2double(get(hObject, 'String'));
if isnan(nsec)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new density value
handles.data.npb = nsec;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_nsec_CreateFcn(hObject, ~, ~)
% hObject    handle to box_nsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function box_angulovpples_Callback(hObject, ~, handles)
% hObject    handle to box_angulovpples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_angulovpples as text
%        str2double(get(hObject,'String')) returns contents of box_angulovpples as a double
angulovpples = str2double(get(hObject, 'String'));
if isnan(angulovpples)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new density value
handles.data.angulovpples = angulovpples;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_angulovpples_CreateFcn(hObject, ~, ~)
% hObject    handle to box_angulovpples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
nbins=str2double(get(hObject,'Value'));
set(handles.box_nsec,'String',nbins);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_nsec_Callback(hObject, ~, handles)
% hObject    handle to slider_nsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
nbins=2^((get(hObject,'Value'))*10);
set(handles.box_nsec,'String',nbins);

% --- Executes during object creation, after setting all properties.
function slider_nsec_CreateFcn(hObject, ~, ~)
% hObject    handle to slider_nsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_cargapuntos.
function checkbox_cargapuntos_Callback(hObject, ~, handles)
% hObject    handle to checkbox_cargapuntos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    checkbox=get(hObject,'Value');
    switch checkbox
        case 1
            handles.pushbutton_1loadP.Enable='on';
            handles.checkbox_generaartefacto.Enable='off';
            handles.text2.Enable='off';
            handles.text3.Enable='off';
            handles.text4.Enable='off';
            handles.text5.Enable='off';
            handles.text6.Enable='off';
            handles.text7.Enable='off';
            handles.box_artefacto_a.Enable='off';
            handles.box_artefacto_b.Enable='off';
            handles.box_artefacto_c.Enable='off';
            handles.box_artefacto_n.Enable='off';
            handles.box_artefacto_inc.Enable='off';
            handles.box_artefacto_error.Enable='off';
            handles.popupmenu_createartefact.Enable='off';
            handles.checkbox_generaartefacto.Enable='off';
        case 0
            handles.pushbutton_1loadP.Enable='off';
            handles.checkbox_generaartefacto.Enable='on';
    end
catch error
    errordlg(['Ha habido un error: ' error.identifier]);
end

% Hint: get(hObject,'Value') returns toggle state of checkbox_cargapuntos


% --- Executes on button press in checkbox_generaartefacto.
function checkbox_generaartefacto_Callback(hObject, ~, handles)
% hObject    handle to checkbox_generaartefacto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkbox=get(hObject,'Value');
switch checkbox
    case 1
        handles.checkbox_cargapuntos.Enable='off';
        handles.pushbutton_1loadP.Enable='off';
        handles.text2.Enable='on';
        handles.text3.Enable='on';
        handles.text4.Enable='on';
        handles.text5.Enable='on';
        handles.text6.Enable='on';
        handles.text7.Enable='on';
        handles.box_artefacto_a.Enable='on';
        handles.box_artefacto_b.Enable='on';
        handles.box_artefacto_c.Enable='on';
        handles.box_artefacto_n.Enable='on';
        handles.box_artefacto_inc.Enable='on';
        handles.box_artefacto_error.Enable='on';
        handles.popupmenu_createartefact.Enable='on';
    case 0
        handles.checkbox_cargapuntos.Enable='on';
        handles.text2.Enable='off';
        handles.text3.Enable='off';
        handles.text4.Enable='off';
        handles.text5.Enable='off';
        handles.text6.Enable='off';
        handles.text7.Enable='off';
        handles.box_artefacto_a.Enable='off';
        handles.box_artefacto_b.Enable='off';
        handles.box_artefacto_c.Enable='off';
        handles.box_artefacto_n.Enable='off';
        handles.box_artefacto_inc.Enable='off';
        handles.box_artefacto_error.Enable='off';
        handles.popupmenu_createartefact.Enable='off';
end
% Hint: get(hObject,'Value') returns toggle state of checkbox_generaartefacto


% --------------------------------------------------------------------
function menu_loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.txt','Select the 3D point cloud file. Tip: it must be an ASCII file with XYZ info.');
    handles.data.pathname = pathname;
    [~,nombrearchivo,~] = fileparts(filename);
    handles.data.filename = nombrearchivo;
    P=load(strcat(pathname, filename));
    % Por si acaso, guardo las columnas de la 4 al final
    [~,ncolumnas]=size(P);
    if ncolumnas >=4
        handles.data.P_extradata=P(:,ncolumnas:4);
    end
    % limpio y me quedo s�lo con las coordenadas, las tres primeras
    % columnas
    P=P(:,1:3);
    handles.data.P = P;
    % activamos el bot�n de scatter para ver qu� ha cargado
    handles.pushbutton_scatterpoints.Enable='on';
    % activamola preparaci�n de planos
    handles.pushbutton_2setupplanes.Enable='on';
    handles.pushbutton_2preparaTIN_fast.Enable='on';
    handles.text_ncercanos.Enable='on';
    handles.text_tolerancia.Enable='on';
    handles.box_nneighbours.Enable='on';
    handles.box_tolerancia.Enable='on';
    % activamos el salvado de la base de datos
    handles.menu_saveddbb.Enable='on';
    % activamos el bot�n de representar de nuevo
    handles.pushbutton_plot3dpoints.Enable='on';
    % establecemos el n�mero de puntos
    [npuntos,~]=size(P);
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
    % guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Point cloud loaded. File: ',filename,' number of points: ',num2str(npuntos)];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
catch error
    errordlg(['Error: ' error.identifier]);

end

guidata(hObject,handles)


function menu_loadxyznormals_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.txt','Select the 3DPC that includes the normals: XYZ-NxNyNz.');
    handles.data.pathname = pathname;
    [~,nombrearchivo,~] = fileparts(filename);
    handles.data.filename = nombrearchivo;
    P=load(strcat(pathname, filename));
    % Por si acaso, guardo las columnas de la 4 al final
    [~,ncolumnas]=size(P);
	% Guardo las normales que est�n en las tres �ltimas columnas
	[npuntos,columnas]=size(P);
	planos=P(:,columnas-2:columnas); 
    % compruebo que los planos est�n bien calculados
    modulos=(planos(:,1).^2+planos(:,2).^2+planos(:,3).^2).^0.5;
    % elimino los puntos con normales nulas
    I=find(modulos~=0);
    planos=planos(I,:); P=P(I,:);
    if ncolumnas >=4
        handles.data.P_extradata=P(:,ncolumnas:4);
    end
    % limpio y me quedo s�lo con las coordenadas, las tres primeras
    % columnas
    P=P(:,1:3);
    handles.data.P = P;
    % activamos el bot�n de scatter para ver qu� ha cargado
    handles.pushbutton_scatterpoints.Enable='on';
    % activamola preparaci�n de planos
    handles.pushbutton_2setupplanes.Enable='on';
    handles.pushbutton_2preparaTIN_fast.Enable='on';
    handles.text_ncercanos.Enable='on';
    handles.text_tolerancia.Enable='on';
    handles.box_nneighbours.Enable='on';
    handles.box_tolerancia.Enable='on';
    % activamos el salvado de la base de datos
    handles.menu_saveddbb.Enable='on';
    % activamos el bot�n de representar de nuevo
    handles.pushbutton_plot3dpoints.Enable='on';

    % establecemos el n�mero de puntos
    [npuntos,~]=size(P);
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
    % guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Point cloud with normals loaded. File: ',filename,' number of points: ',num2str(npuntos)];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
catch error
    errordlg(['Error: ' error.identifier]);

end

% Ahora preparo el an�lisis estad�stico
tic

% guardo los datos con los que calculamos

    % establecemos el n�mero de puntos en la pantalla
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
    handles.data.P=P;
    handles.data.planos=planos;
% convertimos los planos a la proyecci�n estereogr�fica
    [w,b]=vnor2vbuz_v02(planos(:,1),planos(:,2),planos(:,3));
    planos_estereo=[w,b];
    handles.data.planos_estereo=planos_estereo;
% preparamos la representaci�n de los planos
    [~ , polos_estereo_cartesianas]=prepara_representa(planos_estereo);
    handles.data.polos_estereo_cartesianas=polos_estereo_cartesianas;
% activamos el c�lculo de planos (siguiente paso)
    handles.pushbutton_3statanalysis.Enable='on';
    handles.text_nsec.Enable='on';
    handles.text_angulovpples.Enable='on';
    handles.slider_nsec.Enable='on';
    handles.box_nsec.Enable='on';
    handles.box_angulovpples.Enable='on';
    handles.text_box_maxpples.Enable='on';
    handles.box_maxpples.Enable='on';

    % establecemos el n�mero de puntos
    [npuntos,~]=size(P);
    handles.text_npuntos.Visible='on';
    handles.text_npuntos.String=npuntos;
    handles.text_label_npuntos.Visible='on';
% activamos el bot�n de representar los polos en stereo
    handles.pushbutton_plotstereopoles.Enable='on';
tiempoempleado=floor(toc);
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Point cloud with normals loaded. File: ',filename,' number of points: ',num2str(npuntos)];
    S = strvcat(a,S2);
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;

guidata(hObject,handles)


% --------------------------------------------------------------------
function menu_loadddbb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadddbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.mat','Abra el archivo de datos');
S= load(strcat(pathname,filename));
aux=S.aux;
data=S.data;
gui=S.gui;
% Ahora nos quedamos s�lo con el nombre del archivo
[~,filename,~] = fileparts(filename);
% Pongo el nombre del archivo en la ventana
% handles.figure_main1.Name.String=['Discontinuity Set Extractor - ',filename]);

% pasamos a las handles los grupos de datos guardados
handles.data=data;
% a�adimos el pathname y el filename
handles.data.filename = filename;
handles.data.pathname = pathname;
handles.gui=gui;
handles.aux=aux;
% separamos a cada variable los datos de las handles
npuntos=handles.aux.npuntos;
planos_pples=handles.aux.planos_pples;
familia_cluster_plano=handles.aux.familia_cluster_plano;
%slider_cluster=handles.aux.slider_cluster;
%slider_familiy=handles.aux.slider_familiy;
phase1=handles.gui.phase1;
phase2=handles.gui.phase2;
phase3=handles.gui.phase3;
phase4=handles.gui.phase4;
phase5=handles.gui.phase5;
% Activaci�n de los botones y cuadros
% botones fase 1: preparaci�n de los puntos
handles.pushbutton_scatterpoints.Enable=phase1;
handles.pushbutton_plot3dpoints.Enable=phase1;
handles.text_label_npuntos.Visible=phase1;
handles.text_label_npuntos.Enable=phase1;
handles.text_npuntos.String=npuntos;
handles.text_npuntos.Visible=phase1;
handles.text_npuntos.Enable=phase1;
% fase 2: preparaci�n de los planos
handles.pushbutton_2setupplanes.Enable=phase2;
handles.text_ncercanos.Enable=phase2;
handles.box_nneighbours.Enable=phase2;
handles.text_tolerancia.Enable=phase2;
handles.box_tolerancia.Enable=phase2;
handles.pushbutton_plotstereopoles.Enable=phase2;
% fase 3: c�lculo de planos principales
handles.pushbutton_3statanalysis.Enable=phase3;
handles.pushbutton_31editppalpoles.Enable=phase3;
handles.text_nsec.Enable=phase3;
handles.slider_nsec.Enable=phase3;
handles.box_nsec.Enable=phase3;
handles.text_angulovpples.Enable=phase3;
handles.box_angulovpples.Enable=phase3;
handles.text_box_maxpples.Enable=phase3;
handles.box_maxpples.Enable=phase3;
handles.pushbutton_plotdensitypoles.Enable=phase3;
handles.uitable_principalplanes.Visible=phase3;
handles.uitable_principalplanes.Enable=phase3;
handles.pushbutton_plotdensitypoles.Enable=phase3;
% fase 4: asignaci�n de planos principales a puntos
handles.pushbutton_4ppalpolesassignment.Enable=phase4;
handles.text_box_cone.Enable=phase4;
handles.box_cone.Enable=phase4;
handles.pushbutton_plot3dpointsppal.Enable=phase4;
handles.pushbutton_plotstereopolesppal.Enable=phase4;
handles.pushbutton_save_txtfam.Enable=phase4;
% fase 5: an�lisis cluster y determinaci�n de planos
handles.pushbutton_5aclusteranalysis.Enable=phase5;
handles.pushbutton_51clustereditor.Enable=phase5;
handles.pushbutton_52restartclusters.Enable=phase5;
handles.pushbutton_5bmargeclusters.Enable=phase5;

handles.text33.Enable=phase5;
handles.text34.Enable=phase5;
handles.checkbox_vnfamilia.Enable=phase5;
handles.box_ksigmas.Enable=phase5;

handles.uitable_familiaclusterplano.Visible=phase5;
handles.uitable_familiaclusterplano.Enable=phase5;

handles.pushbutton_save_txt_all.Enable=phase5;

% guardamos los valores de los boxes
handles.box_nneighbours.String=handles.data.npb;
handles.box_tolerancia.String=handles.data.tolerancia;
handles.box_nsec.String=handles.data.nsec;
handles.box_angulovpples.String=handles.data.angulovpples;
handles.box_maxpples.String=handles.data.maxpples;
handles.box_cone.String=handles.data.cone;

% establecemos algunos handles
handles.uitable_principalplanes.Data=planos_pples;
handles.uitable_familiaclusterplano.Data=familia_cluster_plano;

% activamos el salvado de la base de datos
handles.menu_saveddbb.Enable='on';

% Recupero el listbox lob
if isfield(handles.data,'log')
    a = handles.data.log;
    % guardo la informaci�n en el log
    % a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Database recovered'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
else
    t= now;
    DateString = datestr(t);
    S = [DateString, ' - Database recovered'];
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    handles.listbox_log.ListboxTop= 1; % vista de la �ltima l�nea
    handles.data.log = S;
end
% por compatibilidad compruebo si el nombre del archivo existe
if isfield(handles.data,'filename')
    % existe y no hago nada
else
    % no existe y le pongo el nombre del ddbb
    handles.data.filename = filename;
    handles.data.pathname = pathname;
end

% Update handles structue

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_saveddbb_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveddbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.gui.phase1=handles.pushbutton_scatterpoints.Enable;
handles.gui.phase2=handles.pushbutton_2setupplanes.Enable;
handles.gui.phase3=handles.pushbutton_3statanalysis.Enable;
handles.gui.phase4=handles.pushbutton_4ppalpolesassignment.Enable;
handles.gui.phase5=handles.pushbutton_5aclusteranalysis.Enable;
%otros handles a guardar
handles.aux.npuntos=handles.text_npuntos.String;
handles.aux.planos_pples=handles.uitable_principalplanes.Data;
handles.aux.familia_cluster_plano=handles.uitable_familiaclusterplano.Data';
%handles.aux.slider_cluster=handles.slider_cluster);
%handles.aux.slider_familiy=handles.slider_family);
handles.aux.text_npuntos = handles.text_npuntos;
% guardamos los valores de los boxes
handles.data.npb=handles.box_nneighbours.String;
handles.data.tolerancia=handles.box_tolerancia.String;
handles.data.nsec=handles.box_nsec.String;
handles.data.angulovpples=handles.box_angulovpples.String;
handles.data.maxpples=handles.box_maxpples.String;
handles.data.cone=handles.box_cone.String;
% handles.data.ppcluster=handles.box_pointspercluster.String;
% Guardo la info en el listbox_log y la meto en la ddbb
% guardo la informaci�n en el log
a = handles.listbox_log.String;
t= now;
DateString = datestr(t);
S2 = [DateString, ' - The database was saved.'];
S = strvcat(a,S2)  ;
handles.listbox_log.String=S;
% fijo la vista del listbox en la �ltima entrada
[N,~]=size(a); % a es el n�mero de entradas antes de meter estas
N = N+1;
handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
handles.data.log = S;

% preparamos las handles a guardar
data = handles.data; 
gui = handles.gui; 
aux=handles.aux; 
% box=handles.box;
if isfield(handles.data,'pathname') & handles.data.pathname ~= 0
    pathname = handles.data.pathname;
    filename = handles.data.filename;
    % [filename, pathname] = uiputfile([pathname,'*.mat'], 'Save the ddbb in the file:');
    [filename, pathname] = uiputfile('*.mat', 'Save the ddbb in the file:',[pathname,filename,'.mat']);
else
    [filename, pathname] = uiputfile(['*.mat'],'Save the ddbb in the file:');
end
% guardo en las handles el nombre del archivo y el path
handles.data.pathname = pathname;
handles.data.filename = filename;
save(strcat(pathname,filename),'data','gui','aux');

% guardo las handles
guidata(hObject,handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
about;



% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure_main1);

% --- Executes on button press in pushbutton_clear2.
function pushbutton_clear2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% limpiamos las handles
try
% handles = rmfield(handles, 'data'); %esto no limpia!!!
% hay que desactivar todos los botones y textboxes
handles.checkbox_cargapuntos.Value=0;
handles.checkbox_cargapuntos.Enable='on';
handles.checkbox_generaartefacto.Value=0;
handles.checkbox_generaartefacto.Enable='on';
handles.pushbutton_scatterpoints.Enable='off';
handles.text2.Enable='off';
handles.text3.Enable='off';
handles.text4.Enable='off';
handles.text5.Enable='off';
handles.text6.Enable='off';
handles.text7.Enable='off';
handles.box_artefacto_a.Enable='off';
handles.box_artefacto_b.Enable='off';
handles.box_artefacto_c.Enable='off';
handles.box_artefacto_n.Enable='off';
handles.box_artefacto_inc.Enable='off';
handles.box_artefacto_error.Enable='off';
handles.popupmenu_createartefact.Enable='off';
handles.pushbutton_1loadP.Enable='off';
handles.text_label_npuntos.Visible='off';
handles.text_npuntos.Visible='off';
handles.pushbutton_2setupplanes.Enable='off';
handles.pushbutton_2preparaTIN_fast.Enable='off';
handles.text_ncercanos.Enable='off';
handles.text_tolerancia.Enable='off';
handles.box_nneighbours.Enable='off';
handles.box_tolerancia.Enable='off';
handles.pushbutton_3statanalysis.Enable='off';
handles.pushbutton_31editppalpoles.Enable='off';
handles.text_nsec.Enable='off';
handles.text_angulovpples.Enable='off';
handles.slider_nsec.Enable='off';
handles.box_nsec.Enable='off';
handles.box_angulovpples.Enable='off';
handles.uitable_principalplanes.Enable='off';
handles.pushbutton_4ppalpolesassignment.Enable='off';
handles.text_box_cone.Enable='off';
handles.box_cone.Enable='off';
handles.pushbutton_plotstereopolesppal.Enable='off';
handles.pushbutton_plot3dpointsppal.Enable='off';
handles.pushbutton_plotdensitypoles.Enable='off';
handles.pushbutton_plotstereopoles.Enable='off';
handles.pushbutton_plot3dpoints.Enable='off';
handles.text_box_maxpples.Enable='off';
handles.box_maxpples.Enable='off';
handles.pushbutton_5aclusteranalysis.Enable='off';
handles.pushbutton_51clustereditor.Enable='off';
handles.pushbutton_52restartclusters.Enable='off';
handles.text33.Enable='off';
handles.text34.Enable='off';
handles.checkbox_vnfamilia.Enable='off';
handles.box_ksigmas.Enable='off';
handles.uitable_familiaclusterplano.Enable='off';
handles.pushbutton_save_txt_all.Enable='off';
handles.pushbutton_save_txtfam.Enable='off';

% limpiamos las figuras
cla(handles.axes_11,'reset')
handles.text_figuretitle.String='';

clear handles.data handles.aux handles.gui
clear -regexp ^handles.uipanel ^handles.text ^handles.pushbutton ^handles.slide ^handles.box ^handles.check
% limpio el listbox log
t= now;
DateString = datestr(t);
S = strvcat([DateString, ' - Full data cleaned.'],[DateString, ' - Waiting for orders.']); % tiene que ser un string
handles.listbox_log.String=S;

% limpiamos todas las variables
catch error
    errordlg(['Error: ' error.identifier]);

end


% --- Executes on button press in pushbutton_plot3dpoints.
function pushbutton_plot3dpoints_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot3dpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup=handles.checkbox_popup_axes11.Value;
P=handles.data.P;
if popup==0
    cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
    scatter3(handles.axes_11,P(:,1),P(:,2),P(:,3),10,P(:,3),'filled');
    title(handles.axes_11,['3D Points: ',num2str(length(P)),' points']);
    axis(handles.axes_11,'equal') ,xlabel(handles.axes_11,'axis X'),ylabel(handles.axes_11,'axis Y'),zlabel(handles.axes_11,'axis Z');
else
    % Uso o no del Computer Vision Toolbox de MATLAB
    version=ver;
    toolboxes={version.Name};
    uso=length(find(contains(toolboxes,'Computer Vision Toolbox')==1));
    if uso==1
        if str2double(getfield(version,{find(contains(toolboxes,'Computer Vision Toolbox')==1)},'Version'))>=6.2
            % Tengo el Toolbox para nubes de puntos y puedo usarlo
            ptCloud=pointCloud(P(:,1:3));
            h=figure;
            pcshow(ptCloud);
            h.Name='3D Point Cloud';
        else
            % No lo tengo y empleo la programaci�n antigua
            h=figure;
            h.Color=[1 1 1];
            scatter3(P(:,1),P(:,2),P(:,3),10,P(:,3),'filled');
            title(['3D Points: ',num2str(length(P)),' points']);
            axis('equal') ,xlabel('axis X'),ylabel('axis Y'),zlabel('axis Z');
        end
    end
end

% --- Executes on button press in pushbutton_plot3dpointsppal.
function pushbutton_plot3dpointsppal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot3dpointsppal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup=handles.checkbox_popup_axes11.Value;
puntos_ppalasignados=handles.data.puntos_ppalasignados;
I=find(puntos_ppalasignados(:,4)>0);
A=puntos_ppalasignados(I,:);
if popup==0
    cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
    scatter3(handles.axes_11,A(:,1),A(:,2),A(:,3),20,A(:,4),'filled');
    title(['3D Points Family assigned: ',num2str(length(A)),' points']);
    axis equal ,xlabel('axis X'),ylabel('axis Y'),zlabel('axis Z');
else
    
% Uso o no del Computer Vision Toolbox de MATLAB
version=ver;
toolboxes={version.Name};
uso=length(find(contains(toolboxes,'Computer Vision Toolbox')==1));
if uso==1
    if str2double(getfield(version,{find(contains(toolboxes,'Computer Vision Toolbox')==1)},'Version'))>=6.2
        % Tengo el Toolbox para nubes de puntos y puedo usarlo
        % Dibujo la nube
        ptCloud_HSV=handles.data.ptCloud_HSV;
        % Dibujo la falsilla para comparar
		h=figure; 
        falsilla_riquelme;
		h.Color=[1 1 1];
		axis('square','equal');
        % Nota que I son los �ndices de los puntos con clusters asignados,
		% hay que filtrar esto
        polos_x=handles.data.polos_estereo_cartesianas(I,1);
        polos_y=handles.data.polos_estereo_cartesianas(I,2);
        polos_z=zeros(size(polos_x)); 
        polos_z(:)=-0.1;
        polos_colores=handles.data.polos_estereo_cartesianas_HSV;
        scatter3(polos_x,polos_y,polos_z,[],polos_colores,'filled');
		title(['Stereographic Projection, Normal Vector Poles: ',num2str(length(polos_z)),' points']);
		xlabel('axis X'); ylabel('axis Y');
        h.Name='HSV colour scheme (dip direction - dip) of the normal vector poles';
        % Ahora dibujo la nube con HSV
        h=figure; pcshow(handles.data.ptCloud_HSV);
        h.Name='3D point cloud coloured according the HSV scheme';
        % Ahora dibujo la nube con RGB
        h=figure; pcshow(handles.data.ptCloud_RGB);
        h.Name='3D point cloud coloured using one colour for each DS';
        
    else
        h=figure; h.Color=[1 1 1];
        scatter3(A(:,1),A(:,2),A(:,3),20,A(:,4),'filled');
        title(['3D Points Family assigned: ',num2str(length(A)),' points']);
        axis equal ,xlabel('axis X'),ylabel('axis Y'),zlabel('axis Z');
    end
end

end


% --- Executes on button press in pushbutton_plotstereopoles.
function pushbutton_plotstereopoles_Callback(hObject, eventdata, handles)
% representamos los polos en estereogr�ficas en el 11
% preparamos las variables locales, a partir de las handles
popup=handles.checkbox_popup_axes11.Value;
polos_estereo_cartesianas=handles.data.polos_estereo_cartesianas;
if popup==0
    % dibujamos la plantilla de wulff
    handles.text_figuretitle.String='Stereographic Projection Normal Vector Poles';
    cla(handles.axes_11,'reset');
    % dibujamos la wulff, ahora la de Riquelme :D
    % wulff;
    falsilla_riquelme;
    axis(handles.axes_11,'square','equal');
    % scatter(handles.axes_11,polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2),calidad_tin(:,1));
    z=zeros(size(polos_estereo_cartesianas(:,1)));
    z(:,1)=-0.1;
    scatter3(handles.axes_11,polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2),z,1);
    title(['Stereographic Projection, Normal Vector Poles: ',num2str(length(polos_estereo_cartesianas)),' points']);
    xlabel(handles.axes_11,'axis X'); ylabel(handles.axes_11,'axis Y');
else
    % dibujamos la plantilla de wulff, ahora la de Riquelme :D
    h=figure;
    % wulff;
    falsilla_riquelme;
    h.Color=[1 1 1];
    axis('square','equal');
    % scatter(polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2),calidad_tin(:,1));
    z=zeros(size(polos_estereo_cartesianas(:,1)));
    z(:,1)=-0.1;
    scatter3(polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2),z,1);
    title(['Stereographic Projection, Normal Vector Poles: ',num2str(length(polos_estereo_cartesianas)),' points']);
    xlabel('axis X'); ylabel('axis Y');
end

% --- Executes on button press in pushbutton_plotdensitypoles.
function pushbutton_plotdensitypoles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotdensitypoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set up the input data
popup=handles.checkbox_popup_axes11.Value;
polos_pples_cart=handles.data.polos_pples_cart;
X=handles.data.X;
Y=handles.data.Y;
density=handles.data.density;
% representamos la salida
[kk, nc]=size(polos_pples_cart);
if nc==2
    tamanyo=1;
else
    tamanyo = 20;
end
xa=polos_pples_cart(1:kk,1)'+0.1;
xb=polos_pples_cart(1:kk,2)'+0;
if nc==2
    xc=0;
else
    xc=polos_pples_cart(1:kk,3)'+0.1;
end
% etiquetas=num2str([1:1:kk]');
maxd=max(max(density)); mind=min(min(density));
numberisolines=80; % n�mero de isolon�neas
isolines=(maxd-mind)/numberisolines;
if popup==0
    handles.text_figuretitle.String='Poles Density Plot';
    cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
    % wulff;
    falsilla_riquelme;
    scatter3(handles.axes_11,polos_pples_cart(1:kk,1),polos_pples_cart(1:kk,2),polos_pples_cart(1:kk,3),tamanyo,'filled','MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75]);
    % title(handles.axes_11,['Poles Density Plot, Principal Poles. Isolines each ',num2str(isolines)]);
    title(handles.axes_11,['Poles Density Plot, Principal Poles. Isolines each ',num2str(100/numberisolines),'%']);
    for ii=1:kk
       text(xa(ii),xb(ii),xc(ii), ['J_{',num2str(ii),'}'],'FontSize',18,'EdgeColor','k','BackgroundColor','w');
    end
    xlabel(handles.axes_11,'axis X'); ylabel(handles.axes_11,'axis Y');
    hold on; contour3(handles.axes_11,X,Y,density,numberisolines);
    axis (handles.axes_11,[-1 1 -1 1]); axis(handles.axes_11,'square','equal');
    dcm = datacursormode(gcf);
    datacursormode on;
    % Aqu� puede haber problema con el app nuevo
    set(dcm,'updatefcn',@myfunction)
else
    filename = handles.data.filename;
    h=figure('name',[filename, ' density function']);
    % wulff;
    falsilla_riquelme;
    h.Color=[1 1 1];
    hold on; contour3(X,Y,density,numberisolines); % dibuja con contornos
    axis ([-1 1 -1 1]); axis('square','equal');
    for ii=1:kk
       text(xa(ii),xb(ii),xc(ii), ['J_{',num2str(ii),'}'],'FontSize',18, ...
           'EdgeColor','k','BackgroundColor','w');
    end
    scatter3(polos_pples_cart(1:kk,1),polos_pples_cart(1:kk,2),polos_pples_cart(1:kk,3),...
        tamanyo,'filled','MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75]);
    g.Title.String=['Poles Density Plot, Principal Poles. Isolines each ',num2str(100/numberisolines),'%'];
    xlabel('axis X'); ylabel('axis Y');
    dcm = datacursormode(h);
    datacursormode on;
    set(dcm,'updatefcn',@myfunction)

end

% Primero verifico si existe el pathname
if isfield(handles.data,'pathname') & handles.data.pathname ~= 0
    % Si existe lo pongo
    pathname = handles.data.pathname;
else
    % Si no existe tomo en el que est�
    pathname = [pwd,'\'];
end
if isfield(handles.data,'filename') & handles.data.filename ~= 0
    filename = handles.data.filename;
    [~,filename,~] = fileparts(filename);
else
    filename = 'Output';
end

% Guardo la imagen
name_png = [pathname,'Density - ', filename,'.png'];
name_pdf = [pathname,'Density - ', filename,'.pdf'];
% export_fig(name, '-m2.5', '-transparent');
saveas(gcf, name_png);
saveas(gcf, name_pdf);



% --- Executes on button press in pushbutton_plotstereopolesppal.
function pushbutton_plotstereopolesppal_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotstereopolesppal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup=handles.checkbox_popup_axes11.Value;
polos_estereoppalasignados=handles.data.polos_estereoppalasignados;
A=polos_estereoppalasignados;
I=find(A(:,3)>0); 
A=A(I,:);

% polos_estereoppalasignados_limpio(I,:)=A;
% represento las estereogr�ficas
if popup==0
    handles.text_figuretitle.String='Stereographic Projection Assigned Principal Poles';
    cla(handles.axes_11,'reset');
    % wulff;
    falsilla_riquelme;
    axis(handles.axes_11,'square','equal');
    scatter(handles.axes_11,A(:,1),A(:,2),5,A(:,3));
    title(handles.axes_11,['Stereographic Projection Assigned Principal Poles: ',num2str(length(A)),' points']);
    xlabel(handles.axes_11,'X'); ylabel(handles.axes_11,'Y');
else
    h=figure;
    handles.text_figuretitle.String='';
    cla(handles.axes_11,'reset');
    % dibujamos la wulff, ahora la de Riquelme :D
    % wulff;
    falsilla_riquelme; h.Color=[1 1 1];axis('square','equal');
    scatter(A(:,1),A(:,2),5,A(:,3));
    title(['Stereographic Projection Assigned Principal Poles: ',num2str(length(A)),' points']);
    xlabel('X'); ylabel('Y');
end




function box_cone_Callback(hObject, eventdata, handles)
% hObject    handle to box_cone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_cone as text
%        str2double(get(hObject,'String')) returns contents of box_cone as a double
value = str2double(get(hObject, 'String'));
if isnan(value)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if value<=0 
    errordlg('The value must be positive','Error');
    handles.box_cone.String='30';
end
% Save the new density value
handles.data.cone = value;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_cone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_cone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_maxpples_Callback(hObject, eventdata, handles)
% hObject    handle to box_maxpples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_maxpples as text
%        str2double(get(hObject,'String')) returns contents of box_maxpples as a double
value = str2double(get(hObject, 'String'));
if isnan(value)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if value<=0 
    errordlg('The value must be integer positive','Error');
    handles.box_maxpples.String='20';
end
% Save the new density value
handles.data.maxpples = value;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_maxpples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_maxpples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    hObject.BackgroundColor='white';
end





function box_pointspercluster_Callback(hObject, eventdata, handles)
% hObject    handle to box_pointspercluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ppcluster = str2double(get(hObject, 'String'));
if isnan(ppcluster)
    hObject.String=50;
    errordlg('Input must be a number','Error');
end
% Save the new density value
handles.data.ppcluster = ppcluster;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_pointspercluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_pointspercluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    hObject.BackgroundColor='white';
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    hObject.BackgroundColor=[.9 .9 .9];
end




% --- Executes during object creation, after setting all properties.
function slider_family_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_family (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function slider_cluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_2preparaTIN_fast.
function pushbutton_2preparaTIN_fast_Callback(hObject, eventdata, handles)
% C�lculo de curvaturas sin el test de coplanaridad
tic;
P=handles.data.P;
[npuntos,~]=size(P);
npb=str2double(get(handles.box_nneighbours,'String'));
% tolerancia=str2num(get(handles.box_tolerancia,'String'));
handles.data.npb=npb;
% handles.data.tolerancia=tolerancia;
% preparamos los planos
	% Uso o no del Computer Vision Toolbox de MATLAB
	version=ver;
    toolboxes={version.Name};
    uso=length(find(contains(toolboxes,'Computer Vision Toolbox')==1));
    % En realidad, pccnormals est� siempre por lo que se puede ejecutar independientemente de su versi�n
	if uso==1
		% usamos el toolbox para calcular las normales
		ptCloud=pointCloud(P);
		planos=pcnormals(ptCloud,npb);
        tiempoempleado=floor(toc);
        % guardo la informaci�n en el log
        a = handles.listbox_log.String;
        t= now;
        DateString = datestr(t);
        S2 = [DateString, ' - Normals calculated with Computer Vision Toolbox, num of neighbours: ',num2str(npb),', n points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' s.'];
        S = strvcat(a,S2)  ;
        handles.listbox_log.String=S;
        % fijo la vista del listbox en la �ltima entrada
        [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
        N = N+1;
        handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
        handles.data.log = S;
	else
		% usamos la funci�n nuestra
		[idx, dist, ~, calidad_tin, planos]=f_preparaTIN_v03_nocoplanartest(P, npb);
		handles.data.idx = idx; % En realidad, esto no se usa despu�s
		handles.data.dist = dist; % Tampoco se usa despu�s
		handles.data.calidad_tin=calidad_tin; % No se usa
        % guardo la informaci�n en el log
        a = handles.listbox_log.String;
        t= now;
        DateString = datestr(t);
        S2 = [DateString, ' - Normals calculated without compalarity test, num of neighbours: ',num2str(npb),', n points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' s.'];
        S = strvcat(a,S2)  ;
        handles.listbox_log.String=S;
        % fijo la vista del listbox en la �ltima entrada
        [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
        N = N+1;
        handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
        handles.data.log = S;
	end
    handles.data.planos=planos; % Guardo los planos en las handles en cualquier caso
% convertimos los planos a la proyecci�n estereogr�fica
    [planos_estereo]=prepara_estereo(handles.data.planos);
    handles.data.planos_estereo=planos_estereo;
% preparamos la representaci�n de los planos
    [polos_estereo_polares, polos_estereo_cartesianas]=prepara_representa(planos_estereo);
    handles.data.polos_estereo_polares=polos_estereo_polares;
    handles.data.polos_estereo_cartesianas=polos_estereo_cartesianas;
% guardamos el n�mero de puntos final tras la preparaci�n
    % no es necesario, pues la preparaci�n r�pida no elimina ning�n punto
% representamos los polos en estereogr�ficas en el 11
    % Nota: se desactiva la representaci�n, activando el bot�n de plot
    % pushbutton_plotstereopoles_Callback(hObject, eventdata, handles)
% activamos el c�lculo de planos (siguiente paso)
    handles.pushbutton_3statanalysis.Enable='on';
    handles.text_nsec.Enable='on';
    handles.text_angulovpples.Enable='on';
    handles.slider_nsec.Enable='on';
    handles.box_nsec.Enable='on';
    handles.box_angulovpples.Enable='on';
    handles.text_box_maxpples.Enable='on';
    handles.box_maxpples.Enable='on';

% activamos el bot�n de representar los polos en stereo
    handles.pushbutton_plotstereopoles.Enable='on';
guidata(hObject,handles)


% --- Executes on button press in pushbutton_save_txt_output.
function pushbutton_save_txt_output_Callback(hObject, eventdata, handles)
try
    familia=str2num(get(handles.text_family,'String')); cluster=str2num(get(handles.text_cluster,'String'));
    val=handles.saveoutput.val;
    pathname = handles.data.pathname;
    switch val
        case 1 %guardamos las todas las coordenadas y el rgb seg�n la familia que le toque
            [np,~]=size(handles.data.puntos_familia_cluster);
            A=handles.data.puntos_familia_cluster(:,1:4);
            % guardamos un archivo para el polyworks
            XYZ_RGB=zeros(np,6);
            XYZ_RGB=A(:,1:3);
            im=A(:,4); %guardamos las familias
            % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
            n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
            im= double(im);
            im=im*255/n;
            im=uint8(im);
            rgb = ind2rgb(im,jet(255));
            %rgb = ind2rgb(gray2ind(im,n),jet(255));
            % Crear nube de puntos con atributo RGB (0 a 255)
            R=round(rgb(:,:,1)*255);
            G=round(rgb(:,:,2)*255);
            B=round(rgb(:,:,3)*255);
            XYZ_RGB(:,4)=reshape(R,[],1);
            XYZ_RGB(:,5)=reshape(G,[],1);
            XYZ_RGB(:,6)=reshape(B,[],1);
            % exportar nube de puntos
            dlmwrite([pathname, 'XYZ-RGB-js.txt'],XYZ_RGB, 'delimiter', '\t');
        case 2 %guardamos las coordenadas y el rgb del cluster seleccionado
            
            PFC=handles.data.puntos_familia_cluster; % cargamos la matriz calculada
            Ifamilias=unique(PFC(:,4),'sorted'); % �ndices de las familias
            [nf,~]=size(Ifamilias);
            for i=1:nf
                familia=Ifamilias(i);
                A=PFC(find(PFC(:,4)==familia),:); %puntos que pertenecen a la familia seleccionada
                % guardamos el archivo para poder abrirlo en polyworks
                [np,~]=size(A);
                XYZ_RGB=zeros(np,6);
                XYZ_RGB=A(:,1:3);
                im=A(:,5); %guardamos los clusters
                % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
                n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
                im= double(im);
                im=im*255/n;
                im=uint8(im);
                rgb = ind2rgb(im,jet(255));
                %rgb = ind2rgb(gray2ind(im,n),jet(255));
                % Crear nube de puntos con atributo RGB (0 a 255)
                R=round(rgb(:,:,1)*255);
                G=round(rgb(:,:,2)*255);
                B=round(rgb(:,:,3)*255);
                XYZ_RGB(:,4)=reshape(R,[],1);
                XYZ_RGB(:,5)=reshape(G,[],1);
                XYZ_RGB(:,6)=reshape(B,[],1);
                % exportar nube de puntos
                dlmwrite([pathname, 'XYZ-RGB-js-',num2str(familia),'-cl-',num2str(cluster),'.txt'],XYZ_RGB, 'delimiter', '\t');
            end
        
        case 3 %guardamos las coordenadas, familia y cl�ster
            A=handles.data.puntos_familia_cluster;
            dlmwrite([pathname,'XYZ-js-c.txt'],A, 'delimiter', '\t');
        
        case 4 %guardamos la familia cl�ster par�metros del plano
            A=handles.data.familia_cluster_plano;
            dlmwrite([pathname,'js-c-abcd.txt'],A, 'delimiter', '\t');
        
        case 5
            A=handles.data.puntos_familia_cluster;
            [np,~]=size(A); % n�mero de puntos en el point cloud
            B=handles.data.familia_cluster_plano;
            C=zeros(np,9); C(:,1:5)=A(:,1:5);
            jointset=unique(B(:,1));
            [njs,~]=size(jointset);
            for i=1:njs
                clusters=unique(B(B(:,1)==jointset(i),2));
                [ncs,~]=size(clusters);
                for j=1:ncs
                    I=find(C(:,4)==jointset(i) & C(:,5)==clusters(j));
                    C(I,6)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),4);
                    C(I,7)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),5);
                    C(I,8)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),6);
                    C(I,9)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),7);
                end
            end
            dlmwrite([pathname,'xyz-js-c-abcd.txt'],C, 'delimiter', '\t');
        
    end
catch error
    errordlg(['Error: ' error.identifier]);

end



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton_exit.
function pushbutton_exit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_save_txtfam.
function pushbutton_save_txtfam_Callback(hObject, eventdata, handles)
% Genera la salida tras asignar los polos a los puntos, sin el an�lisis
% cluster
try
    tic % pongo el contador a 0
    % [np,~]=size(handles.data.polos_estereo_cartesianas);
    
    % Primero verifico si existe el pathname
    if isfield(handles.data,'pathname') & handles.data.pathname ~= 0
        % Si existe lo pongo
        pathname = handles.data.pathname;
    else
        % Si no existe tomo en el que est�
        pathname = [pwd,'\'];
    end
    if isfield(handles.data,'filename') & handles.data.filename ~= 0
        filename = handles.data.filename;
        [~,filename,~] = fileparts(filename);
    else
        filename = 'Output';
    end
    
    puntos_ppalasignados=handles.data.puntos_ppalasignados;
    
    % comprobamos si hay alguna familia asignada
    if max(puntos_ppalasignados(:,4))>0
        I=find(puntos_ppalasignados(:,4)>0);
        puntos_ppalasignados=puntos_ppalasignados(I,:);
    end

    im=puntos_ppalasignados(:,4); %guardamos las familias
    % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
    n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
    im= double(im);
    im=im*255/n;
    im=uint8(im);
    rgb = ind2rgb(im,jet(255));
    % Crear nube de puntos con atributo RGB (0 a 255)
    colores=zeros(size(puntos_ppalasignados,1),3);
    colores(:,1)=reshape(round(rgb(:,:,1)*255),[],1);
    colores(:,2)=reshape(round(rgb(:,:,2)*255),[],1);
    colores(:,3)=reshape(round(rgb(:,:,3)*255),[],1);

    % IDEA IMPORTANTE, METER EL JS COMO INTENSITY Y PASAR DEL TXT OUTPUT

    % Guardo �nicamente el XYZ_Js, el RGB no sirve para nada en CC
    XYZ_JS=puntos_ppalasignados(:,1:3);
    XYZ_JS(:,4)=puntos_ppalasignados(:,4); % le pongo tambi�n las familias para que el escalar las pueda representar
    [~]=f_savematrix([pathname,filename, ' XYZ-JS-early_classification.txt'], XYZ_JS);
    % dlmwrite([pathname, filename, ' XYZ-JS-early_classification.txt'],XYZ_JS, 'delimiter', '\t','precision', 16);
    % Ahora guardo el archivo del pointcloud
    XYZ_RGB_HSV=handles.data.XYZ_RGB_HSV;
    
    % Uso o no del Computer Vision Toolbox de MATLAB
    version=ver;
    toolboxes={version.Name};
    uso=length(find(contains(toolboxes,'Computer Vision Toolbox')==1));
    if uso==1
        if str2double(getfield(version,{find(contains(toolboxes,'Computer Vision Toolbox')==1)},'Version'))>=6.2
            % Tengo el Toolbox para nubes de puntos y puedo usarlo
            % guardamos un archivo ply
            handles.data.ptCloud_RGB=pointCloud(puntos_ppalasignados(:,1:3));
            handles.data.ptCloud_RGB.Color=uint8(colores);
            % Si lo quiero guardar hago esto
            % pcwrite(ptCloud_early,[pathname, filename, ' XYZ-RGB-early_classification.ply'],'PLYFormat','binary');
            % Si lo quiero dibujar hago esto:
            % figure; pcshow(ptCloud_early);
            
            % Preparo la nube con el HSV y la guardo
            handles.data.ptCloud_HSV=pointCloud(XYZ_RGB_HSV(:,1:3));
            handles.data.ptCloud_HSV.Normal=XYZ_RGB_HSV(:,7:9);
            handles.data.ptCloud_HSV.Color=uint8(XYZ_RGB_HSV(:,4:6));
            pcwrite(handles.data.ptCloud_HSV,[pathname, filename, ' XYZ-HSV-early_classification.ply'],'PLYFormat','binary');   
        else
            % No lo tengo y empleo la programaci�n antigua
        end
    end
    
    % guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    tiempo = toc;
    S2 = [DateString, ' - An early classification was saved: ',filename, ' XYZ-JS-early_classification.txt. ', num2str(tiempo), ' s.'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;

    guidata(hObject,handles)
catch error
    errordlg(['Error: ' error.identifier]);

end


% --- Executes on selection change in popupmenu_save_output.
function popupmenu_save_output_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_save_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% determinamos los datos seleccionados
val=get(hObject,'Value');
% hacemos visible el bot�n de salida
handles.pushbutton_save_txt_output.Enable='on';
% guardamos la salida
handles.saveoutput.val=val;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_save_output_CreateFcn(hObject, ~, handles)
% hObject    handle to popupmenu_save_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_popup_axes11.
function checkbox_popup_axes11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_popup_axes11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
popup=get(hObject,'Value');
switch popup
    case 1
        hObject.String='Popup Plot on';
    case 0
        hObject.String='Popup Plot off';
end
  
% Hint: get(hObject,'Value') returns toggle state of checkbox_popup_axes11


% --- Executes on button press in pushbutton_save_txt_all.
function pushbutton_save_txt_all_Callback(hObject, eventdata, handles)
try
    tic;

    % Primero verifico si existe el pathname
    if isfield(handles.data,'pathname') & handles.data.pathname ~= 0
        % Si existe lo pongo
        pathname = handles.data.pathname;
    else
        % Si no existe tomo en el que est�
        pathname = [pwd,'\'];
    end
    if isfield(handles.data,'filename') & handles.data.filename ~= 0
        filename = handles.data.filename;
        [~,filename,~] = fileparts(filename);
    else
        filename = 'Output';
    end
        
     % Se genera un reporte con los datos
     [npoints,~]=size(handles.data.P);
     if isfield(handles.data,'npb')
         knn = handles.data.npb;
     else
         handles.data.npb=0;
         knn=0;
     end
     if isfield(handles.data,'tolerancia')
         tolerancia = handles.data.tolerancia;
     else
         handles.data.tolerancia=0;
         tolerancia=0;
     end
     
     nsec = handles.data.nsec;
     angulovpples = handles.data.angulovpples;
     cone = handles.data.cone;
     vnfamilia = handles.data.vnfamilia;
     ksigmas = handles.data.ksigmas;
     [nfamilias,~] = size(handles.data.planos_pples); % calculada al principio de este callback
     [ ~ ] = f_report( pathname, filename, npoints, knn, tolerancia, nsec, angulovpples, cone, vnfamilia, ksigmas, nfamilias, handles.data.planos_pples, handles.data.familia_cluster_plano);
    
    % Genero la salida para analizar los polos en otro software
    polos_estereo_cartesianas=handles.data.polos_estereo_cartesianas;
    [ dipdir, dip ] = f_cart2clar( polos_estereo_cartesianas(:,1),polos_estereo_cartesianas(:,2) );
    [np,~]=size(dip);
    polos = zeros(np,2);
    polos(:,1)=dipdir;
    polos(:,2)=dip;
    [~]=f_savematrix([pathname,filename,' Poles_Dipdir-Dip.txt'], polos);    
    % dlmwrite([pathname,filename,' Poles_Dipdir-Dip.txt'],polos, 'delimiter', '\t');
    
    % Guardamos las todas las coordenadas y el rgb seg�n la familia que le toque
    % [np,~]=size(handles.data.puntos_familia_cluster);
    A=handles.data.puntos_familia_cluster(:,1:4);
    % guardamos un archivo para el polyworks
    % XYZ_RGB=zeros(np,7); % la quito porque recomiendan no generarla antes
    XYZ_RGB=A(:,1:3);
    XYZ_RGB(:,7)=A(:,4);
    im=A(:,4); %guardamos las familias
    % [ rgb ] = f_randomrgb( im );
    % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
    n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
    im= double(im);
    im=im*255/n;
    im=uint8(im);
    rgb = ind2rgb(im,jet(255));
    % Crear nube de puntos con atributo RGB (0 a 255)
    R=round(rgb(:,:,1)*255);
    G=round(rgb(:,:,2)*255);
    B=round(rgb(:,:,3)*255);
    XYZ_RGB(:,4)=reshape(R,[],1);
    XYZ_RGB(:,5)=reshape(G,[],1);
    XYZ_RGB(:,6)=reshape(B,[],1);
    % exportar nube de puntos
    [~]=f_savematrix([pathname,filename, ' XYZ-RGB-js.txt'], XYZ_RGB);
    % dlmwrite([pathname,filename, ' XYZ-RGB-js.txt'],XYZ_RGB, 'delimiter', '\t', 'precision', 16);
    % guardo los xyz-rgb con sus vectores normales
    D=XYZ_RGB;
        
    % Para cada familia, guardamos sus coordenadas aisladas con
    % un color rgb por cluster desordenado!!!!
    
    PFC=handles.data.puntos_familia_cluster; % cargamos la matriz calculada
    Ifamilias=unique(PFC(:,4),'sorted'); % �ndices de las familias
    [nf,~]=size(Ifamilias);
    cluster=0;
    for i=1:nf
        familia=Ifamilias(i);
        % A=PFC(find(PFC(:,4)==familia),:); %puntos que pertenecen a la familia seleccionada
        A=PFC(PFC(:,4)==familia,:); %puntos que pertenecen a la familia seleccionada
        % Guardamos el archivo para poder abrirlo en polyworks
        % [np,~]=size(A);
        % XYZ_RGB=zeros(np,7);
        XYZ_RGB=A(:,1:3); % le paso las coordenadas de los puntos
        XYZ_RGB(:,7)=A(:,5); % le paso los ids del cluster
        im=A(:,5); %guardamos los clusters
        colorordenado = 1; % variable para ordenar o desordenar los colores de los clusters en RGB
        % 0 ordenado, 1 desordenado
        if colorordenado == 1
            [ rgb ] = f_randomrgb( im );
        else
            % transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
            n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
            im= double(im);
            im=im*255/n;
            im=uint8(im);
            rgb = ind2rgb(im,jet(255));
        end
        % Crear nube de puntos con atributo RGB (0 a 255)
        R=round(rgb(:,:,1)*255);
        G=round(rgb(:,:,2)*255);
        B=round(rgb(:,:,3)*255);
        XYZ_RGB(:,4)=reshape(R,[],1);
        XYZ_RGB(:,5)=reshape(G,[],1);
        XYZ_RGB(:,6)=reshape(B,[],1);
        % exportar nube de puntos
        [~]=f_savematrix([pathname, filename, ' XYZ-RGB-js-',num2str(familia),'-cl-',num2str(cluster),'.txt'], XYZ_RGB);
        % dlmwrite([pathname, filename, ' XYZ-RGB-js-',num2str(familia),'-cl-',num2str(cluster),'.txt'],XYZ_RGB, 'delimiter', '\t', 'precision', 16);
    end

    
    %guardamos las coordenadas, familia y cl�ster
    A=handles.data.puntos_familia_cluster;
    [~]=f_savematrix([pathname,filename, ' XYZ-js-c.txt'], A);
    % dlmwrite([pathname,filename, ' XYZ-js-c.txt'],A, 'delimiter', '\t', 'precision', 16);

    
    %guardamos la familia cl�ster par�metros del plano
    A=handles.data.familia_cluster_plano;
    [~] = f_savematrix([pathname,filename, ' js-c-abcd.txt'],A);
    % dlmwrite([pathname,filename, ' js-c-abcd.txt'],A, 'delimiter', '\t', 'precision', 16);

    
    % guardamos todas las coordenadas con todos los datos
    A=handles.data.puntos_familia_cluster;
    [np,~]=size(A); % n�mero de puntos en el point cloud
    B=handles.data.familia_cluster_plano;
    C=zeros(np,9); C(:,1:5)=A(:,1:5);
    jointset=unique(B(:,1));
    [njs,~]=size(jointset);
    for i=1:njs
        clusters=unique(B(B(:,1)==jointset(i),2));
        [ncs,~]=size(clusters);
        for j=1:ncs
            I=find(C(:,4)==jointset(i) & C(:,5)==clusters(j));
            C(I,6)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),4);
            C(I,7)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),5);
            C(I,8)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),6);
            C(I,9)=B(B(:,1)==jointset(i) & B(:,2)==clusters(j),7);
        end
    end
    [~] = f_savematrix([pathname,filename, ' xyz-js-c-abcd.txt'],C);
    % dlmwrite([pathname,filename, ' xyz-js-c-abcd.txt'],C, 'delimiter', '\t', 'precision', 16);
    
    % genero la salida XYZRGBNxNyNz
    D(:,7:9)=C(:,6:8);
    [~] = f_savematrix([pathname,filename,' XYZ-RGB-NxNyNz.txt'],D);
    % dlmwrite([pathname,filename,' XYZ-RGB-NxNyNz.txt'],D, 'delimiter', '\t', 'precision', 16);
    
    % genero la salida Dipdir_Dip_Density
    % planos_pples=handles.data.planos_pples; % no lo cargo porque se ha
    % cargado al principio
    [~] = f_savematrix([pathname,filename,' Dipdir-Dip-Density.txt'],handles.data.planos_pples);    
    % dlmwrite([pathname,filename,' Dipdir-Dip-Density.txt'],handles.data.planos_pples, 'delimiter', '\t');
    
    tiempoempleado=floor(toc);

    % guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Saved all the results to text files; total time: ', num2str(tiempoempleado),' seconds'];
    % S = strvcat(a,S2);
    S = char(a,S2);
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
    
     % Y ya puestos, guardo el log en un log.txt
     f = fopen([pathname,filename,' - log.txt'], 'wt');
     [n,~]=size(S);
     for i=1:n
        fprintf(f, '%s \n', S(i,:));
     end
     fclose(f);
    

    

catch error
    errordlg(['Error: ' error.identifier]);

end



% --------------------------------------------------------------------
function menu_edit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_config_Callback(hObject, eventdata, handles)
% hObject    handle to menu_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo la configuraci�n
% try
%     ksigmas = handles.data.ksigmas;
%     if isempty(ksigmas)
%         ksigmas=0;
%     else
%     end
% catch error
%    ksigmas = 0;
% end
if isfield(handles.data,'ksigmas')
    ksigmas = handles.data.ksigmas;
else
    ksigmas = 0;
end

setappdata(0,'ksigmas',ksigmas);
try
    vnfamilia = handles.data.vnfamilia; 
    if isempty(vnfamilia)
        vnfamilia=0;
    else
    end
catch error
   vnfamilia = 0;
end
setappdata(0,'vnfamilia',vnfamilia);
h = config;
waitfor(h);
a=getappdata(0,'globalksigmas');
ksigmas=a;
handles.data.ksigmas = ksigmas;
vnfamilia=getappdata(0,'globalvnfamilia');
handles.data.vnfamilia = vnfamilia;
guidata(hObject,handles)


% --- Executes on button press in pushbutton_31editppalpoles.
function pushbutton_31editppalpoles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_31editppalpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Edici�n manual de los polos principales
% Preparo las variables necesarias para pasarlas al global y de ah� a la
% nueva ventana
planos_pples=handles.data.planos_pples;
polos_pples_cart=handles.data.polos_pples_cart;
% Si los planos principales todav�a no tienen el % de puntos asignados, la matriz tendr� dimensi�n 3 filas. 
% Regularizo esa matriz para que tenga dimensi�n 4 columnas.
[n,c]=size(planos_pples);
if c==3
    planos_pples=[planos_pples zeros(n,1)];
    % polos_pples_cart=[polos_pples_cart zeros(n,1)];
end
X=handles.data.X;
Y=handles.data.Y;
density=handles.data.density;
polos_estereo_cartesianas=handles.data.polos_estereo_cartesianas; 
P = handles.data.P;
setappdata(0,'global_ppal_poles',planos_pples);
setappdata(0,'global_polos_pples_cart',polos_pples_cart);
setappdata(0,'global_X',X);
setappdata(0,'global_Y',Y);
setappdata(0,'global_density',density);
setappdata(0,'polos_estereo_cartesianas',polos_estereo_cartesianas);
setappdata(0,'P',P);
h = gui_ppalpoleseditor_v06;
waitfor(h);
planos_pples=getappdata(0,'global_ppal_poles');
% guardamos la edici�n en las handles
handles.data.planos_pples=planos_pples;
% introducimos los planos principales en la tabla
handles.uitable_principalplanes.Visible='on';
handles.uitable_principalplanes.Enable='on';
handles.uitable_principalplanes.Data=planos_pples;
% convertimos la notaci�n de Clar a las coordenadas de los polos
% principales
dirbuz=planos_pples(:,1);
buz=planos_pples(:,2);
polos_pples_cart=zeros(size(planos_pples));
[ x,y ] = f_clar2cart( dirbuz,buz );
polos_pples_cart(:,1)=x;
polos_pples_cart(:,2)=y;
% guardo la densidad en los nuevos planos pples
% con esto puedo ver la densidad en 3D
polos_pples_cart(:,3)=planos_pples(:,3); 
handles.data.polos_pples_cart=polos_pples_cart;
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    S2 = [DateString, ' - Manual edition of the principal poles' ];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S;
guidata(hObject,handles)


% --- Executes on selection change in listbox_log.
function listbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_log


% --- Executes during object creation, after setting all properties.
function listbox_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_vnfamilia.
function checkbox_vnfamilia_Callback(hObject, eventdata, handles)
checkbox=get(hObject,'Value');
switch checkbox
    case 1
        vnfamilia = 1;
    case 0
        vnfamilia = 0;
end
handles.data.vnfamilia = vnfamilia;
guidata(hObject,handles)



function box_ksigmas_Callback(hObject, eventdata, handles)
ksigmas = str2double(get(hObject, 'String'));
if isnan(ksigmas) && ksigmas<0
    hObject.String=0;
    errordlg('Input must be a positive number','Error');
end
% Save the new density value
handles.data.ksigmas = ksigmas;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function box_ksigmas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ksigmas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_normalspacing_Callback(hObject, eventdata, handles)
% hObject    handle to menu_normalspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_normalspacing;
% msgbox('Proximatelly');


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure_main1.
function figure_main1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_main1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --------------------------------------------------------------------
function uipushtool_new_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton_clear2_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uipushtool_loadfile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_loadfile_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uipushtool_openddbb_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_openddbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_loadddbb_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uipushtool_saveddbb_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_saveddbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_saveddbb_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function uipushtool_about_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu_about_Callback(hObject, eventdata, handles)


% --- Executes when selected cell(s) is changed in uitable_principalplanes.
function uitable_principalplanes_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_principalplanes (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
x = pos(1);
y = pos(2);
[dipdir, dip]=f_cart2clar(x,y);
output_txt = {['Dip direction: ',num2str(dipdir,3),'[�]'],...
    ['Dip: ',num2str(dip,3),'[�]']};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Density: ',num2str(pos(3),4)];
end


% --------------------------------------------------------------------
function menu_savepoints_Callback(hObject, eventdata, handles)
% hObject    handle to menu_savepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.data,'P')
	P=handles.data.P;
    % A�ado las columnas extra
    if isfield(handles.data,'P_extradata')
        [~,nce]=size(handles.data.P_extradata);
        if nce>=1 
            P(:,4:nce)=handles.data.P_extradata(:,:);
        end
    end
	pathname = handles.data.pathname;
	filename = handles.data.filename;
	[~,filename,~] = fileparts(filename);
	dlmwrite([pathname,filename,'.txt'],P, 'delimiter', '\t','precision', 16);
end


% --------------------------------------------------------------------
function menu_persistence_Callback(hObject, eventdata, handles)
% hObject    handle to menu_persistence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_persistence;


% --- Executes on button press in pushbutton_5bmargeclusters.
function pushbutton_5bmargeclusters_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_5bmargeclusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% c�lculo de los cl�sters sin m�nimo de puntos por cluster. Eso se asigna
% con el editor de cl�sters
tic % para tener el tiempo que tardo en hacer el an�lisis cluster, se pondr� en el log
% % guardo los datos con los que he calculado los clusters
% ppcluster=0; % NO hace falta
% handles.data.ppcluster=ppcluster; % No hace falta
familia_cluster_plano=handles.data.familia_cluster_plano;
puntos_familia_cluster=handles.data.puntos_familia_cluster;
vnfamilia=get(handles.checkbox_vnfamilia,'Value'); handles.data.vnfamilia = vnfamilia;
ksigmas=str2double(get(handles.box_ksigmas,'String')); handles.data.ksigmas = ksigmas;
[familia_cluster_plano] = f_merge_clusters_v01(ksigmas, vnfamilia, puntos_familia_cluster, familia_cluster_plano);% Guardamos en las handles la clasificaci�n con todos los clusters
% la salida es con todos los clusters sin filtrar, luego los guardamos en
% unos handles para utilizarlos siempre
handles.data.familia_cluster_plano=familia_cluster_plano;
% Pongo la matriz de familia cluster planos en la interfaz
handles.uitable_familiaclusterplano.Enable='on';
handles.uitable_familiaclusterplano.Data=familia_cluster_plano;
% activo la edici�n de clusters
handles.pushbutton_save_txt_all.Enable='on';
% calculo el n�mero de puntos tras el an�lisis cluster
[npuntos,~]=size(puntos_familia_cluster);
handles.text_npuntos.String=num2str(npuntos);
tiempoempleado=floor(toc);
% guardo la informaci�n en el log
    a = handles.listbox_log.String;
    t= now;
    DateString = datestr(t);
    if vnfamilia ==1
        % S3 = ['Cl`s planes are oriented with its ppal pole normal vector, cl are merged with ksigmas = ',num2str(ksigmas)];
        S3 = 'Cl`s planes are oriented with its ppal pole normal vector.';
    else
        S3 = 'Cl`s planes are oriented with its best fit plane.';
    end
    S2 = [DateString, ' - Cluster analysis. ',S3,', n of points: ',num2str(npuntos),'; total time: ', num2str(tiempoempleado),' seconds'];
    S = strvcat(a,S2)  ;
    handles.listbox_log.String=S;
    % fijo la vista del listbox en la �ltima entrada
    [N,~]=size(a); % a es el n�mero de entradas antes de meter estas
    N = N+1;
    handles.listbox_log.ListboxTop=N; % vista de la �ltima l�nea
    handles.data.log = S; 
guidata(hObject,handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over box_nsec.
function box_nsec_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to box_nsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Changelog
% DSE 2.10
% 20200126 Introduzco el an�lisis DBSCAN del toolbox de MATLAB, que es
% muuucho m�s r�pido
% 20200120 Introduzco el c�lculo de normales con el toolbox de MATLAB
% 20200213 Actualizo la programaci�n para quitar el set y el get y migrar la app
% - cambio el dlmwrite por el writematrix que est� disponible desde la 2019a

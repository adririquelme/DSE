function varargout = gui_clusterseditor(varargin)
% GUI_CLUSTERSEDITOR MATLAB code for gui_clusterseditor.fig
%      GUI_CLUSTERSEDITOR, by itself, creates a new GUI_CLUSTERSEDITOR or raises the existing
%      singleton*.
%
%      H = GUI_CLUSTERSEDITOR returns the handle to a new GUI_CLUSTERSEDITOR or the handle to
%      the existing singleton*.
%
%      GUI_CLUSTERSEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CLUSTERSEDITOR.M with the given input arguments.
%
%      GUI_CLUSTERSEDITOR('Property','Value',...) creates a new GUI_CLUSTERSEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_clusterseditor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_clusterseditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_clusterseditor

% Last Modified by GUIDE v2.5 16-Oct-2014 17:12:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_clusterseditor_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_clusterseditor_OutputFcn, ...
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


% --- Executes just before gui_clusterseditor is made visible.
function gui_clusterseditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_clusterseditor (see VARARGIN)

% Choose default command line output for gui_clusterseditor
handles.output = hObject;
% traigo las variables globales al workspace
puntos_familia_cluster=getappdata(0,'puntos_familia_cluster');
familia_cluster_plano=getappdata(0,'familia_cluster_plano');
puntos_familia_cluster_fullclusters=getappdata(0,'puntos_familia_cluster_fullclusters');
familia_cluster_plano_fullclusters=getappdata(0,'familia_cluster_plano_fullclusters');
% Configuro el slider
familias=unique(familia_cluster_plano(:,1),'sorted');
maxfamilia=length(familias);
if maxfamilia>1 
    set(handles.slider_ds,'Enable','on','Min',1,'Max',maxfamilia,'Value',1,'SliderStep',[1 1]/(maxfamilia-1));
else
    set(handles.slider_ds,'Enable','off');
end
% pongo los clusters en la tabla
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano);
% guardamos en las handles estas variables
handles.puntos_familia_cluster=puntos_familia_cluster;
handles.familia_cluster_plano=familia_cluster_plano;
handles.puntos_familia_cluster_fullclusters=puntos_familia_cluster_fullclusters;
handles.familia_cluster_plano_fullclusters=familia_cluster_plano_fullclusters;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_clusterseditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_clusterseditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton_applyallds.
function pushbutton_applyallds_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_applyallds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Preparo los datos de entrada
puntos_familia_cluster=handles.puntos_familia_cluster_fullclusters;
familia_cluster_plano=handles.familia_cluster_plano_fullclusters;
% leo el mínimo número de puntos por cluster
ppclusterallds=str2double(get(handles.box_ppclusterallds,'String'));
% aplico el filtro con la función
% importante: la variable de salida machaca la de entrada, con lo que se
% puede aplicar el filtro en varias fases
ds = 0; % le indico a la función que aplique esto a todos los DS
[ puntos_familia_cluster, familia_cluster_plano ] = f_clusterclear( puntos_familia_cluster, familia_cluster_plano , ds, ppclusterallds);
% represento la salida en la matriz
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano);
% guardo los handles
handles.puntos_familia_cluster=puntos_familia_cluster;
handles.familia_cluster_plano=familia_cluster_plano;
% guardo la salida como variables globales
setappdata(0,'puntos_familia_cluster',puntos_familia_cluster);
setappdata(0,'familia_cluster_plano',familia_cluster_plano);
guidata(hObject,handles)

% --- Executes on button press in pushbutton_applyds.
function pushbutton_applyds_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_applyds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
puntos_familia_cluster=handles.puntos_familia_cluster;
familia_cluster_plano=handles.familia_cluster_plano;
% leo el mínimo número de puntos por cluster
ppclusterds=str2double(get(handles.box_ppclusterds,'String'));
% aplico el filtro con la función
% importante: la variable de salida machaca la de entrada, con lo que se
% puede aplicar el filtro en varias fases
ds = str2double(get(handles.text_ds,'String')); % le indico a la función que aplique esto al DS
[ puntos_familia_cluster, familia_cluster_plano ] = f_clusterclear( puntos_familia_cluster, familia_cluster_plano , ds, ppclusterds);
% represento la salida en la matriz
I=find(familia_cluster_plano(:,1)==ds);
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano(I,:));
% dibujamos la función probabilística de acumulación de los ppc
A=familia_cluster_plano;
% h=figure;
I=find(A(:,1)==ds); puntosporcluster=sort(A(I,3)');
cdfplot(puntosporcluster);
% guardo los handles
handles.puntos_familia_cluster=puntos_familia_cluster;
handles.familia_cluster_plano=familia_cluster_plano;
% guardo la salida como variables globales
setappdata(0,'puntos_familia_cluster',puntos_familia_cluster);
setappdata(0,'familia_cluster_plano',familia_cluster_plano);
guidata(hObject,handles)



function box_ppclusterallds_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppclusterallds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ppclusterallds = str2double(get(hObject, 'String'));
if isnan(ppclusterallds)
    set(hObject, 'String', 100);
    errordlg('Input must be a number','Error');
end
if ppclusterallds < 0
    set(hObject, 'String', 100);
    errordlg('Input must be a positive number','Error');
end
valor = ppclusterallds;
resto = valor - floor(valor);
if resto == 0
    % todo ok
else
    set(hObject, 'String', 100);
    errordlg('Input must be an integer','Error');  
end
% Save the new density value
handles.data.ppclusterallds = ppclusterallds;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function box_ppclusterallds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppclusterallds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function box_ppclusterds_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppclusterds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% NOTA: es la misma programación que el textbox ppclusterallds, pero en las
% handles meto el valor que le toca.
ppclusterallds = str2double(get(hObject, 'String'));
if isnan(ppclusterallds)
    set(hObject, 'String', 100);
    errordlg('Input must be a number','Error');
end
if ppclusterallds < 0
    set(hObject, 'String', 100);
    errordlg('Input must be a positive number','Error');
end
valor = ppclusterallds;
resto = valor - floor(valor);
if resto == 0
    % todo ok
else
    set(hObject, 'String', 100);
    errordlg('Input must be an integer','Error');  
end
% Save the new density value
handles.data.ppclusterds = ppclusterallds;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function box_ppclusterds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppclusterds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_ds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider_ds_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds=floor((get(hObject,'Value')));
set(handles.text_ds,'String',ds);
A=handles.familia_cluster_plano;
% h=figure;
I=find(A(:,1)==ds); puntosporcluster=A(I,3)';
cens = A(I,2)';
% ecdf(puntosporcluster,'function','cdf','censoring',cens,'bounds','on');
cdfplot(puntosporcluster)
% filtro los valores para que sólo salga esa familia
familia_cluster_plano=getappdata(0,'familia_cluster_plano');
% pongo los clusters en la tabla
I=find(familia_cluster_plano(:,1)==ds);
set(handles.uitable_familiaclusterplano,'Visible','on','Data',familia_cluster_plano(I,:));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_ds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function varargout = gui_normalspacing(varargin)
% GUI_NORMALSPACING MATLAB code for gui_normalspacing.fig
%      GUI_NORMALSPACING, by itself, creates a new GUI_NORMALSPACING or raises the existing
%      singleton*.
%
%      H = GUI_NORMALSPACING returns the handle to a new GUI_NORMALSPACING or the handle to
%      the existing singleton*.
%
%      GUI_NORMALSPACING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_NORMALSPACING.M with the given input arguments.
%
%      GUI_NORMALSPACING('Property','Value',...) creates a new GUI_NORMALSPACING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_normalspacing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_normalspacing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_normalspacing

% Last Modified by GUIDE v2.5 01-May-2015 10:34:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_normalspacing_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_normalspacing_OutputFcn, ...
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


% --- Executes just before gui_normalspacing is made visible.
function gui_normalspacing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_normalspacing (see VARARGIN)

% Choose default command line output for gui_normalspacing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_normalspacing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_normalspacing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to menu_loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    set(handles.text_status,'String','Loading text file ...');
    [filename, pathname] = uigetfile('*.txt','Select the xyz-jset-cluster-abcd file');
    % archivo = strcat(pathname, filename);
    Base=load(strcat(pathname, filename));
        
    % activamos cosas si procede
    % preparamos las matrices P y Q
    P=Base(:,1:5);
    js=unique(P(:,4)); % vector con los ids de los joint sets
    [njs,~]=size(js); % número de joint sets, no los índices!!!!
    contadorQ=1;
    for i=1:njs
        iaux=js(i); % id del js número i
        I = find(Base(:,4)==iaux); % posiciones donde están esos js
        Maux=Base(I,5:9); % vector con los números de clúster de cada punto y los parámetros del plano
        clusters=unique(Maux(:,1)); % vector con los ids de los clusters del js i
        [nc,~]=size(clusters); % número de clusters para ese js
        for j=1:nc
            Q(contadorQ,1)=iaux;
            I=find(Maux(:,1)==clusters(j));
            Q(contadorQ,2)=clusters(j);
            Inp=find(Base(:,4)==iaux & Base(:,5)==clusters(j));
            [npoints,~]=size(Inp);
            Q(contadorQ,3)=npoints; %número de puntos
            Q(contadorQ,4:7)=Maux(I(1),2:5);
            contadorQ=contadorQ+1;
        end
    end
    v_jointsets=unique(Q(:,1)); % vector con los índices de los joint sets
    [njs,~]=size(v_jointsets); % njs número de joint sets
    handles.data.njs=njs;
    handles.data.v_jointsets=v_jointsets; 
    handles.data.Base = Base;
    handles.data.P=P; % P xyz-js-cl
    handles.data.Q=Q; % Q js-c-abcd
    handles.data.pathname = pathname;
    
    % preparo el slider de los joint sets
    if njs==1
        set(handles.slider_joint_set,'Enable','on','Min',1,'Max',njs,'Value',1,'SliderStep',[1 1]/(1));
    else
        set(handles.slider_joint_set,'Enable','on','Min',1,'Max',njs,'Value',1,'SliderStep',[1 1]/(njs-1));
    end
    
    
    % si todo ha estado bien, activo los botones
    % set(handles.pushbutton_proyectapuntos,'Enable','on'); % desactivado
    % por nueva versión
    set(handles.pushbutton_spacing_analysis_dsi,'Enable','on');
    set(handles.pushbutton_spacing_analysis_allds,'Enable','on');
    set(handles.text_joint_set_label,'Enable','on');
    set(handles.text_joint_set,'Enable','on');
    set(handles.slider_joint_set,'Enable','on');
    set(handles.text_bandwidth_label,'Enable','on');
    set(handles.box_bandwidth,'Enable','on');
    set(handles.text_optimal_bandwidth_label,'Enable','on');
    set(handles.text_optimal_bandwidth,'Enable','on');
    set(handles.text_smean_label,'Enable','on');
    set(handles.text_smean,'Enable','on');
    set(handles.text_status,'String','Waiting for your orders my Lord ...');
    
catch error
errordlg(['Error: ' error.identifier]);
end
guidata(hObject,handles)


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_proyectapuntos.
function pushbutton_proyectapuntos_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_proyectapuntos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los datos
P=handles.data.P;
Q=handles.data.Q;
[~]=f_ptosproyectados(P,Q);


% --- Executes on button press in pushbutton_spacing_analysis_dsi.
function pushbutton_spacing_analysis_dsi_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_spacing_analysis_dsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = handles.data.pathname;
% P=handles.data.P;
% Q=handles.data.Q;
Base=handles.data.Base; % xyj-js-c-abcd
v_jointsets=handles.data.v_jointsets;
js=v_jointsets(floor((get(handles.slider_joint_set,'Value'))));
bandwidth=str2num(get(handles.box_bandwidth,'String'));
[ optimalbandwidth , Smean] = f_spacing_analysis_v11( Base, js, bandwidth, pathname); 
%if optimalbandwidth >0
    set(handles.text_optimal_bandwidth,'String',num2str(optimalbandwidth));
    set(handles.text_smean,'String',num2str(Smean));
%end
handles.data.optimanbandwidth=optimalbandwidth;



% --- Executes on slider movement.
function slider_joint_set_Callback(hObject, eventdata, handles)
% hObject    handle to slider_joint_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los handles
v_jointsets=handles.data.v_jointsets;
    js=v_jointsets(floor((get(hObject,'Value'))));
    set(handles.text_joint_set,'String',js);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint_set_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function box_bandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to box_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_bandwidth as text
%        str2double(get(hObject,'String')) returns contents of box_bandwidth as a double


% --- Executes during object creation, after setting all properties.
function box_bandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_m_Callback(hObject, eventdata, handles)
% hObject    handle to box_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_m as text
%        str2double(get(hObject,'String')) returns contents of box_m as a double


% --- Executes during object creation, after setting all properties.
function box_m_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_n_Callback(hObject, eventdata, handles)
% hObject    handle to box_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_n as text
%        str2double(get(hObject,'String')) returns contents of box_n as a double


% --- Executes during object creation, after setting all properties.
function box_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_spacing_analysis_allds.
function pushbutton_spacing_analysis_allds_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_spacing_analysis_allds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% calcula todos los espaciados
njs=handles.data.njs;
    pathname = handles.data.pathname;
    Base=handles.data.Base; % xyj-js-c-abcd
    bandwidth=str2double(get(handles.box_bandwidth,'String'));
for i=1:njs
    [ ~ , ~] = f_spacing_analysis_v11( Base, i, bandwidth, pathname);
end

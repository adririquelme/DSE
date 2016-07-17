function varargout = gui_ppalpoleseditor_v03(varargin)
%    {Editor of principal poles. Matlab GUI}
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
% GUI_PPALPOLESEDITOR_V03 MATLAB code for gui_ppalpoleseditor_v03.fig
%      GUI_PPALPOLESEDITOR_V03, by itself, creates a new GUI_PPALPOLESEDITOR_V03 or raises the existing
%      singleton*.
%
%      H = GUI_PPALPOLESEDITOR_V03 returns the handle to a new GUI_PPALPOLESEDITOR_V03 or the handle to
%      the existing singleton*.
%
%      GUI_PPALPOLESEDITOR_V03('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PPALPOLESEDITOR_V03.M with the given input arguments.
%
%      GUI_PPALPOLESEDITOR_V03('Property','Value',...) creates a new GUI_PPALPOLESEDITOR_V03 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_ppalpoleseditor_v03_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_ppalpoleseditor_v03_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_ppalpoleseditor_v03

% Last Modified by GUIDE v2.5 15-Mar-2015 19:06:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_ppalpoleseditor_v03_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_ppalpoleseditor_v03_OutputFcn, ...
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


% --- Executes just before gui_ppalpoleseditor_v03 is made visible.
function gui_ppalpoleseditor_v03_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_ppalpoleseditor_v03 (see VARARGIN)

% Choose default command line output for gui_ppalpoleseditor_v03


% cargo las imágenes
handles.output = hObject;
A = imread('img/restart','bmp');
set(handles.pushbutton_restartppalpoles,'cdata',A);
A = imread('img/delete','bmp');
set(handles.pushbutton_removepolenew,'cdata',A);
A = imread('img/insert','bmp');
set(handles.pushbutton_insertpole,'cdata',A);
% A = imread('img/modify','bmp');
% set(handles.pushbutton_save_ppalplanes,'cdata',A);

handles.output = hObject;

% Preparo las variables globales
ppal_poles=getappdata(0,'global_ppal_poles');
polos_pples_cart=getappdata(0,'global_polos_pples_cart');
X=getappdata(0,'global_X');
Y=getappdata(0,'global_Y');
density=getappdata(0,'global_density');
% ponemos los polos en la tabla
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
% guardamos las variables en las handles
handles.ppal_poles=ppal_poles;
handles.polos_pples_cart=polos_pples_cart;
handles.X=X;
handles.Y=Y;
handles.density=density;

% represento la función de densidad
plotstereo_Callback(hObject, eventdata, handles);

guidata(hObject, handles);

% UIWAIT makes gui_ppalpoleseditor_v03 wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = gui_ppalpoleseditor_v03_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function box_nppalpoles_Callback(hObject, eventdata, handles)
% hObject    handle to box_nppalpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject, 'String'));
if isnan(value)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if value<=0 
    errordlg('The value must be positive','Error');
    set(handles.box_nppalpoles,'String','0')
end
resto = value - floor(value);
if resto == 0
    % todo ok
else
    set(hObject, 'String', 0);
    errordlg('Input must be an integer','Error');  
    set(handles.box_nppalpoles,'String','0')
end
% Save the new density value
handles.newnppalpoles=value;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of box_nppalpoles as text
%        str2double(get(hObject,'String')) returns contents of box_nppalpoles as a double


% --- Executes during object creation, after setting all properties.
function box_nppalpoles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_nppalpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_restartppalpoles.
function pushbutton_restartppalpoles_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_restartppalpoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newppalpoles=str2double(get(handles.box_nppalpoles,'String'));
ppal_poles=zeros(newppalpoles,3);
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
handles.ppal_poles=ppal_poles;
% guardo la variable en las handles
handles.ppal_poles = ppal_poles;
% represento de nuevo el stereoplot
plotstereo_Callback(hObject, eventdata, handles);
% paso la variable al global
guardaglobales_Callback(hObject, eventdata, handles);
% Update handles structure
guidata(hObject,handles)



% --- Executes on selection change in popupmenu_ppalpolenumber.
function popupmenu_ppalpolenumber_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ppalpolenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ppalpolenumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ppalpolenumber


% --- Executes during object creation, after setting all properties.
function popupmenu_ppalpolenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ppalpolenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_ppalpoledipdirection_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppalpoledipdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject, 'String'));
if isnan(value)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% if value<0 
%     errordlg('The value must be positive','Error');
%     set(handles.box_ppalpoledipdirection,'String','0')
% end


% --- Executes during object creation, after setting all properties.
function box_ppalpoledipdirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppalpoledipdirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_ppalpoledip_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppalpoledip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject, 'String'));
if isnan(value)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if value<0 
    errordlg('The value must be positive','Error');
    set(handles.box_ppalpoledip,'String','0')
end
if value>90 
    errordlg('Dip value cannot be higher than 90 degrees','Error');
    set(handles.box_ppalpoledip,'String','0')
end


% --- Executes during object creation, after setting all properties.
function box_ppalpoledip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppalpoledip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save_ppalplanes.
function pushbutton_save_ppalplanes_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save_ppalplanes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los datos que necesito
ppal_poles=handles.ppal_poles;
X=handles.X;
Y=handles.Y;
density=handles.density;
% tomo los datos del nuevo polo principal
nppalpole=str2double(get(handles.box_ppalpolid,'String'));
dipdirection=str2double(get(handles.box_ppalpoledipdirection,'String'));
dip=str2double(get(handles.box_ppalpoledip,'String'));
% calculo las coordenadas nuevas en cartesianas
[xq, yq]=f_clar2cart(dipdirection, dip);
% calculo la densidad del polo
zq=griddata(X,Y,density,xq,yq);
% insertamos una fila al final
v=[dipdirection dip zq];
% guardo los valores que hemos metido
ppal_poles(nppalpole,:)=v;
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
handles.ppal_poles=ppal_poles;
% dibujo los polos
plotstereo_Callback(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes on slider movement.
function slider_ppalpole_Callback(hObject, eventdata, handles)
% hObject    handle to slider_ppalpole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nppalpole=floor((get(hObject,'Value')));
set(handles.text_nppalpole,'String',nppalpole);
handles.nppalpole=nppalpole;
ppal_poles=handles.ppal_poles;
dipdirection=ppal_poles(nppalpole,1);
dip=ppal_poles(nppalpole,2);
set(handles.box_ppalpoledipdirection,'String',num2str(dipdirection));
set(handles.box_ppalpoledip,'String',num2str(dip));
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function slider_ppalpole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_ppalpole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% activo el palen principal
%%% Este está inhabilitado!!!!!!
set(handles.uipanel1,'Visible','on');
% mostramos los planos principales en la tabla
ppal_poles=handles.ppal_poles;
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
% calculo el número de polos principales y los guardo en las handles
[nppalpoles,~]=size(ppal_poles);
handles.nppalpoles=nppalpoles;
% preparo el slider
if nppalpoles == 0
    set(handles.slider_ppalpole,'Enable','off');
    set(handles.uitable_ppalpoles,'Enable','off');
    slidervalue=0;
end
if nppalpoles == 1
    slidervalue=1;
    set(handles.slider_ppalpole,'Value',slidervalue);
    set(handles.uitable_ppalpoles,'Enable','off');
end
if nppalpoles > 1
    set(handles.slider_ppalpole,'Enable','on','Min',1,'Max',nppalpoles,'Value',1,'SliderStep',[1 1]/nppalpoles);
    slidervalue=1;
end
% Update handles structure
guidata(hObject,handles)


% --- Executes on button press in pushbutton_removepole.
function pushbutton_removepole_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_removepole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los planos principales
%%% Este está inhabilitado!!!!!!!
ppal_poles=handles.ppal_poles;
% tomo el número de polo que quiero eliminar
nppalpole=str2double(get(handles.text_nppalpole,'String'));
% elimino esa fila
ppal_poles(nppalpole,:)=[];
% configuro el entorno para la nueva dimensión
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
[newppalpoles,~]=size(ppal_poles); % vemos la dimensión del número de polos
if newppalpoles == 0
    set(handles.slider_ppalpole,'Enable','off');
    set(handles.uitable_ppalpoles,'Enable','off');
    slidervalue=0;
end
if newppalpoles == 1
    slidervalue=1;
    set(handles.slider_ppalpole,'Value',slidervalue);
    set(handles.uitable_ppalpoles,'Enable','off');
end
if newppalpoles > 1
    set(handles.slider_ppalpole,'Enable','on','Min',1,'Max',newppalpoles,'Value',1,'SliderStep',[1 1]/newppalpoles);
    slidervalue=1;
end

% paso la variable al global
setappdata(0,'global_ppal_poles',ppal_poles);
% guardo la variable en las handles
handles.ppal_poles = ppal_poles;
% Update handles structure
guidata(hObject,handles)



function box_ppalpole2move_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppalpole2move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_ppalpole2move as text
%        str2double(get(hObject,'String')) returns contents of box_ppalpole2move as a double


% --- Executes during object creation, after setting all properties.
function box_ppalpole2move_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppalpole2move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_moveup.
function pushbutton_moveup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_moveup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los planos principales
ppal_poles=handles.ppal_poles;
% preparo los índices de los polos que quiero mover
ppalpole2move=str2double(get(handles.box_ppalpole2move,'String'));
if ppalpole2move>=2
    ppalpolemove2=ppalpole2move-1;
    [ppal_poles]=swap(ppal_poles,1,ppalpole2move,ppalpolemove2);
    % cambio los boxes
    set(handles.box_ppalpole2move,'String',num2str(ppalpolemove2));
    % pongo el resultado en la tabla
    set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
    % guardo la variable en las handles
    handles.ppal_poles = ppal_poles;
    % dibujo los polos
    plotstereo_Callback(hObject, eventdata, handles);
    % paso la variable al global
    guardaglobales_Callback(hObject, eventdata, handles);
    % Update handles structure
    guidata(hObject,handles)
end


% --- Executes on button press in pushbutton_movedown.
function pushbutton_movedown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_movedown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ppal_poles=handles.ppal_poles;
[n,~]=size(ppal_poles);
% preparo los índices de los polos que quiero mover
ppalpole2move=str2double(get(handles.box_ppalpole2move,'String'));
if ppalpole2move~=n
    ppalpolemove2=ppalpole2move+1;
    [ppal_poles]=swap(ppal_poles,1,ppalpole2move,ppalpolemove2);
    % cambio los boxes
    set(handles.box_ppalpole2move,'String',num2str(ppalpolemove2));
    % pongo el resultado en la tabla
    set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
    % guardo la variable en las handles
    handles.ppal_poles = ppal_poles;
    % dibujo los polos
    plotstereo_Callback(hObject, eventdata, handles);
    % paso la variable al global
    guardaglobales_Callback(hObject, eventdata, handles);
    % Update handles structure
    guidata(hObject,handles)
end

% --- Executes on button press in pushbutton_moveto.
function pushbutton_moveto_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_moveto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% preparo los planos principales
ppal_poles=handles.ppal_poles;
% preparo los índices de los polos que quiero mover
ppalpole2move=str2double(get(handles.box_ppalpole2move,'String'));
ppalpolemove2=str2double(get(handles.box_moveto,'String'));
[ppal_poles]=swap(ppal_poles,1,ppalpole2move,ppalpolemove2);
% cambio los boxes
set(handles.box_ppalpole2move,'String',num2str(ppalpole2move));
set(handles.box_moveto,'String',num2str(ppalpolemove2));
% pongo el resultado en la tabla
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
% guardo la variable en las handles
handles.ppal_poles = ppal_poles;
% dibujo los polos
plotstereo_Callback(hObject, eventdata, handles);
% paso la variable al global
guardaglobales_Callback(hObject, eventdata, handles);
% Update handles structure
guidata(hObject,handles)



function box_moveto_Callback(hObject, eventdata, handles)
% hObject    handle to box_moveto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_moveto as text
%        str2double(get(hObject,'String')) returns contents of box_moveto as a double


% --- Executes during object creation, after setting all properties.
function box_moveto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_moveto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function box_pole2remove_Callback(hObject, eventdata, handles)
% hObject    handle to box_pole2remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_pole2remove as text
%        str2double(get(hObject,'String')) returns contents of box_pole2remove as a double


% --- Executes during object creation, after setting all properties.
function box_pole2remove_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_pole2remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_removepolenew.
function pushbutton_removepolenew_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to pushbutton_removepolenew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ppal_poles=handles.ppal_poles;
% tomo el número de polo que quiero eliminar
nppalpole=str2double(get(handles.box_pole2remove,'String'));
% elimino esa fila
ppal_poles(nppalpole,:)=[];
% configuro el entorno para la nueva dimensión
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
% guardo la variable en las handles
handles.ppal_poles = ppal_poles;
% Dibujo cómo queda el stereonet
plotstereo_Callback(hObject, eventdata, handles);
% paso la variable al global
guardaglobales_Callback(hObject, eventdata, handles);
% Update handles structure
guidata(hObject,handles)


% --- Executes on button press in pushbutton_insertpole.
function pushbutton_insertpole_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_insertpole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tomo los polos principales
ppal_poles=handles.ppal_poles;
X=handles.X;
Y=handles.Y;
density=handles.density;
% insertamos una fila al final
xq=0;
yq=0;
zq=griddata(X,Y,density,xq,yq);
v=[xq yq zq];
ppal_poles=[ppal_poles;v];
% configuro el entorno para la nueva dimensión
set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
% dibujo los polos
plotstereo_Callback(hObject, eventdata, handles);
% guardo la variable en las handles
handles.ppal_poles = ppal_poles;
% paso la variable al global
guardaglobales_Callback(hObject, eventdata, handles); 
% Update handles structure
guidata(hObject,handles)




function box_ppalpolid_Callback(hObject, eventdata, handles)
% hObject    handle to box_ppalpolid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_ppalpolid as text
%        str2double(get(hObject,'String')) returns contents of box_ppalpolid as a double


% --- Executes during object creation, after setting all properties.
function box_ppalpolid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_ppalpolid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function guardaglobales_Callback(hObject, eventdata, handles) 
ppal_poles=handles.ppal_poles;
setappdata(0,'global_ppal_poles',ppal_poles);
polos_pples_cart=handles.polos_pples_cart;
setappdata(0,'global_polos_pples_cart',polos_pples_cart);


function plotstereo_Callback(hObject, eventdata, handles) 
polos_pples = handles.ppal_poles;
polos_pples_cart=polos_pples;
[ polos_pples_cart(:,1),polos_pples_cart(:,2) ] = f_clar2cart( polos_pples(:,1),polos_pples(:,2) );
X=handles.X;
Y=handles.Y;
density=handles.density;
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
% maxd=max(max(density)); mind=min(min(density));
numberisolines=80; % número de isoloníneas
% isolines=(maxd-mind)/numberisolines;

    cla(handles.axes_11,'reset'); % limpiamos las figuras existentes
    wulff;
    opcion3D = 1;
    if opcion3D ==1
        % opción 3D
        scatter3(handles.axes_11,polos_pples_cart(1:kk,1),polos_pples_cart(1:kk,2),polos_pples_cart(1:kk,3),tamanyo,'filled','MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75]);
        title(handles.axes_11,['Poles Density Plot, Principal Poles. Isolines each ',num2str(100/numberisolines),'%']);
        xlabel(handles.axes_11,'axis X'); ylabel(handles.axes_11,'axis Y');
        hold on; contour3(handles.axes_11,X,Y,density,numberisolines);
        for ii=1:kk
            text(xa(ii),xb(ii),xc(ii), ['J_{',num2str(ii),'}'],'FontSize',18,'EdgeColor','k','BackgroundColor','w');
        end
    else
        % opcion 2D
        scatter(handles.axes_11,polos_pples_cart(1:kk,1),polos_pples_cart(1:kk,2),tamanyo,'filled','MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75]);
        title(handles.axes_11,['Poles Density Plot, Principal Poles. Isolines each ',num2str(100/numberisolines),'%']);
        xlabel(handles.axes_11,'axis X'); ylabel(handles.axes_11,'axis Y');
        hold on; contour(handles.axes_11,X,Y,density,numberisolines);  
        for ii=1:kk
            text(xa(ii),xb(ii), ['J_{',num2str(ii),'}'],'FontSize',18,'EdgeColor','k','BackgroundColor','w');
        end
    end

    
    
    axis (handles.axes_11,[-1 1 -1 1]); axis(handles.axes_11,'square');
    
    % preparo el puntero
    dcm = datacursormode(gcf);
    datacursormode on;
    set(dcm,'updatefcn',@myfunction)
    


    



% --- Executes when entered data in editable cell(s) in uitable_ppalpoles.
function uitable_ppalpoles_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_ppalpoles (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA
ppal_poles=handles.ppal_poles;
pos1=eventdata.Indices(1);
pos2=eventdata.Indices(2);
if pos2~=3
    ppal_poles(pos1,pos2)=eventdata.NewData;
    % calculo la densidad del nuevo punto
    X=handles.X;
    Y=handles.Y;
    density=handles.density;
    xq=ppal_poles(pos1,1);
    yq=ppal_poles(pos1,2);
    [xq, yq]=f_clar2cart(xq,yq);
    zq=griddata(X,Y,density,xq,yq);
    ppal_poles(pos1,3)=zq;
    set(handles.uitable_ppalpoles,'Enable','on','Data',ppal_poles);
    handles.ppal_poles=ppal_poles;
    % dibjo la nueva situación
    plotstereo_Callback(hObject, eventdata, handles)
    % paso la variable al global
    guardaglobales_Callback(hObject, eventdata, handles); 
    % Update handles structure
    guidata(hObject,handles)
end


% --------------------------------------------------------------------
function uitoggletool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable_ppalpoles.
function uitable_ppalpoles_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_ppalpoles (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% Al seleccionar, tomará el índice del polo principal y se lo pone al box
% de id of principal pole, box_ppalpole2move
try
pos1=eventdata.Indices(1);
set(handles.box_ppalpole2move,'String',num2str(pos1));
set(handles.box_pole2remove,'String',num2str(pos1));
catch error
end

function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
x = pos(1);
y = pos(2);
[dipdir, dip]=f_cart2clar(x,y);
output_txt = {['Dip direction: ',num2str(dipdir,3),'[º]'],...
    ['Dip: ',num2str(dip,3),'[º]']};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Density: ',num2str(pos(3),4)];
end

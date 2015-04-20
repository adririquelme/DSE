function varargout = about(varargin)
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
% ABOUT MATLAB code for about.fig
%      ABOUT, by itself, creates a new ABOUT or raises the existing
%      singleton*.
%
%      H = ABOUT returns the handle to a new ABOUT or the handle to
%      the existing singleton*.
%
%      ABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ABOUT.M with the given input arguments.
%
%      ABOUT('Property','Value',...) creates a new ABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before about_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to about_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help about

% Last Modified by GUIDE v2.5 18-Apr-2015 18:26:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_OpeningFcn, ...
                   'gui_OutputFcn',  @about_OutputFcn, ...
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


% --- Executes just before about is made visible.
function about_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to about (see VARARGIN)

% Choose default command line output for about
handles.output = hObject;
guidata(hObject, handles);
A = imread('img/gpl3','bmp');
set(handles.pushbutton3,'cdata',A);
A = imread('img/logoua','bmp');
set(handles.text_logoua,'cdata',A);
guidata(hObject, handles);
A = imread('img/logo_unil','bmp');
set(handles.text_logounil,'cdata',A);
A = imread('img/DSE_colour','bmp');
set(handles.text_logodse,'cdata',A);
guidata(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes about wait for user response (see UIRESUME)
% uiwait(handles.figure_about);


% --- Outputs from this function are returned to the command line.
function varargout = about_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_salir.
function pushbutton_salir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_salir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure_about);


% --- Executes on button press in text_logounil.
function text_logounil_Callback(hObject, eventdata, handles)
% hObject    handle to text_logounil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

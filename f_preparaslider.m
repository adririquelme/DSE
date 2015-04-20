function [slidervalue]=f_preparaslider(nppalpoles)
% Función que prepara el slider de principal poles.
% pendiente de desarrollo
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
if nppalpoles == 0
    set(handles.slider_ppalpole,'Enable','off');
    set(handles.uitable_ppalpoles,'Enable','off');
    slidervalue=0;
end
if ppalpoles == 1
    slidervalue=1;
    set(handles.slider_ppalpole,'Value',slidervalue);
    set(handles.uitable_ppalpoles,'Enable','off');
end
if ppalpoles > 1
    set(handles.slider_ppalpole,'Enable','on','Min',1,'Max',nppalpoles,'Value',1,'SliderStep',[1 1]/nppalpoles);
    slidervalue=1;
end
end

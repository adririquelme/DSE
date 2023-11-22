function output_txt = f_stereopickcolour_v00(empt,event_obj)
%    {Customizes text of data tips}
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
%    Discontinuity Set Extractor, Copyright (C) 2015 Adrian Riquelme Guill
%    Discontinuity Set Extractor comes with ABSOLUTELY NO WARRANTY.
%    This is free software, and you are welcome to redistribute it
%    under certain conditions.
% 

pos = get(event_obj,'Position');
x = pos(1);
y = pos(2);
[dipdir, dip]=f_cart2clar(x,y);
output_txt = {['Dip direction: ',num2str(dipdir,3),'º'],...
    ['Dip: ',num2str(dip,3),'º']};

% If there is a Z-coordinate in the position, display it as well
% if length(pos) > 2
%     output_txt{end+1} = ['Density: ',num2str(pos(3),4)];
% end

% Calculo el color del punto
xIdx = find(event_obj.Target.XData == pos(1));
yIdx = find(event_obj.Target.YData == pos(2));
idx = intersect(xIdx,yIdx);
color = event_obj.Target.CData(idx,1:3);

% add to the data cursor text
% output_txt{end+1} = sprintf('%.3f ',color);
output_txt{end+1} = sprintf('Colour: [%.3f, %.3f, %.3f] ',color(1), color(2), color(3));


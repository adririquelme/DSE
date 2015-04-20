function [alfa] = o2a(omega)
%    {función omega a alfa}
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
alfa=zeros(size(omega));
I=find(omega>=0 & omega<pi/2); alfa(I)=pi/2-omega(I)+pi;
I=find(omega>=pi/2 & omega <pi);alfa(I)=pi-(omega(I)-pi/2);
I=find(omega>=pi & omega<3*pi/2);alfa(I)=pi/2-(omega(I)-pi);
I=find(omega>=3*pi/2 & omega<2*pi);alfa(I)=7*pi/2-omega(I);

% if omega>=0 && omega <pi/2
%     alfa=pi/2-omega+pi; %omega en el 1c, llevo alfa al 3c
% else
%     if omega>=pi/2 && omega <pi
%         alfa=pi-(omega-pi/2); %omega en el 2c, alfa al 4c
%     else
%         if omega>=pi && omega <3*pi/2
%             alfa=pi/2-(omega-pi); %omega en el 3c, lo llevo al 1c
%         else
%             alfa=7*pi/2-omega; %omega en el 4c, lo llevo al 2c
%         end
%     end
% end
end
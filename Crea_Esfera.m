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
R=10; n=10000;
i=1;
test=1;
while test==1
    x=rand*R-R/2;
    y=rand*R-R/2;
    z=rand*R-R/2;
    rho=(x^2+y^2+z^2)^(0.5);
    if rho<=R
        P(i,1)=x;
        P(i,2)=y;
        P(i,3)=z;
        i=i+1;
    end
    if i==n
        test=0;
    end
end


fi = fopen('puntos.txt', 'w') ;
[n,p]=size(P);
for k=1:n
    fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3));
end
fclose(fi);

function [ A,B,C ] = f_vbuz2vnor( w,b )
% f_vbuz2vnor, Adrián Riquelme octubre 2013
%   Función que toma el vector buzamiento de un plano y devuelve las
%   componentes (A,B,C) del vector normal al plano.
A=sin(b)*sin(w);
B=sin(b)*cos(w);
C=cos(b);



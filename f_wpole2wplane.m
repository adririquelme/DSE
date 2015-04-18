function [ wplane ] = f_wpole2wplane( wpole )
% wpole2wplane, Adrián Riquelme, abril 2013
% función que toma el omega de un polo y lo convierte en en el omega del
% plano
% Importante: los ángulos son en radianes!!

wplane=zeros(size(wpole));
I=find(wpole>=0 & wpole<pi); wplane(I)=wpole(I)+pi;
I=find(wpole>=pi & wpole<2*pi); wplane(I)=wpole(I)-pi;
% if wpole>=0 && wpole<pi
%     wplane=wpole+pi;
% else
%     wplane=wpole-pi;
% end
end
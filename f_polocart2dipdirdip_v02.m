function [ dipdir, dip ] = f_polocart2dipdirdip_v02( x,y )
%% [ dipdir, dip ] = f_polocart2dipdirdip( x,y )
% Función que convierte las coordenadas cartesianas de un polo de un vector
% normal de un plano a la notación de Clar (dirección de buzamiento y
% buzamiento)
% Adrián Riquelme Guill, 4 diciembre 2014
% inputs: x e y, coordenadas del polo en el stereonet
% outputs: dip direction and dip in radians

dipdir = zeros(size(x));

% primer cuadrante
I = find(x>=0 & y>=0); 
dipdir(I)=atan(x(I)./y(I))+pi;

% segundo cuadrante
I = find(x>0 & y<0); 
dipdir(I)=2*pi+atan(x(I)./y(I));

% tercer cuadrante
I = find(x<=0 & y<=0); 
dipdir(I)=atan(x(I)./y(I));

% cuarto cuadrante
I = find(x<0 & y>0); 
dipdir(I)=pi+atan(x(I)./y(I));



dip = 2*atan((x.^2+y.^2).^0.5);
I=find(x==0 & y == 0); 
dipdir(I)=0; dip(I)=0;



end





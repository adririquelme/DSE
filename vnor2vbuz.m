function [w,b]=vnor2vbuz(ux,uy,uz)
% Función de conversión vector normal a vector buzamiento del plano
% Adrián Riquelme, abril 2013
% [w,b]=vnor2vbuz(ux,uy,uz)
% Input:
% - componentes del vector normal al plano
% Output:
% - w: Ángulo que forma el vector de buzamiento con el eje OY, considerado
% como el norte
% - b: Ángulo que forma la lÃ­nea de mÃ¡xima pendiente del plano con su
% proyecciÃ³n horizontal.
uxy= (ux^2+uy^2)^(0.5);
bz=-uxy;
if uxy==0
    bx=0;
    by=0;
else
    bx=ux/uxy*uz;
    by=uy/uxy*uz;
end
bxy = abs(uz);
if bx>=0 && by>=0
    w = atan(bx/by);
end
if bx>0 && by<0
    w = pi-atan(abs(bx/by));
end
if bx<=0 && by<=0
    w = pi + atan(abs(bx/by));
end
if bx<0 && by>0
    w = 2*pi - atan(abs(bx/by));
end

b = atan(bz/bxy);

if bx==0 ||by==0
    w = 0;
end
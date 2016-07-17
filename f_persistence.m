function [ persistence_dip, persistence_dipdir ] = f_persistence( P, dipdir, dip )
% función que calcula la dimensión máxima de un cluster de puntos en 3D
% según dos direcciones: dirección de buzamiento y dirección de plano
% Inputs: 
% P: nube de puntos 3D, en un SR cartesiano donde OY está orientado al
% norte
% dipdir: dirección de buzamiento en radiantes
% dip: buzamiento en radiantes
% Adrián Riquelme, diciembre 2015

% calculo la matriz de rotación
[ R ] = f_dipdirdip2R( dipdir, dip );

% Calculo las coordenadas de los puntos en el nuevo SR, donde OX tiene la
% dirección del buzamiento, OY de la dirección del plano y el OZ del vector
% normal al plano

P1=P*R;

%% Cálculo de la persistencia en la dirección del vector de buzamiento


end

function [ R ] = f_dipdirdip2R( dipdir, dip )
% [ R ] = f_dipdirdip2R( dipdir, dip )
% Función que calcula la matriz de rotación de la base canónica a un SR
% compuesto por tres vectores:
% v1: vector buzamiento, OX
% v2: vector dirección: OY
% v3: vector normal: OZ
% Inputs: dipdir, dip en radianes
% Adrián Riquelme, diciembre 2015

R= [cos(dip)*cos(pi/2-dipdir) cos(pi-dipdir) sin(dip)*cos(pi/2-dipdir);
    cos(dip)*sin(pi/2-dipdir) sin(pi-dipdir) sin(dip)*sin(pi/2-dipdir);
    sin(dip) 0 cos(dip)];


end



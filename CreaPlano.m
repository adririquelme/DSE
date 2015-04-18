function [ P ] = CreaPlano( l1, l2, espaciado, giroX, giroY, giroZ, error)
% Función que genera un plano de dimensiones dadas y lo orienta según tres
% giros
% Input
% - l1: lado 1
% - l2: lado 2
% - espaciado: distancia entre puntos
% - giroX: giro del plano respecto al eje X en radianes!!!
% - giroY: giro del plano respecto al eje Y
% - giroZ: giro del plano respecto al eje Z
% error: error gaussiano, es el valor de sigma*3 (99%)
x=[-l1/2:espaciado:l1/2];
y=[-l2/2:espaciado:l2/2];
[aux, nx]=size(x);
[aux,ny]=size(y);
P=[]; %se inicia el vector y generamos los puntos en el plano XY
for ii=1:nx
    for jj=1:ny
        posicion=(ii-1)*ny+jj;
        P(1,posicion)=x(ii)+random('Normal',0,error/3,1);
        P(2,posicion)=y(jj)+random('Normal',0,error/3,1);
        P(3,posicion)=0+random('Normal',0,error/3,1);
    end
end
cgx=cos(giroX);
sgx=sin(giroX);

cgy=cos(giroY);
sgy=sin(giroY);

cgz=cos(giroZ);
sgz=sin(giroZ);
Mgx=[1 0 0; 0 cgx sgz; 0 -sgx cgx];
Mgy=[cgy 0 sgy; 0 1 0; -sgy 0 cgy];
Mgz=[cgz sgz 0;-sgz cgz 0; 0 0 1];
% giramos los puntos 
P=Mgz*Mgy*Mgx*P;
%trasponemos P
P=P';

% guardamos en un archivo hexaedro.txt
fi = fopen('plano.txt', 'w') ;
[n,p]=size(P);
for k=1:n
    fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3));
end
fclose(fi);
% % guardamos en un archivo puntos.txt
fi = fopen('puntos.txt', 'w') ;
[n,p]=size(P);
for k=1:n
    fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3));
end
fclose(fi);
% dibujamos la salida
figure
scatter3(P(:,1),P(:,2),P(:,3),5,P(:,3));
xlabel('eje X'); ylabel('eje Y');zlabel('eje Z');
axis equal;
end


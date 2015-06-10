function [planos_estereo]=prepara_estereo(planos)
% Partimos de que tenemos la matriz planos, con informaciï¿½n de todos los
% vectores normales de los planos obtenidos
% w: dirección del vector buzamiento
% b: ángulo del buzamiento respecto a la horizontal
% La salida sería la matriz planos_estereo, de dimensión n de puntos y dos
% columnas. En la primera columna se encuentra el valor de w y en la
% segunda el de b
% input
% - planos: matriz que contiene la ecuaciï¿½n de cada plano, ABCD
% output
% - planos_estereo: matriz que contiene los datos de los vectores de
% buzamiento de los planos, en forma w y b
% w: ángulo que forma la línea de máxima pendiente con el norte OY
% b: ángulo que forma la línea de máxima pendiente con su proyección
% horizontal
[np,~] = size ( planos );
planos_estereo = zeros (np,2);
for j=1:np
    [w,b]=vnor2vbuz(planos(j,1),planos(j,2),planos(j,3));
    planos_estereo(j,1)=w;
    planos_estereo(j,2)=b;
end
% guardamos en un archivo estereo.txt para el stereo32
% son los vectores buzamiento, luego son los planos
% fi = fopen('stereo.txt', 'w') ;
% for k=1:np
%     fprintf(fi,  '%f %f	P \n', planos_estereo(k,1)/pi*180,planos_estereo(k,2)/pi*180);
% end
% 
% fclose(fi);

end
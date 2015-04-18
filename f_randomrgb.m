function [ rgb ] = f_randomrgb( im0 )
% Función que toma una columna de datos y las clasifica según su color rgb
% de forma aleatoria.
% Adrián Riquelme, 4 noviembre 2014
% [ rgb ] = f_randomrgb( im )

% reordeno aleatoriamente la columna
[indices, ~] = sort(unique(im0));
nindices = length(indices);
desorden = randsample(nindices,nindices);
im = zeros(size(im0));
for i=1:nindices
    indice = desorden(i);
    im(im0(:,1)==indices(i))=indice;
end

% transforma escala de intensidades (0 a n) a RGB (0 a 1)  from http://www.alecjacobson.com/weblog/?p=1655
n = size(unique(reshape(im,size(im,1)*size(im,2),size(im,3))),1);
im= double(im);
im=im*255/n;
im=uint8(im);
rgb = ind2rgb(im,jet(255));
end


function [indices]=f_findarray (listaorigen, listavalores)
% función que busca en un array los índices que tiene un valor contenido en
% otro array
[nvalores,~]=size(listavalores);
indices = [];
for i=1:nvalores
    valorbuscado = listavalores(i,1);
    I=find(listaorigen==valorbuscado);
    indices = [indices; I];
end

end

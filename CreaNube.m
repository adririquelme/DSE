function [ P ] = CreaCono( a, b, c, n)
% [ P ] = CreaNube( a, b, c, n)
% Crea una nube de puntos con dimensión a,b,c
% El número de puntos es n
P=rand(n,3);
P(:,1)=P(:,1).*a;
P(:,2)=P(:,2).*b;
P(:,3)=P(:,3).*c;

% guardamos en un archivo cono.txt
    fi = fopen('nube.txt', 'w') ;
    [n,p]=size(P);
    for k=1:n
        fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
    end 
    fclose(fi);
        fi = fopen('puntos.txt', 'w') ;
    [n,p]=size(P);
    for k=1:n
        fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
    end 
    fclose(fi);

end


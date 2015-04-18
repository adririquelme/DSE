R=10; n=10000;
i=1;
test=1;
while test==1
    x=rand*R-R/2;
    y=rand*R-R/2;
    z=rand*R-R/2;
    rho=(x^2+y^2+z^2)^(0.5);
    if rho<=R
        P(i,1)=x;
        P(i,2)=y;
        P(i,3)=z;
        i=i+1;
    end
    if i==n
        test=0;
    end
end


fi = fopen('puntos.txt', 'w') ;
[n,p]=size(P);
for k=1:n
    fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3));
end
fclose(fi);

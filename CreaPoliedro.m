function [ P ] = CreaTetraedro( l, h, n, inc, error)
% Función que genera las coordenadas de puntos en la superficie de un
% poliedro
% Adrián Riquelme, abril 2013
% l: lado de la base
% h: altura del hexaedro. 0 si es regular
% n: número de lados del poliedro
% inc: separación entre los puntos
% error: error gaussiano que le metemos a los puntos

P=[0 0 0]; %se inicia el vector
test = 1; %iniciamos las comprobaciones
if l==0
    test = test*0;
end
resto = (n - floor(n));
if resto ~=0
    disp('El valor de n no es correcto. Debe ser entero y positivo');
    test = test*0;
end

if test ==0
    P=0; % el poliedro es nulo y no se puede crear
else
    if h==0
        h = l; % el poliedro será regular
    end
    % creamos el poliedro
    t=0:(inc/h):1;
    % r=t/h*(l/(3^0.5));
    [x,y,z]=cylinder(t,n);
    [a,b]=size(x);
    for ii=1:b-1
        for jj=1:a
            zi=z(jj,ii)*h;
            xi=x(jj,ii)*(l/3^0.5);
            yi=y(jj,ii)*(l/3^0.5);
            zf=z(jj,ii+1)*h;
            xf=x(jj,ii+1)*(l/3^0.5);
            yf=y(jj,ii+1)*(l/3^0.5);
            d=((xi-xf)^2+(yi-yf)^2+(zi-zf)^2)^(0.5);
            if d==0
                v=[0 0 0];
            else
                if xi==xf && yi==yf && zi==zf
                    v=[xi yi zi];
                else
                    if d/inc - floor(d/inc)==0
                        inci=floor(d/inc);
                    else
                        inci=floor(d/inc)+1;
                    end
                    if xi==xf
                        xn=0;
                        for kk=1:(inci+1)
                            xn(1,kk)=xf+random('Normal',0,error/3,1);
                        end
                    else
                    xn=[xi:(xf-xi)/inci:xf]+random('Normal',0,error/3,1);
                    end 
                    if yi==yf
                        yn=0;
                        for kk=1:(inci+1)
                            yn(1,kk)=yf+random('Normal',0,error/3,1);
                        end
                    else
                    yn=[yi:(yf-yi)/inci:yf]+random('Normal',0,error/3,1);
                    end                      
                    if zi==zf
                        zn=0;
                        for kk=1:(inci+1)
                            zn(1,kk)=zf+random('Normal',0,error/3,1);
                        end
                    else
                        zn=[zi:(zf-zi)/inci:zf]+random('Normal',0,error/3,1);
                    end
                    v=[xn;yn;zn]';
                end
            end
            P=[P;v];
        end
    end
%     % guardamos en un archivo poliedro.txt
%     fi = fopen('poliedro.txt', 'w') ;
%     [n,p]=size(P);
%     for k=1:n
%         fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
%     end 
%     fclose(fi);
    % guardamos en un archivo puntos.txt
      fi = fopen('puntos.txt', 'w') ;
    [n,p]=size(P);
    for k=1:n
        fprintf(fi,  '%f %f	%f \n', P(k,1),P(k,2),P(k,3)); 
    end 
    fclose(fi);
    

end


end
    


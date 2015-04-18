function [polos_pples, polos_pples_cart, density, X, Y]=f_prepara_planos_kde(polos_estereo_cartesianas,nsec, angulovpples, maxpples)
%% Función que busca los planos principales mediante la estimación de densidad de kernels
% Se determinan los polos del vector normal al plano.
% Input:
% - polos_estereo_carterianas
% - nsec
% - angulovpples
% - maxpples: número máximo de planos principales que buscamos
% Output:
% - polos_pples(alfa(rd), beta(rd), fdensidad). Coordenadas polares
% - polos_pples_cart(x,y) de P'. Coordenadas cartesianas
% - density: valores de la función de densidad
% - X: coordenadas x de los bins de la función de densidad
% - Y: coordenadas y de los bins de la función de densidad
% Creamos la función de densidad mediante los kernels
% nsec = input('Introduce el num de sectores a considerar.\nPotencia de 2: 2,4,8,16,32,64,128... \nRecomendable 64, 2^6=64: \n');
densidadminima = 0.0001; %establezco la densidad mínima en tanto por uno
[~,density,X,Y]=kde2d(polos_estereo_cartesianas,nsec);
[ dmax, Xmax, Ymax ] = maxsearch2d( X,Y,density,densidadminima) ; 
[~, ns]=size(dmax);

% ns es el n de máximos que he encontrado, por lo que no puedo encontrar
% más planos principales que ns

%convertimos la tolerancia. Es el valor con el que se compara el
%paralelismo de los vectores normales

proyeccion = cos(angulovpples/180*pi);

% Con los planos, vamos a registrarlos en la salida
para=0;
ii=1; % ii es el n de plano principal que estoy considerando
kk=1; % kk es el orden de plano principal que he encontrado
polos_pples=zeros(1,3); %se inicializa la matriz con los resultados
polos_pples_cart=zeros(1,2); %inicializamos la matriz de polos pples proyectados
vnormal_pples=zeros(1,4); %se inicializa la matriz auxiliar de vectores normales
while para==0
    % con las coordenadas en cartesianas, determinamos el plano en notación
    % vector de buzamiento
    % alfa es el ángulo medido desde el OX (polares) de las coordenadas del
    % polo principal
    % beta es el ángulo que forma el vector normal (polo) con el plano
    % horizontal
    x=Xmax(ii); y=Ymax(ii);
    if x>=0
        if y>=0
            alfa = atan(y/x);
        else
            alfa = 2*pi+atan(y/x);
        end
    else
        if y>=0
            alfa = pi+atan(y/x);
        else
            alfa = pi+atan(y/x);
        end
    end
    beta = 2*atan((x^2+y^2)^0.5);
    if x==0 && y==0
        alfa=0;
        beta=0;
    end
    polos_pples(kk,1)=alfa/pi*180;
    polos_pples(kk,2)=beta/pi*180;
    polos_pples(kk,3)=dmax(ii); %ponemos el num de puntos que tiene asociado
    vnormal_pples(kk,1)=sin(alfa)*sin(beta);  %el vector es unitario
    vnormal_pples(kk,2)=cos(alfa)*sin(beta);
    vnormal_pples(kk,3)=cos(beta);
    vnormal_pples(kk,4)=dmax(ii); %al vector normal le ponemos el num de puntos que tiene asociado
    polos_pples_cart(kk,1)=x;
    polos_pples_cart(kk,2)=y;
    polos_pples_cart(kk,3)=dmax(ii);
    if ii==1
        ii=ii+1; %como no he terminado, considero buscar en otro plano mas
        kk=kk+1; %este se incrementa si se acepta el plano!!!!!!
    else
        test = 1;
        % vamos a probar si el plano ii no es paralelo al resto encontrados
        ux1=vnormal_pples(kk,1);
        uy1=vnormal_pples(kk,2);
        uz1=vnormal_pples(kk,3);
        % vamos a comparar el plano ii con todos los ya encontrados, los kk
        for jj=1:(kk-1)
            ux2=vnormal_pples(jj,1);
            uy2=vnormal_pples(jj,2);
            uz2=vnormal_pples(jj,3);
            proyeccion2 = abs(ux1*ux2+uy1*uy2+uz1*uz2);
            if proyeccion2 > proyeccion
                % es paralelo, luego no se considera
                test = test*0; 
            end
        end
        % si test=1 el plano ii no es paralelo a todos los anteriores 
        % si test=0, ha encontrado al menos uno paralelo, luego eliminamos el
        % plano
        if test==0
            % no pasa el test y borramos ese plano
            vnormal_pples(kk,:)=[];
            polos_pples(kk,:)=[];
            polos_pples_cart(kk,:)=[];
            ii=ii+1; % se considera el siguiente plano
        else
            % como el plano es bueno, lo dejamos
            ii=ii+1; % se considera el siguiente plano
            kk=kk+1; % se acepta el plano
        end

    end
    if kk>nsec || kk>maxpples || ii>ns %hemos encontrado todos los planos que buscamos o hemos buscado por todos los max que tenemos
        para=1;
    end
end
end

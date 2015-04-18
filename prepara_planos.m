%% Script que busca los planos principales
% Output:
% - planos_pples(omega(rd), beta(rd), fdensidad)
% - planos_pples_polocart(x,y) de P'
% - vnormal_pples(ux,uy,uz)
% partimos de la fdensidad_cuadrada
npb = input('Introduce el número de planos a buscar: \n');
[ns, aux]=size(fdensidad_cuadrada);
if npb<=0 || npb>=ns
    Alerta = msgbox('El nº de planos a buscar debe ser positivo y menor que la discretización del histograma. Se fija en 1 por defecto','Cuidadorrrrrrr!!','warn');
    npb = 1;
end


% Según el grado de sectorización que hayamos utilizado en la
% determinaciónd el histograma, se determina el ángulo mínimo para no
% generar problemas en los planos horizontales.
% ang min = 2*atan(2/ns)
fprintf('Valor mínimo recomendable de holgura: %dº\n',floor(2*atan(2/ns)/pi*180)+1);
tolerancia = input('Introduce los grados de holgura para búsqueda de planos, Vg: 30º: \n');
if tolerancia<=0
    Alerta = msgbox('Los grados introducidos son incorrectos. Se fija en 10º por defecto','Cuidadorrrrrrr!!','warn');
    tolerancia = 10;
end
proyeccion = cos(tolerancia/180*pi);%convertimos la tolerancia. Este será el valor con el que se comparará el paralelismo de los vectores normales

%preparamos la función de densidad para búsqueda de máximos
% la función de densidad la convertimos a una matriz de 3 columnas
% col 1: coordenada x, col2: coordenada y
% col3: nº de puntos en el bin para la coordenada
fdensidad_cuadrada_aux=zeros(ns,3); %iniciamos la matriz auxiliar
for ii=1:ns
    x=ii*2/ns-1;
    for jj=1:ns
        y=jj*2/ns-1;
        fdensidad_cuadrada_aux((ii-1)*ns+jj,1)=x;
        fdensidad_cuadrada_aux((ii-1)*ns+jj,2)=y;
        fdensidad_cuadrada_aux((ii-1)*ns+jj,3)=fdensidad_cuadrada(ii,jj);
    end
end
% Se ordena la función de densidad según el número de planos por coordenada. Es ascendente, por lo que los máximos estarán al final de la matriz
fdensidad_cuadrada_aux=sortrows(fdensidad_cuadrada_aux,3); % buscamos los planos predominantes
para=0;
planos_pples=zeros(1,2); %se inicializa la matriz con los resultados
planos_pples_polocart=zeros(1,2);
vnormal_pples=zeros(1,3); %se inicializa la matriz auxiliar de vectores normales
ii=1; %ii es el plano que estamos testeando. Desde 1 hasta ns^2.
iii=1; %iii es el número de planos pples que buscamos. De 1 a npb.
while para==0;
    % Para el plano ii, determinamos sus parámetros
    x = fdensidad_cuadrada_aux(ns^2-(ii-1),1); %coordenada x del polo q testeamos
    y = fdensidad_cuadrada_aux(ns^2-(ii-1),2); %coordenada y del polo que testeamos
    % con las coordenadas, determinamos el plano en notación vector de
    % buzamiento
    if x>=0
        if y>=0
            omega = atan(x/y);
        else
            omega = pi+atan(x/y);
        end
    else
        if y>=0
            omega = 2*pi+atan(x/y);
        else
            omega = pi+atan(x/y);
        end
    end
    beta = 2*atan((x^2+y^2)^0.5);
    if x==0 && y==0
        omega=0;
        beta=0;
    end
    % Introducimos los parámetros de ii en iii
    planos_pples(iii,1)=omega/pi*180;
    planos_pples(iii,2)=beta/pi*180;
    planos_pples(iii,3)=fdensidad_cuadrada_aux(ns^2-(ii-1),3); %ponemos el número de puntos que tiene asociado
    vnormal_pples(iii,1)=sin(omega)*sin(beta);  %notar que el vector es unitario por definición
    vnormal_pples(iii,2)=cos(omega)*sin(beta); 
    vnormal_pples(iii,3)=cos(beta);
    vnormal_pples(iii,4)=fdensidad_cuadrada_aux(ns^2-(ii-1),3); %al vector normal le ponemos el número de puntos que tiene asociado
    %para un plano iii, buscamos los planos ii que no sean paralelos a iii
    %ya encontrados
    if ii==1
        % el primer plano que comparamos lo aceptamos directamente
        planos_pples_polocart(iii,1)=x;
        planos_pples_polocart(iii,2)=y;
        iii=iii+1;%para el primer plano, se coge directamente pues es el máximo de la fd
        ii=ii+1;
        % fdensidad_cuadrada_aux(ns^2-(ii-1),:)=[]; %eliminamos la fila que hemos utiliz
    else
        test = 1;
        ux1=vnormal_pples(iii,1);
        uy1=vnormal_pples(iii,2);
        uz1=vnormal_pples(iii,3);
        % vamos a comparar el plano ii (metido en iii) con todos los ya
        % encontrados
        for jj=1:(iii-1)
            ux2=vnormal_pples(jj,1);
            uy2=vnormal_pples(jj,2);
            uz2=vnormal_pples(jj,3);
            proyeccion2 = abs(ux1*ux2+uy1*uy2+uz1*uz2);
            if proyeccion2 > proyeccion
                % como son sensiblemente paralelos, no es un nuevo plano,
                % pero es paralelo al que tenemos. Por eso, afectará en su 
                % dirección en función del número de planos asociados
                test = test*0; %si son sensiblemente paralelos, el plano no vale
                % IDEA: si no pasa el test, el plano jj debería de verse
                % afectado por el iii
                planos_pples(jj,3)=planos_pples(jj,3)+fdensidad_cuadrada_aux(ns^2-(ii-1),3); %al plano que hemos encontrado que es paralelo, le añadimos los planos que hemos detectado
            end
            planos_pples(iii,4)=test;
        end
        if test==0
            % si test=1 el plano iii no es paralelo a todos los anteriores 
            % si test=0, ha encontrado al menos uno paralelo, luego eliminamos el plano
            vnormal_pples(iii,:)=[];
            planos_pples(iii,:)=[];
        else
            % como el plano es bueno, lo dejamos
            planos_pples_polocart(iii,1)=x;
            planos_pples_polocart(iii,2)=y;
            iii=iii+1;
        end
        ii=ii+1;%pasamos al siguiente punto
        % fdensidad_cuadrada_aux(ns^2-(ii-1),:)=[]; %eliminamos la fila que hemos utilizado
    end
    if iii>npb || ii==ns^2
        para=1;
    end
end

%% le hago un test a vnormal_pples
[nvp,aux]=size(vnormal_pples);
vnormal_pples_test=zeros(nvp,nvp);
for ii=1:nvp
    ux1=vnormal_pples(ii,1);
    uy1=vnormal_pples(ii,2);
    uz1=vnormal_pples(ii,3);
    for jj=1:nvp
        ux2=vnormal_pples(jj,1);
        uy2=vnormal_pples(jj,2);
        uz2=vnormal_pples(jj,3);
        vnormal_pples_test(ii,jj)=ux1*ux2+uy1*uy2+uz1*uz2;
    end
end

%% Preparamos la salida de los planos
% fijamos en el 95% los planos a contener en la salida

para =0;
planos_acumulado=0;
planos_total=sum(planos_pples(:,3));
ii=1;
while para==0
    planos_acumulado=planos_acumulado+planos_pples(ii,3);
    fprintf('Plano nº %d Omega = %dº Beta = %dº %% del total: %d%%. Acumulado %d%%\n',ii, floor(planos_pples(ii,1)),floor(planos_pples(ii,2)),floor(planos_pples(ii,3)/planos_total*100),floor(planos_acumulado/planos_total*100));
    planos_pples_polocart(ii,3)=planos_pples(ii,3);
    ii=ii+1;
    if planos_acumulado/planos_total>=0.95 || ii==iii-1
        para=1;
    end
end

% represntamos los puntos de salida
figure('Name','Planos principales encontrados. Representación de P en estereográficas','NumberTitle','off');
wulff;
tamanyo=floor(planos_pples_polocart(1:ii-1,3)/min(planos_pples_polocart(1:ii-1,3)))*10;
scatter(planos_pples_polocart(1:ii-1,1),planos_pples_polocart(1:ii-1,2),tamanyo,tamanyo,'filled');
xa=planos_pples_polocart(1:ii-1,1)';
xb=planos_pples_polocart(1:ii-1,2)';
etiquetas=num2str([1:1:ii-1]');
text(xa,xb,etiquetas,'FontSize',18);
xlabel('eje X'); ylabel('eje Y');

% limpiamos la basura
clear npb ns aux tolerancia Alerta proyeccion x y ux1 uy1 uz1 ux2 uy2 uz2 vnormal_pples_test nvp iii ii
clear fdensidad_cuadrada_aux
clear para planos_acumulado planos_total tamanyo xa xb etiquetas


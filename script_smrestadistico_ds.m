% Opción de cargar a saco todas las lecturas de todos los puntos
% Cargo el archivo
[filename, pathname] = uigetfile('*.txt','Select the name-js-c-abcd.txt file');
[~,nombrearchivo,~] = fileparts(filename);
P=load(strcat(pathname, filename));
[n,columnas]=size(P);
% Primero determino en qué columna está el js
switch columnas
    case 7
        pos_col_js=1;
    case 9
        pos_col_js=4;
    otherwise
        f = msgbox('Invalid text file', 'Error','error');
end

ux=P(:,columnas-3);
uy=P(:,columnas-2);
uz=P(:,columnas-1);
[w,b]=vnor2vbuz_v02(ux,uy,uz);
P(:,columnas+1)=w*180/pi;
P(:,columnas+2)=-b*180/pi;

% Calculo los histogramas y los estadísticos

js=unique(P(:,pos_col_js));
njs=length(js);
f=waitbar(0,'Calculando estadísticos e histogramas.');
h=figure;
for i=1:njs
    waitbar(i/n,f,sprintf('Familia %d/%d',i,njs));
    subplot(2,njs,i);
    I=find(P(:,pos_col_js)==js(i));
    X=P(I,(columnas+1):(columnas+2));
    h1=histogram(X(:,1)); 
    media=mean(X(:,1)); sigma=std(X(:,1));
    title(['\mu=',num2str(media),'; \sigma=',num2str(sigma)]);
    hold on;
    subplot(2,njs,njs+i);
    histogram(X(:,2));
    media=mean(X(:,2)); sigma=std(X(:,2));
    title(['\mu=',num2str(media),'; \sigma=',num2str(sigma)]);
end
delete(f);
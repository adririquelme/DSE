
% Riquelme -- Program for plotting a stereonet for DSE
% Written by Adrian Riquelme, September 2016
% ariquelme@ua.es
% Department of Civil Engineering, University of Alicante, Spain

% First, we define the circle and the axis
% Code extracted from the wulff net
N = 50;
cx = cos(0:pi/N:2*pi);                           % points on circle
cy = sin(0:pi/N:2*pi);
xh = [-1 1];                                     % horizontal axis
yh = [0 0];
xv = [0 0];                                      % vertical axis
yv = [-1 1];
axis([-1 1 -1 1]);
axis('square');
plot(xh,yh,'-.k',xv,yv,'-.k');                     %plot green axes
axis off;
hold on;
plot(cx,cy,'--k');                                %plot white circle

% Now, we draw the circles that refer to the dip angle
psi = [0:pi/N:2*pi];
beta=[15 30 45 60 75 90]/180*pi;
[~,n]=size(beta);
for i = 1:(n-1)                                   % plot dip circles
   [radio]=f_radio(beta(i));
   x = radio .* sin(psi);
   y = radio .* cos(psi);
   plot(x,y,':r');
   text(radio,0,num2str(beta(i)*180/pi),'HorizontalAlignment','Left','Verticalalignment','bottom','FontSize',8);
end
% Inserto el label del buzamiento de 90
[radio]=f_radio(90*pi/180);
text(radio,0,num2str(90),'HorizontalAlignment','Left','Verticalalignment','bottom','FontSize',8);

axis('square');

% Finally, we draw the circles that refer to the dip direction
alpha0 = 0:pi/6:(2*pi-pi/12);
alpha = pi/2 - alpha0+pi;
etiqueta = 0:360/12:(330);
x = 1.2*cos(alpha);
y = 1.2*sin(alpha);
[~,n]=size(alpha);
tamanyoangulos=12;
for i=1:n
    % le pongo su etiqueta el ángulo respecto al norte
    if etiqueta(i)==0 || etiqueta(i)==180
        text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','center','VerticalAlignment','cap','FontSize',tamanyoangulos);
    else
       if etiqueta(i)>0 && etiqueta(i)<180
           text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Right','FontSize',tamanyoangulos);
       else
           text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Left','FontSize',tamanyoangulos);
       end
    end
    
    % Pongo una línea radial para marcar la dirección del polo
    
%     xaux=[-cos(alpha(i))  cos(alpha(i))];
%     yaux=[-sin(alpha(i))  sin(alpha(i))];
%     plot(xaux,yaux,'r:.');

    xaux=[f_radio(15*pi/180)*cos(alpha(i))  cos(alpha(i))];
    yaux=[f_radio(15*pi/180)*sin(alpha(i))  sin(alpha(i))];
    plot(xaux,yaux,'r:.');
    
    
    
    % pongo una pequeña línea para marcar dónde va ese label
    xaux=[cos(alpha(i))  1.05*cos(alpha(i))];
    yaux=[sin(alpha(i))  1.05*sin(alpha(i))];
    plot(xaux,yaux,'k-');
end

% Inserto una descripción 
% x = 1;
% y = 1;
% text(1,1,'\color{red} \ldots \color{black} dip')
% text(1,1.1,'\color{red} -- \color{black} dip direction')


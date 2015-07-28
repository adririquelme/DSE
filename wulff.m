% wulff -- Program for plotting a Wulff net
% to plot points, first calculate theta = pi*(90-azimuth)/180
% then rho = tan(pi*(90-dip)/360), and finally the components
% xp = rho*cos(theta) and yp = rho*cos(theta)
% Written by Gerry Middleton, November 1995

% Modificado por Adri�n Riquelme, junio 2015

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
psi = [0:pi/N:pi];
for i = 1:8                                      %plot great circles
   rdip = i*(pi/18);                             %at 10 deg intervals
   radip = atan(tan(rdip)*sin(psi));
   rproj = tan((pi/2 - radip)/2);
   x1 = rproj .* sin(psi);
   x2 = rproj .* (-sin(psi));
   y = rproj .* cos(psi);
   plot(x1,y,':r',x2,y,':r');
end
for i = 1:8                                     %plot small circles
   alpha = i*(pi/18);
   xlim = sin(alpha);
   ylim = cos(alpha);
   x = [-xlim:0.01:xlim];
   d = 1/cos(alpha);
   rd = d*sin(alpha);
   y0 = sqrt(rd*rd - (x .* x));
   y1 = d - y0;
   y2 = - d + y0;
   plot(x,y1,':r',x,y2,':r');
end
axis('square');

% le pongo sus labels
alpha0 = 0:pi/6:(2*pi-pi/12);
alpha = pi/2 - alpha0;
etiqueta = 0:360/12:(330);
x = 1.1*cos(alpha);
y = 1.1*sin(alpha);
[~,n]=size(alpha);
for i=1:n
    % le pongo su etiqueta el ángulo respecto al norte
    if etiqueta(i)==0 || etiqueta(i)==pi
        text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Center');
    else
       if etiqueta(i)>0 && etiqueta(i)<180
           text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Left');
       else
           text(x(i),y(i),num2str(etiqueta(i)),'HorizontalAlignment','Right');
       end
    end
    % pongo una pequeña línea para marcar dónde va ese label
    xaux=[cos(alpha(i))  1.05*cos(alpha(i))];
    yaux=[sin(alpha(i))  1.05*sin(alpha(i))];
    plot(xaux,yaux,'k-');
end

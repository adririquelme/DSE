function [ XCoeff, YCoeff, CCoeff ] = f_planefit( x,y,z )
% Function to fit a plane from a set of 3d coordinates
% [ XCoeff, YCoeff, CCoeff ] = f_planefit( x,y,z )
% http://www.mathworks.es/support/solutions/en/data/1-1AVW5/?solution=1-1AVW5
% Input:
% x: x coordinates vector
% y: y coordinates vector
% z: z coordinates vector
% Output:
% z = XCoeff * x + YCoeff * y + CCoeff

Xcolv = x(:); % Make X a column vector
Ycolv = y(:); % Make Y a column vector
Zcolv = z(:); % Make Z a column vector
Const = ones(size(Xcolv)); % Vector of ones for constant term

Coefficients = [Xcolv Ycolv Const]\Zcolv; % Find the coefficients
XCoeff = Coefficients(1); % X coefficient
YCoeff = Coefficients(2); % X coefficient
CCoeff = Coefficients(3); % constant term
% Using the above variables, z = XCoeff * x + YCoeff * y + CCoeff

L=plot3(x,y,z,'ro'); % Plot the original data points
set(L,'Markersize',2*get(L,'Markersize')) % Making the circle markers larger
set(L,'Markerfacecolor','r') % Filling in the markers
hold on
x1=min(x(:));
x2=max(x(:));
y1=min(y(:));
y2=max(y(:));
[xx, yy]=meshgrid(x1:(x2-x1)/10:x2,y1:(y2-y1)/10:y2); % Generating a regular grid for plotting
zz = XCoeff * xx + YCoeff * yy + CCoeff;
surf(xx,yy,zz) % Plotting the surface
title(sprintf('Plotting plane z=(%f)*x+(%f)*y+(%f)',XCoeff, YCoeff, CCoeff))
% By rotating the surface, you can see that the points lie on the plane
% Also, if you multiply both sides of the equation in the title by 4,
% you get the equation in the comment on the third line of this example


end


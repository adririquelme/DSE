%% función omega a alfa
function [alfa] = o2a(omega)
alfa=zeros(size(omega));
I=find(omega>=0 & omega<pi/2); alfa(I)=pi/2-omega(I)+pi;
I=find(omega>=pi/2 & omega <pi);alfa(I)=pi-(omega(I)-pi/2);
I=find(omega>=pi & omega<3*pi/2);alfa(I)=pi/2-(omega(I)-pi);
I=find(omega>=3*pi/2 & omega<2*pi);alfa(I)=7*pi/2-omega(I);

% if omega>=0 && omega <pi/2
%     alfa=pi/2-omega+pi; %omega en el 1c, llevo alfa al 3c
% else
%     if omega>=pi/2 && omega <pi
%         alfa=pi-(omega-pi/2); %omega en el 2c, alfa al 4c
%     else
%         if omega>=pi && omega <3*pi/2
%             alfa=pi/2-(omega-pi); %omega en el 3c, lo llevo al 1c
%         else
%             alfa=7*pi/2-omega; %omega en el 4c, lo llevo al 2c
%         end
%     end
% end
end
function [ angle ] = f_anglev1v2( w1,b1,w2,b2 )
% [ angle ] = f_anglev1v2( w1,b1,w2,b2 )
% angles in radians
% w1: dip direction of plane 1
% b1: dip of plane 1
% w2: dip direction of plane 2
% b2: dip direction of plane 2

[ A1,B1,C1 ] = f_vbuz2vnor( w1,b1 );
[ A2,B2,C2 ] = f_vbuz2vnor( w2,b2 );
v1=[A1, B1, C1];
v2=[A2, B2, C2];
angle=acos(v1*v2');

end


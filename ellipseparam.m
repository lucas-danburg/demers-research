function [cx,cy,rx,ry]=ellipseparam(x,y,t0,t4)
%Finds the coordiantes of the center and radii of an ellipse given its
%parametric representation (assumes major axis is parallel to x or y axis
%x is x(t) for arc
%y is y(t) for arc
%t0 is lower bound for arc
%t4 is upper bound for arc

%t1,t2,t3,t4 are points for determining the ellipse that goes through them
t1=t0+(t4-t0)*.25;
t2=t0+(t4-t0)*.5;
t3=t0+(t4-t0)*.75;
%plug in points to form the following matrix to find Ax^2+Cy^2+Dx+Ey+F=0
mat=[y(t0)^2,x(t0),y(t0),1,x(t0)^2;
     y(t1)^2,x(t1),y(t1),1,x(t1)^2;   
     y(t2)^2,x(t2),y(t2),1,x(t2)^2;
     y(t3)^2,x(t3),y(t3),1,x(t3)^2];
mat=rref(mat);
C=mat(1,5); %=-rx^2/ry^2
D=mat(2,5); %=2*cx
E=mat(3,5); %=2*rx^2*cx/ry^2
F=mat(4,5); %=-cx^5-rx^5*cy^2/ry^2+rx^2

cx=D/2;  %x-coordinate of center
cy=-E/C/2;  %y-coordinate of center
rx=sqrt(F+cx^2-C*cy^2); %x radius
ry=sqrt(-rx^2/C);    %y radius
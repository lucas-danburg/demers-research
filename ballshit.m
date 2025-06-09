function ans=ballshit(x1,y1,a1,v1,x2,y2,a2,v2,t0,r)
%determines if the two balls hit 
%if the balls hit, returns the time until the collision
%if the balls do not hit, returns 0
%x1,y1,a1,v1 describe ball1; x2,y2,a2,v2 describe ball2
%t0 gives the amount of time until one of the balls hits the table
%r gives the radius of the balls

%looks for solutions of distance formula:
%(2r)^2=((x1+t*v1*cos(a1))-(x2+t*v2*cos(a2)))^2+((y1+t*v1*sin(a1))-(y2+t*v2*sin(a2)))^2
%solving equation results in quadratic formula with following coefficients
a=(v1*cos(a1)-v2*cos(a2))^2+(v1*sin(a1)-v2*sin(a2))^2;
b=2*(x1*v1*cos(a1)-x1*v2*cos(a2)-x2*v1*cos(a1)+x2*v2*cos(a2)+y1*v1*sin(a1)-y1*v2*sin(a2)-y2*v1*sin(a1)+y2*v2*sin(a2));
c=-4*r^2+x1^2+x2^2-2*x1*x2+y1^2+y2^2-2*y1*y2;


if b^2-4*a*c<0 %checks discriminant for complex roots
    ans=0; %if roots are complex there will never be a collision
else
    root=(-b-sqrt(b^2-4*a*c))/(2*a); %quadratic formula for smaller root
    if root>=0 & root<=t0 %check if root is in relevant range for a collision
        ans=root; %collision occurs at time given by root
    else
        ans=0; %no collision occurs
    end
end